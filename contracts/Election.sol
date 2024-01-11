// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Election {
    // Constructor
    constructor() {
        voteTotal = 0;
    }

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
        string party;
    }

    // Read/write Candidates
    mapping(uint => Candidate) public candidates;

    // Store Candidates Count
    uint public candidatesCount;

    function addCandidate(string memory _name, string memory _party) public {
        require(voteTotal == 0, "Cannot submit candidate after first vote recorded");

        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0, _party);

        emit AddCandidateEvent(candidatesCount);
    }

    event AddCandidateEvent(uint indexed candidateId);

    // Read/write voters
    mapping(address => bool) public voters;

    uint public voteTotal;

    function vote(uint _candidateId) public {
        require(!voters[msg.sender], "Vote already cast from this address");
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Candidate ID is not in range of candidates");
        require(candidatesCount >= 2, "Must be at least 2 candidates before votes can be cast");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        voteTotal++;

        emit VotedEvent(_candidateId);
    }

    event VotedEvent(uint indexed candidateId);
}
