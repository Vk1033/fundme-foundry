// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 5 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE); // Give USER 10 ETH
    }

    function testMinDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18, "Minimum USD should be 5");
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender, "Owner should be the contract deployer");
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4, "Price feed version should be 4");
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert("Didnt send enough ETH");
        fundMe.fund(); // Sending 0.01 ETH, which is less than 5 USD at current price
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // Give USER 5 ETH
        fundMe.fund{value: SEND_VALUE}();

        assertEq(fundMe.getAddressToAmountFunded(USER), SEND_VALUE, "Funded amount should match sent value");
    }
}
