// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract SimpleStorage {
    uint256 public favoriteNumber;
    struct Person{
        uint256 favNumber;
        string name;
    }
    Person[] public listOfNames;
    Person public Pat = Person({favNumber: 1, name: "Pat"});

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }
    function addElementToListOfNames(uint256 _favNumber, string memory _name) public {
        listOfNames.push(Person({favNumber: _favNumber, name: _name}));
    }
}