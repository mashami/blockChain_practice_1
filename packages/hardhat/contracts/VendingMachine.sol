//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract VendingMachine {

    
    address public owner;
    mapping (address => uint) public cupcakeBalances;

 
    constructor(address _owner) {
        owner = _owner;
        cupcakeBalances[address(this)] = 100;
    }

    modifier isOwner {
      require(msg.sender == owner, "Only the owner can refill.");
      _;
    }

    
   
    function refill(uint amount) public isOwner {
        cupcakeBalances[address(this)] += amount;
    }

    function purchase(uint amount) public payable {
        require(msg.value >= amount * 1 ether, "You must pay at least 1 ETH per cupcake");
        require(cupcakeBalances[address(this)] >= amount, "Not enough cupcakes in stock to complete this purchase");
        cupcakeBalances[address(this)] -= amount;
        cupcakeBalances[msg.sender] += amount;
    }
}
