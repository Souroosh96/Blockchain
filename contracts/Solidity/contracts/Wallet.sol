//Get funds from users
//Withdraw funds
//Set a minimum funding value in USD

//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minimumUsd = 50 * 1e18;

    //Address of funders
    address[] public funders; 

    //Amount each funder sent
    mapping(address => uint256) public addressToAmountFunded;

    //Owner Address
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    function fund()public payable{

        //Min fund amount in USD to receive
        require( msg.value.getConversionRate() >= minimumUsd, "Did not send enough funds");
        //Cannot use getConversionRate() directly here because it is not defined here.


        //if require condition is not satisfied:
        //1.The error message will be published
        //2.Any prior action would be reverted
        //3.Remaining gas until reaching require statement would be sent back to the user.
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

    //Withdrawing the total funds received
    //Need to reset the addressToAmountFunded values to zero
    function withdraw() public onlyOwner{
        
        //An option to make the function only accessible for the owner
        //require(msg.sender == owner,"Sender is not owner");

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        
        //reset the array
        funders = new address[](0);
        
        //Withdraw the funds
        //1.transfer
        //payable(msg.sender).transfer(address(this).balance);
        //2.send
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess,"Send Failed");
        
        //3.call
        (bool callSuccess,) = payable (msg.sender).call{value:address(this).balance}("");
        require(callSuccess,"Call failed");
    }

    modifier onlyOwner{
        require(msg.sender == owner,"Sender is not owner");
        _;
    }
}