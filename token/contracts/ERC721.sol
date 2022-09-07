// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./library.sol";

contract ERC721 {
    string private _name;
    string private _symbol;

    address public owner;

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => address) public _owner;

    mapping(address => uint256) public _balance;

    mapping(uint256 => address) public _tokenApproval;

    uint256[] private _allTokens;

    mapping(address => mapping(address => bool)) _operatorApproval;

    event Transfer(address _from, address _to, uint256 _tokenId);

    event Approval(address _owner, address approve, uint256 tokenId);

    event Approvalforall(address _owner, address operator, bool _approved);

    ///ERC721: approval to current owner
    error sameOwner();

    ///ERC721: approve caller is not token owner nor approved for all
    error tokenOwner();

    ///ERC721: mint to the zero address
    error addressZero();

    ///ERC721: token already minted
    error alreadyExists();

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert();
        }
        _;
    }

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
    }

    function Name() external view returns (string memory) {
        return _name;
    }

    function Symbol() external view returns (string memory) {
        return _symbol;
    }

    function balanceof(address owner) public view returns (uint256) {
        return _balance[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return _owner[tokenId];
    }

    function approve(address _to, uint256 token_id) public {
        address owner = ownerOf(token_id);

        if (_to == owner) {
            revert sameOwner();
        }
        if (msg.sender != owner || isApprovedforAll(owner, msg.sender)) {
            revert tokenOwner();
        }
        _approve(_to, token_id);
    }

    function _approve(address to, uint256 token_id) internal {
        _tokenApproval[token_id] = to;

        emit Approval(ownerOf(token_id), to, token_id);
    }

    function isApprovedforAll(address owner, address _operator)
        public
        view
        returns (bool)
    {
        return _operatorApproval[owner][_operator];
    }

    function getApprove(uint256 token_id) public view returns (address) {
        _requireminted(token_id);

        return _tokenApproval[token_id];
    }

    function _requireminted(uint256 token_id) internal view {
        if (_exists(token_id)) {
            revert();
        }
        //require(_exists(token_id), "ERC721: invalid token ID");
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owner[tokenId] != address(0);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenid
    ) public {
        if (!isApprovedOrOwner(msg.sender, tokenid)) {
            revert();
        }
        _transfer(from, to, tokenid);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        if (!(isApprovedOrOwner(msg.sender, tokenId)))
            _safeTransferFrom(from, to, tokenId, "");
    }

    function _safeTransferFrom(
        address from,
        address to,
        uint256 tokenid,
        bytes memory data
    ) internal {
        _transfer(from, to, tokenid);
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenid
    ) internal {
        if (ownerOf(tokenid) != from) {
            revert tokenOwner();
        }

        if (to == address(0)) {
            revert();
        }

        _beforeTokentransfer(from, to, tokenid);

        _approve(to, tokenid);

        _balance[from] -= 1;
        _balance[to] += 1;
        _owner[tokenid] = to;

        emit Transfer(from, to, tokenid);

        _afterTokenTransfer(from, to, tokenid);
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _allTokens.push(tokenId);
        _tokenIdCounter.increment();
        _safeMint(to, tokenId, "");

    }

    function _safeMint(
        address to,
        uint256 tokenid,
        bytes memory data
    ) internal {
        _mint(to, tokenid);
    }

    function _mint(address to, uint256 tokenId) internal {
        if (to == address(0)) {
            revert addressZero();
        }
        if (_exists(tokenId)) {
            revert alreadyExists();
        }
        _beforeTokentransfer(address(0), to, tokenId);

        _balance[to] += 1;

        _owner[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

    function _beforeTokentransfer(
        address from,
        address to,
        uint256 tokenid
    ) internal {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenid
    ) internal {}

    function isApprovedOrOwner(address spender, uint256 tokenid)
        public
        view
        returns (bool)
    {
        address owner = ownerOf(tokenid);

        return (spender == owner ||
            isApprovedforAll(owner, spender) ||
            getApprove(tokenid) == spender);
    }

    function setApprovalForAll(address _operator, bool _approved) public {
        _setApprovalforAll(msg.sender, _operator, _approved);
    }

    function _setApprovalforAll(
        address owner,
        address _operator,
        bool _approved
    ) internal {
        if (owner == _operator) {
            revert sameOwner();
        }

        _operatorApproval[owner][_operator] = _approved;

        emit Approvalforall(owner, _operator, _approved);
    }

    function burn(uint256 tokenId) public {
        if (!isApprovedOrOwner(msg.sender, tokenId)) {
            revert();
        }
        _burn(tokenId);
    }

    function _burn(uint256 tokenId) internal {
        address owner = ownerOf(tokenId);

        _beforeTokentransfer(owner, address(0), tokenId);

        _approve(address(0), tokenId);

        _balance[owner] -= 1;

        delete _owner[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);

        _allTokens.pop();
    }

    function totalSupply() public view  returns (uint256) {
        return _allTokens.length;
    }
}
