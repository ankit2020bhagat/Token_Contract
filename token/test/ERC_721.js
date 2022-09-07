const { ethers } = require("hardhat");

describe("ERC_721", function () {
    let myContract, owner, recepient1, recepient2, recepient3;
    it("ContractDeployement", async function () {
        [owner, recepient1, recepient2, recepient3] = await ethers.getSigners();
        let ERC721Contract = await ethers.getContractFactory("ERC721");
        myContract = await ERC721Contract.deploy("myEpicNFT", "NFT");
        await myContract.deployed();
        console.log("Contract Address :", myContract.address);
        console.log("Owner Address :", owner.address);
    })

    it("let mint nft", async function () {

        console.log("Name: ",await myContract.Name());
        console.log("Symbol: ",await myContract.Symbol());
        console.log("Contract Owner: ",await myContract.owner())
        console.log("Account Owner :",owner.address);
         let tranasction_safemint = await myContract.connect(owner).safeMint(recepient1.address);

         await tranasction_safemint.wait();

        tranasction_safemint = await myContract.connect(owner).safeMint(recepient2.address,{gasLimit: 6721975,
			gasPrice: 20000000000, });
        await tranasction_safemint.wait();

        tranasction_safemint =await myContract.connect(owner).safeMint(recepient3.address,{gasLimit: 6721975,
			gasPrice: 20000000000, });
        await tranasction_safemint.wait();

        //console.log(tranasction_safemint);
        console.log("Recepient Address: ", recepient1.address);
        console.log("Owner of token id O :", await myContract._owner(0));
        console.log("Owner of token id 1",await myContract._owner(1));
        console.log("Owner of token id 2",await myContract._owner(2));

        console.log(`balance of ${recepient1.address} ${await myContract._balance(recepient1.address)}`);
        console.log(`balance  of ${recepient2.address} ${await myContract._balance(recepient2.address)}`);
        console.log(`balace of ${recepient3.address} ${await myContract._balance(recepient3.address)}`);
        console.log(recepient2.address);
    })

    it("Calling Approve Transfer function :",async function(){
        const tranasction_approve=await myContract.connect(recepient1).approve(recepient2.address,0,{gasLimit :6721975,gasPrice: 20000000000});
        
        await tranasction_approve.wait();

        const tranasction_trnasfer = await myContract.connect(recepient1).transferFrom(recepient1.address,recepient2.address,0,{gasLimit:6721975,gasPrice:20000000000});

        await tranasction_trnasfer.wait();

        console.log(`balance  of ${recepient2.address} ${await myContract._balance(recepient2.address)}`);

        console.log(`balance of ${recepient1.address} ${await myContract._balance(recepient1.address)}`);
        console.log("Owner of token id O :", await myContract._owner(0));
        console.log("Owner of token id 1",await myContract._owner(1));
    })

    it("Burning NFT",async function(){
        const tranasaction_burn = await myContract.connect(recepient2).burn(0,{gasLimit:6721975,gasPrice:20000000000});

        await tranasaction_burn.wait();

        console.log(`balance  of ${recepient2.address} ${await myContract._balance(recepient2.address)}`);

        console.log("Total Supply :",await myContract.totalSupply())

        
    })

})