require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    chiliz_testnet: {
      url: "https://spicy-rpc.chiliz.com/",
      accounts: [process.env.PRIVATE_KEY],
    },
    chiliz_mainnet: {
      url: "https://rpc.chiliz.com/",
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
