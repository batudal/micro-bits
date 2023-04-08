//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @author takezo.eth
/// @notice Scalable microcolonies implementation
library BaseLayer {
    function get_slot(uint8 _storage_slot, uint8 _slot)
        public
        view
        returns (uint16)
    {
        assembly {
            mstore(0, caller())
            mstore(0x20, _storage_slot)
            let slot := keccak256(0, 0x40)
            let v := shr(mul(_slot, 0x10), sload(slot))
            v := and(0xffff, v)
            mstore(0x00, v)
            return(0x00, 0x20)
        }
    }

    function set_slot(
        uint16 _value,
        uint8 _storage_slot,
        uint8 _slot
    ) public {
        assembly {
            mstore(0, caller())
            mstore(0x20, _storage_slot)
            let slot := keccak256(0, 0x40)
            let word := sload(slot)
            let v := shr(mul(_slot, 0x10), word)
            v := and(0xffff, v)
            v := xor(_value, v)
            v := shl(mul(_slot, 0x10), v)
            v := xor(v, word)
            sstore(slot, v)
        }
    }
}
