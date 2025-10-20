// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

// libraries
//import "forge-std/Test.sol";

/*function testTransientReset() public {
    TransientVsStorage c = new TransientVsStorage();

    c.writeBoth(123);
    (uint256 s, uint256 t1) = c.readBoth();
    console.log("tx1:", s, t1); // expect 123, 123

    // simulate new tx
    (s, uint256 t2) = c.readBoth();
    console.log("tx2:", s, t2); // expect 123, 0
}*/
