// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    address public owner;

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) private candidates;
    uint[] private candidateIds;
    mapping(address => bool) public hasVoted;
    uint private nextId = 1;

    event CandidateAdded(uint id, string name);
    event Voted(address voter, uint candidateId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addCandidate(string calldata name) external onlyOwner {
        require(bytes(name).length > 0, "Name required");
        uint id = nextId++;
        candidates[id] = Candidate(id, name, 0);
        candidateIds.push(id);
        emit CandidateAdded(id, name);
    }

    function vote(uint candidateId) external {
        require(!hasVoted[msg.sender], "Already voted");
        require(candidateId > 0 && candidateId < nextId, "Invalid candidate");
        hasVoted[msg.sender] = true;
        candidates[candidateId].voteCount += 1;
        emit Voted(msg.sender, candidateId);
    }

    function getCandidate(uint candidateId) external view returns (uint, string memory, uint) {
        require(candidateId > 0 && candidateId < nextId, "Invalid candidate");
        Candidate storage c = candidates[candidateId];
        return (c.id, c.name, c.voteCount);
    }

    function getCandidateIds() external view returns (uint[] memory) {
        return candidateIds;
    }

    function totalVotes(uint candidateId) external view returns (uint) {
        require(candidateId > 0 && candidateId < nextId, "Invalid candidate");
        return candidates[candidateId].voteCount;
    }

    function candidateCount() external view returns (uint) {
        return candidateIds.length;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Invalid");
        owner = newOwner;
    }
}
