// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";

abstract contract Properties is BeforeAfter, Asserts {

    /// INVARIANT-01: Individual user balance cannot be more than the total supply
    function invariant_01() public {
        address[] memory users = _getActors();
        for (uint256 i = 0; i < users.length; i++) {
            t(
                weth9.balanceOf(users[i]) <= weth9.totalSupply(),
                "INVARIANT-01: user balance cannot be more than the total supply"
            );
        }
    }

    /// INVARIANT-02: The sum of all users weth balances should be equal to the total supply
    function invariant_02() public {
        uint256 usersWethBalance;
        address[] memory users = _getActors();
        for (uint256 i = 0; i < users.length; i++) {
            usersWethBalance += weth9.balanceOf(users[i]);
        }
        /// TODO: make this check consider transfers
        t(usersWethBalance == weth9.totalSupply(), "INVARIANT-02: sum of users weth balances should be equal to the total supply");
    }

    /// INVARIANT-03: The sum of deposits minus the sum of withdrawals should be equal to the total supply
    function invariant_03() public {
        uint256 diff = sumDeposits - sumWithdrawals;
        t(diff == weth9.totalSupply(), "INVARIANT-03: sum of deposits should be equal to the total supply");
    }
}
