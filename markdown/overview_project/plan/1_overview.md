## ⚙️ **Task: “The Vault Switchboard” 🧠💾**

### 🪐 Concept

Build a single function that acts like a _mini control panel_ for a vault.
It takes an input number and — depending on what range it falls into —
performs a different storage or arithmetic operation using **raw assembly**.

---

### 🧩 what you’ll play with

- **`SLOAD` / `SSTORE`** — read and write to storage
- **`ADD` / `DIV` / `MUL`** — basic arithmetic directly in assembly
- **`JUMPI`** — conditional jump for branching
- **`MSTORE`** — write a result into memory for a return
- optionally **`STOP`** / `REVERT` for ending the execution

---

### 💻 What the function should do conceptually

When you call `controlPanel(uint256 code)`, it should:

1. **If code < 100** →
   load a stored counter from slot 0, add the code to it, and write it back.

2. **If 100 ≤ code < 200** →
   divide the current stored counter by `(code - 99)` and store that.

3. **If 200 ≤ code < 300** →
   reset the counter to `0`.

4. **Otherwise** →
   jump to a small block that writes `9999` into memory and returns it (without touching storage).

---

### 🧠 what this teaches you

- stack order discipline (`value`, `slot` order in SSTORE)
- conditional branching with `JUMPDEST` & `JUMPI`
- difference between transient memory and persistent storage
- gas feeling: arithmetic vs storage cost

---

### 🎯 success criteria

- You can call the function with different `code` values and see the slot change accordingly.
- You can measure gas for each branch (storage heavy vs memory only).
- You can optionally log the memory return to see what’s written there.

---
