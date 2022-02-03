// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./libraries/Base64.sol";

contract CoinsGoneWild is ERC721Enumerable, ERC721URIStorage, Ownable {
  uint256 public constant WLPPR_PRICE = 0.008 ether;
  uint256 public constant MAX_PER_ADDRESS = 20;
  uint256 public immutable MAX_ARTPCS;
  bool public isSaleActive = false;
  string public baseSvg =
    "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  string[] public firstWord = [
    "Spicy",
    "Tangy",
    "Sweet",
    "Bitter",
    "Sour",
    "CoughSyrup"
  ];
  string[] public secondWord = [
    "Pleasant",
    "Angry",
    "Romantic",
    "Sad",
    "Happy",
    "Annoying"
  ];
  string[] public thirdWord = [
    "Ether",
    "Bitcoin",
    "Litecoin",
    "Cardano",
    "Solana",
    "Tezos"
  ];

  constructor(uint256 maxCoinsSupply) ERC721("Coins Gone Wild", "CGWLD") {
    console.log("Art Pieces ARTPCS launched at ");
    console.log(address(this));
    MAX_ARTPCS = maxCoinsSupply;
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function randomWord(uint256 tokenId) internal view returns (bytes memory) {
    uint256 rand1 = random(
      string(abi.encodePacked("FIRST", Strings.toString(tokenId)))
    );
    rand1 = rand1 % firstWord.length;

    uint256 rand2 = random(
      string(abi.encodePacked("SECOND", Strings.toString(tokenId)))
    );
    rand2 = rand2 % secondWord.length;

    uint256 rand3 = random(
      string(abi.encodePacked("THIRD", Strings.toString(tokenId)))
    );
    rand3 = rand3 % thirdWord.length;
    return
      abi.encodePacked(firstWord[rand1], secondWord[rand2], thirdWord[rand3]);
  }

  function mintWildCoin() external payable {
    require(msg.value >= WLPPR_PRICE, "Each Wild Coin costs 0.008 Ether");
    require(totalSupply() < MAX_ARTPCS, "All Wild Coins are Minted");
    uint256 nextArtpiece = totalSupply() + 1000;
    string memory randomWordResult = string(randomWord(nextArtpiece));
    bytes memory finalSvg = abi.encodePacked(
      baseSvg,
      randomWordResult,
      "</text></svg>"
    );
    console.log("Minted ", randomWordResult);
    _safeMint(msg.sender, nextArtpiece);
    string memory imageURI = Base64.encode(finalSvg);
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',
            randomWordResult,
            '", "description": "A collection of coins gone rogue in the bear market.", "image": "data:image/svg+xml;base64,',
            imageURI,
            '"}'
          )
        )
      )
    );
    _setTokenURI(
      nextArtpiece,
      string(abi.encodePacked("data:application/json;base64,", json))
    );
  }

  function withdrwaAll() external onlyOwner {
    address payable target = payable(owner());
    bool success = target.send(address(this).balance);
    require(success, "Transfer Failed");
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId
  ) internal override(ERC721, ERC721Enumerable) {
    ERC721Enumerable._beforeTokenTransfer(from, to, tokenId);
  }

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
    ERC721URIStorage._burn(tokenId);
  }

  function supportsInterface(bytes4 interfaceId)
    public
    view
    override(ERC721, ERC721Enumerable)
    returns (bool)
  {
    return ERC721.supportsInterface(interfaceId);
  }

  function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
  {
    return ERC721URIStorage.tokenURI(tokenId);
  }

  function maxSupply() external view returns (uint256) {
    return MAX_ARTPCS;
  }
}
