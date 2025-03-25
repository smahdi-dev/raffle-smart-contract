// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";

abstract contract CodeConstants {
    uint256 public constant SEPOLIA_ETH_CHAINID = 11155111;
    uint256 public constant LOCAL_CHAINID = 31337;
}

contract HelperConfig is CodeConstants, Script {
    error HelperConfig__InvalidChainid();

    struct NetworkConfig {
        uint256 entranceFee;
        uint256 interval;
        address vrfCoordinator;
        bytes32 gasLane;
        uint256 subscriptionId;
        uint32 callbackGasLimit;
    }

    NetworkConfig public localNetworkConfig;
    mapping (uint256 chainid => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[SEPOLIA_ETH_CHAINID] = getSepoliaEthConfig();
    }

    function getConfigByChainid(uint256 chainid) public returns (NetworkConfig memory) {
        if (networkConfigs[chainid].vrfCoordinator != address(0)) {
            return networkConfigs[chainid];
        } else if (chainid == LOCAL_CHAINID) {
            getOrCreateAnvilConfig();
        } else {
            revert HelperConfig__InvalidChainid();
        }
    }

    function getSepoliaEthConfig() public pure returns (memory NetworkConfig) {
        return  NetworkConfig ({
            entranceFee: 0.01 ether, // 1e16 wei
            interval: 30,
            vrfCoordinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae,
            subscriptionId: 0,
            callbackGasLimit: 50000,
        })
    }

    function getOrCreateAnvilConfig() public return (NetworkConfig memory) {
        if (localNetworkConfig.vrfCoordinator != address(0)) {
            return localNetworkConfig
        }
    }
}
