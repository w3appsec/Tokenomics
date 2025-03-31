// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IERC20.sol";

contract TokenExchng {
    IERC20 public token1;
    address public owner1;
    IERC20 public token2;
    address public owner2;

    constructor(
        address _token1,
        address _owner1,
        address _token2,
        address _owner2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
    }

    function exchngT1T2(uint n) external {
        require(token1.allowance(msg.sender, address(this)) >= n, "T1 allowance");
        _safeTransferFrom(token1, msg.sender, owner2, n);
        _safeTransferFrom(token2, owner2, msg.sender, n);
    }

    function _safeTransferFrom(
        IERC20 token,
        address sender,
        address recipient,
        uint256 amount
    ) private {
        bool sent = token.transferFrom(sender, recipient, amount);
        require(sent, "Token transfer failed");
    }
}