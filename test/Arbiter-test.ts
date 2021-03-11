import { expect } from "chai";
import { ethers } from "hardhat";

describe("Arbiter", () => {
  let arbiter;
  let alice;
  let bob;

  const uniswapFactoryAddr = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";
  const sushiswapRouterAddr = "0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F";

  const USDC = "0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6";
  const USDT = "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D";

  before(async () => {
    const signers = await ethers.getSigners();

    alice = signers[0];
    bob = signers[1];
  });

  beforeEach(async () => {
    let Arbiter = await ethers.getContractFactory("Arbiter");

    arbiter = await Arbiter.deploy(uniswapFactoryAddr, sushiswapRouterAddr);

    await arbiter.deployed();
  });

  it("Should be able to start arbitrage", async () => {
    expect(await arbiter.start(USDT, USDC, 1000, 1000)).not.be.null;
  });
});
