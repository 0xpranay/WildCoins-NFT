// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { ethers } = require("hardhat");
async function main() {
  const contractFactory = await ethers.getContractFactory("CoinsGoneWild");
  const contractInstance = await contractFactory.deploy(10000);
  await contractInstance.deployed();
  console.log("Contract deployed at, ", contractInstance.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
