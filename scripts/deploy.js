const main = async () => {
    console.log("am i even running bro");
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    console.log("got factory");
    const nftContract = await nftContractFactory.deploy();
    console.log("got contract", nftContract.address);
    await nftContract.deployed();
    console.log("NFT contract deployed to: ", nftContract.address);

    let txn = await nftContract.makeAnEpicNFT();
    await txn.wait();
    
    // Mint another NFT for fun.
    txn = await nftContract.makeAnEpicNFT();
    // Wait for it to be mined.
    await txn.wait();
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

runMain();