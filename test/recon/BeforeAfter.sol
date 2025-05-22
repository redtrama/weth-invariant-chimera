// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Setup} from "./Setup.sol";

// ghost variables for tracking state variable values before and after function calls
abstract contract BeforeAfter is Setup {
    struct Vars {
        uint256 weth9Balance;
    }

    Vars internal _before;
    Vars internal _after;

    modifier updateGhosts {
        __before();
        _;
        __after();
    }

    function __before() internal {
        _before.weth9Balance = weth9.balanceOf(_getActor());
    }

    function __after() internal {
        _after.weth9Balance = weth9.balanceOf(_getActor());
    }
}