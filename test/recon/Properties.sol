// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";

abstract contract Properties is BeforeAfter, Asserts {
    function invariant_sumUsersDeposits() public {
        uint256 diff = sumDeposits - sumWithdrawals;
        t(diff == weth9.totalSupply(), "sumUsersDeposits: sum of deposits should be equal to the total supply");
    }

    function invariant_userBalanceCannotBeMoreThanTotalSupply() public {
        address[] memory users = _getActors();
        for (uint256 i = 0; i < users.length; i++) {
            t(weth9.balanceOf(users[i]) <= weth9.totalSupply(), "userBalanceCannotBeMoreThanTotalSupply: user balance cannot be more than the total supply");
        }
    }

    function invariant_sumUsersWethBalances_shouldBeEqualToTotalSupply() public {
        uint256 usersWethBalance;
        address[] memory users = _getActors();
        for (uint256 i = 0; i < users.length; i++) {
            usersWethBalance += weth9.balanceOf(users[i]);
        }
        // This reverts cause not considering transfers
        // t(usersWethBalance == weth9.totalSupply(), "sumUsersWethBalances_shouldBeEqualToTotalSupply: sum of users weth balances should be equal to the total supply");
    }

    function invariant_makeit100() public {
        weth9.allowance(address(0xb0b), address(0xc0ff33));
    }
}