// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; 
import { Base64 } from "./libraries/Base64.sol";


contract MyEpicNFT is ERC721URIStorage {

    // Limit number of NFTs to 15
    uint8 maxNFT = 15;

    // Unique tokenId for each NFT
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Event that is emited after minting the NFT
    event NewEpicNFTMinted(address sender, uint256 tokenId);


    // SVG data
    string svgPart1Red = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 70 70'><style>.base { fill: white; font-family: arial; font-size: 4px; }</style><rect width='100%' height='100%' fill='#310600' /><text x='50%' y='10%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgPart2Red = "</text><style>.t1 { fill: #AB1F0D; animation: t1 2s ease-in-out infinite; } .t2 { fill: #F58D80; animation: t2 2s ease-in-out infinite; } .t3 { fill: #F14E39; animation: t3 2s ease-in-out infinite; } .t4 { fill: #942819; animation: t4 2s ease-in-out infinite; } .t5 { fill: #F56653; animation: t5 2s ease-in-out infinite; } .t6 { fill: #D03D2A; animation: t6 2s ease-in-out infinite; } .t7 { fill: #F5A298; animation: t7 2s ease-in-out infinite; } .t8 { fill: #F5897B; animation: t8 2s ease-in-out infinite; } .t9 { fill: #7D2114; animation: t9 2s ease-in-out infinite; } @keyframes t1 { 0% { fill: #AB1F0D } 20% { fill: #F86C5A } 40% { fill: #5F0000 } 60% { fill: #AB1F0D } } @keyframes t2 { 5% { fill: #F58D80 } 25% { fill: #FFDACD } 45% { fill: #A94134 } 65% { fill: #F58D80 } } @keyframes t3 { 10% { fill: #F14E39 } 30% { fill: #FF9B86 } 50% { fill: #A50200 } 70% { fill: #F14E39 } } @keyframes t4 { 15% { fill: #942819 } 35% { fill: #E17566 } 55% { fill: #480000 } 75% { fill: #942819 } } @keyframes t5 { 20% { fill: #F56653 } 40% { fill: #FFB3A0 } 60% { fill: #A91A07 } 80% { fill: #F56653 } } @keyframes t6 { 25% { fill: #D03D2A } 45% { fill: #FF8A77 } 65% { fill: #840000 } 85% { fill: #D03D2A } } @keyframes t7 { 30% { fill: #F5A298 } 50% { fill: #FFEFE5 } 60% { fill: #A9564C } 90% { fill: #F5A298 } } @keyframes t8 { 35% { fill: #F5897B } 55% { fill: #FFD6C8 } 75% { fill: #A93D2F } 95% { fill: #F5897B } } @keyframes t9 { 40% { fill: #7D2114 } 60% { fill: #CA6E61 } 80% { fill: #310000 } 100% { fill: #7D2114 } } .b1 { fill: #BB311E; animation: b1 2s ease-in-out infinite; } .b2 { fill: #F16553; animation: b2 2s ease-in-out infinite; } .b3 { fill: #D63924; animation: b3 2s ease-in-out infinite; } .b4 { fill: #F98778; animation: b4 2s ease-in-out infinite; } .b5 { fill: #9E2717; animation: b5 2s ease-in-out infinite; } @keyframes b1 { 0% { fill: #BB311E } 20% { fill: #FF7E6B } 40% { fill: #6F0000 } 60% { fill: #BB311E } } @keyframes b2 { 10% { fill: #F16553 } 30% { fill: #FFB2A0 } 50% { fill: #A51907 } 70% { fill: #F16553 } } @keyframes b3 { 20% { fill: #D63924 } 40% { fill: #FF8671 } 60% { fill: #8A0000 } 80% { fill: #D63924 } } @keyframes b4 { 30% { fill: #F98778 } 50% { fill: #FFD4C5 } 70% { fill: #AD3B2C } 90% { fill: #F98778 } } @keyframes b5 { 40% { fill: #9E2717 } 60% { fill: #EB7464 } 80% { fill: #520000 } 100% { fill: #9E2717 } } .overlay { fill: #fff; opacity: .1; animation: overlay 2s ease-in-out infinite; } @keyframes overlay { 30% { opacity: 0; fill: #000; } 50% { opacity: .1; } 70% { opacity: 0; } } </style> <g> <path fill='#E8422C' d='M10,15h50l10,10l-35,30l-35,-30z'/> <!-- Top shapes --> <path class='t1' d='M0,25h14l-4,-10z'/> <path class='t2' d='M10,15h11l-7,10z'/> <path class='t3' d='M14,25h14l-7,-10z'/> <path class='t4' d='M21,15h14l-7,10z'/> <path class='t5' d='M28,25h14l-7,-10z'/> <path class='t6' d='M35,15h14l-7,10z'/> <path class='t7' d='M42,25h14l-7,-10z'/> <path class='t8' d='M49,15h11l-4,10z'/> <path class='t9' d='M56,25h14l-10,-10z'/> <!-- Bottom shapes --> <path class='b1' d='M0,25h14l21,30z'/> <path class='b2' d='M14,25h14l7,30z'/> <path class='b3' d='M28,25h14l-7,30z'/> <path class='b4' d='M42,25h14l-21,30z'/> <path class='b5' d='M56,25h14l-35,30z'/> <path class='overlay' d='M10,15h50l10,10l-35,30l-35,-30z'/> </g> </svg>";
    string svgPart1Yellow = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 70 70'><style>.base { fill: black; font-family: arial; font-size: 4px; }</style><rect width='100%' height='100%' fill='#FFF9B6' /><text x='50%' y='10%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgPart2Yellow = "</text><style>.t1 { fill: #FFFEA9; animation: t1 2s ease-in-out infinite; } .t2 { fill: #E6DF9A; animation: t2 2s ease-in-out infinite; } .t3 { fill: #FFF323; animation: t3 2s ease-in-out infinite; } .t4 { fill: #FFE300; animation: t4 2s ease-in-out infinite; } .t5 { fill: #FFCE45; animation: t5 2s ease-in-out infinite; } .t6 { fill: #FBF46D; animation: t6 2s ease-in-out infinite; } .t7 { fill: #FBD148; animation: t7 2s ease-in-out infinite; } .t8 { fill: #F2F013; animation: t8 2s ease-in-out infinite; } .t9 { fill: #FEE440; animation: t9 2s ease-in-out infinite; } @keyframes t1 { 0% { fill: #FFFEA9 } 20% { fill: #FFFFE3 } 40% { fill: #FFFEC9 } 60% { fill: #FFFEA9 } } @keyframes t2 { 5% { fill: #E6DF9A } 25% { fill: #F9F6DE } 45% { fill: #E6DF9A } 65% { fill: #E6DF9A } } @keyframes t3 { 10% { fill: #FFF323 } 30% { fill: #FFFBB8 } 50% { fill: #FFF775 } 70% { fill: #FFF323 } } @keyframes t4 { 15% { fill: #FFE300 } 35% { fill: #FFF6AC } 55% { fill: #FFEE60 } 75% { fill: #FFE300 } } @keyframes t5 { 20% { fill: #FFCE45 } 40% { fill: #FFE18B } 60% { fill: #FFCE45 } 80% { fill: #FFCE45 } } @keyframes t6 { 25% { fill: #FBF46D } 45% { fill: #FEFAA4 } 65% { fill: #FBF46D } 85% { fill: #FBF46D } } @keyframes t7 { 30% { fill: #FBD148 } 50% { fill: #FEF0C3 } 60% { fill: #FEE38D } 90% { fill: #FBD148 } } @keyframes t8 { 35% { fill: #F2F013 } 55% { fill: #FCFBB0 } 75% { fill: #FCFB6B } 95% { fill: #F2F013 } } @keyframes t9 { 40% { fill: #FEE440 } 60% { fill: #FFF6C1 } 80% { fill: #FFEF88 } 100% { fill: #FEE440 } } .b1 { fill: #FFFEA9; animation: b1 2s ease-in-out infinite; } .b2 { fill: #E6DF9A; animation: b2 2s ease-in-out infinite; } .b3 { fill: #FFF323; animation: b3 2s ease-in-out infinite; } .b4 { fill: #FFE300; animation: b4 2s ease-in-out infinite; } .b5 { fill: #FFCE45; animation: b5 2s ease-in-out infinite; } @keyframes b1 { 0% { fill: #FFFEA9 } 20% { fill: #FFFFE3 } 40% { fill: #FFFEC9 } 60% { fill: #FFFEA9 } } @keyframes b2 { 5% { fill: #E6DF9A } 25% { fill: #F9F6DE } 45% { fill: #E6DF9A } 65% { fill: #E6DF9A } } @keyframes b3 { 10% { fill: #FFF323 } 30% { fill: #FFFBB8 } 50% { fill: #FFF775 } 70% { fill: #FFF323 } } @keyframes b4 { 15% { fill: #FFE300 } 35% { fill: #FFF6AC } 55% { fill: #FFEE60 } 75% { fill: #FFE300 } } @keyframes b5 { 20% { fill: #FFCE45 } 40% { fill: #FFE18B } 60% { fill: #FFCE45 } 80% { fill: #FFCE45 } } .overlay { fill: #fff; opacity: .1; animation: overlay 2s ease-in-out infinite; } @keyframes overlay { 30% { opacity: 0; fill: #000; } 50% { opacity: .1; } 70% { opacity: 0; } } </style> <g> <path fill='#FFFEA9' d='M10,15h50l10,10l-35,30l-35,-30z'/> <!-- Top shapes --> <path class='t1' d='M0,25h14l-4,-10z'/> <path class='t2' d='M10,15h11l-7,10z'/> <path class='t3' d='M14,25h14l-7,-10z'/> <path class='t4' d='M21,15h14l-7,10z'/> <path class='t5' d='M28,25h14l-7,-10z'/> <path class='t6' d='M35,15h14l-7,10z'/> <path class='t7' d='M42,25h14l-7,-10z'/> <path class='t8' d='M49,15h11l-4,10z'/> <path class='t9' d='M56,25h14l-10,-10z'/> <!-- Bottom shapes --> <path class='b1' d='M0,25h14l21,30z'/> <path class='b2' d='M14,25h14l7,30z'/> <path class='b3' d='M28,25h14l-7,30z'/> <path class='b4' d='M42,25h14l-21,30z'/> <path class='b5' d='M56,25h14l-35,30z'/> <path class='overlay' d='M10,15h50l10,10l-35,30l-35,-30z'/> </g> </svg>";

    // NFT foreground text
    string[] firstWords = ["Red", "Yellow"];
    string[] secondWords = ["Sparkling", "Flashing", "Glittering", "Shining", "Twinkling"];
    string[] thirdWords = ["Diamond", "Jewel", "Gem", "Ruby", "Emerald", "Sapphirine"];


    constructor () ERC721 ("DiamondsNFT", "DIAMNFT"){
        console.log("This is my NFT contract. Woooohooooooooooo!!!");
    }

    function makeAnEpicNFT() public {
        // Enforce the limit of available NFTs
        require(_tokenIds.current() <= maxNFT);

        // Get current tokenId
        uint256 newItemId = _tokenIds.current();

        // Randomly pick words
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));
        string memory finalSvg;
        
        // Check if first word is red -> set red diamond, else yellow diamond
        if(keccak256(bytes(first)) == keccak256(bytes("Red"))) {
            finalSvg = string(abi.encodePacked(svgPart1Red, first, second, third, svgPart2Red));
        } else {
            finalSvg = string(abi.encodePacked(svgPart1Yellow, first, second, third, svgPart2Yellow));
        }

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Create final Token URI
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");


        // Mint the NFT to the sender
        _safeMint(msg.sender, newItemId);

        // Set the NFT's data
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

        // Increment counter
        _tokenIds.increment();

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // I seed the random generator
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        // Get value between 0 and array length
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
    }

    function getTotalNFTsMintedSoFar() public view returns (uint256){
        return _tokenIds.current();
    }

}



