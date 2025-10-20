// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

/*
    Transient storage is introduced in EIP-1153 with opCodes TLOAD and TSTORE

    - TLOAD pops one 32-byte word from top of the stack
 */
contract TransientVsStorage {
    uint256 public persistent; // normal storage

    // Pick a literal for the transient slot
    uint256 internal constant TRANSIENT_SLOT = 0xBEEF;

    function writeBoth(uint256 value) external {
        persistent = value;
        assembly {
            tstore(TRANSIENT_SLOT, value)
        }
    }

    function readTransient() external view returns (uint256 result) {
        assembly {
            result := tload(TRANSIENT_SLOT)
        }
    }

    function readBoth() external view returns (uint256 stored, uint256 transientVal) {
        stored = persistent;
        assembly {
            transientVal := tload(TRANSIENT_SLOT)
        }
    }
}
