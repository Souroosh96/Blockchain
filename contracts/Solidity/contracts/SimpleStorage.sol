// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;//Latest : 0.8.27

//pragma solidity ^0.8.8 -> It means any version above 0.8.8 can also be used!
//pragma solidity >=0.8.8 <0.9.0 -> It means any version above 0.8.8 and below 0.9.0 can be used

contract SimpleStorage{
    // bool, int,uint,address,bytes
    // bool: true , false
    // uint: uint8,...,uint256(default uint)
    // int: int8,...,int256
    // string: " "
    // address 0x..
    // bytes: bytes32(Max),bytes(Any size)

    //This gets initialized to zero!
    uint256  favoriteNumber;
    
    //An object of struct type People
    People person = People({favoriteNumber:2, name: 'Angelo'});
    
    //Defining the struct People
    struct People{
        uint256 favoriteNumber;
        string name;
    }

    //An array of objects type uint256
    //uint256[] public favoriteNumbersList;

    //An array of objects type People
    //People[3] public people;      //Static Array
    People[] public people;         //Dynamic Array

    //Mapping data struture to have the Key => Value structure, in this case name => favoriteNumber
    mapping (string => uint256) public nameToFavoriteNumber;


    function store(uint256 _favoriteNumber)public virtual{
        favoriteNumber = _favoriteNumber;
    }

    //view,pure
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    //calldata,memory,storage
    function addPerson(string memory _name, uint256 _favoriteNumber) public{
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}
