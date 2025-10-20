### 🧩 Solidity level

you get the _safe abstractions_ — `uint256 x; x = 1;` — compiler picks the opcodes for you.

### ⚙️ Assembly / Yul level

you pop the hood and _see or issue_ the exact opcodes yourself.
that’s where you can test questions such as:

- “what’s the gas delta between `SSTORE` and `TSTORE`?”
- “what value do I really get if I `sload` slot 0 before anything’s written?”
- “what happens if I manually write to a mapping key?”

so yeah, inline assembly and Yul are _integral_ if your repo’s about storage, slots, and low-level Solidity behavior.

---

### 🚧 How it fits inside your lab

You could have folders like:

```
/experiments
    01_sstore_vs_tstore.sol
    02_manual_sload_yul.sol
    03_mapping_slot_math.sol
/yul
    demo_sstore.yul
    mapping_math.yul
```

- `.sol` files → mix Solidity + `assembly { ... }` blocks.
- pure `.yul` files → minimal examples with only Yul, no Solidity sugar.

Both live perfectly under the same umbrella: **you’re studying how Solidity maps to EVM storage opcodes.**

---

💬 **TL;DR**

> Yul = the language to write or inspect opcodes directly.
> Inline assembly = your portal to use Yul inside Solidity.
> Your storage lab = the playground tying them together.

---
