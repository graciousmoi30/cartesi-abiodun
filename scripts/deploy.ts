import { ethers } from "hardhat";

async function main() {
  const DAOToken = await ethers.getContractFactory("DAOToken");
  const token = await DAOToken.deploy();
  await token.deployed();

  console.log(`The address is ${token.address}`);
  // CONTRACT ADDRESS: 0xc4C8540576e682FE80d8515dfB59D592741DBac8
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
