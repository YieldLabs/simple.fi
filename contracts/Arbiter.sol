pragma solidity >=0.7.0;

import "./libraries/UniswapV2Library.sol";
import "./interfaces/IUniswapV2Router02.sol";
import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IUniswapV2Factory.sol";
import "./interfaces/IERC20.sol";

contract Arbiter {
    address factory;
    uint256 constant deadline = 10 days;
    IUniswapV2Router02 router;

    constructor(address _factory, address _router) public {
        factory = _factory;
        router = IUniswapV2Router02(_router);
    }

    function uniswapV2Call(
        address _sender,
        uint256 _amount0,
        uint256 _amount1,
        bytes calldata _data
    ) external {
        address[] memory path = new address[](2);
        uint256 amountToken = _amount0 == 0 ? _amount1 : _amount0;

        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();

        require(
            msg.sender == UniswapV2Library.pairFor(factory, token0, token1),
            "Unauthorized"
        );

        require(_amount0 == 0 || _amount1 == 0);

        path[0] = _amount0 == 0 ? token1 : token0;
        path[1] = _amount0 == 0 ? token0 : token1;

        IERC20Uniswap token = IERC20Uniswap(_amount0 == 0 ? token1 : token0);

        token.approve(address(router), amountToken);

        uint256 amountRequired = UniswapV2Library.getAmountsIn(
            factory,
            amountToken,
            path
        )[0];

        uint256 amountReceived = router.swapExactTokensForTokens(
            amountToken,
            amountRequired,
            path,
            msg.sender,
            deadline
        )[1];

        IERC20Uniswap otherToken = IERC20Uniswap(
            _amount0 == 0 ? token0 : token1
        );
        otherToken.transfer(msg.sender, amountRequired);
        otherToken.transfer(_sender, amountReceived - amountRequired);
    }
}
