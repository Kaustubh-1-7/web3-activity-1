//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{
    struct Voter{
        address voterAddress;
        bool voted;
    }

    struct Candidate{
        string c_name;
        uint c_votes;
    }

    // Just like in betting contract --> Bet[] public bet;
    Candidate[] public candidates;
    Voter[] public voters;

    // Just like in betting contract --> address public owner; uint public min_bet_amount;
    address public owner;
    bool public votingOpen = false;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not Contract Owner");
        _;
    }

    modifier votingIsOpen(){
        require(votingOpen == true, "Voting is Closed");
        _;
    }

    // To add candidate name voting should be open.
    function addCandidate(string memory _name) public onlyOwner{
        require(votingOpen == false, "Voting is Open");
        candidates.push(Candidate(_name, 0)); // Initially candidate will have c_votes=0.
    }

    // It's obvious that election will be held between atleast 2 candidates.
    function startVoting() public onlyOwner{
        require(candidates.length>=2,"Add atleast 2 candidates");
        votingOpen = true;
    }

    function vote(uint candidateList) public votingIsOpen{
        require(candidateList < candidates.length, "Wrong Candidate");

        for(uint i=0;i<voters.length;i++){
            require(voters[i].voterAddress != msg.sender, "Already Voted");
        }

        candidates[candidateList].c_votes++;
        voters.push(Voter(msg.sender, true));
    }

    function getTotalVotes(uint candidateList) public view returns (uint){
        require(candidateList < candidates.length, "Invalid Candidate");
        return candidates[candidateList].c_votes;
    }

    function getCandidateCount() public view returns (uint){
        return candidates.length;
    }

    function getCandidateName(uint list) public view returns (string memory){
        require(list<candidates.length,"Wrong list");
        return candidates[list].c_name;
    }
}