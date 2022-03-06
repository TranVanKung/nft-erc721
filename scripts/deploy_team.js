const { ethers } = require("hardhat");

async function main() {
  const Collection = await ethers.getContractFactory("MyTeam");
  const collection = await Collection.deploy("DGD DI", "DGDDI");
  await collection.deployed();
  console.log("Successfully deployed smart contract to:", collection.address);
  await collection.mint(
    "https://ipfs.io/ipfs/QmeHxa3rr5Xkvbggw7bjSjcouK7tS5UmATydHhmynDbi82"
  );

  console.log("NFT successfully minted");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

// nft address: 0x9C7017A48C17bE5d5cb4198DF37C17255c79Aaa7
