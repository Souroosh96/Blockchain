// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {SimpleStorage} from "./SimpleStorage.sol";
contract StorageFactory{
    SimpleStorage[] public listOfSimpleStorage;
    
    function createSimpleStorageContract() public{
        SimpleStorage simpleStorage = new SimpleStorage();
        listOfSimpleStorage.push(simpleStorage);
    }

    function sfStore(uint256 _contractIndex, uint256 _favoriteNumber) public{
        listOfSimpleStorage[_contractIndex].store(_favoriteNumber);
    }

    function sfRetrieve(uint256 _contractIndex) public view returns(uint256){
        return listOfSimpleStorage[_contractIndex].favoriteNumber();
    }
}