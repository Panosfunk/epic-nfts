const main = async () => {
    const axios = require('axios');
    const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("NFT contract deployed to: ", nftContract.address, "\n");

    let randomWordBase64 = await nftContract.generateRandomJsonData();
    randomWordBase64 = Buffer.from(randomWordBase64, 'base64');
    let randomWordJson = JSON.parse(randomWordBase64);

    console.log(randomWordJson);
    var config = {
        method: 'post',
        url: 'https://api.pinata.cloud/pinning/pinJSONToIPFS',
        headers: { 
            'Content-Type': 'application/json', 
            'pinata_api_key': `${process.env.REACT_APP_PINATA_API_KEY}`,
            'pinata_secret_api_key': `${process.env.REACT_APP_PINATA_API_SECRET}`,
        },
        data : 
        {
            "name": randomWordJson.name,
            "description": randomWordJson.description,
            "data": randomWordJson.image
        }
    };

    const res = await axios(config);
    
    const tokenURI = `ipfs://${res.data.IpfsHash}`;
    console.log(tokenURI);
    let txn = await nftContract.makeAnEpicNFT(tokenURI);
    await txn.wait();
    console.log("NFT #1 deployed");
    
    // // Mint another NFT for fun.
    // randomWord = await nftContract.generateRandomStringData();
    // txn = await nftContract.makeAnEpicNFT(randomWord);
    // // Wait for it to be mined.
    // await txn.wait();
    // console.log("NFT #2 deployed");
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

// const main = async () => {
//     const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
//     const nftContract = await nftContractFactory.deploy();
//     await nftContract.deployed();
//     console.log("Contract deployed to:", nftContract.address);
//   };
  
//   const runMain = async () => {
//     try {
//       await main();
//       process.exit(0);
//     } catch (error) {
//       console.log(error);
//       process.exit(1);
//     }
//   };
  
//   runMain();