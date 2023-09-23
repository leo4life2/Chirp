// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { console } from "forge-std/Test.sol";
import {Script, console2} from "forge-std/Script.sol";
import {Chirp} from "../src/Chirp.sol";

contract ChirpScript is Script {


    function run() public {
        uint256 deployerKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        Chirp chirp = new Chirp();

        vm.stopBroadcast();
        console.log("Chirp Address: ", address(chirp));
    }
}
