// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract Voting {
    address public owner;
    enum Phase { Setup, Registration, Voting, Ended }
    Phase public currentPhase;
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
        bool exists;
    }
    struct Voter {
        bool registered;
        bool voted;
        uint votedCandidateId;
    }
    mapping(uint => Candidate) private candidates;
    uint[] private candidateIds;
    uint private nextCandidateId;
    mapping(address => Voter) public voters;
    uint public totalVotes;
    event CandidateAdded(uint  indexed candidateId, string name);
    event VoterRegistered(address indexed voter);
    event PhaseAdvanced(Phase newPhase);
    event VoteCast(address indexed voter, uint indexed candidateId);
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    modifier inPhase(Phase _phase) {
        require(currentPhase == _phase, "Wrong phase");
        _;
    }
    constructor() {
        owner = msg.sender;
        currentPhase = Phase.Setup;
        nextCandidateId = 1;
    }
    function addCandidate(string calldata _name) external onlyOwner {
        require(currentPhase == Phase.Setup || currentPhase == Phase.Registration, "Candidates cannot be added now");
        uint cid = nextCandidateId++;
        candidates[cid] = Candidate({ id: cid, name: _name, voteCount: 0, exists: true });
        candidateIds.push(cid);
        emit CandidateAdded(cid, _name);
    }
    function advancePhase() external onlyOwner {
        require(currentPhase != Phase.Ended, "Already ended");
        if (currentPhase == Phase.Setup) currentPhase = Phase.Registration;
        else if (currentPhase == Phase.Registration) currentPhase = Phase.Voting;
        else if (currentPhase == Phase.Voting) currentPhase = Phase.Ended;
        emit PhaseAdvanced(currentPhase);
    }
    function registerVoter(address _voter) external {
        require(currentPhase == Phase.Registration, "Registration closed");
        require(msg.sender == owner || msg.sender == _voter, "Not allowed to register this voter");
        require(!voters[_voter].registered, "Already registered");
        voters[_voter] = Voter({ registered: true, voted: false, votedCandidateId: 0 });
        emit VoterRegistered(_voter);
    }
    function vote(uint _candidateId) external inPhase(Phase.Voting) {
        Voter storage sender = voters[msg.sender];
        require(sender.registered, "Not registered");
        require(!sender.voted, "Already voted");
        require(candidates[_candidateId].exists, "Candidate not found");

        sender.voted = true;
        sender.votedCandidateId = _candidateId;
        candidates[_candidateId].voteCount += 1;
        totalVotes += 1;
        emit VoteCast(msg.sender, _candidateId);
    }
    function getCandidate(uint _candidateId) external view returns (uint id, string memory name, uint voteCount) {
        require(candidates[_candidateId].exists, "Candidate not found");
        Candidate storage c = candidates[_candidateId];
        return (c.id, c.name, c.voteCount);
    }
    function listCandidates() external view returns (uint[] memory ids, string[] memory names, uint[] memory votes) {
        uint n = candidateIds.length;
        ids = new uint[](n);
        names = new string[](n);
        votes = new uint[](n);
        for (uint i = 0; i < n; i++) {
            uint cid = candidateIds[i];
            Candidate storage c = candidates[cid];
            ids[i] = c.id;
            names[i] = c.name;
            votes[i] = c.voteCount;
        }
        return (ids, names, votes);
    }
    function getWinner() external view inPhase(Phase.Ended) returns (uint id, string memory name, uint voteCount) {
        require(candidateIds.length > 0, "No candidates");
        uint bestId = candidateIds[0];
        uint bestVotes = candidates[bestId].voteCount;
        for (uint i = 1; i < candidateIds.length; i++) {
            uint cid = candidateIds[i];
            if (candidates[cid].voteCount > bestVotes) {
                bestVotes = candidates[cid].voteCount;
                bestId = cid;
            }
        }
        Candidate storage winner = candidates[bestId];
        return (winner.id, winner.name, winner.voteCount);
    }
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
    receive() external payable {}
}

