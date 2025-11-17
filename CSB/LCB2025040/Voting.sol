// SPDX-License-Identifier: MIT
pragma solidity^0.8.30;

contract voting {
    struct candidate {
        uint cand_no;
        string cand_name;
        uint voteCount;
    }

    candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    address public owner;
    uint ct = 1;
    bool start_voting;

    constructor (bool _start_voting) {
        require(_start_voting == true, "Voting has not started");
        owner = msg.sender;
        start_voting = _start_voting;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function set_candidate_name(string memory _cand_name) onlyOwner public{
        candidates.push(candidate(ct,_cand_name,0));
        ct++;
    }

    function available_cand() public view returns (candidate[] memory){
        return candidates;
    }

    function getVotes(uint _cand_no) public view returns (uint){
        require(_cand_no >= 1 && _cand_no <= candidates.length, "Invalid candidate number");
        return candidates[_cand_no-1].voteCount;
    }

    function vote(uint _cand_no) public {
        require(hasVoted[msg.sender] == false, "You have already voted");
        require(_cand_no >= 1 && _cand_no <= candidates.length, "Invalid candidate number");
        hasVoted[msg.sender] = true;
        candidates[_cand_no-1].voteCount += 1;
    }
}