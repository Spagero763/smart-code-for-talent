// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DailyCheckIn {
    event CheckedIn(address indexed user, uint256 streak, uint256 timestamp);

    mapping(address => uint256) public lastCheckIn; // unix time
    mapping(address => uint256) public streak;      // consecutive days

    uint256 public constant DAY = 1 days;
    uint256 public graceWindow = 12 hours; // allows small delays

    function checkIn() external {
        uint256 last = lastCheckIn[msg.sender];
        if (last == 0) {
            streak[msg.sender] = 1;
        } else if (block.timestamp <= last + DAY + graceWindow && block.timestamp >= last + DAY) {
            streak[msg.sender] += 1;
        } else if (block.timestamp > last + DAY + graceWindow) {
            streak[msg.sender] = 1; // missed window -> reset
        } else {
            revert("Too early");
        }
        lastCheckIn[msg.sender] = block.timestamp;
        emit CheckedIn(msg.sender, streak[msg.sender], block.timestamp);
    }
}
