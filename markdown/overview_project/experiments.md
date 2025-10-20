### 🧪 structure idea

make a repo called something like **`slot-lab`** (or `evm-slot-lab` if you want it to sound a bit more technical) and have folders:

```
/experiments
    01_transient_vs_storage.sol
    02_inheritance_slots.sol
    03_struct_packing.sol
    04_mapping_layout.sol
    05_constant_vs_immutable.sol
    06_delete_behavior.sol
    07_selfdestruct_slots.sol
    08_upgrade_collision.sol
/tests
    test_01_transient_vs_storage.t.sol
    ...
README.md
```

each experiment = one “mythbusting” contract with short Foundry tests that log slot contents before/after actions.

---

### 🔥 possible experiment ideas

- **transient vs storage** — log what persists between txs.
- **inheritance shift** — deploy parent/child and dump slot positions.
- **struct + array packing** — test alignment rules with weird combos.
- **bit-packing edge cases** — prove where data overlaps or not.
- **constant/immutable** — show that they don’t occupy runtime storage.
- **delete() behavior** — see how clearing affects gas refunds.
- **SSTORE gas refunds** — measure actual refund behavior post-EIP-3529.
- **storage collision demo** — intentionally overlap layout like in proxy bugs.
- **layout at N** — try the new Solidity 0.8.29 feature.
- **mapping slot math** — manually derive and read mapping positions in assembly.

---

### 🧩 goal vibe

> “A living notebook of low-level Solidity experiments: slots, packing, gas, and storage weirdness.”

It doesn’t have to _do_ anything — each file just isolates one mechanic, explains it, and proves it with code.

---

### 🧠 meta-twist

You could even have a “registry” contract that tracks all experiment addresses and emits events when you deploy new ones — just as a cheeky nod to the structure you love.

---
