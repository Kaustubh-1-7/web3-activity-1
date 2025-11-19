// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting{
    
    struct Candidate{
        uint id;
        string candidate_name;
        address candidate_address;
        uint votes;
    }

    address public owner;

    Candidate[] public Candidates;

    bool voting_open = false;
    bool voting_ended = false;

    

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender==owner, "Not contract owner.");
        _;
    }
    uint sno = 1;
    function AddCandidate(string memory candidate_name, address _candidate_address) public onlyOwner {
    require(voting_open == false, "Voting is already open");

    bool present = false;
    for(uint i = 0; i < Candidates.length; i++){
        if(Candidates[i].candidate_address == _candidate_address){
            present = true;
        }
    }

    require(!present, "Candidate already present.");

    Candidates.push(Candidate(sno, candidate_name, _candidate_address, 0));
    sno++;
}


    function startVoting()public onlyOwner{
        require(voting_open == false, "Voting is already open");
        voting_open = true;
    }


    mapping (address => bool) public hasVoted;

     function vote(uint candidate_id) public {
        require(voting_open == true, "Voting is not open");
        require(msg.sender != owner, "Owner cannot vote");
        require(!hasVoted[msg.sender], "You have already voted");
        require(candidate_id >= 1, "Invalid candidate ID");
        
        require(candidate_id <= Candidates.length, "Invalid candidate ID");
        Candidates[candidate_id-1].votes++;
        hasVoted[msg.sender] = true;
     }
        
    function ViewVotes(uint candidate_id)view public returns(uint) {
        require(voting_open == false , "Voting not closed yet");
        require(candidate_id >= 1 && candidate_id <= Candidates.length, "Invalid candidate ID");
        return Candidates[candidate_id-1].votes;
    }

    function EndVoting()public onlyOwner{

     voting_open = false;
    }

    function getWinner() public view returns (string memory winnerName, uint winnerVotes, address winnerAddress) {
    require(voting_open == false, "Voting not closed yet");
    require(Candidates.length > 0, "No candidates available");

    uint maxVotes = 0;
    uint winnerIndex = 0;

    for (uint i = 0; i < Candidates.length; i++) {
        if (Candidates[i].votes > maxVotes) {
            maxVotes = Candidates[i].votes;
            winnerIndex = i;
        }
    }

    Candidate memory winner = Candidates[winnerIndex];
    return (winner.candidate_name, winner.votes, winner.candidate_address);
}

}