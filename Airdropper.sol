// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Airdropper {
    event Airdropped(address indexed token, uint256 recipients, uint256 totalAmount);

    // Sender must approve this contract to spend tokens before calling.
    function airdropEqual(address token, address[] calldata recipients, uint256 amountEach) external {
        require(amountEach > 0 && recipients.length > 0, "Invalid params");
        uint256 total = amountEach * recipients.length;
        for (uint256 i = 0; i < recipients.length; i++) {
            require(IERC20(token).transferFrom(msg.sender, recipients[i], amountEach), "transfer fail");
        }
        emit Airdropped(token, recipients.length, total);
    }

    function airdropAmounts(address token, address[] calldata recipients, uint256[] calldata amounts) external {
        require(recipients.length == amounts.length && recipients.length > 0, "Length mismatch");
        uint256 total;
        for (uint256 i = 0; i < recipients.length; i++) {
            total += amounts[i];
            require(IERC20(token).transferFrom(msg.sender, recipients[i], amounts[i]), "transfer fail");
        }
        emit Airdropped(token, recipients.length, total);
    }
}
