// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage{

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    string[] firstWords = ["League", "Category", "List", "Group", "Gathering", "Summary"];
    string[] secondWords = ["of", "of", "of", "of", "of", "of"];
    string[] thirdWords = ["Legends", "WarCraft", "Myths", "Clans", "Players", "Gamers"];

    string baseSvg = 
    "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'>"
    "<style>.base { fill: white; font-family: serif; font-size: 24px; }</style>"
    "<rect width='100%' height='100%' fill='black' />"
    "<text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string closingSvg = "</text></svg>";

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. WHAHAHAHOU!");
    }

    function pickRancdomWordFromArray(string memory seed, string[] memory nArray, uint256 tokenId) private pure returns(string memory) {
        uint256 index = random(string(abi.encodePacked(seed, Strings.toString(tokenId)))) % nArray.length;
        return nArray[index];
    }

    function generateRandomJsonData() public view returns(string memory) { 
        uint256 newItemId = _tokenIds.current();

        string memory firstWord = pickRancdomWordFromArray("first", firstWords, newItemId);
        string memory secondWord = pickRancdomWordFromArray("second", secondWords, newItemId);
        string memory thirdWord = pickRancdomWordFromArray("third", thirdWords, newItemId);
        string memory combinedWord = string(abi.encodePacked(firstWord, secondWord, thirdWord));

        string memory finalSvg = string(abi.encodePacked(baseSvg, firstWord, secondWord, thirdWord, closingSvg));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{'
                            '"name": "', combinedWord, '", '
                            '"description": "A highly acclaimed collection of squares.", '
                            '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(finalSvg)), '"'
                        '}'
                    )
                )
            )
        );

        console.log("base64", Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{'
                            '"name": "', combinedWord, '", '
                            '"description": "A highly acclaimed collection of squares.", '
                            '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(finalSvg)), '"'
                        '}'
                    )
                )
            )
        ), "\n\n");
        // console.log(string(abi.encodePacked(json)));
        return json;

    }

    function makeAnEpicNFT(string memory finalTokenUri) public {
        uint256 newItemId = _tokenIds.current();
        

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function random(string memory input) private pure returns(uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
}