//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Vote {
        address payable voter;
        uint Candidate_no;
    }

    Vote[] public votes;

    uint public Candidate1_votes=0;
    uint public Candidate2_votes=0;
    uint public result;

    mapping(address => bool) public hasVoted;

    address public owner;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    string public Candidate1_name;
    string public Candidate2_name;
    bool public names_stored=false;
    bool public voting_open=false;

    function store_candidate_names(string memory _name1, string memory _name2) onlyOwner public{
        require(names_stored==false, "Candidate names are already stored");
        Candidate1_name = _name1;
        Candidate2_name = _name2;
        names_stored = true;
        voting_open= true;
    }

    function put_vote(uint Candidate_no) public {
        require(hasVoted[msg.sender] == false, "You have already voted.");
        
        require(names_stored==true, "Candidate names are not stored");
        require(voting_open == true, "Voting not open");
        require(Candidate_no == 1 || Candidate_no == 2, "Invalid Candidate No.");

        votes.push(Vote(payable(msg.sender), Candidate_no));
        hasVoted[msg.sender] = true;

        if(Candidate_no == 1) Candidate1_votes++;
        else Candidate2_votes++;
    }

    function close_voting() public onlyOwner{
        require(voting_open==true, "Voting already closed!");
        voting_open = false;
    }

    function declare_result() public onlyOwner{
        require(voting_open==false, "Voting is still open");
        if (Candidate1_votes>Candidate2_votes) {
            result=1;
        }
        else if (Candidate1_votes<Candidate2_votes){
            result=2;
        }
        else{
            result=0;
        }
    }
}