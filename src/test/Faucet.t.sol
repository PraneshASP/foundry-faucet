// SPDX-License-Identifier: MIT
pragma solidity >=0.8;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";

import {Utils} from "./utils/Utils.sol";
import {Faucet} from "../Faucet.sol";
import {MockERC20} from "../MockERC20.sol";

contract BaseSetup is Test {
    Utils internal utils;
    Faucet internal faucet;
    MockERC20 internal token;

    address payable[] internal users;
    address internal owner;
    address internal dev;
    uint256 internal faucetBal = 1000;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(2);
        owner = users[0];
        vm.label(owner, "Owner");
        dev = users[1];
        vm.label(dev, "Developer");

        token = new MockERC20();
        faucet = new Faucet(IERC20(token));
        token.mint(address(faucet), faucetBal);
    }
}

contract FaucetTest is BaseSetup {
    uint256 amountToDrip = 1;

    function setup() public override {
        super.setUp();
    }

    function test_drip_transferToDev() public {
        console.log(
            "Should transfer tokens to recipient when `drip()` is called"
        );
        uint256 _inititalDevBal = token.balanceOf(dev);

        // Make sure that initial dev balance is Zero
        assertEq(_inititalDevBal, 0);

        // Request some tokens to the dev wallet from the wallet
        faucet.drip(dev, amountToDrip);

        uint256 _devBalAfterDrip = token.balanceOf(dev);

        /// The difference should be equal to the amount requested from the faucet
        assertEq(_devBalAfterDrip - _inititalDevBal, amountToDrip);
    }

    function test_drip_reduceFaucetBalance() public {
        console.log("The faucet balance should be reduced");
        faucet.drip(dev, amountToDrip);
        assertEq(token.balanceOf(address(faucet)), faucetBal - amountToDrip);
    }

    function test_drip_revertIfThrottled() public {
        console.log("Should revert if tried to throttle");
        faucet.drip(dev, amountToDrip);

        vm.expectRevert(abi.encodePacked("TRY_LATER"));
        faucet.drip(dev, amountToDrip);
    }

    function test_drip_revertIfLimitExceeded() public {
        console.log("Should revert if tried to request more than limit");
        vm.expectRevert(abi.encodePacked("EXCEEDS_LIMIT"));
        faucet.drip(dev, 1000);
    }

    function test_drip_revertIfZeroAddress() public {
        console.log("Should revert if recipient is ZERO_ADDRESS");
        vm.expectRevert(abi.encodePacked("INVALID_RECIPIENT"));
        faucet.drip(address(0), amountToDrip);
    }

    function test_drip_withFuzzing(address _recipient, uint256 _amount) public {
        console.log("Should handle fuzzing");
        /// inform the constraints to the fuzzer, so that the tests dont revert on bad inputs.
        vm.assume(_amount <= 100);
        vm.assume(_recipient != address(0));
        uint256 _inititalBal = token.balanceOf(_recipient);
        faucet.drip(_recipient, _amount);
        uint256 _balAfterDrip = token.balanceOf(_recipient);
        assertEq(_balAfterDrip - _inititalBal, _amount);
        assertEq(token.balanceOf(address(faucet)), faucetBal - _amount);
    }

    function test_setLimit() public {
        console.log("Should set the limit when called by the owner");
        faucet.setLimit(1000);

        /// the `limit` should be updated
        assertEq(faucet.limit(), 1000);
    }

    function test_setLimit_revertIfNotOwner() public {
        console.log("Should revert if not called by Owner");
        /// Sets the msg.sender as `dev` for the next tx
        vm.prank(dev);
        vm.expectRevert(abi.encodePacked("Ownable: caller is not the owner"));
        faucet.setLimit(1000);
    }
}
