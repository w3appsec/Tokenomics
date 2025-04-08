// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IERC20.sol";

contract TokenExchng {
    IERC20 public token1;
    address public owner1;
    uint public poolSize1;
    IERC20 public token2;
    address public owner2;
    uint public poolSize2;

    constructor(
        address _token1,
        address _owner1,
        uint _initPoolSize1,
        address _token2,
        address _owner2,
        uint _initPoolSize2
    ) {
        token1 = IERC20(_token1);
        owner1 = _owner1;
        poolSize1 = _initPoolSize1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
        poolSize2 = _initPoolSize2;
    }

    function exchngT1T2(uint n) external {
        require(token1.allowance(msg.sender, address(this)) >= n, "T1 allowance");
        //uint k = poolSize2 / poolSize1;
        uint m = (n * poolSize2) / poolSize1;
        _safeTransferFrom(token1, msg.sender, owner1, n);
        _safeTransferFrom(token2, owner2, msg.sender, m);
        poolSize1 += n;
        poolSize2 -= m;
    }

    function exchngT2T1(uint n) external {
        require(token2.allowance(msg.sender, address(this)) >= n, "T2 allowance");
        //uint k = poolSize1 / poolSize2;
        uint m = (n * poolSize1) / poolSize2;
        _safeTransferFrom(token2, msg.sender, owner2, n);
        _safeTransferFrom(token1, owner1, msg.sender, m);
        poolSize2 += n;
        poolSize1 -= m;
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
