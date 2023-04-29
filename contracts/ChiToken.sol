// SPDX-License-Identifier: MIT

// Declare solidity compiler version
pragma solidity ^0.8.10;

// Import ERC20 from OpenZeppelin library
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Declare contract name and inherit from ERC20
contract ChiToken is ERC20 {
    constructor() ERC20("ChiToken", "CHI") {
        // Mint 1 million CHI tokens and send to the contract deployer
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
    
    // Wrap ETH to CHI tokens
    function wrap() public payable {
        // Mint CHI tokens to the caller equivalent to the amount of ETH received
        _mint(msg.sender, msg.value);
    }
    
    // Unwrap CHI tokens to ETH
    function unwrap(uint256 amount) public {
        // Burn CHI tokens from the caller equivalent to the amount specified
        _burn(msg.sender, amount);
         // Transfer ETH to the caller equivalent to the amount of CHI tokens burned
        payable(msg.sender).transfer(amount);
    }
}
