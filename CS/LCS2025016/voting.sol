

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; 

contract Election {

 
    struct Voter {
          address voterAddress;
           uint vote; 
  
     
    }


    Voter[] public maddan1;
    Voter[] public maddan2;


    uint public party01_votes = 0;
    uint public party02_votes = 0;
    uint public total_votes = 0;
    uint public result;


    address public election_commision;


    mapping(address => bool) public votecheck;


    modifier onlyelection_commision() {
        require(msg.sender == election_commision, "Not authorised");
        _;
    }


    string public party01_name;
    string public party02_name;
    bool public party_set = false;
    bool public election_open = false;
    bool public election_ended = false;

    constructor() {
        election_commision = msg.sender;
    }


    function set_party_names(string memory _party01, string memory _party02) public onlyelection_commision {
        require(party_set == false, "party names are already set");
        party01_name = _party01;
        party02_name = _party02;
        party_set = true;
    }

   
    function start_election() public onlyelection_commision {
        require(party_set == true, "set parties first");
        require(election_open == false, "election already open");
        election_open = true;
        election_ended = false;
    }


    function vote(uint party_no) public {
        require(election_open == true, "election not open");
        require(party_no == 1 || party_no == 2, "invalid party no");
        require(votecheck[msg.sender] == false, "Already voted");

  
        if (party_no == 1) {
            maddan1.push(Voter(msg.sender, 1));
            party01_votes = party01_votes +1;
        } else {
            maddan2.push(Voter(msg.sender, 1));
             party02_votes += 1;
        }

        votecheck[msg.sender] = true;
        total_votes += 1;
    }

 
    function close_election() public onlyelection_commision {
        require(election_open == true, "Election already closed");
        election_open = false;
        election_ended = true;
    }

   
    function declare_result() public onlyelection_commision {
        require(election_ended == true, "Election not ended yet");

        if (party01_votes > party02_votes)   result = 1;
          
         else if (party01_votes < party02_votes)   result = 2;  
          
        else  result = 0; 
        
        
    }
}


