// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Setup} from "./Setup.sol";

// ghost variables for tracking state variable values before and after function calls
abstract contract BeforeAfter is Setup {
    struct Vars {
        uint256 __ignore__;
        // TODO rename do wethUserBalance
        uint256 userBalance;
    }

    Vars internal _before;
    Vars internal _after;

    modifier updateGhosts() {
        __before();
        _;
        __after();
    }

    function __before() internal {
        _before.userBalance = weth9.balanceOf(address(_getActor()));
    }

    function __after() internal {
        _after.userBalance = weth9.balanceOf(address(_getActor()));
    }
}
