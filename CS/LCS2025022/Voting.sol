// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {

    struct Candidate {
        string name;
        uint votes;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    function addCandidate(string memory name) public {
        candidates.push(Candidate(name, 0));
    }

    function vote(uint index) public {
        require(index < candidates.length, "Invalid candidate");
        require(!hasVoted[msg.sender], "Already voted");

        candidates[index].votes++;
        hasVoted[msg.sender] = true;
    }

    function getCandidateCount() public view returns (uint) {
        return candidates.length;
    }

    function getCandidate(uint index) public view returns (string memory, uint) {
        require(index < candidates.length, "Invalid candidate");
        Candidate memory c = candidates[index];
        return (c.name, c.votes);
    }
}

