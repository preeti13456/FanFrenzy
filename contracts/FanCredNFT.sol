// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract FanCredNFT is ERC721 {
    uint256 public tokenCounter;
    mapping(uint256 => uint8) public tokenTier; // 1=Rookie, 2=Veteran, 3=Legend

    constructor() ERC721("FanCredNFT", "FCRED") {}

    function mintNFT(address to, uint8 tier) public {
        uint256 newTokenId = tokenCounter++;
        _safeMint(to, newTokenId);
        tokenTier[newTokenId] = tier;
    }
}
