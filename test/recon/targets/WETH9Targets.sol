// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "../BeforeAfter.sol";
import {Properties} from "../Properties.sol";
// Chimera deps
import {vm} from "@chimera/Hevm.sol";

// Helpers
import {Panic} from "@recon/Panic.sol";

import "src/WETH9.sol";

abstract contract Weth9Targets is
    BaseTargetFunctions,
    Properties
{
    /// CUSTOM TARGET FUNCTIONS - Add your own target functions here ///
    function weth9_deposit_clamped(uint256 amount) public payable asActor {
        uint256 userWethBalanceBefore = weth9.balanceOf(_getActor());
        uint256 userEthBalanceBefore = address(_getActor()).balance;
        uint256 clampedAmount = between(amount, 1 , address(_getActor()).balance);
        weth9_deposit(clampedAmount);
        uint256 userWethBalanceAfter = weth9.balanceOf(_getActor());
        uint256 userEthBalanceAfter = address(_getActor()).balance;
        // PROPERTY: Weth balance should increase by the amount deposited
        t(userWethBalanceAfter == userWethBalanceBefore + clampedAmount, "weth9_deposit_clamped: weth balance should increase by the amount deposited");

        // PROPERTY: Eth balance should decrease by the amount deposited
        t(userEthBalanceAfter == userEthBalanceBefore - clampedAmount, "weth9_deposit_clamped: eth balance should decrease by the amount deposited");
    }

    function weth9_withdraw_clamped(uint256 amount) public payable asActor {
        uint256 beforeBalance = weth9.balanceOf(_getActor());
        uint256 beforeEthBalance = address(_getActor()).balance;
        uint256 clampedAmount = between(amount, 1 , weth9.balanceOf(_getActor()));
        weth9_withdraw(clampedAmount);
        uint256 afterBalance = weth9.balanceOf(_getActor());
        uint256 afterEthBalance = address(_getActor()).balance;


        // 1) Property_1: Weth balance should decrease after withdrawal
        t(beforeBalance > afterBalance, "weth9_withdraw_clamped: balance should decrease");

        // 2) Property_2: Eth balance should increase by the amount withdrawn
        t(beforeEthBalance + clampedAmount == afterEthBalance, "weth9_withdraw_clamped: eth balance should increase by the amount withdrawn");

    }

    /// AUTO GENERATED TARGET FUNCTIONS - WARNING: DO NOT DELETE OR MODIFY THIS LINE ///

    function weth9_approve(address guy, uint256 wad) public {
        weth9.approve(guy, wad);
    }

    function weth9_deposit(uint256 amount) public payable {
        weth9.deposit{value: amount}();

        sumDeposits += amount;
    }

    function weth9_transfer(address dst, uint256 wad) public {
        weth9.transfer(dst, wad);
    }

    function weth9_transferFrom(address src, address dst, uint256 wad) public {
        weth9.transferFrom(src, dst, wad);
    }

    function weth9_withdraw(uint256 wad) public {
        weth9.withdraw(wad);

        sumWithdrawals += wad;
    }
}