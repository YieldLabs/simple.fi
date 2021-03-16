pragma solidity >=0.7.6;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IERC20.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Callee.sol";
import "./libraries/UniswapV2Library.sol";

contract FlashBoy is IUniswapV2Callee {
    address immutable factory;
    uint256 constant deadline = 10 minutes;
    IUniswapV2Router02 immutable router;

    constructor(address _factory, address _router) public {
        factory = _factory;
        router = IUniswapV2Router02(_router);
    }

    function start(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1
    ) external {
        address pair = IUniswapV2Factory(factory).getPair(token0, token1);
        require(pair != address(0));

        IUniswapV2Pair(pair).swap(
            amount0,
            amount1,
            address(this),
            bytes("not empty")
        );
    }

    function uniswapV2Call(
        address _sender,
        uint256 _amount0,
        uint256 _amount1,
        bytes calldata _data
    ) external override {
        address[] memory path = new address[](2);
        uint256 amountToken = _amount0 == 0 ? _amount1 : _amount0;

        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();

        require(
            msg.sender == UniswapV2Library.pairFor(factory, token0, token1),
            "FLASHBOY: Unauthorized"
        );

        require(_amount0 == 0 || _amount1 == 0);

        path[0] = _amount0 == 0 ? token1 : token0;
        path[1] = _amount0 == 0 ? token0 : token1;

        IERC20 token = IERC20(_amount0 == 0 ? token1 : token0);

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

        assert(amountReceived > amountRequired);

        token.transfer(msg.sender, amountRequired);
        token.transfer(_sender, amountReceived - amountRequired);
    }
}
