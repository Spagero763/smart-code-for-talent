// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract OnchainNotepad {
    event NoteSaved(address indexed author, uint256 indexed id, string text, uint256 timestamp);

    struct Note { address author; string text; uint256 timestamp; }
    mapping(uint256 => Note) public notes;
    uint256 public nextId;

    function save(string calldata text) external {
        notes[nextId] = Note(msg.sender, text, block.timestamp);
        emit NoteSaved(msg.sender, nextId, text, block.timestamp);
        nextId++;
    }

    function get(uint256 id) external view returns (Note memory) {
        return notes[id];
    }
}
