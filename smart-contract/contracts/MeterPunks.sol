// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract MeterPunks is ERC721, Ownable, ReentrancyGuard {
 using Strings for uint256;
 bytes32 public merkleRoot;
  mapping(address => bool) public whitelistClaimed;
 using Counters for Counters.Counter;
 Counters.Counter private supply;
 string public uriPrefix = "ipfs://QmQifR81xmJiEU3iTPADGfpiBdbw5hqjzmN6vMRfjxKB1j/";
 string public uriSuffix = ".json";
 string public hiddenMetadataUri;
 uint256 public cost = 25 ether;
 uint256 public maxSupply = 10000;
 uint256 public maxMintAmountPerTx = 1000;
 bool public paused = false;
 bool public whitelistMintEnabled = false;
 bool public revealed = true;
 constructor() ERC721("Meter Punks", "MTP") {
   mint(200);
 }
 modifier mintCompliance(uint256 _mintAmount) {
   require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
   require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
   _;
 }
 function totalSupply() public view returns (uint256) {
   return supply.current();
 }
 function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
   require(!paused, "The contract is paused!");
   if (msg.sender != owner()) {
     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
   }
   _mintLoop(msg.sender, _mintAmount);
 }
 function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
   _mintLoop(_receiver, _mintAmount);
 }

 modifier mintPriceCompliance(uint256 _mintAmount) {
    require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
    _;
  }

function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
    // Verify whitelist requirements
    require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
    require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
    bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
    require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');

    whitelistClaimed[_msgSender()] = true;
    _safeMint(_msgSender(), _mintAmount);
  }

 function walletOfOwner(address _owner)
   public
   view
   returns (uint256[] memory)
 {
   uint256 ownerTokenCount = balanceOf(_owner);
   uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
   uint256 currentTokenId = 1;
   uint256 ownedTokenIndex = 0;
   while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
     address currentTokenOwner = ownerOf(currentTokenId);
     if (currentTokenOwner == _owner) {
       ownedTokenIds[ownedTokenIndex] = currentTokenId;
       ownedTokenIndex++;
     }
     currentTokenId++;
   }
   return ownedTokenIds;
 }
 function tokenURI(uint256 _tokenId)
   public
   view
   virtual
   override
   returns (string memory)
 {
   require(
     _exists(_tokenId),
     "ERC721Metadata: URI query for nonexistent token"
   );
   if (revealed == false) {
     return hiddenMetadataUri;
   }
   string memory currentBaseURI = _baseURI();
   return bytes(currentBaseURI).length > 0
       ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
       : "";
 }
 function setRevealed(bool _state) public onlyOwner {
   revealed = _state;
 }
 function setCost(uint256 _cost) public onlyOwner {
   cost = _cost;
 }
 function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
   maxMintAmountPerTx = _maxMintAmountPerTx;
 }
 function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
   hiddenMetadataUri = _hiddenMetadataUri;
 }
 function setUriPrefix(string memory _uriPrefix) public onlyOwner {
   uriPrefix = _uriPrefix;
 }
 function setUriSuffix(string memory _uriSuffix) public onlyOwner {
   uriSuffix = _uriSuffix;
 }
 function setPaused(bool _state) public onlyOwner {
   paused = _state;
 }
 function withdraw() public onlyOwner {
   (bool os, ) = payable(owner()).call{value: address(this).balance}("");
   require(os);
 }
 function _mintLoop(address _receiver, uint256 _mintAmount) internal {
   for (uint256 i = 0; i < _mintAmount; i++) {
     supply.increment();
     _safeMint(_receiver, supply.current());
   }
 }
 function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
    merkleRoot = _merkleRoot;
  }
  function setWhitelistMintEnabled(bool _state) public onlyOwner {
    whitelistMintEnabled = _state;
  }
 function _baseURI() internal view virtual override returns (string memory) {
   return uriPrefix;
 }
}


