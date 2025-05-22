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
    function weth9_deposit_clamped(uint256 amount) public payable {
        uint256 clampedAmount = between(amount, 1 , address(this).balance);
        weth9_deposit(clampedAmount);
    }

    function weth9_withdraw_clamped(uint256 amount) public payable {
        uint256 clampedAmount = between(amount, 0 , weth9.balanceOf(address(this)));
        weth9_withdraw(clampedAmount);
    }

    /// AUTO GENERATED TARGET FUNCTIONS - WARNING: DO NOT DELETE OR MODIFY THIS LINE ///

    function weth9_approve(address guy, uint256 wad) public {
        weth9.approve(guy, wad);
    }

    function weth9_deposit(uint256 amount) public payable {
        weth9.deposit{value: amount}();
    }

    function weth9_transfer(address dst, uint256 wad) public {
        weth9.transfer(dst, wad);
    }

    function weth9_transferFrom(address src, address dst, uint256 wad) public {
        weth9.transferFrom(src, dst, wad);
    }

    function weth9_withdraw(uint256 wad) public {
        weth9.withdraw(wad);
    }
}