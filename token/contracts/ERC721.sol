// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ERC721 {
    string private _name;
    string private _symbol;

    mapping(uint256 => address) _owner;

    mapping(address => uint256) _balance;

    mapping(uint256 => address) _tokenApproval;

    mapping(address => mapping(address => bool)) _operatorApproval;

    event Transfer(address _from, address _to, uint256 _tokenId);

    event Approval(address _owner, address approve, uint256 tokenId);

    event Approvalforall(address _owner, address operator, bool _approved);
     
     ///ERC721: approval to current owner
     error sameOwner();

     ///ERC721: approve caller is not token owner nor approved for all
     error tokenOwner();
     

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function balanceof(address owner) public view returns (uint256) {
        return _balance[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return _owner[tokenId];
    }

    

    function approve(address _to, uint256 token_id) public  {
        address owner = ownerOf(token_id);

        if (_to != owner) {
            revert sameOwner();
        }
        if (msg.sender == owner || isApprovedforAll(owner, msg.sender)) {
            revert tokenOwner();
        }
        _approve(_to,token_id);
    }

    function _approve(address to,uint token_id) internal {
         _tokenApproval[token_id]=to;

         emit Approval(ownerOf(token_id), to, token_id);
    }

    function isApprovedforAll(address owner, address _operator)
        public
        view
        returns (bool)
    {
        return _operatorApproval[owner][_operator];
    }

    function safeTranasferFrom(
        address from,
        address to,
        uint256 tokenid,
        bytes memory data
    ) external {
        _safeTranasfer(from, to, tokenid, data);
    }

    function _safeTranasfer(
        address from,
        address to,
        uint256 tokentid,
        bytes memory data
    ) internal {}

    function transferfrom(
        address from,
        address to,
        uint256 tokenid
    ) public {}

    function setApprovalForAll(address _operator, bool _approved) public {}

    function getApprove(uint256 tokenid) external view returns (address) {}

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool)
    {}
}
