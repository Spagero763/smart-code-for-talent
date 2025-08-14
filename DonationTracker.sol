// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DonationTracker {
    event CauseRegistered(uint256 indexed causeId, string name, address indexed beneficiary);
    event Donated(uint256 indexed causeId, address indexed from, uint256 amount);

    struct Cause { string name; address payable beneficiary; uint256 totalReceived; bool exists; }

    mapping(uint256 => Cause) public causes;
    uint256 public causeCount;

    function registerCause(string calldata name, address payable beneficiary) external returns (uint256 id) {
        require(beneficiary != address(0), "bad beneficiary");
        id = causeCount++;
        causes[id] = Cause(name, beneficiary, 0, true);
        emit CauseRegistered(id, name, beneficiary);
    }

    // Funds are forwarded instantly to beneficiary; contract only tracks totals.
    function donate(uint256 causeId) external payable {
        Cause storage c = causes[causeId];
        require(c.exists, "no cause");
        require(msg.value > 0, "no value");
        c.totalReceived += msg.value;
        (bool ok, ) = c.beneficiary.call{value: msg.value}("");
        require(ok, "forward failed");
        emit Donated(causeId, msg.sender, msg.value);
    }
}
