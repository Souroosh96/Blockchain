// SPDX-License-Identifier: MIT  
pragma solidity 0.8.30; 

contract DataLocationSample{
    string public name; // Data Location is storage
    struct Person{
        string FirstName;
        string LastName;
    }
    Person[] public ListOfNames;

    function AddName(string calldata _name , string memory _name2) public{
        string memory _name3 = string.concat(_name2 , " The Great"); // Data Location is memory
        ListOfNames.push(Person(_name,_name3)); // Data Location is memory
    }
}