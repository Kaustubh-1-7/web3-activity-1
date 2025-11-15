// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract voting{
    struct candidate{
        string candidate_name;
        uint candidate_id;
        uint vote_count;
    }

    struct voters{
        address voter;
        bool voted;
    }

    address public owner;

    candidate[] public candidates;
    voters[] public voter_list;
    bool voting_started=false;

    constructor(){
        owner=msg.sender;
    }

    modifier onlyowner(){
        require(msg.sender==owner,"not owner");
        _;
    }

    function add_candidate(string memory _candidate_name) public onlyowner{
        require(voting_started==false,"voting has already begin");
        uint id=candidates.length+1;
        candidates.push(candidate(_candidate_name,id,0));
    }

    function start_voting() public onlyowner{
        require(candidates.length>0,"no candidates added");
        require(voting_started==false,"voting already in process");
        voting_started=true;
    }

    function Voted(address _voter) public view returns (bool){
        for(uint i=0; i<voter_list.length; i++){
            if(voter_list[i].voter==_voter){
                return true;
            }
        }
        return false;
    }

    function vote(uint candidate_id)public {
        require(voting_started=true,"voting has not started yet");
        require(candidate_id<=candidates.length,"invalid candidates");
        require(!Voted(msg.sender),"already voted");
        voter_list.push(voters((msg.sender),true));
        candidates[candidate_id].vote_count++;
    }

    function end_voting() public onlyowner{
        require(voting_started==true,"voting has already stopped");
        voting_started=false;
    }
    function totalCandidates() public view returns(uint){
            return candidates.length;
        }

    function count_votes(uint candidate_id)public view returns(uint){
        require(candidate_id<=candidates.length,"invalid candidate id");
        return candidates[candidate_id].vote_count;
    }

    function winner()public view returns(string memory winning_name, uint winning_votes) {
        require(voting_started==false,"voting in progress");

        uint max_votes=0;
        uint winning_index=0;
        for(uint i=0;i<candidates.length;++i){
            if(candidates[i].vote_count>max_votes){
                max_votes=candidates[i].vote_count;
                winning_index=i;
            }
        }

        return(candidates[winning_index].candidate_name,candidates[winning_index].vote_count); 
    }
}
