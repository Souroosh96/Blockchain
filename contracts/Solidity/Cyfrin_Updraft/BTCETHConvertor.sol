//SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract BTCETHConvertor{

    function getLatestBTCPriceInETH() public view returns (uint256) {
        //Address : 0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22);
        (,int256 price,,,) = pricefeed.latestRoundData();
        return uint256(price);
    }

    function getDecimal() public view returns(uint256){
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22);
        return (pricefeed.decimals());
    }
}