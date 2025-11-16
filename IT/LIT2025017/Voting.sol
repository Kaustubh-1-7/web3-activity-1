// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// add candidate, vote for candidate, prevent double voting, view total votes
// candidates list, add vote, open voting, close voting, declare result, check votes for each 

contract Voting{

    struct candidate{
        uint id;
        address candidate_address;
        string candidate_name;
    }
    
    address public owner;

    candidate[] public candidates;
    
    bool voting_open = false;
    bool voting_ended = false;
    constructor(){
        owner=msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender==owner, "Not contract owner.");
        _;
    }
    uint it = 1;
    uint[] public votes;
    function addCandidate(string memory candidate_name, address candidate_address) public onlyOwner{
        require(voting_open==false, "Voting is open.");
        require(voting_ended==false, "Voting is already complete.");
        bool f = true;
        for(uint i = 0; i < candidates.length; i++){
            if (candidates[i].candidate_address == candidate_address){
                f = false;
            }
        }
        require(f==true, "Candidate is already present");
        candidates.push(candidate(it,candidate_address,candidate_name));
        it++;
        votes.push(0);
    }
    
    uint total_votes=0;

    function open_voting() public onlyOwner{
        require(candidates.length>1, "Less than 2 candidates.");
        require(voting_open==false, "Voting is already open.");
        voting_open=true;
    }

    mapping (address => bool) public already_voted;

    function add_vote(uint candidate_to_vote) public{
        require(already_voted[msg.sender]==false, "User has already voted");
        require(voting_open==true,"Voting is still closed.");
        require(voting_ended==false, "Voting is already complete.");
        require(candidate_to_vote<=votes.length, "Please enter a valid Candidate ID");
        votes[candidate_to_vote-1]++;
        already_voted[msg.sender]=true;
        total_votes++;
    }

    function check_votes(uint candidate_id) public view returns(uint _votes){
        require(candidate_id<=votes.length, "Please enter a valid Candidate ID");
        return votes[candidate_id-1];
    }

    uint winner=0;

    function close_voting() public onlyOwner{
        require(voting_open==true, "Voting is already closed.");
        require(total_votes>=1, "Cast at least 1 vote");
        voting_ended=true;
        voting_open=false;


        for(uint x = 0; x < votes.length; x++){
            if (votes[winner]<votes[x]){
                winner = x;
            }
        }
        uint c = 0;
        for(uint x = 0; x < votes.length; x++){
            if (votes[x]==votes[winner]){
                c++;
            }
        }

        winner++;
        if (c>1) winner = 0;
        
    }

    function declare_result() public onlyOwner view returns(string memory result){
        require(voting_ended==true, "Voting has not yet ended.");
        if (winner==0){
            result = "Tie";
        }else{
            result = candidates[winner-1].candidate_name;
        }
        return result;
    }
}
