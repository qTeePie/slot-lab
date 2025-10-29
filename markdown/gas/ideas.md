### 🧪 runtime vs creation — loop test idea

```solidity
assembly {
assembly {
            // first 32 bytes is creation's size
            let crSize := mload(creation)
            let crPtr := add(creation, 0x20) // skips size

            // position of 0x3f (return from constructor) + 1 is start of runtime
            let offset := add(pos, 1)

            let runPtr := add(crPtr, offset)
            let runSize := sub(crSize, offset) // full length - constructor

            // 0x40 stores next available slot in memory
            runtime := mload(0x40) // the base slot for runtime
            let dest := add(runtime, 0x20) // destination for array data
            mstore(runtime, runSize) // store array length as first 32 bytes

            let i := 0
            for {} lt(i, runSize) {} {
                // at dest + i, store the thing in creation at offset +1
                let value := mload(add(runPtr, i))
                mstore(add(dest, i), value)

                i := add(i, 0x20) // increments pointer 32 bytes
            }

            // update 0x40 to hold next available slot
            mstore(0x40, add(dest, and(add(runSize, 0x3f), not(0x1f))))
        }
}
```

This is an example from slicing bytecode after 0xf3 to isolate runtime from creationCode. Do something similar with splitting bytearrays in assembly vs soldiity.
to test how `mload/mstore` behaves when looping & copying large byte chunks, compare it later to solidity slice performance.
