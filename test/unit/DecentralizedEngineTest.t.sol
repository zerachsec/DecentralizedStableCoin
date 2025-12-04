// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test} from "lib/forge-std/src/Test.sol";
import {DeployScripts} from "../../script/DeployScripts.s.sol";
import {DecentralizedStableCoin} from "../DecentralizedStableCoin.sol";
import {DSCEngine} from "../DSCEngine.sol";

contract DecentralizedEngineTest {
    // Test contract logic will go here

    DeployScripts deployer;
    DecentralizedStableCoin dsc;
    DSCEngine dscEngine;

    function setup() external {
        deployer = new DeployScripts();
        (dsc, dscEngine) = deployer.run();
    }

    ////////// price feed tests //////////

    function testGetUsdValue() external {
        
    }

    }
