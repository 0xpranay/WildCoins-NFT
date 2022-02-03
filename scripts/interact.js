const hre = require("hardhat");
const { ethers } = require("hardhat");
console.clear();
async function main() {
  const contractFactory = await ethers.getContractFactory("CoinsGoneWild");
  const contractInstance = contractFactory.attach(
    "0xBc4377668BB685d737Ff66be2F5700A68c4b2635"
  );
  for (let i = 0; i < 6; i++) {
    const caller = await ethers.getSigner(0);
    const instance = contractInstance.connect(caller);
    const txn = await instance.mintWildCoin({
      value: ethers.utils.parseEther("0.008"),
    });
    await txn.wait();
    console.log("Mined at ", txn.hash);
  }
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
