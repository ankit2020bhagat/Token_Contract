const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyToken", function () {
  it("", async function () {
    let MultiTokenNFT, tokenContract, owner, addr1, addr2, addr3, addrs
  //  const uri="https://bafybeihd4sxshvvk5b7wjawekvl64grqvxmocqh2l54y2qzppvdhf3enzq.ipfs.nftstorage.link/"
     MultiTokenNFT = await ethers.getContractFactory("MyToken",);
    const mytoken = await MultiTokenNFT.deploy("https://bafybeihd4sxshvvk5b7wjawekvl64grqvxmocqh2l54y2qzppvdhf3enzq.ipfs.nftstorage.link/{id}.json");
    await mytoken.deployed();
    [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners()
   console.log(mytoken.address);
  const mint= await mytoken.connect(owner).mint(1,10)
   await mint.wait();
   console.log(await mytoken.minted[0]);
   await mytoken.connect(owner).uri(1,"https://bafybeihd4sxshvvk5b7wjawekvl64grqvxmocqh2l54y2qzppvdhf3enzq.ipfs.nftstorage.link/");
   console.log(await mytoken._uris[1]);
   console.log("Account Address",owner.address);
  }
  );
});