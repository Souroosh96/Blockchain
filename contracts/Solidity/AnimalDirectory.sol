pragma solidity 0.8.30;

contract AnimalDirectory{
    struct Animal {
        string name;
        uint256 NOfFeet;
    }
    Animal[] public ListOfAnimals;
   
    constructor(){
    ListOfAnimals.push(Animal("Elephant", 4));
    ListOfAnimals.push(Animal("Chicken", 2));
    ListOfAnimals.push(Animal("Snake", 0));
    }

    function addAnimal(string memory _name, uint256 _NOfFeet) public {
        ListOfAnimals.push(Animal(_name, _NOfFeet));
    }
}