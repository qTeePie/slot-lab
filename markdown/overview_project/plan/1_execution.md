## 🌕 **EVM Mastery Roadmap (Yellow Paper Edition)**

### 🩵 **Phase 1 — Machine state fundamentals (μ)**

💡 Goal: understand _what the EVM actually keeps in its head_ while running.

**Steps:**

1. Learn what’s inside the **machine state μ**:

   - stack (LIFO, 1024 max)
   - memory (volatile, byte-addressed)
   - program counter (PC)
   - gas counter
   - current instruction (`I`)

2. Understand **word size (32 bytes)** and how everything is padded.
3. Be able to describe what happens when you execute one instruction:
   `μ′ = Ξ(σ, μ, I)` (new machine state after step).

✨ _Mini goals:_

- Know what “top of stack” means (`μₛ[0]`).
- Know that memory autogrows in 32-byte chunks.

---

### 💙 **Phase 2 — World state (σ)**

💡 Goal: understand the persistent part of Ethereum (the “global hard drive”).

**Steps:**

1. Understand `σ : Address → Account`.
2. Know the 4 account fields:
   `{ nonce, balance, storageRoot, codeHash }`.
3. Understand how `σ[a]ₛ` = the _storage trie_ of that address.
4. Learn that `storageRoot` is a Merkle hash of that trie.
5. Realize: `SSTORE` / `SLOAD` modify or read _σ[Iₐ]ₛ[key]_.

✨ _Mini goals:_

- Visualize one contract’s storage as its own tree.
- Know that `SSTORE` changes the world state σ, but `MSTORE` only changes μₘ (memory).

---

### 💜 **Phase 3 — Execution environment (I)**

💡 Goal: understand what “context” a contract executes in.

**Steps:**

1. Know each field:
   `Iₐ` (address), `Iₒ` (originator), `Iᵥ` (value), `I_d` (calldata), `I_c` (caller), `I_g` (gas).
2. Understand how this changes with `CALL` and `DELEGATECALL`.
3. Be able to tell what’s _shared_ (access list, gas) and what’s _isolated_ (storage, memory).

---

### 💚 **Phase 4 — Opcode behavior**

💡 Goal: understand how each group of opcodes maps to the machine/world state.

**Categories to study:**

| group        | examples                                   | what to notice           |
| :----------- | :----------------------------------------- | :----------------------- |
| Stack ops    | `PUSH`, `POP`, `SWAP`, `DUP`               | purely μₛ                |
| Arithmetic   | `ADD`, `MUL`, `DIV`, `MOD`                 | cheap, 3–5 gas           |
| Memory       | `MLOAD`, `MSTORE`, `MSIZE`, `CALLDATACOPY` | transient, per-call only |
| Storage      | `SLOAD`, `SSTORE`                          | persistent, affects σ    |
| Transient    | `TLOAD`, `TSTORE`                          | clears at end of tx      |
| Flow control | `JUMP`, `JUMPI`, `STOP`, `REVERT`          | program counter control  |
| Environment  | `ADDRESS`, `CALLER`, `CALLVALUE`, etc.     | read from `I`            |
| System       | `CALL`, `DELEGATECALL`, `CREATE`, `RETURN` | spawn new frames         |

✨ _Mini goals:_

- Be able to trace how each opcode touches μ, σ, or I.
- Know gas cost types: very low / low / mid / high / access list adjustments.

---

### 💛 **Phase 5 — Gas & refunds**

💡 Goal: understand how gas changes after each instruction.

**Steps:**

1. Know `C` = cost function (e.g. `C_SSTORE`, `C_SLOAD`).
2. Learn what “cold” vs “warm” means (EIP-2929).
3. Understand `Aₖ` (access list) and `Aᵣ` (refund counter).
4. Learn refund logic (`R_sclear`, `r_dirtyclear`, `r_dirtyreset`).

✨ _Mini goals:_

- Be able to read the full `C_SSTORE` formula and explain each branch.
- Know that refunds apply **at the end of the transaction**.

---

### 💜 **Phase 6 — Transient storage (EIP-1153)**

💡 Goal: understand `TSTORE` / `TLOAD`.

**Steps:**

1. Understand it lives like storage (key-value) but resets at end of tx.
2. Read the EIP formal spec (similar logic to `SSTORE`, just ephemeral).
3. Compare gas cost to normal storage.

✨ _Mini goals:_

- Show that data disappears after tx ends.
- Use it as an “on-chain temp variable” demo.

---

### 💙 **Phase 7 — Contracts calling contracts**

💡 Goal: see how `CALL`, `DELEGATECALL`, and `CREATE` modify context.

**Steps:**

1. Trace which parts of `I` change.
2. Observe gas forwarding, return data, and shared access list.
3. Experiment with nested calls in your lab contract.

---

### 💚 **Phase 8 — Putting it together**

💡 Goal: apply it all.

**Project ideas:**

- build your _Vault Switchboard_
- create a “gas profiler” contract that logs gas before and after opcodes
- simulate your own mini-EVM step function in JavaScript

---

### 💫 optional “advanced boss level”

- Read how `SELFDESTRUCT` interacts with gas refunds.
- Dive into the CREATE2 address formula.
- Peek at precompiles (`ecrecover`, `sha256`, etc.).

---
