// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Dog_NFT is ERC721URIStorage, Ownable
{
    uint8 public total_supply = 0;
    uint8 public constant MAX_NFT_Supply = 5;
    uint256 public constant NFT_Price = 100;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) Ownable(msg.sender) {}


    // 铸造 Dog NFT
    function mintDog(uint8 numberOfTokens) public payable 
    {
        require(total_supply + numberOfTokens <= MAX_NFT_Supply, "Purchase would exceed max supply of Dogs");
        require(NFT_Price * numberOfTokens <= msg.value);
        
        for (uint i = 0; i < numberOfTokens; i++)
        {
            _safeMint(msg.sender, total_supply++);
        }
    }

    // NFT URI
    function _baseURI() internal pure override returns (string memory) 
    {
        return "http://localhost:8000/metadata/";
    }
    
    function tokenURI(uint256 tokenId) public view override returns (string memory)
    {
        _requireOwned(tokenId);
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, Strings.toString(tokenId), ".json") : "";
    }

}