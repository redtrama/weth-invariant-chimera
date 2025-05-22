// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Asserts} from "@chimera/Asserts.sol";
import {BeforeAfter} from "./BeforeAfter.sol";

abstract contract Properties is BeforeAfter, Asserts {
    function invariant_sumUsersDeposits() public {
        uint256 diff = sumDeposits - sumWithdrawals;
        t(diff == weth9.totalSupply(), "sumUsersDeposits: sum of deposits should be equal to the total supply");
    }
}