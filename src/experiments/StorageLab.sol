// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

contract StorageLab {
    uint256 public value;

    /// Takes an input number, and depending on range, performs different storage / arithmetic operation
    function controlPanel(uint256 code) external {
        assembly {
            // push value from storage onto stack
            let val := sload(0x00)

            // case 1: code less than 100
            if lt(code, 100) {
                // do add operation, push sum onto stack, save to storage
                let result := add(val, code)
                sstore(0x00, result)
            }

            // case 2: 100 <= code < 200
            // for multiple clauses in if, use bitwise ops
            if and(lt(code, 200), iszero(lt(code, 100))) {
                let subtracted := sub(code, 99)
                let result := div(val, subtracted)

                sstore(0x00, result)
            }

            // case 3: code >= 200
            if iszero(lt(code, 200)) { sstore(0x00, 0) }
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
