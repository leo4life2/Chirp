// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Chirp} from "../src/Chirp.sol";

contract ChirpTest is Test {
    Chirp public chirp;

    function setUp() public {
        chirp = new Chirp();
    }

    function testPostPeep() public {
        string memory cid = "QmT78zSuBmuS4z925WZfrqQ1qHaJ56DQaTfyMUF7F8ff5o";
        
        chirp.postPeep(cid);

        (, address user, string memory peepCid, , uint256 likeCount, uint256 commentCount) = chirp.peeps(0);
        assertEq(user, address(this), "Peep poster address mismatch");
        assertEq(peepCid, cid, "Peep content ID mismatch");
        assertEq(likeCount, 0, "Initial like count should be 0");
        assertEq(commentCount, 0, "Initial comment count should be 0");
    }

    function testLikeAndUnlikePeep() public {
        chirp.postPeep("ExampleCID");

        chirp.likePeep(0);
        (, , , , uint256 likesAfterLike, ) = chirp.peeps(0);
        assertEq(likesAfterLike, 1, "Like count should be 1 after a like");

        chirp.likePeep(0);  // Unlike
        (, , , , uint256 likesAfterUnlike, ) = chirp.peeps(0);
        assertEq(likesAfterUnlike, 0, "Like count should be 0 after unlike");
    }

    function testCommentOnPeep() public {
        chirp.postPeep("AnotherExampleCID");
        string memory comment = "This is a test comment!";

        chirp.commentOnPeep(0, comment);
        (, , , , , uint256 commentsAfterComment) = chirp.peeps(0);
        assertEq(commentsAfterComment, 1, "Comment count should be 1 after a comment");
    }

}
