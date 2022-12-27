// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";

/// @title EnvironmentalToken

contract EnvironmentalToken is ERC721, Ownable {
    constructor() ERC721("AMA-NFT", "AMA") {}

    using Counters for Counters.Counter;
    Counters.Counter private supply;

    uint256 public maxSupply = 1000;

    /// TO DO: add IPFS metadata

    /// TO DO: add a method to don't allow change maxSupply
    uint256 public cost = 0 wei;

    /// @notice struct for the token (TO DO: remove this struct and add a mapping)
    struct Environmental {
        string data;
    }

    /// all tokens emitted
    Environmental[] public environmental;

    // @notice getEnvironmental returns all tokens
    function getEnvironmental() public view returns (Environmental[] memory) {
        return environmental;
    }

    // @notice totalSupply returns the total number of tokens
    function totalSupply() public view returns (uint256) {
        return supply.current();
    }

    // @notice mint function to mint a new token
    function mint(string memory _data, address _owner)
        public
        payable
        onlyOwner
    {
        require(supply.current() <= maxSupply, "Max supply exceeded!");
        require(msg.value >= cost, "Insufficient funds!");
        require(bytes(_data).length > 0, "Data is empty!");
        supply.increment();
        Environmental memory _newEnvironmental = Environmental(_data);
        environmental.push(_newEnvironmental);
        _safeMint(_owner, supply.current());
    }

    // @notice returns the environmental data of a token
    function getEnvironmentalById(uint256 _tokenId)
        public
        view
        returns (string memory)
    {
        require(
            _tokenId > 0 && _tokenId <= supply.current(),
            "Token does not exist!"
        );
        return environmental[_tokenId - 1].data;
    }

    // @notice returns the environmental data of a owner
    function getEnvironmentalByOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256[] memory result = new uint256[](balanceOf(_owner));
        uint256 counter = 0;
        for (uint256 i = 1; i <= supply.current(); i++) {
            if (ownerOf(i) == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
