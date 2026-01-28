// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WalletInteraction
/// @notice Simple contract to track user interactions
/// @dev Uses unchecked math for gas optimization
contract WalletInteraction {
    address public owner;
    bool public paused;
    mapping(address => uint256) public interactions;
    mapping(address => uint256) public lastInteraction;

    event Interacted(address indexed user, uint256 count, uint256 timestamp);
    event Paused(bool status);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "contract paused");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function interact() external whenNotPaused {
        unchecked {
            interactions[msg.sender]++;
        }
        lastInteraction[msg.sender] = block.timestamp;
        emit Interacted(msg.sender, interactions[msg.sender], block.timestamp);
    }

    function getMyCount() external view returns (uint256) {
        return interactions[msg.sender];
    }

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
        emit Paused(_paused);
    }
}
