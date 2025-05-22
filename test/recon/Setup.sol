// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

// Chimera deps
import {BaseSetup} from "@chimera/BaseSetup.sol";
import {vm} from "@chimera/Hevm.sol";

// Managers
import {ActorManager} from "@recon/ActorManager.sol";
import {AssetManager} from "@recon/AssetManager.sol";

// Helpers
import {Utils} from "@recon/Utils.sol";

import {console2} from "forge-std/console2.sol";

// Your deps
import "src/WETH9.sol";

abstract contract Setup is BaseSetup, ActorManager, AssetManager, Utils {
    WETH9 weth9;

    uint256 sumDeposits;
    uint256 sumWithdrawals;
    
    /// === Setup === ///
    /// This contains all calls to be performed in the tester constructor, both for Echidna and Foundry
    function setup() internal virtual override {
        weth9 = new WETH9(); // TODO: Add parameters here

        _addActor(address(0xb0b));
        _addActor(address(0xc0ff33));

        // Fund actors with 100 ether
        vm.deal(address(0xb0b), 100 ether);
        vm.deal(address(0xc0ff33), 100 ether);

        console2.log("weth9 balance of 0xb0b", address(0xb0b).balance);
    }

    fallback() external payable {
        // TODO: Add fallback logic here
    }

    /// === MODIFIERS === ///
    /// Prank admin and actor
    
    modifier asAdmin {
        vm.prank(address(this));
        _;
    }

    modifier asActor {
        vm.prank(address(_getActor()));
        _;
    }
}
