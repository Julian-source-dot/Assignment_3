require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    unima: {
      url: "http://134.155.50.136:8506",
      accounts: ["Private Key"]
    }
  }
};
