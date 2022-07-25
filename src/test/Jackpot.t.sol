// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../Jackpot.sol";

contract DeployJackpot is Test {

    Jackpot public jackpot;
    function setUp() public {
       jackpot = new Jackpot(9152);
    }

    function testCanDeposit() public {
        jackpot.deposit{value: 0.2 ether}();
    }

    function testCanSpin() public {
        jackpot.spin();
    }
}
