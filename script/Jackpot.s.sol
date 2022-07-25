// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "./HelperConfig.sol";
import "../src/Jackpot.sol";

contract DeployJackpot is Script, HelperConfig {

    function run() external {
        HelperConfig helperConfig = new HelperConfig();
        uint64 subscriptionId = 9152;
        vm.startBroadcast();
        Jackpot createJackpot = new Jackpot(subscriptionId);

        vm.stopBroadcast();
    }
}
