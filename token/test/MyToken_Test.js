const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyToken", function () {

  let MultiTokenNFT, mytoken, owner, addr1, addr2, addr3, addrs
  // const uri1="https://bafybeihd4sxshvvk5b7wjawekvl64grqvxmocqh2l54y2qzppvdhf3enzq.ipfs.nftstorage.link/"
  before(async function () {
    MultiTokenNFT = await ethers.getContractFactory("MyToken",);
    mytoken = await MultiTokenNFT.deploy();
    await mytoken.deployed();
    [owner, addr1, addr2, addr3, ...addrs] = await ethers.getSigners()
    console.log(mytoken.address);
  });

  describe("Miniting and Testing", function () {
    it("Should return minted token", async function () {
      const mint = await mytoken.connect(owner).mint(1, 10);
      const mint1 = await mytoken.connect(addr1).mint(2, 30);
      await mint.wait();
      await mint1.wait();
      console.log(await mytoken.minted(1));
      console.log(await mytoken.balanceOf(addr1.address, 2));

    });
    it("Testing URI for each Token ID", async function () {
      await mytoken.uri1(2, "https://bafybeihd4sxshvvk5b7wjawekvl64grqvxmocqh2l54y2qzppvdhf3enzq.ipfs.nftstorage.link/");
      console.log(await mytoken._uris(2));
      console.log("Account Address", owner.address);
    });

  });


});
