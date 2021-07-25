pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Cert is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _certCounter;

    constructor(string memory name, string memory symbol)
        ERC721(name, symbol)
    {}

    function mintCert(address owner, string memory uri)
        public
        returns (uint256)
    {
        _certCounter.increment();

        uint256 certId = _certCounter.current();

        _safeMint(owner, certId);
        _setTokenURI(certId, uri);

        return certId;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return "ipfs://";
    }
}
