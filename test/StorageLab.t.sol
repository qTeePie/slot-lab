// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "../lib/forge-std/src/Test.sol";
import "../solidity/experiments/StorageLab.sol";

contract StorageLabTest is Test {
    StorageLab lab;

    function setUp() public {
        lab = new StorageLab();
    }

    function testStoreAndLoad() public {
        uint256 gasBefore = gasleft();
        lab.setValue(123);
        uint256 gasUsed = gasBefore - gasleft();
        emit log_named_uint("Gas used for SSTORE", gasUsed);

        uint256 stored = lab.getValue();
        assertEq(stored, 123);
    }
}
