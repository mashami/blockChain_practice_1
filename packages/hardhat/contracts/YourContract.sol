// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

// Use OpenZeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
// import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * A smart contract that allows changing a state variable of the contract and tracking the changes.
 * It also allows the owner to withdraw the Ether in the contract.
 * @author BuidlGuidl
 */

contract YourContract {
    // State Variables
    address public immutable owner;
    address public owner2 = 0x90Cab0f966483e362C2980312B0a0eFCBdd88b19;
    string public greeting = "Building Unstoppable Apps!";
    bool public premium = false;
    uint256 public totalCounter = 0;
    string public purpose = "Building Unstoppable apps!";
    mapping(address => uint) public userGreetingCounter;

    // Events: a way to emit log statements from a smart contract that can be listened to by external parties
    event GreetingChange(
        address indexed greetingSetter,
        string newGreeting,
        bool premium,
        uint256 value
    );

    // Constructor: Called once on contract deployment
    // Check packages/hardhat/deploy/00_deploy_your_contract.ts
    mapping(address => uint256) public balance;

		event Log(address indexed sender, string message);

    constructor(address _owner) {
        owner = _owner;
        console.log("The owner address ===>", owner);
        balance[_owner] = 100;
    }

    // Modifiers: used to define a set of rules that must be met before or after a function is executed

    modifier isMoneyEnough() {
        require(msg.value >= 0.001 ether, "NOT ENOUGH");
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Not the Owner");
        _;
    }

    uint256 public price = 0.001 ether;

    modifier isPriceEnough() {
        require(msg.value >= price, "NOT ENOUGH");
        _;
    }

    // Function to set initial balance
    function setInitialBalance(address ownerBalance, uint256 amount) public {
        require(ownerBalance != address(0), "Invalid address provided");
        balance[ownerBalance] = amount;
    }

    // Function to set a new greeting
    function setGreeting(string memory _newGreeting) public payable {
        // Print data to the Hardhat chain console. Remove when deploying to a live network.
        console.log(
            "Setting new greeting '%s' from %s",
            _newGreeting,
            msg.sender
        );

        // Change state variables
        greeting = _newGreeting;
        totalCounter += 1;
        userGreetingCounter[msg.sender] += 1;

        // Set premium based on value sent with the transaction
        if (msg.value > 0) {
            premium = true;
        } else {
            premium = false;
        }

        // Emit: keyword used to trigger an event
        emit GreetingChange(msg.sender, _newGreeting, premium, msg.value);
    }

    // Function to transfer an amount to another address
    function transfer(address to, uint256 amount) public {
        require(balance[msg.sender] >= amount, "NOT ENOUGH!");
        balance[msg.sender] -= amount;
        balance[to] += amount;
				emit Log(msg.sender, "SUCCESS TRANSFER"); // This line was corrected. The `+=` operator should be used instead of `+`.
    }

    // Function to set a new purpose, modifying price slightly each time
    function setPurpose(string memory newPurpose) public isPriceEnough payable {
        price = (price * 1001) / 1000; // Increase price by a fraction (0.1%)
        purpose = newPurpose;
        console.log(msg.sender, "set purpose to", purpose);
    }

    /**
     * Function that allows the owner to withdraw all the Ether in the contract.
     * The function can only be called by the owner of the contract as defined by the isOwner modifier.
     */
    function withdraw() public isOwner {
        (bool success, ) = owner.call{ value: address(this).balance }("");
        require(success, "Failed to send Ether");
    }

    /**
     * Function that allows the contract to receive ETH.
     */
    receive() external payable {}
}
