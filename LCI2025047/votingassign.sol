// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    Candidate[] public votes;
    uint public result;
    address public owner;
    uint public must1_vote;
    constructor (uint _must1_vote){
        owner = msg.sender;
        must1_vote= _must1_vote;
    } 
    modifier onlyOwner{
        require(msg.sender == owner , "You are not the owner");
        _;
    }

    mapping(uint => Candidate) public candidates;
    uint public candidatesCount;

  
    mapping(address => bool) public hasVoted;

   
    event CandidateAdded(uint indexed _id, string _name);
    
    event Voted(uint indexed _candidateId, address indexed _voter);

    
    function addCandidate(string memory _name) public {
        
        candidatesCount++;
        
       
        candidates[candidatesCount] = Candidate(
            candidatesCount, 
            _name,
            0);

        emit CandidateAdded(candidatesCount, _name);
    }

    
    function vote(uint _candidateId) public {
        
        require(!hasVoted[msg.sender], "Error: You have already voted.");

      
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Error: Invalid candidate ID.");

        
        candidates[_candidateId].voteCount++;

        
        hasVoted[msg.sender] = true;

        emit Voted(_candidateId, msg.sender);
    }

    
    function getVoteCount(uint _candidateId) public view returns (uint) {
       
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Error: Invalid candidate ID.");
        
        
        return candidates[_candidateId].voteCount;
    }

    
    function getCandidatesCount() public view returns (uint) {
        return candidatesCount;
    }
    


}   
