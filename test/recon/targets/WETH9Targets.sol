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

abstract contract Weth9Targets is BaseTargetFunctions, Properties {
    /// CUSTOM TARGET FUNCTIONS - Add your own target functions here ///

    /// @notice send ETH to the current actor
    function send_eth(uint256 amount) public payable {
        vm.prank(address(this));
        payable(address(_getActor())).transfer(amount);
    }

    /// AUTO GENERATED TARGET FUNCTIONS - WARNING: DO NOT DELETE OR MODIFY THIS LINE ///

    function weth9_deposit(uint256 amount) public payable updateGhosts asActor  {
        uint256 clampedAmount = between(amount, 0, address(_getActor()).balance);
        uint256 userBalanceBefore = weth9.balanceOf(address(_getActor()));
        weth9.deposit{value: clampedAmount}();
        uint256 userBalanceAfter = weth9.balanceOf(address(_getActor()));
        
        /// Property: Deposit > 0 should increase user balance
        t(userBalanceAfter == userBalanceBefore - clampedAmount, "weth9_deposit: user balance should increase");

        depositSum += clampedAmount;
    }

    function weth9_withdraw(uint256 wad) public updateGhosts asActor  {
        weth9.withdraw(wad);
        withdrawSum += wad;
    }

    function weth9_approve(address guy, uint256 wad) public asActor {
        weth9.approve(guy, wad);
    }

    function weth9_transfer(address dst, uint256 wad) public asActor {
        weth9.transfer(dst, wad);
    }

    function weth9_transferFrom(address src, address dst, uint256 wad) public asActor {
        weth9.transferFrom(src, dst, wad);
    }
}
