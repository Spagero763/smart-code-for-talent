// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeCapsule {
    struct Capsule {
        address owner;
        uint256 unlockTime;
        uint256 amount;
    }

    mapping(uint256 => Capsule) public capsules;
    uint256 public capsuleCount;

    function createCapsule(uint256 _unlockTime) external payable {
        require(msg.value > 0, "Send ETH");
        require(_unlockTime > block.timestamp, "Time must be future");

        capsules[capsuleCount] = Capsule(msg.sender, _unlockTime, msg.value);
        capsuleCount++;
    }

    function withdrawCapsule(uint256 _id) external {
        Capsule storage cap = capsules[_id];
        require(msg.sender == cap.owner, "Not owner");
        require(block.timestamp >= cap.unlockTime, "Too early");

        uint256 amount = cap.amount;
        cap.amount = 0;
        payable(msg.sender).transfer(amount);
    }
}
