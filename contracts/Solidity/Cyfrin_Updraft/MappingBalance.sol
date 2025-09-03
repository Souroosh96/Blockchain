// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Balance{
    mapping (address => uint256) public balances; // address -> balance)

    function deposit(uint256 amount) external payable {
        balances[msg.sender] += amount;
    }
     function retrieve() external view returns (address, uint256) {
    return (msg.sender, balances[msg.sender]); //Returns a tuple
    }
}
