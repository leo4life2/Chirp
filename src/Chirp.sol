// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Chirp {

    struct Comment {
        address user;
        string cid;  // IPFS CID pointing to the comment content
        uint256 timestamp;
    }

    struct Peep {
        uint256 index;
        address user;
        string cid;  // IPFS CID pointing to the peep content
        uint256 timestamp;
        uint256 likeCount;  // Counter for number of likes
        uint256 commentCount;  // Counter for number of comments
    }

    Peep[] public peeps;
    uint256 public peepIndex = 0;  // Global peep index to track each Peep

    mapping(uint256 => mapping(address => bool)) public hasLiked;
    mapping(uint256 => Comment[]) public peepComments;

    event NewPeep(uint256 indexed peepIndex, address indexed user, string cid, uint256 timestamp);  
    event NewLike(address indexed user, uint256 indexed peepIndex);
    event RemovedLike(address indexed user, uint256 indexed peepIndex);
    event NewComment(address indexed user, uint256 indexed peepIndex, string cid, uint256 timestamp);  // Modified to use CID

    function postPeep(string memory _cid) external {
        peeps.push(Peep({
            index: peepIndex,
            user: msg.sender,
            cid: _cid,
            timestamp: block.timestamp,
            likeCount: 0,
            commentCount: 0
        }));
        emit NewPeep(peepIndex, msg.sender, _cid, block.timestamp);
        peepIndex += 1;
    }

    function likePeep(uint256 _peepIndex) external {
        require(_peepIndex < peeps.length, "Peep index out of bounds");
        
        if (hasLiked[_peepIndex][msg.sender]) {
            hasLiked[_peepIndex][msg.sender] = false;
            peeps[_peepIndex].likeCount -= 1;
            emit RemovedLike(msg.sender, _peepIndex);
        } else {
            hasLiked[_peepIndex][msg.sender] = true;
            peeps[_peepIndex].likeCount += 1;
            emit NewLike(msg.sender, _peepIndex);
        }
    }

    function commentOnPeep(uint256 _peepIndex, string memory commentCid) external {
        require(_peepIndex < peeps.length, "Peep index out of bounds");
        
        Comment memory newComment = Comment({
            user: msg.sender,
            cid: commentCid,  // Storing the CID of the comment
            timestamp: block.timestamp
        });

        peepComments[_peepIndex].push(newComment);
        peeps[_peepIndex].commentCount += 1;

        emit NewComment(msg.sender, _peepIndex, commentCid, block.timestamp);
    }

    function getComments(uint256 _peepIndex) external view returns (Comment[] memory) {
        return peepComments[_peepIndex];
    }
}