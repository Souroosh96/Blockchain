// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract FunctionTest{
    uint256 public testVar = 3;

    function VisibleWithinCurrentContract() private view returns(uint256){
        uint256 double = testVar * 2;
        return double;
    } 

     // helper function to test private
    function testPrivate() public view returns(uint256) {
        return VisibleWithinCurrentContract();
    }

    function NotVisibleWithinCurrentContract() external pure returns(uint256){
        return 45;
    } 

    function VisibleWithinChildContract() internal view returns(uint256){
        uint256 Triple = testVar * 3;
        return Triple;
    } 

    // helper function to test internal
    function testInternal() public view returns(uint256) {
        return VisibleWithinChildContract();
    }
}

contract ChildContract is FunctionTest{
    function ChildContractFunction() public view returns(uint256) {
        uint256 test = VisibleWithinChildContract(); // This is a private function and should not be visible within the child contract.
        return test;
    }
}