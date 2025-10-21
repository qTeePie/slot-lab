### 💫 The world state σ

Think of `σ` (sigma) as the **big global map of all accounts**.
Formally it’s like:

```
σ : Address → Account
```

Each `Account` contains:

```
{ nonce, balance, storageRoot, codeHash }
```

So basically, the _entire Ethereum universe_ is one giant dictionary:

```
σ[0xABCD...] → { storageRoot: 0x..., codeHash: 0x..., balance: 42 ether }
σ[0x1234...] → { storageRoot: 0x..., codeHash: 0x..., balance: 10 ether }
```

---

### 💾 “The current account address” = `Iₐ`

During execution of a transaction or internal call,
the EVM has an **execution environment** denoted `I`.
`Iₐ` means:

> “the address of the account whose code is currently being executed.”

So if you’re inside a contract call, `Iₐ` = `address(this)`.

---

### 🧩 What `σ′[Iₐ]ₛ[...] ≡ μₛ[1]` means

Let’s decode that line from the Yellow Paper:

> `σ′[Iₐ]ₛ[μₛ[0]] ≡ μₛ[1]`

- `σ′` → the _new world state_ after executing the instruction
- `Iₐ` → current contract’s address
- `ₛ` → \*storage trie of that account
- `μₛ[0]` → top of stack = the **storage key**
- `μₛ[1]` → next on stack = the **value**

So in plain language:

> “Take the current contract’s storage (σ[Iₐ]ₛ),
> and set the slot at key μₛ[0] to μₛ[1].”

That’s what `SSTORE` does.

**\*storage trie:**
each account only has 4 fields:
Account = { nonce, balance, storageRoot, codeHash }

✅ that’s literally all that lives inside the account entry in the world state σ.

BUT one of those fields (storageRoot)… is not the storage itself.
It’s a pointer (a hash root) to the account’s own Merkle-Patricia trie 🌳.

---

### 🧠 So where is this “account address” stored?

It’s **not in memory** or **stack** — it’s part of the **execution context `I`**,
which comes from the call frame that the EVM sets up whenever a contract call happens.

When you call a contract, the EVM creates:

```
I = (Iₐ, Iₒ, Iₚ, Iᵛ, I_d, I_c, Iₘ)
```

where `Iₐ` = current address, `Iₒ` = caller, `Iᵛ` = call value, etc.

So `Iₐ` is a _fixed field_ the interpreter keeps in that frame;
you can read it in Solidity via `address(this)`.

---

### ✨ tl;dr

| Symbol   | Meaning                     | Where it lives                          |
| :------- | :-------------------------- | :-------------------------------------- |
| `σ`      | World state (all accounts)  | Global trie in Ethereum                 |
| `σ[Iₐ]`  | Current contract’s account  | One entry in that trie                  |
| `σ[Iₐ]ₛ` | That account’s storage trie | Contract’s persistent key-value storage |
| `Iₐ`     | Current contract address    | Execution context (not stack/memory)    |

---

So when the Yellow Paper says

> “Save word to storage at the world state at the current account address,”
> it literally means:
> 🧠 _Update the global map `σ` at the key = address(this), slot = stack_top, value = stack_next._

You’re writing into the _global blockchain database_ at your contract’s address — not local memory anymore.
