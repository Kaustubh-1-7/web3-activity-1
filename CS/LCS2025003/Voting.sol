//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting{
    address public admin;
    bool public Voting_Closed;

    constructor() {
        admin= msg.sender;
        Voting_Closed=false;
    }

   struct Candidate {
        string Name;
        uint Vote_Count;
    }  
    
    Candidate[] public Candidates;
    mapping(address => bool) public Has_Voted;

    function Add_Candidate (string memory _name) public{
        require (msg.sender == admin, "Only admin can add candidates");
        require (!Voting_Closed, "Voting is Closed");
        Candidates.push(Candidate(_name, 0));
    }
    function Vote(uint _CandidateIndex) public {
        require (!Voting_Closed, "Voting is Closed ");
        require (!Has_Voted[msg.sender], "Already voted");
        require (_CandidateIndex < Candidates.length, "Invalid Candidate");
        Has_Voted[msg.sender] = true;
        Candidates[_CandidateIndex].Vote_Count++;
    }

    function Get_Votes(uint _CandidateIndex) public view returns (uint) {
        require(_CandidateIndex < Candidates.length, "Invalid Candidate");
        return Candidates[_CandidateIndex].Vote_Count;
    }

    function Close_Voting() public {
        require (msg.sender == admin, "Only admin can Close Voting");
        Voting_Closed=true;
    }

    function Get_Winner() public view returns (string memory Winner_Name, uint Winner_Votes) {
        require(Voting_Closed,"Voting is not closed yet");
        uint highest=0;
        uint Winner_Index=0;

        for (uint i=0; i < Candidates.length; i++){
            if (Candidates[i].Vote_Count > highest) {
                highest = Candidates[i].Vote_Count;
                Winner_Index=i;
            }
        }

        return (Candidates[Winner_Index].Name, Candidates[Winner_Index].Vote_Count);
    }
    
    function Get_Candidate_Count() public view returns (uint){
        return Candidates.length;
    }
}
