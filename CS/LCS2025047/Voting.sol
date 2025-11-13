//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        address voterAddress;
        bool hasVoted;
    }

    Candidate[4] public candidates;
    uint public candidateCount;
    uint public totalVotes;

    Voter[] public voters; 
    address public owner;
    bool public votingOpen;

    modifier onlyOwner {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier whenVotingOpen {
        require(votingOpen == true, "Voting is not open");
        _;
    }

    constructor() {
        owner = msg.sender;
        candidateCount = 0;
        votingOpen = false;
    }

    function addCandidate(string memory _name) public onlyOwner {
        require(candidateCount < 4, "Maximum 4 candidates allowed.");
        candidates[candidateCount] = Candidate(_name, 0);
        candidateCount++;
    }

    function startVoting() public onlyOwner {
        require(candidateCount > 0, "Add candidates first.");
        votingOpen = true;
    }

    function endVoting() public onlyOwner {
        require(votingOpen == true, "Voting already ended.");
        votingOpen = false;
    }

    function hasVoted(address _voter) public view returns (bool) {
        for(uint i = 0; i < voters.length; i++){
            if(voters[i].voterAddress == _voter && voters[i].hasVoted){
                return true;
            }
        }
        return false;
    }

    function vote(uint candidateIndex) public whenVotingOpen {
        require(candidateIndex < candidateCount, "Invalid candidate.");
        require(!hasVoted(msg.sender), "Already voted.");

        candidates[candidateIndex].voteCount++;
        voters.push(Voter(msg.sender, true));
        totalVotes++;
    }

    function getCandidateVotes(uint candidateIndex) public view returns (uint) {
        require(candidateIndex < candidateCount, "Invalid candidate.");
        return candidates[candidateIndex].voteCount;
    }

    function getCandidateName(uint candidateIndex) public view returns (string memory) {
        require(candidateIndex < candidateCount, "Invalid candidate.");
        return candidates[candidateIndex].name;
    }
}