### 💿 Step 1 — Memory starts empty each call

When your contract function begins, the EVM gives you a blank memory space.
By convention, Solidity starts reserving from the bottom (address `0x00` upward).

And yes — it’s completely **per call** (wiped clean every time).

---

### 🧩 Step 2 — The “free memory pointer”

Solidity keeps a special 32-byte word at **address `0x40`**.
That’s where it stores the **next free memory slot** —
basically:

```solidity
mstore(0x40, 0x80)
```

is done early in execution, so it knows “memory up to 0x80 is used.”
Any time the compiler allocates new memory (for arrays, strings, structs, etc.), it:
1️⃣ reads the pointer at `0x40`,
2️⃣ stores the new data starting from that address,
3️⃣ updates the pointer to point to the next free space.

So the pointer at `0x40` = the compiler’s internal “bookmark” for the next allocation.

---

### ⚙️ Step 3 — Memory layout pattern

Solidity roughly uses memory like this:

| Address range | Purpose                                                               |
| ------------- | --------------------------------------------------------------------- |
| `0x00 – 0x3F` | scratch space (temp ops, function selector, etc.)                     |
| `0x40`        | free memory pointer (points to next empty byte)                       |
| `0x60+`       | actual dynamic variable data (arrays, structs, calldata copies, etc.) |

For example:

```solidity
function foo() public pure returns (bytes memory b) {
    b = new bytes(10);
}
```

→ Solidity will:

- read `mload(0x40)` (maybe 0x80)
- store the length 10 at `[0x80..0x9F]`
- then the data at `[0xA0..]`
- update the pointer at `0x40` to mark the new end of memory.

---

### 🧠 Step 4 — You can control it manually (Yul / inline assembly)

If you write Yul or assembly, you can _choose_ where things go:

```yul
mstore(0x00, 123)     // store 123 at memory slot 0x00
mstore(0x20, 456)     // store 456 at memory slot 0x20
let x := mload(0x00)  // read back 123
```

You decide the offsets manually — it’s just a big byte array.

---

### 💬 TL;DR feelings version

😭 “How tf do you control where memory vars go??”
💙 “Solidity uses a system pointer stored at `0x40` to track the next free spot.
You can’t set it directly in high-level Solidity, but in Yul you can pick exact addresses with `mstore` and `mload`.
Memory is per-call, sequential, and managed like a scratchpad — not like storage slots.”

---

ick\*.
