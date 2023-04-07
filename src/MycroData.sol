//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./lib/Worker.sol";

/// @author takezo.eth
/// @notice Scalable microcolonies implementation
/// @dev Missions executed FIFO
/// @dev 2^16 ants per mission
contract MycroData {
    struct Colony {
        uint16 worker_1_hp_available;
        uint16 worker_1_hp_on_mission;
        uint16 worker_2_hp_available;
        uint16 worker_2_hp_on_mission;
        uint16 worker_3_hp_available;
        uint16 worker_3_hp_on_mission;
    }

    struct Mission {
        uint16 worker_1hp;
        uint16 worker_2hp;
        uint16 worker_3hp;
    }

    error InsufficientAnts(uint32 available, uint32 required);

    mapping(address => Colony) colonies;
    mapping(address => Mission[]) missions;
    address public controller;

    constructor() {
        controller = msg.sender;
        colonies[address(msg.sender)] = Colony({
            worker_1_hp_available: 42,
            worker_1_hp_on_mission: 0,
            worker_2_hp_available: 0,
            worker_2_hp_on_mission: 0,
            worker_3_hp_available: 0,
            worker_3_hp_on_mission: 0
        });
    }

    modifier only_controller() {
        require(msg.sender == controller);
        _;
    }

    function get_1hp_workers() external view returns (uint16) {
        return Worker.get_1hp_workers();
    }

    function get_2hp_workers() external view returns (uint16) {
        return Worker.get_2hp_workers();
    }

    function get_3hp_workers() external view returns (uint16) {
        return Worker.get_3hp_workers();
    }

    function set_1hp_workers(uint16 v) external {
        Worker.set_1hp_workers(v);
    }

    function farm(uint16 amount) external {
        uint16 w_1hp = Worker.get_1hp_workers();
        uint16 w_2hp = Worker.get_2hp_workers();
        uint16 w_3hp = Worker.get_3hp_workers();
        if (uint32(amount) > uint32(w_1hp) + uint32(w_2hp) + uint32(w_3hp)) {
            revert InsufficientAnts({
                available: uint32(w_1hp) + uint32(w_2hp) + uint32(w_3hp),
                required: uint32(amount)
            });
        }
        if (amount > w_1hp) {
            Worker.set_1hp_workers(0);
            if (amount - w_1hp > w_2hp) {
                Worker.set_2hp_workers(0);
                Worker.set_1hp_workers(w_2hp);
                Worker.set_3hp_workers(amount - w_1hp - w_2hp);
                Worker.set_2hp_workers(amount - w_1hp);
            } else {
                Worker.set_2hp_workers(amount - w_1hp);
            }
        } else {
            Worker.set_1hp_workers(w_1hp - amount);
        }
    }
}
