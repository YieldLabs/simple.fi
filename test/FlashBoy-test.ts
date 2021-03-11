import { expect } from "chai";
import { ethers } from "hardhat";

describe("FlashBoy", () => {
  let flashboy;
  let alice;
  let bob;

  const uniswapFactoryAddr = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";
  const sushiswapRouterAddr = "0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac";

  const USDC = "0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6";
  const USDT = "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D";
  const DAI = "0x6b175474e89094c44da98b954eedeac495271d0f";
  const WETH = "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2";

  before(async () => {
    const signers = await ethers.getSigners();

    alice = signers[0];
    bob = signers[1];
  });

  beforeEach(async () => {
    let FlashBoy = await ethers.getContractFactory("FlashBoy");

    flashboy = await FlashBoy.deploy(uniswapFactoryAddr, sushiswapRouterAddr);

    await flashboy.deployed();
  });

  it("Should be able to start arbitrage", async () => {
    expect(await flashboy.start(WETH, USDC, 10, 0)).not.be.null;
  });
});
