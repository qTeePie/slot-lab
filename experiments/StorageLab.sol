// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract StorageLab {
    uint256 public value;

    /// Takes an input number, and depending on range, performs different storage / arithmetic operation
    function controlPanel(uint256 code) external {
        if (code < 100) {
            assembly {
                // pushes value from storage onto stack
                let retrieved := sload(0x00)
                // pops retrieved + code of stack, pushes sum on stack
                let sum := add(retrieved, code)
            }
        }
    }

    function setValue(uint256 x) external {
        assembly {
            // store x to slot 0
            sstore(0x00, x)
        }
    }

    function getValue() external view returns (uint256 result) {
        assembly {
            // load from slot 0
            result := sload(0x00)
        }
    }
}
