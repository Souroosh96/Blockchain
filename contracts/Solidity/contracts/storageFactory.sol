//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

contract StorageFactory{

    ///*
    SimpleStorage[] public simpleStorageArray;
    function createSimpleStorageContract()public{

        //Deploying new SimpleStorage contracts
        SimpleStorage simpleStorage = new SimpleStorage();

        //Storing the address of those contracts in an array
        simpleStorageArray.push(simpleStorage);
    }

    //**
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        simpleStorage.store(_simpleStorageNumber);
    }

    //***
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        SimpleStorage simpleStorage = simpleStorageArray[_simpleStorageIndex];
        return simpleStorage.retrieve();
    }
}



//* if you go with address[] public simpleStorageArray; , then you should have your sfStore function as below:

///  function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
//     SimpleStorage simpleStorage = SimpleStorage(simpleStorageArray[_simpleStorageIndex]);
//     simpleStorage.store(_simpleStorageNumber);
//  }


//**For simplicity, you can define the function body like below:
//  function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public{
//        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
//    }

//*** For simplicity, you can define the function body like below:
// function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
//        
//        return simpleStorageArray[_simpleStorageIndex].retrieve();
//    }