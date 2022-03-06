pragma solidity ^0.8.4;

contract ERC721 {
    mapping(address => uint256) internal _balances;
    mapping(uint256 => address) internal _owners;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    mapping(uint256 => address) private _tokenApprovals;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );

    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    // return the number of nft of an user
    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "Address is zero");
        return _balances[_owner];
    }

    // find owner of an nft
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _owners[_tokenId];
        require(owner != address(0), "Token ID is not exist");
        return owner;
    }

    // standard transferFrom method check if the receive smart contract is capable of receiving NFT
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) public payable {
        transferFrom(_from, _to, _tokenId);
        require(_checkOnERC721Received(), "Receiver not implemented");
    }

    // simple version to check for NFT receivability of a smart contract
    function _checkOnERC721Received() private pure returns (bool) {
        return true;
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    // transfer ownershiip of a single NFT
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public payable {
        address owner = ownerOf(_tokenId);
        require(
            msg.sender == owner ||
                getApproved(_tokenId) == msg.sender ||
                isApprovedForAll(owner, msg.sender),
            "msg.sender is not the owner or approved for transfer"
        );

        require(owner == _from, "from address is not the owner");
        require(_to != address(0), "Address is the zero address");
        require(_owners[_tokenId] != address(0), "Token ID does not exist");

        approve(address(0), _tokenId);
        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    // update an approved address for an NFT
    function approve(address _approved, uint256 _tokenId) public payable {
        address owner = ownerOf(_tokenId);
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "msg.sender is not the owner or the approved operator"
        );
        _tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    // enable or disable operator
    function setApprovalForAll(address _operator, bool _approved) external {
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    // get the approved address for an NFT
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(_owners[_tokenId] != address(0), "Token ID does not exist");

        return _tokenApprovals[_tokenId];
    }

    // check if an address is an operator for another address
    function isApprovedForAll(address _owner, address _operator)
        public
        view
        returns (bool)
    {
        return _operatorApprovals[_owner][_operator];
    }

    // EIP165 proposal, query if a contract implements  another interface
    function supportsInterface(bytes4 interfaceID)
        public
        pure
        virtual
        returns (bool)
    {
        return interfaceID == hex"80ac58cd";
    }
}
