const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("ERC_20", function () {
    let getContract, deployContract, owner, _to, spender;
    it("Deploying ERC_20 token", async function () {
        [owner, _to, spender] = await ethers.getSigners();
        getContract = await ethers.getContractFactory("ERC_20");
        deployContract = await getContract.deploy();
        console.log("Contract Address :", deployContract.address);
        console.log("Owner Address :", owner.address);
        console.log("Total supply of ERC_20:", await deployContract.totalSupply());
        const ownerBalance = await deployContract.balanceOf(owner.address);
        // console.log("Owner Balance ",await deployContract.balanceOf(owner.address));
        console.log(`Balance of ${owner.address} is :${ownerBalance}`)
    });
    it("Minting ERC_20", async function () {
        await deployContract.connect(owner).tranfer(_to.address, 100);
        console.log("Balance of Reciepient address", await deployContract.balanceOf(_to.address));
        console.log("Owner Balance ", await deployContract.balanceOf(owner.address));
    });

    it("Allowing spender :", async function () {
      await deployContract.approve(spender.address,40);
      console.log("Spender Balance :",await deployContract.allowance(owner.address,spender.address));
    });

    it("Minting through spender ",async function(){
       await deployContract.connect(spender).tranferFrom(owner.address,_to.address,20);
    
        console.log("Spender Balance :",await deployContract.allowance(owner.address,spender.address));
        console.log("Balance of Recepient address", await deployContract.balanceOf(_to.address));
        console.log("Balance of Owner address", await deployContract.balanceOf(owner.address));
    })

    it("Burning NFT :",async function(){
        await deployContract._burn(owner.address,20);
        console.log("Owner Balance ",await deployContract.balanceOf(owner.address));
    })

    it("Burn NFT using spender",async function(){
       
        await deployContract.connect(spender).burnFrom(owner.address,10);
        console.log("spender Balance :",await deployContract.allowance(owner.address,spender.address));
        console.log("Owner Balance: ",await deployContract.balanceOf(owner.address));
    })
});