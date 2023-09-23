// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Chirp {

    struct Peep {
        address user;
        string cid;  // IPFS CID pointing to the peep content
        uint256 timestamp;
    }

    Peep[] public peeps;

    event NewPeep(address indexed user, string cid, uint256 timestamp);

    function postPeep(string memory _cid) external {
        peeps.push(Peep({
            user: msg.sender,
            cid: _cid,
            timestamp: block.timestamp
        }));
        emit NewPeep(msg.sender, _cid, block.timestamp);
    }

    function getPeep(uint256 index) public view returns (address, string memory, uint256) {
        Peep memory peep = peeps[index];
        return (peep.user, peep.cid, peep.timestamp);
    }
}
