// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";

abstract contract Properties is BeforeAfter, Asserts {
    bool hasWithrawn;

    uint256 sumUserBalances;

    uint256 depositSum;
    uint256 withdrawSum;



    /// === INVARIANTS === ///

    /// 1) Sum of user balances should be equal to totalSupply
    function invariant_userBalances_equal_totalSupply() public {
        for (uint256 i = 0; i < _getActors().length; i++) {
            address actor = _getActors()[i];
            uint256 balance = weth9.balanceOf(actor);
            sumUserBalances += balance;
        }

        t(sumUserBalances == weth9.totalSupply(), "sum of user balances should be equalt to totalSupply");
    }

    /// 2) Deposit sum minus withdraw sum should be equal to total supply
    function invariant_totalSupply_1() public {
        t(depositSum - withdrawSum == weth9.totalSupply(), "Deposit sum minus withdraw sum should be equal to total supply");
    }

    function canary_hasWithdrawn() public {
        t(!hasWithrawn, "fail");
    }
}
