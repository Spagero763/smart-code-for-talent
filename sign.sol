// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title WalletInteraction
/// @notice Simple contract to track user interactions
/// @dev Uses unchecked math for gas optimization
contract WalletInteraction {
    address public owner;
    mapping(address => uint256) public interactions;

    event Interacted(address indexed user, uint256 count);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function interact() external {
        unchecked {
            interactions[msg.sender]++;
        }
        emit Interacted(msg.sender, interactions[msg.sender]);
    }

    function getMyCount() external view returns (uint256) {
        return interactions[msg.sender];
    }
}
