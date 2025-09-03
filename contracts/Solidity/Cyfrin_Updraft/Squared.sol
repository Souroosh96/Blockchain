// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {SimpleStorage} from "./SimpleStorage.sol";

contract Squared is SimpleStorage{

    function store(uint256 _favoriteNumber) public override {
        favoriteNumber = _favoriteNumber * _favoriteNumber;
    }
}