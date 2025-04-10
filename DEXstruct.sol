// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import "./IERC20.sol";

contract DEXstruct {
    struct Pool {
        IERC20 instance;
        address owner;
        uint size;
    }

    mapping(string => Pool) public pools;

    string public sym1;
    string public sym2;

    constructor(
        string memory _sym1,
        address _token1,
        address _owner1,
        uint _initPoolSize1,
        string memory _sym2,
        address _token2,
        address _owner2,
        uint _initPoolSize2
    ) {
        sym1 = _sym1;
        pools[sym1].instance = IERC20(_token1);
        pools[sym1].owner = _owner1;
        pools[sym1].size = _initPoolSize1;

        sym2 = _sym2;
        pools[sym2].instance = IERC20(_token2);
        pools[sym2].owner = _owner2;
        pools[sym2].size = _initPoolSize2;
    }

    function exchng(string memory from, string memory to, uint n) external {
        Pool storage fromPool = pools[from];
        Pool storage toPool = pools[to];
        IERC20 fromToken = fromPool.instance;
        IERC20 toToken = toPool.instance;
        require(fromToken.allowance(msg.sender, address(this)) >= n, "FROM allowance");
        uint m = (n * toPool.size) / fromPool.size;
        require(toToken.allowance(toPool.owner, address(this)) >= m, "TO allowance");
        fromPool.size += n;
        toPool.size -= m;
        _safeTransferFrom(fromToken, msg.sender, fromPool.owner, n);
        _safeTransferFrom(toToken, toPool.owner, msg.sender, m);
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
