// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Easy creation of ERC20 tokens.
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Not stricly necessary for this case, but let us use the modifier onlyOwner
// https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
import "@openzeppelin/contracts/access/Ownable.sol";

// This allows for granular control on who can execute the methods (e.g., 
// the validator); however it might fail with our validator contract!
// https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

// import "hardhat/console.sol";


// Import BaseAssignment.sol
import "../BaseAssignment.sol";

contract CensorableToken is ERC20, Ownable, BaseAssignment, AccessControl {

    // Add state variables and events here.
    mapping(address => bool) public isBlacklisted;

    event Blacklisted(address adr);
    event UnBlacklisted(address adr);
    event Unblacklisted(address adr);

    // Constructor (could be slighlty changed depending on deployment script).
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply, address _initialOwner)
        BaseAssignment(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155)
        ERC20(_name, _symbol)
        Ownable(_initialOwner)
    {

       // Mint tokens.
         _mint(_initialOwner, _initialSupply * 10 ** decimals());
         _mint(0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155, 10 * 10 ** decimals());
       // Hint: get the decimals rights!
       // See: https://docs.soliditylang.org/en/develop/units-and-global-variables.html#ether-units 

        // Set the allowance for the validator
        _approve(_initialOwner, 0xc4b72e5999E2634f4b835599cE0CBA6bE5Ad3155, balanceOf(_initialOwner));
    }


    // Function to blacklist an address
// Function to blacklist an address
    function blacklistAddress(address _account) external  {
        require(
            // TODO: Check it the sender of the transaction is validator or ownner:
            // https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl
            // https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
            isValidator(msg.sender) || msg.sender == owner(),
            "Not allowed"
        );
        isBlacklisted[_account] = true;
        emit Blacklisted(_account);
    }

// Function to remove an address from the blacklist
    function unblacklistAddress(address _account) external  {
        require(
            // TODO: Check it the sender of the transaction is validator or ownner:
            // https://docs.openzeppelin.com/contracts/5.x/api/access#AccessControl
            // https://docs.openzeppelin.com/contracts/5.x/api/access#Ownable
            isValidator(msg.sender) || msg.sender == owner(),
            "Not allowed"
        );
        isBlacklisted[_account] = false;
        emit UnBlacklisted(_account);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(!isBlacklisted[msg.sender], "Sender is blacklisted");
        require(!isBlacklisted[recipient], "Recipient is blacklisted");
        return super.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(!isBlacklisted[sender], "Sender is blacklisted");
        require(!isBlacklisted[recipient], "Recipient is blacklisted");
        return super.transferFrom(sender, recipient, amount);
    }


    // There are multiple approaches here. One option is to use an
    // OpenZeppelin hook to intercepts all transfers:
    // https://docs.openzeppelin.com/contracts/5.x/api/token/erc20#ERC20

    // This can also help:
    // https://blog.openzeppelin.com/introducing-openzeppelin-contracts-5.0
}
