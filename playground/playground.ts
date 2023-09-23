import { ethers } from 'ethers';


const provider = new ethers.JsonRpcProvider("https://sepolia-rpc.scroll.io/");

// Read the private key from the environment variable
const privateKey = process.env.PRIVATE_KEY;
if (!privateKey) {
    throw new Error("Please set the PRIVATE_KEY environment variable.");
}
const wallet = new ethers.Wallet(privateKey, provider);

const contractAddress = "0xd27EaC1253059bB4a350cddb45FC616a7bD354a5";
const contractABI = [
    {
        "inputs": [
            {
                "internalType": "string",
                "name": "_cid",
                "type": "string"
            }
        ],
        "name": "postPeep",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
];

const chirpContract = new ethers.Contract(contractAddress, contractABI, wallet);

async function postPeepToChirp(cid: string) {
    try {
        const tx = await chirpContract.postPeep(cid);
        console.log("Transaction sent:", tx.hash);
        await tx.wait();
        console.log("Transaction confirmed!");
    } catch (error) {
        console.error("Error posting peep:", error);
    }
}

const exampleCID = "QmXckWwczifCygr9ubJ4g97NQRLoRLYvND9GqvLmZTXwvo";
postPeepToChirp(exampleCID);