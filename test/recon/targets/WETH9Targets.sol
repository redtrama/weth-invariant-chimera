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
    function weth9_deposit_clamped(uint256 amount) public payable asActor {
        uint256 userWethBalanceBefore = weth9.balanceOf(_getActor());
        uint256 userEthBalanceBefore = address(_getActor()).balance;
        uint256 clampedAmount = between(amount, 1, address(_getActor()).balance);
        weth9_deposit(clampedAmount);
        uint256 userWethBalanceAfter = weth9.balanceOf(_getActor());
        uint256 userEthBalanceAfter = address(_getActor()).balance;

        // DEPOSIT-01: Weth balance should increase by the amount deposited
        t(
            userWethBalanceAfter == userWethBalanceBefore + clampedAmount,
            "weth9_deposit_clamped: weth balance should increase by the amount deposited"
        );

        // DEPOSIT-02: Eth balance should decrease by the amount deposited
        t(
            userEthBalanceAfter == userEthBalanceBefore - clampedAmount,
            "weth9_deposit_clamped: eth balance should decrease by the amount deposited"
        );
    }

    function weth9_withdraw_clamped(uint256 amount) public payable asActor {
        uint256 userWethBalanceBefore = weth9.balanceOf(_getActor());
        uint256 userEthBalanceBefore = address(_getActor()).balance;
        uint256 clampedAmount = between(amount, 1, weth9.balanceOf(_getActor()));
        weth9_withdraw(clampedAmount);
        uint256 userWethBalanceAfter = weth9.balanceOf(_getActor());
        uint256 userEthBalanceAfter = address(_getActor()).balance;

        // 1) WITHDRAW-01: Weth balance should decrease after withdrawal
        t(userWethBalanceBefore - clampedAmount == userWethBalanceAfter, "weth9_withdraw_clamped: weth balance should decrease after withdraw");

        // 2) WITHDRAW-02: Eth balance should increase by the amount withdrawn
        t(
            userEthBalanceBefore + clampedAmount == userEthBalanceAfter,
            "weth9_withdraw_clamped: eth balance should increase by the amount withdrawn"
        );
    }

    /// AUTO GENERATED TARGET FUNCTIONS - WARNING: DO NOT DELETE OR MODIFY THIS LINE ///

    function weth9_approve(uint256 wad) public asActor {
        // get an actor from the list to approve
        address actor = _getActor();
        weth9.approve(actor, wad);
    }

    function weth9_deposit(uint256 amount) public asActor {
        weth9.deposit{value: amount}();

        sumDeposits += amount;
    }

    function weth9_transfer(address dst, uint256 wad) public asActor {
        // Get a random actor from the list as the destination
        address[] memory actors = _getActors();
        require(actors.length > 1, "Need at least 2 actors for transfer");
        
        // Select a different actor than the sender
        address sender = _getActor();
        address recipient;
        uint256 recipientIndex = uint256(keccak256(abi.encodePacked(block.timestamp))) % actors.length;
        recipient = actors[recipientIndex];
        
        // Make sure we don't transfer to ourselves
        if (recipient == sender) {
            recipientIndex = (recipientIndex + 1) % actors.length;
            recipient = actors[recipientIndex];
        }
        
        weth9.transfer(recipient, wad);
    }

    function weth9_transferFrom(address src, address dst, uint256 wad) public asActor {
        // Get a random actor from the list as the destination
        address[] memory actors = _getActors();
        require(actors.length > 1, "Need at least 2 actors for transferFrom");
        
        // Select different actors for source and destination
        address spender = _getActor();
        uint256 recipientIndex = uint256(keccak256(abi.encodePacked(block.timestamp))) % actors.length;
        address recipient = actors[recipientIndex];
        
        // Make sure recipient is different from spender
        if (recipient == spender) {
            recipientIndex = (recipientIndex + 1) % actors.length;
            recipient = actors[recipientIndex];
        }
        
        weth9.transferFrom(spender, recipient, wad);
    }

    function weth9_withdraw(uint256 wad) public asActor {
        weth9.withdraw(wad);

        sumWithdrawals += wad;
    }
}
