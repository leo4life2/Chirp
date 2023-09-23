// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Chirp} from "../src/Chirp.sol";

contract ChirpTest is Test {
    Chirp public chirp;

    function setUp() public {
        chirp = new Chirp();
    }

    function test_PostPeep() public {
        string memory testCID = "QmT78zSuBmuS4z925WZfrqQ1qHaJ56DQaTfyMUF7F8ff5o"; // Example CID
        chirp.postPeep(testCID);

        (address user, string memory cid, uint256 timestamp) = chirp.getPeep(0);
        assertEq(user, address(this));
        assertEq(cid, testCID);
    }
}