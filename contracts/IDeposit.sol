pragma solidity =0.8.1;

interface IDeposit {

    function deposit(
        address from,
        address token,
        uint96 amount
    ) external payable returns (uint96 received);

    function withdraw(
        address from,
        address to,
        address token,
        uint amount
    ) external payable;

    function transfer(
        address from,
        address to,
        address token,
        uint amount
    ) external payable;
}