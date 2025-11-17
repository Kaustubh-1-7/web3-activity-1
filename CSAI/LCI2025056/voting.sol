// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract voting{
    string[] public candidates;
    uint[] public no_of_votes;
    mapping(address=>bool) public hasvoted;
    function to_add_candidates(string memory _name) public {
        candidates.push(_name);
        no_of_votes.push(0);
    }
    function to_check_vote(uint candidate) public {
        require(!hasvoted[msg.sender], "you have already voted");
        require(candidate<candidates.length, "You are not elegible!");
        no_of_votes[candidate]++;
        hasvoted[msg.sender]=true;
    }
    function to_get_vote(uint candidate) public view returns (uint){
        require(candidate<candidates.length, "You are not elegible!");
        return no_of_votes[candidate];
    }
}