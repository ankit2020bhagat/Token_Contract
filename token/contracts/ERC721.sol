// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./library.sol";

interface IERC721Receiver {
   
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

contract ERC721 {
    string private _name;
    string private _symbol;

    address public owner;

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    mapping(uint256 => address)  _owner;

    mapping(address => uint256)  _balance;

    mapping(uint256 => address)  _tokenApproval;

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

    ///only owner can call this function
    error onlyowner();

    ///token doesn't exists
    error doesntExists();

    ///transfer to non ERC721Receiver implementer
    error non_ERC721();

    ///tranfer to zero address
    error zeroAddress();

    

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert onlyowner();
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

    function balanceof(address owner_) public view returns (uint256) {
        return _balance[owner_];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        return _owner[tokenId];
    }

    function approve(address _to, uint256 token_id) public {
        address owner_ = ownerOf(token_id);

        if (_to == owner_) {
            revert sameOwner();
        }
        if (msg.sender != owner_ || isApprovedforAll(owner, msg.sender)) {
            revert tokenOwner();
        }
        _approve(_to, token_id);
    }

    function _approve(address to, uint256 token_id) internal {
        _tokenApproval[token_id] = to;

        emit Approval(ownerOf(token_id), to, token_id);
    }

   

    


    function isApprovedforAll(address owner_, address _operator)
        public
        view
        returns (bool)
    {
        return _operatorApproval[owner_][_operator];
    }

    function getApprove(uint256 token_id) public view returns (address) {
        _requireminted(token_id);

        return _tokenApproval[token_id];
    }

    function _requireminted(uint256 token_id) internal view {
        if (!_exists(token_id)) {
            revert doesntExists();
        }
        
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
            revert tokenOwner();
        }
        _transfer(from, to, tokenid);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public {
        if (!(isApprovedOrOwner(msg.sender, tokenId))){
            revert tokenOwner();
        }
            safeTransferFrom(from, to, tokenId, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenid,
        bytes memory data
    ) public {
        _safeTransfer(from, to, tokenid,data);

    }
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
        _transfer(from, to, tokenId);
        if(!_checkOnERC721Received(from, to, tokenId, data)){
            revert non_ERC721();
        }
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
            revert zeroAddress();
        }

        _beforeTokentransfer(from, to, tokenid,1);

        _approve(to, tokenid);

        _balance[from] -= 1;
        _balance[to] += 1;
        _owner[tokenid] = to;

        emit Transfer(from, to, tokenid);

        _afterTokenTransfer(from, to, tokenid,1);
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
        if(!_checkOnERC721Received(address(0), to, tokenid, data)){
            revert non_ERC721();
        }
    }

    function _mint(address to, uint256 tokenId) internal {
        if (to == address(0)) {
            revert addressZero();
        }
        if (_exists(tokenId)) {
            revert alreadyExists();
        }
        _beforeTokentransfer(address(0), to, tokenId,1);

        _balance[to] += 1;

        _owner[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId,1);
    }

    function _beforeTokentransfer(
        address from,
        address to,
        uint256 tokenid,
          uint256 batchSize
    ) internal {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenid,
        uint256 batchSize
    ) internal {}

    function isApprovedOrOwner(address spender, uint256 tokenid)
        public
        view
        returns (bool)
    {
        address owner_ = ownerOf(tokenid);

        return (spender == owner_ ||
            isApprovedforAll(owner_, spender) ||
            getApprove(tokenid) == spender);
    }

    function setApprovalForAll(address _operator, bool _approved) public {
        _setApprovalforAll(msg.sender, _operator, _approved);
    }

    function _setApprovalforAll(
        address owner_,
        address _operator,
        bool _approved
    ) internal {
        if (owner_ == _operator) {
            revert sameOwner();
        }

        _operatorApproval[owner_][_operator] = _approved;

        emit Approvalforall(owner_, _operator, _approved);
    }

    function burn(uint256 tokenId) public {
        if (!isApprovedOrOwner(msg.sender, tokenId)) {
            revert();
        }
        _burn(tokenId);
    }

    function _burn(uint256 tokenId) internal {
        address owner_ = ownerOf(tokenId);

        _beforeTokentransfer(owner_, address(0), tokenId,1);

        _approve(address(0), tokenId);

        _balance[owner_] -= 1;

        delete _owner[tokenId];

        emit Transfer(owner_, address(0), tokenId);

        _afterTokenTransfer(owner_, address(0), tokenId,1);

        _allTokens.pop();
    }

    function totalSupply() public view  returns (uint256) {
        return _allTokens.length;
    }

    function isContract(address account) internal view returns (bool) {
       
        return account.code.length > 0;
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (isContract(to)) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                   
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }
}