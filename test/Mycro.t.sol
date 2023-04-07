// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Mycro.sol";

contract MycroTest is Test {
    Mycro public mycro;

    function setUp() public {
        mycro = new Mycro();
    }

    function testTotalWorker() public {
        uint16 total_workers = mycro.get_total_workers();
        assertEq(total_workers, 42);
    }

    function testSet1HPWorker() public {
        mycro.set_1hp_workers(31);
        assertEq(mycro.get_1hp_workers(), 31);
    }
}
