// Import ethers from Hardhat environment
const { ethers } = require("hardhat");

async function main() {
    // Fetch the contract factory
    const CensorableToken = await ethers.getContractFactory("CensorableToken");

    // Parameters for the constructor
    const name = "CensorableToken";
    const symbol = "CNSR";
    const initialSupply = ethers.parseEther("1000");  // 1000 tokens, for example
    const initialOwner = "YOUR METAMASK ADDRESS";  // Replace with actual owner address
    const validatorAddress = "0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155";  // Replace with actual validator address

    // Deploy the contract
    const censorableToken = await hre.ethers.deployContract("CensorableToken", [name, symbol, initialSupply, initialOwner]);
    
    // Wait for deployment to finish
    await censorableToken.waitForDeployment();

    console.log("CensorableToken deployed to:", censorableToken.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
