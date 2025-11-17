//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting{

    struct Candidate{
        address candidate_add;
        uint votes;
        uint id;
    }

    constructor(){
        owner = msg.sender;
    }
    address public owner;
    modifier OnlyOwner{
        require(msg.sender == owner, "Not contract owner!");
        _;
    }

    address finalWinner;
    bool hasVotingStarted = false;
    bool hasVotingEnded = false;
    Candidate[] public candidateList;
    uint i = 0;

    function add_candidate(address _candidate_address) public OnlyOwner{
        require(hasVotingStarted==false, "Voting has already started!");
        require(hasVotingEnded==false, "Voting has already ended!");
        for(uint j = 0; j < candidateList.length; j++){
            require(_candidate_address != candidateList[j].candidate_add, "Same candidate has already entered the competition.");
        }
        candidateList.push(Candidate(_candidate_address, 0, i));
        i++;
    }

    function startVoting() public OnlyOwner{
        require(hasVotingStarted==false, "Voting has already started!");
        require(hasVotingEnded==false, "Voting has already ended!");
        require(i>1, "Less than two candidate have registered");
        hasVotingStarted = true;
    }


    function endVoting() public OnlyOwner{
        require(hasVotingStarted==true, "Voting has not even started!");
        require(hasVotingEnded==false, "Voting has already ended!");
        require(i>1, "Only one cadidate has registered");
        hasVotingEnded = true;
    }

    address[] public voterList;
    function putVote(address _candidateAddress) public {
        for(uint j = 0; j < voterList.length; j++){
            require(msg.sender != voterList[j], "You have already voted!");
        }
        require(hasVotingStarted==true, "Voting has not even started!");
        require(hasVotingEnded==false, "Voting has already ended!");
        
        bool checkValidCandidate = false;
        for(uint j = 0; j < candidateList.length; j++){
            if(_candidateAddress == candidateList[j].candidate_add){
                checkValidCandidate = true;
                candidateList[j].votes++;
            }
        }
        require(checkValidCandidate == true, "This candidate does not exist");
        voterList.push(msg.sender);
    }

    function viewVotesByID(uint _id) public view returns(uint){
        require(hasVotingStarted==true, "Voting hasn't started yet.");
        bool isIDvalid = false;
        for(uint j = 0; j < candidateList.length; j++){
            if(candidateList[j].id == _id){
                isIDvalid = true;
                return candidateList[j].votes;
            }
        } 
        require(isIDvalid, "Invalid ID");
    }
    
    function viewVotesByAddress(address _address) public view returns(uint){
        require(hasVotingStarted==true, "Voting hasn't started yet.");
        bool isAddressValid = false;
        for(uint j = 0; j < candidateList.length; j++){
            if(candidateList[j].candidate_add == _address){
                isAddressValid = true;
                return candidateList[j].votes;
            }
        } 
        require(isAddressValid, "Invalid ID");
    }

    function declareWinner() public OnlyOwner returns(address){
        require(hasVotingStarted==true, "Voting hasn't even started yet.");
        require(hasVotingEnded==true, "Voting is still ongoing"); 
        uint mx = 0;
        address winner;
        for(uint j = 0; j < candidateList.length; j++){
            if(candidateList[j].votes > mx){
                mx = candidateList[j].votes;
                winner = candidateList[j].candidate_add;
            }
        }
        return winner;
    }



}
