// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WalletInteraction {
    mapping(address => uint256) public interactions;

    event Interacted(address indexed user, uint256 count);

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
