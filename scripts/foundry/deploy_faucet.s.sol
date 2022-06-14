// SPDX-License-Identifier: MIT
pragma solidity >=0.8;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {MockERC20} from "../../src/MockERC20.sol";
import {Faucet} from "../../src/Faucet.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract DeployToken is Script {
    function run() external {
        vm.startBroadcast();

        // First, we need to deploy a token for the faucet
        console.log("Deploying the token...");
        IERC20 _deployedToken = IERC20(new MockERC20());
        console.log("Token deployed ", address(_deployedToken));

        // Deploy the faucet for the deployed token
        console.log("Deploying the faucet...");
        address _deployedFaucet = address(new Faucet(_deployedToken));
        console.log("Faucet deployed ", _deployedFaucet);
    }
}
