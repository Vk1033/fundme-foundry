// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum USD should be 5");
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), address(this), "Owner should be the contract deployer");
    }
}
