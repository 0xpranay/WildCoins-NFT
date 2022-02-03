const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("Deploy check", async function () {
  async function setup(supplyCount) {
    const contractCode = await ethers.getContractFactory("ArtPieces");
    const contractInstance = await contractCode.deploy(supplyCount);
    await contractInstance.deployed();
    const deployer = await ethers.getSigner(0);
    const user = await ethers.getSigner(1);
    return [contractInstance, deployer, user];
  }
  it("Should return correct max supply", async function () {
    const [contract, deployer, user] = await setup(5);
    expect(await contract.maxSupply()).to.equals(5);
  });
});

describe("Mint Function", async function () {
  async function setup(supplyCount) {
    const contractCode = await ethers.getContractFactory("ArtPieces");
    const contractInstance = await contractCode.deploy(supplyCount);
    await contractInstance.deployed();
    const deployer = await ethers.getSigner(0);
    const user = await ethers.getSigner(1);
    return [contractInstance, deployer, user];
  }
  it("Should mint an NFT", async function () {
    const [contract, deployer, user] = await setup(5);
    const userInstance = contract.connect(user);
    const txn = await userInstance.mintArtPiece({
      value: ethers.utils.parseEther("0.008"),
    });
    await txn.wait();
    expect(await contract.balanceOf(user.address)).to.be.equals(1);
  });
  it("Should revert on less ETH", async function () {
    const [contract, deployer, user] = await setup(5);
    const userInstance = contract.connect(user);
    await expect(
      userInstance.mintArtPiece({
        value: ethers.utils.parseEther("0.007"),
      })
    ).to.be.revertedWith("Each Art Piece costs 0.008 Ether");
  });
  it("Should revert after all tokens are minted", async function () {
    const [contract, deployer, user] = await setup(1);
    const txn = await contract.mintArtPiece({
      value: ethers.utils.parseEther("0.008"),
    });
    await txn.wait();
    await expect(
      contract.mintArtPiece({ value: ethers.utils.parseEther("0.008") })
    ).to.be.revertedWith("All Art Pieces are Minted");
  });
});
