// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MycroData.sol";

contract MycroTest is Test {
    MycroData public mycro_data;

    function setUp() public {
        mycro_data = new MycroData();
    }

    function testGet1HPWorkers() public {
        uint16 workers_1hp = mycro_data.get_1hp_workers();
        assertEq(workers_1hp, 42);
    }

    function testSet1HPWorkers() public {
        mycro_data.set_1hp_workers(69);
        assertEq(mycro_data.get_1hp_workers(), 69);
    }

    function testFarm() public {
        mycro_data.farm(7);
    }
}
