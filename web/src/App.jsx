import React, { useEffect, useState } from "react";
import { ethers } from "ethers";
import { css } from "@emotion/react";
import ClipLoader from "react-spinners/ClipLoader";

import './styles/App.css';
import myEpicNft from './utils/MyEpicNFT.json';

// Constants
const TOTAL_MINT_COUNT = 50;
const CONTRACT_ADDRESS = "0x18057cf5C743fEa47b8cE35e614B04E50cf98426";

const App = () => {

  // store current account
  const [currentAccount, setCurrentAccount] = useState("");
  const [currentCount, setCurrentNFTCount] = useState("");
  const [isMining, setIsMining] = useState("");

  const checkIfWalletIsConnected = async () => {
    
    const { ethereum } = window;
    
    // Check if the ethereum object is available
    if (!ethereum) {
      console.log("Make sure you have metamask!");
      return;
    } else {
      console.log("We have the ethereum object", ethereum);
    }

    let chainId = await ethereum.request({ method: 'eth_chainId' });
    console.log("Connected to chain " + chainId);

    // String, hex code of the chainId of the Rinkebey test network
    const rinkebyChainId = "0x4";
    if (chainId !== rinkebyChainId) {
      alert("You are not connected to the Rinkeby Test Network!");
    }

    // Check if we're authorized to access the user's wallet    
    const accounts = await ethereum.request({ method: 'eth_accounts' });

    // If the use has multiple accounts, grab the first one
    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account);
      getNFTCount();

      // If user is connected, setup event listener
      setupEventListener();
    } else {
      console.log("No authorized account found")
    }
  }

  const connectWallet = async () => {
    try {
      const { ethereum } = window;

      // Check if ethereum object is available
      if (!ethereum) {
        alert("You need to install Metamask.");
        return;
      }

      let chainId = await ethereum.request({ method: 'eth_chainId' });
      console.log("Connected to chain " + chainId);

      // String, hex code of the chainId of the Rinkebey test network
      const rinkebyChainId = "0x4";
      if (chainId !== rinkebyChainId) {
        alert("You are not connected to the Rinkeby Test Network!");
      }

      // Request access to account
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      console.log("Connected", accounts[0]);
      setCurrentAccount(accounts[0]);
      getNFTCount();

      // If user is connected, setup event listener
      setupEventListener();

    } catch (error) {
      console.log(error);
    }
  }

  /**
   *  Setup event listener
  */
  const setupEventListener = async () => {
    try {
      const { ethereum } = window;

      // check if ethereum object is available
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, myEpicNft.abi, signer);

        connectedContract.on("NewEpicNFTMinted", (from, tokenId) => {
          console.log(from, tokenId.toNumber())
          alert(`Hey there! We've minted your NFT and sent it to your wallet. It may be blank right now. It can take a max of 10 min to show up on OpenSea. Here's the link: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toNumber()}`)
        });

        getNFTCount();

      } else {
        console.log("Ethereum object does not exist.");
      }

    } catch (error) {
      console.log(error);
    }
  }


  /**
   *  Get the number of NFTs minted so far
  */
  const getNFTCount = async () => {
    try {
      const { ethereum } = window;

      // Check if ethereum object is available
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, myEpicNft.abi, signer);

        let count = await connectedContract.getTotalNFTsMintedSoFar();
        console.log("Retrieved number of NFTs:", count.toNumber());

        setCurrentNFTCount(count.toNumber());

      } else {
        console.log("Ethereum object does not exist.");
      }

    } catch (error) {
      console.log(error);
    }
  }

  /**
   * Mint NFT
  */
  const askContractToMintNft = async () => {
    try {
      const { ethereum } = window;

      // check if ethereum object is available
      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, myEpicNft.abi, signer);

        console.log("Open wallet now and ask for gas");
        let nftTxn = await connectedContract.makeAnEpicNFT();
        setIsMining(true);

        console.log("Mining...");
        await nftTxn.wait();

        console.log(`Mined! Transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);
        setIsMining(false);
      } else {
        console.log("Ethereum object does not exist.");
      }

    } catch (error) {
      console.log(error);
    }

  }

  const renderWalletMintButton = () => {
    return (
      currentAccount === "" ? (<button className="cta-button connect-wallet-button" onClick={connectWallet} >
        Connect to Wallet
      </button>) : (<button onClick={askContractToMintNft} className="cta-button connect-wallet-button">
        Mint NFT
      </button>
      )
    );
  };

  const renderNumberOfNFTs = () => {
    return (
      currentAccount === "" ? (<p>Connect your wallet to see the number of available NFTs</p>) : (<p> {currentCount} / 15 NFTs minted so far.</p>)
    );
  };
  const showIsMiningSpinner = () => {
    return (
      isMining === true ? (<ClipLoader color={'green'} loading={'true'} size={50} />) : (<p></p>)
    );
  };

  /*
  * This runs our function when the page loads.
  */
  useEffect(() => {
    checkIfWalletIsConnected();
  }, [])

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">Diamonds are forever. As NFTs.</p>
          <div className="sub-text">
            {renderNumberOfNFTs()}
          </div>
          {renderWalletMintButton()}
          <div style={{ margin: "20px" }}>
            {showIsMiningSpinner()}
          </div>
          <div className="opensea-text">
            Checkout the collection on
            <div>
              <a
                className="opensea-text"
                href="https://testnets.opensea.io/collection/squarenft-mh4ov2hkhg"
                target="_blank"
                rel="noreferrer"
              >{`OpenSea`}</a></div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;