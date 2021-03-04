import { expect } from "chai";
import { ethers } from "hardhat";

describe("PriceConsumerV3", function () {
  let priceConsumerV3;

  beforeEach(async () => {
    let PriceConsumerV3 = await ethers.getContractFactory("PriceConsumerV3");
    /**
     * Network: Mainnet
     * Aggregator: USDT/USD
     * Address: 0x3E7d1eAB13ad0104d2750B8863b489D65364e32D
     */
    let priceAddr = "0x3E7d1eAB13ad0104d2750B8863b489D65364e32D";
    priceConsumerV3 = await PriceConsumerV3.deploy(priceAddr);

    await priceConsumerV3.deployed();
  });

  it("Should be able to get price data", async () => {
    expect(await priceConsumerV3.getLatestPrice()).not.be.null;
  });
});
