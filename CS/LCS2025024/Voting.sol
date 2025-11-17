// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting{
    struct candidate{
        address payable name;
        uint symbol;
        uint total_votes;
    }
    
    candidate[] public Candidates;

    address public owner;
    address[] public voterData;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    uint public totalCandidates = 0;
    uint public totalVoters = 0;
    bool public voteStarted=false;
    bool public voteEnded=false;
    uint public maxVotes = 0;
    address payable public winner;


    function RegisterCandidates(uint sym) public payable {
        require(voteStarted == false, "Voting has already begun");
         
         Candidates.push(candidate(payable (msg.sender),sym,0)) ;
        totalCandidates++;
    }

    function start_voting() public onlyOwner{
        require(totalCandidates>0, "Enter Candidates");
        require(voteStarted == false, "Voting already started");
        require(voteEnded == false, "Voting already ended");
        voteStarted = true;
    }

    function close_voting() public onlyOwner{
        require(voteEnded == false, "Voting already closed");
        voteEnded = true;
    }

    function vote(uint sym) public payable 
    {
        require(voteEnded == false, "Voting has ended");
        require(voteStarted == true, "Voting has not started");

        int flag = 0;
        for(uint i = 0; i<totalVoters; i++)
        {
            if(msg.sender == voterData[i]) {flag++; break;}
        }
        require(flag == 0,"Duplicate votes not allowed");
        

        flag = 0;
        for(uint i = 0; i<totalCandidates; i++)
        {
            if(Candidates[i].symbol == sym) 
            {Candidates[i].total_votes++; flag++; break;}
        }
        require(flag==1, "Not a valid voting symbol");
        voterData.push(msg.sender);
        totalVoters++;
    }

    function result() public payable
    {
        maxVotes = 0;
        require(voteEnded == true, "Voting not ended yet");
        for(uint i = 0; i<totalCandidates; i++)
        {
            if(Candidates[i].total_votes > maxVotes)
            {maxVotes = Candidates[i].total_votes; winner = Candidates[i].name;}
        }
        
    }
}