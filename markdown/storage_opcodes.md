# Relevant OpCodes

**opcodes to cover: SLOAD, SSTORE, TLOAD, TSTORE, MLOAD, MSTORE, MSIZE, CALLDATACOPY, CODECOPY, etc.**

## Definitions

**Word** - In the EVM, a word = 32 bytes (256 bits) — it’s the basic unit of data the EVM reads, writes, and operates on.

> 1 word = 32 bytes = 256 bits = smallest chunk the EVM understands natively.

Everything — stack slots, memory cells, storage values — is organized in words.

**Machine state** - The machine state μ is like the RAM inside your running EVM instance for a single transaction.

**Memory counter (μᵢ)** - The memory counter tracks how much memory (in 32-byte words) the EVM has expanded so far during the current call.

Every time an opcode touches memory, the EVM checks if the accessed address lies beyond what’s already allocated.

> The memory counter shows how far your memory has expanded up until some moment.
>
> If you read something inside the region you already paid for — like you first read slot 1, then later slot 3 (paying once to reach that far), and then go back to slot 2 — the counter stays the same and that last move costs 0 extra gas, because you’re still inside the paid-for memory.

The memory counter shows how far your memory has expanded so far.
If you read or write further out than before, the counter goes up and you pay gas.
If you stay inside the memory you already used, the counter stays the same and costs 0 extra gas.

---

## MEMORY

### MLOAD 0x51

Load word from memory.

**Number of items**
Popped from the stack: 1
Pushed onto the stack: 1

> The top of the stack after running MLOAD `μ′ₛ[0]`
> will contain the 32-byte word found in the machine state memory `μₘ`
> at the memory offset equal to whatever was on top of the stack before `μₛ[0]`,
> i.e. the bytes from `μₘ[μₛ[0]]` through `μₘ[μₛ[0] + 31]`.

**Simpler:**

It pops the top value from the stack (this value = a memory address, i.e. where in memory to read).
It then reads 32 bytes from memory starting at that address (μₘ[address … address + 31]).

Finally, it pushes that 32-byte word (the data it just fetched) back onto the stack.

_it_ being the EVM.

---

## STORAGE

### SLOAD 0x54

Load word from storage.

**Number of items**
Popped from the stack: 1
Pushed onto the stack: 1

> The top of the stack after running SLOAD `μ′ₛ[0]`
> will contain the storage value found in the world state `σ`
> at this contract’s address `Iₐ`
> and at the storage key equal to whatever was on top of the stack before `μₛ[0]`.

**Simpler:**

```
stack top = storage[currentContract][key]
```

Gas cost is calculated depending on whether this (contract address, storage key) pair is warm or cold (see EIP-2929).

A slot is warm if it has already been accessed earlier in this transaction,
and cold if it’s being touched for the first time.

This check is per-contract and per-storage-slot.
