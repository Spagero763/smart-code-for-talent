// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PollCreator {
    event PollCreated(uint256 indexed pollId, address indexed creator, string question, string[] options);
    event Voted(uint256 indexed pollId, address indexed voter, uint256 optionIndex);
    event PollClosed(uint256 indexed pollId);

    struct Poll {
        string question;
        string[] options;
        mapping(uint256 => uint256) votes; // optionIndex => count
        mapping(address => bool) voted;
        bool open;
        address creator;
    }

    mapping(uint256 => Poll) private _polls;
    uint256 public pollCount;

    function createPoll(string calldata question, string[] calldata options) external returns (uint256 id) {
        require(options.length >= 2 && options.length <= 10, "2-10 options");
        id = pollCount++;
        Poll storage p = _polls[id];
        p.question = question;
        p.creator = msg.sender;
        p.open = true;
        for (uint256 i = 0; i < options.length; i++) {
            p.options.push(options[i]);
        }
        emit PollCreated(id, msg.sender, question, options);
    }

    function vote(uint256 pollId, uint256 optionIndex) external {
        Poll storage p = _polls[pollId];
        require(p.open, "Closed");
        require(!p.voted[msg.sender], "Already voted");
        require(optionIndex < p.options.length, "Bad option");
        p.votes[optionIndex] += 1;
        p.voted[msg.sender] = true;
        emit Voted(pollId, msg.sender, optionIndex);
    }

    function close(uint256 pollId) external {
        Poll storage p = _polls[pollId];
        require(msg.sender == p.creator, "Only creator");
        require(p.open, "Already closed");
        p.open = false;
        emit PollClosed(pollId);
    }

    function getPoll(uint256 pollId) external view returns (
        string memory question,
        string[] memory options,
        bool open,
        address creator
    ) {
        Poll storage p = _polls[pollId];
        return (p.question, p.options, p.open, p.creator);
    }

    function getVotes(uint256 pollId, uint256 optionIndex) external view returns (uint256) {
        return _polls[pollId].votes[optionIndex];
    }

    function hasVoted(uint256 pollId, address user) external view returns (bool) {
        return _polls[pollId].voted[user];
    }
}
