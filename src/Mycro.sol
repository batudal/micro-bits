//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";

/// @author takezo.eth
/// @notice Scalable microcolonies implementation
contract Mycro {
    struct Colony {
        uint16 worker_total;
        uint16 worker_1_hp;
        uint16 worker_2_hp;
        uint16 soldier_total;
        uint16 soldier_1_hp;
        uint16 soldier_zombie;
        uint16 soldier_scouting;
        uint16 zombie_defending;
        uint16 queen_total;
        uint16 queen_level_1;
        uint16 larva_total;
        uint16 larva_incubating;
        uint16 drone_total;
        uint16 drone_mating;
        uint16 princess_total;
        uint16 princess_mating;
    }
    mapping(address => Colony) colonies;

    constructor() {
        colonies[address(msg.sender)] = Colony({
            worker_total: 42,
            worker_1_hp: 1,
            worker_2_hp: 2,
            soldier_total: 3,
            soldier_1_hp: 4,
            soldier_zombie: 5,
            soldier_scouting: 6,
            zombie_defending: 7,
            queen_total: 8,
            queen_level_1: 9,
            larva_total: 10,
            larva_incubating: 11,
            drone_total: 12,
            drone_mating: 13,
            princess_total: 14,
            princess_mating: 15
        });
    }

    function get_total_workers() public view returns (uint16) {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := and(0xffff, mload(0))
            mstore(0x40, v)
            return(0x40, 0x20)
        }
    }

    function get_1hp_workers() public view returns (uint16) {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := shr(0x10, mload(0))
            v := and(0xffff, v)
            mstore(0x40, v)
            return(0x40, 0x20)
        }
    }

    function get_2hp_workers() private view returns (uint16) {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := shr(0x20, mload(0))
            v := and(0xffff, v)
            mstore(0x40, v)
            return(0x40, 0x20)
        }
    }

    function set_1hp_workers(uint16 whp) public {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := shr(0x10, mload(0))
            v := and(0xffff, v)
            v := xor(whp, v)
            v := shl(0x10, v)
            v := xor(v, mload(0))
            sstore(slot, v)
        }
    }

    function set_2hp_workers(uint16 whp) public {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := shr(0x20, mload(0))
            v := and(0xffff, v)
            v := xor(whp, v)
            v := shl(0x20, v)
            v := xor(v, mload(0))
            sstore(slot, v)
        }
    }

    function decrease_worker_hp(uint16 whp) private {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := shr(0x20, mload(0))
            v := and(0xffff, v)
            v := xor(whp, v)
            v := shl(0x20, v)
            v := xor(v, mload(0))
            sstore(slot, v)
        }
    }
}
