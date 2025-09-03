//SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

contract Cows {
    constructor(){

    }
}

contract Birds {
    constructor(){
        
    }
}

contract AnimalFactory {

    Cows[] public listOfCows;
    Birds[] public listOfBirds;
    function createAnimals() public {
        Cows cow = new Cows();
        Birds bird = new Birds();
        listOfCows.push(cow);
        listOfBirds.push(bird);
    }
}