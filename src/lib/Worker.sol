//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @author takezo.eth
/// @notice Scalable microcolonies implementation
library Worker {
    function get_1hp_workers() public view returns (uint16) {
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

    function get_2hp_workers() public view returns (uint16) {
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

    function get_3hp_workers() public view returns (uint16) {
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

    function set_1hp_workers(uint16 hp) public {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := and(0xffff, mload(0))
            v := xor(hp, v)
            v := xor(v, mload(0))
            sstore(slot, v)
        }
    }

    function set_2hp_workers(uint16 hp) public {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := shr(0x10, mload(0))
            v := and(0xffff, v)
            v := xor(hp, v)
            v := shl(0x10, v)
            v := xor(v, mload(0))
            sstore(slot, v)
        }
    }

    function set_3hp_workers(uint16 hp) public {
        assembly {
            mstore(0, caller())
            mstore(0x20, 0)
            let slot := keccak256(0, 0x40)
            mstore(0, sload(slot))
            let v := shr(0x20, mload(0))
            v := and(0xffff, v)
            v := xor(hp, v)
            v := shl(0x20, v)
            v := xor(v, mload(0))
            sstore(slot, v)
        }
    }
}
