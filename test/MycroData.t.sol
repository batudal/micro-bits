// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../src/MycroData.sol";

contract MycroTest is Test {
    MycroData public mycro_data;
    MycroData.Workers public initial;
    error InsufficientAnts(uint32 available, uint32 required);

    function setUp() public {
        initial = MycroData.Workers({
            available_1hp: 42,
            onmission_1hp: 12,
            available_2hp: 0,
            onmission_2hp: 0,
            available_3hp: 0,
            onmission_3hp: 0
        });
        mycro_data = new MycroData(initial);
    }

    function test_GetSlot() public {
        uint16 res = mycro_data.get_slot(0, 0);
        assertEq(res, initial.available_1hp);
        uint16 res_2 = mycro_data.get_slot(0, 1);
        assertEq(res_2, initial.onmission_1hp);
    }

    function test_SetSlot() public {
        mycro_data.set_slot(666, 0, 0);
        assertEq(mycro_data.get_slot(0, 0), 666);
        mycro_data.set_slot(365, 0, 2);
        assertEq(mycro_data.get_slot(0, 2), 365);
    }

    function test_Farm() public {
        mycro_data.farm(15);
        assertEq(mycro_data.get_slot(0, 0), initial.available_1hp - 15);
        assertEq(mycro_data.get_slot(0, 1), initial.onmission_1hp + 15);
    }

    function testFail_Farm() public {
        vm.expectRevert(
            abi.encodeWithSignature(
                "InsufficientAnts(uint32 available, uint32 required)",
                42,
                69
            )
        );
        mycro_data.farm(69);
    }
}
