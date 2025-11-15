// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract voting{

    bool public votingOpen = true;
    uint public winnerID;
    
    struct Candidate{
        string name;
        uint votesReceived;
        
    }

    Candidate[] public Candidates;
    address public owner;
    mapping(address=>bool) public hasVoted;

    constructor(){
        owner=msg.sender;
    }


    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner");
         _; 
    }


    function addCandidate(string memory _name) public onlyOwner {
        require(votingOpen == true, "Voting is closed,candidate cannot be added!!");
        Candidates.push(Candidate(_name, 0));
    }


    function Voting(uint _candidateID) public {

        require(votingOpen == true, "Voting is closed !!");
        require(hasVoted[msg.sender] == false, "You have already voted.");
        require(_candidateID < Candidates.length, "Invalid candidateID.");

        hasVoted[msg.sender] = true;
        Candidates[_candidateID].votesReceived++;

    }
    function declareWinner() public onlyOwner {
        require(votingOpen == true, "Voting closed!!");
        require(Candidates.length > 0, "No candidates registered !! ");

        uint maxVotes = 0;
        uint winningCandidateID = 0;
        
        
        for (uint i = 0; i < Candidates.length; i++) {
            if (Candidates[i].votesReceived > maxVotes) {
                maxVotes = Candidates[i].votesReceived;
                winningCandidateID = i;
            }
        }
        winnerID = winningCandidateID;
        votingOpen = false;

    }
    function getWinner() public view returns (string memory name, uint votesReceived) {
        require(votingOpen == false, "Winner has not been declared yet!");
        
       
        Candidate storage winner = Candidates[winnerID];
        return (winner.name, winner.votesReceived);
    }
}