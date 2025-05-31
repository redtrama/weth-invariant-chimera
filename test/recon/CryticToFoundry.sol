// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";

import "forge-std/console2.sol";

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";

// forge test --match-contract CryticToFoundry -vv
contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    function setUp() public {
        setup();

        targetContract(address(this));
    }

    // forge test --match-test test_crytic -vvv
    function test_crytic() public {
        weth9_deposit_clamped(1);
        weth9_withdraw_clamped(1);
    }

    // forge test --match-test test_weth9_deposit_clamped_0 -vvv

    function test_weth9_deposit_clamped_0() public {
        vm.roll(24607);
        vm.warp(462279);
        switchActor(138022073656404542855550702796636927239616147374028125279881);

        vm.roll(24656);
        vm.warp(1010921);
        weth9_deposit_clamped(46768052394588893382517914646921056761206240445425);
    }
}
