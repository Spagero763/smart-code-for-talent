// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TaskBounty {
    event BountyCreated(uint256 indexed id, address indexed poster, string description, uint256 amount);
    event SolutionSubmitted(uint256 indexed id, address indexed solver, string proof);
    event BountyApproved(uint256 indexed id, address indexed solver, uint256 amount);
    event BountyCanceled(uint256 indexed id, uint256 refund);

    struct Bounty {
        address poster;
        string description;
        uint256 amount;
        bool open;
        address solver;
        string proof;
    }

    mapping(uint256 => Bounty) public bounties;
    uint256 public bountyCount;

    function createBounty(string calldata description) external payable returns (uint256 id) {
        require(msg.value > 0, "Fund bounty");
        id = bountyCount++;
        bounties[id] = Bounty(msg.sender, description, msg.value, true, address(0), "");
        emit BountyCreated(id, msg.sender, description, msg.value);
    }

    function submitSolution(uint256 id, string calldata proof) external {
        Bounty storage b = bounties[id];
        require(b.open, "Closed");
        require(bytes(b.proof).length == 0, "Already submitted");
        b.solver = msg.sender;
        b.proof = proof;
        emit SolutionSubmitted(id, msg.sender, proof);
    }

    function approve(uint256 id) external {
        Bounty storage b = bounties[id];
        require(b.open, "Closed");
        require(msg.sender == b.poster, "Only poster");
        require(b.solver != address(0), "No solver");
        b.open = false;
        uint256 amt = b.amount;
        b.amount = 0;
        (bool ok, ) = payable(b.solver).call{value: amt}("");
        require(ok, "Pay failed");
        emit BountyApproved(id, b.solver, amt);
    }

    function cancel(uint256 id) external {
        Bounty storage b = bounties[id];
        require(b.open, "Closed");
        require(msg.sender == b.poster, "Only poster");
        b.open = false;
        uint256 amt = b.amount;
        b.amount = 0;
        (bool ok, ) = payable(b.poster).call{value: amt}("");
        require(ok, "Refund failed");
        emit BountyCanceled(id, amt);
    }
}
