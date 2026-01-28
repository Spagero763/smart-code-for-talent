// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WalletInteraction
/// @notice Simple contract to track user interactions
/// @dev Uses unchecked math for gas optimization
contract WalletInteraction {
    address public owner;
    bool public paused;
    uint256 public totalInteractions;
    uint256 public cooldownTime = 60; // 1 minute default
    mapping(address => uint256) public interactions;
    mapping(address => uint256) public lastInteraction;

    event Interacted(address indexed user, uint256 count, uint256 timestamp);
    event Paused(bool status);
    event CooldownUpdated(uint256 newCooldown);

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
        require(
            block.timestamp >= lastInteraction[msg.sender] + cooldownTime,
            "cooldown active"
        );
        uint256 newCount;
        unchecked {
            newCount = ++interactions[msg.sender];
            totalInteractions++;
        }
        lastInteraction[msg.sender] = block.timestamp;
        emit Interacted(msg.sender, newCount, block.timestamp);
    }

    function getMyCount() external view returns (uint256) {
        return interactions[msg.sender];
    }

    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;
        emit Paused(_paused);
    }

    function setCooldown(uint256 _seconds) external onlyOwner {
        require(_seconds <= 1 days, "cooldown too long");
        cooldownTime = _seconds;
        emit CooldownUpdated(_seconds);
    }
}
