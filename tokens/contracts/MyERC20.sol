pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";

contract MyERC20 is ERC20, ERC20Detailed {
    constructor(uint256 initialSupply) ERC20Detailed("InsuranceExchangeToken", "IET", 18) public {
        _mint(msg.sender, initialSupply);
    }
}