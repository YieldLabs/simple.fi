import { HardhatUserConfig } from "hardhat/types";
import * as dotenv from "dotenv";

import "@nomiclabs/hardhat-waffle";
import "@openzeppelin/hardhat-upgrades";
import "@nomiclabs/hardhat-ethers";
import "hardhat-typechain";

dotenv.config();

const config: HardhatUserConfig = {
  defaultNetwork: "matic",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [PRIVATE_KEY],
    },
    matic: {
      url: "https://rpc-mainnet.matic.network",
      accounts: [PRIVATE_KEY],
    },
    hardhat: {
      forking: {
        url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
        blockNumber: 11095000,
      },
    },
  },
  typechain: {
    outDir: "types",
    target: "ethers-v5",
  },
  solidity: {
    version: "0.8.6",
    settings: {
      optimizer: {
        enabled: true,
        runs: 500,
      },
    },
  },
};

export default config;
