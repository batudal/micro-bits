//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./lib/BaseLayer.sol";

/// @author takezo.eth
/// @notice Scalable microcolonies implementation
/// @dev Missions executed FIFO
/// @dev 2^16 ants per mission
contract MycroData {
    struct Workers {
        uint16 available_1hp;
        uint16 onmission_1hp;
        uint16 available_2hp;
        uint16 onmission_2hp;
        uint16 available_3hp;
        uint16 onmission_3hp;
    }

    struct WorkerMission {
        uint256 timestamp;
        uint16 worker_1hp;
        uint16 worker_2hp;
        uint16 worker_3hp;
    }

    error InsufficientAnts(uint32 available, uint32 required);

    mapping(address => Workers) workers;
    mapping(address => WorkerMission[]) worker_missions;
    address public controller;

    constructor(Workers memory _workers) {
        controller = msg.sender;
        workers[address(msg.sender)] = Workers({
            available_1hp: _workers.available_1hp,
            onmission_1hp: _workers.onmission_1hp,
            available_2hp: _workers.available_2hp,
            onmission_2hp: _workers.onmission_2hp,
            available_3hp: _workers.available_3hp,
            onmission_3hp: _workers.onmission_3hp
        });
    }

    modifier only_controller() {
        require(msg.sender == controller);
        _;
    }

    /// @dev temporary test functions
    function get_slot(uint8 _type, uint8 _slot) public view returns (uint16) {
        return BaseLayer.get_slot(_type, _slot);
    }

    function set_slot(
        uint16 _value,
        uint8 _type,
        uint8 _slot
    ) public {
        BaseLayer.set_slot(_value, _type, _slot);
    }

    function farm(uint16 _amount) external {
        uint16 available_1hp = BaseLayer.get_slot(0, 0);
        uint16 available_2hp = BaseLayer.get_slot(0, 2);
        uint16 available_3hp = BaseLayer.get_slot(0, 4);
        uint16 onmission_1hp = BaseLayer.get_slot(0, 1);
        uint16 onmission_2hp = BaseLayer.get_slot(0, 3);
        uint16 onmission_3hp = BaseLayer.get_slot(0, 5);
        WorkerMission memory mission;
        mission.timestamp = block.timestamp;
        if (
            uint32(_amount) >
            uint32(available_1hp) +
                uint32(available_2hp) +
                uint32(available_3hp)
        ) {
            revert InsufficientAnts({
                available: uint32(available_1hp) +
                    uint32(available_2hp) +
                    uint32(available_3hp),
                required: uint32(_amount)
            });
        }
        unchecked {
            if (_amount > available_1hp) {
                BaseLayer.set_slot(0, 0, 0);
                BaseLayer.set_slot(onmission_1hp + available_1hp, 0, 1);
                mission.worker_1hp = available_1hp;
                if (_amount - available_1hp > available_2hp) {
                    BaseLayer.set_slot(0, 0, 2);
                    BaseLayer.set_slot(onmission_2hp + available_2hp, 0, 3);
                    mission.worker_2hp = available_2hp;
                    BaseLayer.set_slot(
                        available_3hp -
                            (_amount - available_2hp - available_1hp),
                        0,
                        4
                    );
                    BaseLayer.set_slot(
                        onmission_3hp +
                            available_3hp -
                            (_amount - available_2hp - available_1hp),
                        0,
                        5
                    );
                    mission.worker_3hp =
                        available_3hp -
                        (_amount - available_2hp - available_1hp);
                } else {
                    BaseLayer.set_slot(available_2hp - _amount, 0, 2);
                    BaseLayer.set_slot(
                        onmission_2hp + available_2hp - _amount,
                        0,
                        3
                    );
                }
            } else {
                BaseLayer.set_slot(available_1hp - _amount, 0, 0);
                BaseLayer.set_slot(onmission_1hp + _amount, 0, 1);
                mission.worker_1hp = _amount;
            }
        }
    }
}
