// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Votting{

    struct Vote{
        address payable better;
        
        uint candidate_no;
    }
    // e.g-- (0x1234, 1)

    Vote[] public votes;

    uint public candidate1_votes = 0;
    uint public candidate2_votes = 0;
    uint public total_votes;
    uint public result;


    address public owner;
    

    mapping (address => bool) public has_Voted;

    constructor(){
        owner =msg.sender;
        
    }

    modifier onlyOwner{
        require(msg.sender == owner,"Not contract owner");
        _;
    }


    string public candidate1;
    string public candidate2;
    bool candidates_add = false;
    bool voting_open = false;


    function set_two_candidates (string memory _candidate1,string memory _candidate2) onlyOwner public {
        require(candidates_add==false,"team names are already set");
        candidate1 = _candidate1;
        candidate2 = _candidate2;
        candidates_add = true;
        voting_open = true;
    }

    function put_vote(uint candidate_no) public {
        require(candidates_add == true,"candidates are not set");  
        require(voting_open == true,"votings are not open");  
        require(candidate_no==1||candidate_no==2,"Invalid candidate no");  
        require(has_Voted[msg.sender] == false, "You have already Voted");
          

        votes.push(Vote(payable(msg.sender),candidate_no));

        if(candidate_no ==1) candidate1_votes++;
        else candidate2_votes++;

        has_Voted[msg.sender] = true;
        total_votes++;
    }

    function close_voting() public onlyOwner   {
        require(voting_open==true,"Betting already close");
        voting_open=false;
    }

    function declare_result() public onlyOwner{
        require(voting_open==false,"bettign is still open");
        
        if(candidate1_votes>candidate2_votes) result = 1;
        else if(candidate1_votes == candidate2_votes) result = 0;
        else result = 2;
        
    }


}