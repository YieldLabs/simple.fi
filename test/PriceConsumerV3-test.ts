import { expect } from "chai";
import { ethers } from "hardhat";

describe("PriceConsumerV3", function () {
  let priceConsumerV3;

  beforeEach(async () => {
    let PriceConsumerV3 = await ethers.getContractFactory("PriceConsumerV3");
    priceConsumerV3 = await PriceConsumerV3.deploy();

    await priceConsumerV3.deployed();
  });

  it("Should be able to get price data", async () => {
    expect(await priceConsumerV3.getLatestPrice()).not.be.null;
  });
});
