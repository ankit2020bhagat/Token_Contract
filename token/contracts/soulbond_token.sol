//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Soulbond is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string baseuri =
        "https://gateway.pinata.cloud/ipfs/QmNbFLquR4kwF8YRWtJkRSGo18HkvD9ATY86pSVh7mHnns";

    ///you cannot tranfer this nft;
    error not_tranasferable();

    constructor()
        ERC721("MtToken", "MTN")
    {
        _tokenIdCounter.increment();
    }

    function TokenbaseURI() external view returns (string memory) {
        return baseuri;
    }

    function Mintnft() public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);

        _setTokenURI(tokenId, _baseURI());
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal virtual override {
        if (from != address(0)) {
            revert not_tranasferable();
        }

        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
}
