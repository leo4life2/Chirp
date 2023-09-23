"use client";

import { useState } from "react";
import { ethers } from "ethers";
import { createHelia } from "helia";
import { strings } from "@helia/strings";
import fs from 'fs';
import path from 'path';

export default function Home() {
  const [message, setMessage] = useState("");
  const [userAddress, setUserAddress] = useState("");

  const connectWallet = async () => {
    if (typeof window.ethereum !== "undefined") {
      const [address] = await window.ethereum.request({
        method: "eth_requestAccounts",
      });
      setUserAddress(address);
    } else {
      alert("Please install MetaMask!");
    }
  };

  const publishPeep = async () => {
    try {
      const heliaClient = await createHelia();
      const helia = strings(heliaClient);
      const cid = await helia.add(message);
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const contractAddress = "0xd27EaC1253059bB4a350cddb45FC616a7bD354a5";
      const contractABIPath = path.join(process.cwd(), "resources", "abi.json");
      const contractABI = JSON.parse(fs.readFileSync(contractABIPath, "utf8"));
      const chirpContract = new ethers.Contract(
        contractAddress,
        contractABI,
        signer
      );
      await chirpContract.postPeep(cid.toString());
      alert("Peep published!");
    } catch (error) {
      console.error("Error publishing peep:", error);
    }
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2">
      <button
        onClick={connectWallet}
        className="mb-4 px-4 py-2 font-bold text-white bg-blue-500 rounded-full hover:bg-blue-700"
      >
        Connect Wallet
      </button>
      {userAddress && (
        <div className="flex flex-col items-center">
          <input
            type="text"
            placeholder="Enter your peep here..."
            className="mb-4 p-2 border rounded-md"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
          />
          <button
            onClick={publishPeep}
            className="px-4 py-2 font-bold text-white bg-green-500 rounded-full hover:bg-green-700"
          >
            Publish Peep
          </button>
        </div>
      )}
    </div>
  );
}
