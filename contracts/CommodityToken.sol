pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CommodityToken is ERC721 {
    // Mapping of token ID to current process number
    mapping (uint256 => uint256) public processes;
    
    // Event emitted when a token is moved to a new process
    event CommodityMoved(uint256 tokenId, uint256 processNumber);

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {}

    // Function to mint a new token and start it at process 1
    function mint(uint256 tokenId) public {
        require(!_exists(tokenId), "Token already exists");
        _safeMint(msg.sender, tokenId);
        processes[tokenId] = 1;
    }

    // Function to move a token to the next process
    function moveToNextProcess(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Not token owner");
        uint256 currentProcess = processes[tokenId];
        require(currentProcess < 12, "Token already completed all processes");
        currentProcess++;
        processes[tokenId] = currentProcess;
        emit CommodityMoved(tokenId, currentProcess);
    }
}
