pragma solidity ^0.8.4;

import "./ERC721.sol";

contract Collection is ERC721 {
    string public name; // ER721 metadata
    string public symbol; // ER721 metadata
    uint256 public tokenCount;

    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }

    function tokenURI(uint256 tokenID) public view returns (string memory) {
        require(_owners[tokenID] != address(0), "Token ID does not exist");
        return _tokenURIs[tokenID];
    }

    function mint(string memory _tokenURI) public {
        // ER721 metadata
        tokenCount += 1;
        _balances[msg.sender] += 1;
        _owners[tokenCount] = msg.sender;
        _tokenURIs[tokenCount] = _tokenURI;

        emit Transfer(address(0), msg.sender, tokenCount);
    }

    function supportsInterface(bytes4 interfaceID)
        public
        pure
        override
        returns (bool)
    {
        return interfaceID == hex"80ac58cd" || interfaceID == 0x5b5e139f;
    }
}
