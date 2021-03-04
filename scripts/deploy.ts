import { ethers } from "hardhat";

async function main() {
  const factory = await ethers.getContractFactory("PriceConsumerV3");

  let contract = await factory.deploy();

  console.log(contract.address);

  await contract.deployed();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
