// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0; //compiler version should be greater or equal to 0.8.0

contract Voting {  //smart contract voting is created

    struct Candidate {
        uint id;
        string name;   //candidate names
        uint voteCount;  //vote received by candidate
    }

    address public owner;  //store wallet address of person who deployed the contract
    Candidate[] public candidates; //array that stores all candidates

    mapping(address => bool) public hasVoted; //keep a track if someone has already voted

    bool public votingClosed = false; 

    event CandidateAdded(string name);  //candidate name added
    event Voted(address indexed voter, uint candidateIndex);  //to show who voted for whom
    event VotingClosed(); 

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner has this access"); //check if person calling function is owner
        _;
    }

    modifier notVoted() {
        require(!hasVoted[msg.sender], "You have already voted"); //a person can vote once
        _;
    }

    modifier votingOpen() {
        require(!votingClosed, "Voting is closed"); //address of owner is the one who deploys
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addCandidate(string memory _name) public onlyOwner { //only owner can add a new candidate
        candidates.push(Candidate({
            id: candidates.length, //no of candidate
            name: _name,
            voteCount: 0
        }));
        emit CandidateAdded(_name); //tells blockchain if candidate is added
    }

    
    function vote(uint _candidateIndex) public notVoted votingOpen {  //anyone can call this
        require(_candidateIndex < candidates.length, "Invalid candidate");  //validating candidate index
        candidates[_candidateIndex].voteCount++;  //inc vote count
        hasVoted[msg.sender] = true;  //mark voter as voted
        emit Voted(msg.sender, _candidateIndex);  //who voted for whom
    }

   
    function closeVoting() public onlyOwner { //only owner can close the voting system
        votingClosed = true;
        emit VotingClosed(); //tell people that voting closed
    }

  
    function getWinner() public view returns (string memory winnerName, uint winnerVotes) { //returns winner name and and vote count
        require(votingClosed, "Voting must be closed to view winner"); //result can only be displayed after voting is closed

        uint highestVotes = 0; //initializing highest vote
        uint winnerIndex = 0; //initializing index of winner

        for (uint i = 0; i < candidates.length; i++) { //kind of loop that tells about who has highest vote and no of vote
            if (candidates[i].voteCount > highestVotes) {
                highestVotes = candidates[i].voteCount;
                winnerIndex = i;
            }
        }

        return (candidates[winnerIndex].name, candidates[winnerIndex].voteCount);
    }

    function getCandidate(uint index) public view returns (string memory, uint) {
        require(index < candidates.length, "Invalid index");//make sure index is valid
        Candidate memory c = candidates[index];
        return (c.name, c.voteCount); //sends back name of candidate and vote count
    }
}
