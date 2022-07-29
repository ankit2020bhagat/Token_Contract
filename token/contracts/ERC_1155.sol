// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC_1155 is ERC1155, Ownable {
    uint256[] supplies=[50,100,150];
    uint256[] public  minted=[0,0,0];
   // uint256[] rates = [1 ether,2 ether,3 ether];
    mapping(uint256=>string) public  _uris;
      constructor() ERC1155("https://bafybeihd4sxshvvk5b7wjawekvl64grqvxmocqh2l54y2qzppvdhf3enzq.ipfs.nftstorage.link/{id}.json") {}
    // function setURI(string memory newuri) external {
    //     _setURI(newuri);
    // }
    function mint(uint id, uint amount)  external {
         require(id<supplies.length,"Token doesn't exist");
         require(id>0,"Token doesn't exit");
           uint256 index=id-1;
        // require(msg.value>=amount*rates[index],"Not enough ether");
       
         require(minted[index]+amount<=supplies[index],"Not enough supply");
        _mint(msg.sender,id,amount,"");
        minted[index]+=amount;
    }
    function uri1(uint256 tokenId,string memory _uri)  public  onlyOwner{
     
           
      //   string(abi.encodePacked("https://bafybeihd4sxshvvk5b7wjawekvl64grqvxmocqh2l54y2qzppvdhf3enzq.ipfs.nftstorage.link/",
      //   Strings.toString(tokenId),
      //   ".json"
      //  ))
          require(minted[tokenId-1]>0,"token id is not minted");
         string memory s1=string(abi.encodePacked(_uri,Strings.toString(tokenId),".json"));
         _uris[tokenId]=s1;
    
    }
    function getUri(uint256 tokenId)  public view returns(string memory){
      return (_uris[tokenId]);
    }
    // function setTokenUri(uint256 tokenId,string memory uri) public  onlyOwner{
    //   _uris[tokenId]=uri;
    // }
    
  
    function contractAddress() external  view returns(uint){
          return address(this).balance;
    }
    //  function withDraw() public onlyOwner{
    //      require(address(this).balance>0,"Balance is 0");
    //      payable(owner()).transfer(address(this).balance);
    //  }
        
    
}
