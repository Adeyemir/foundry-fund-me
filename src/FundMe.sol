// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();
error FundMe__NotEnoughETH();
error FundMe__CallFailed();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18;
    AggregatorV3Interface public priceFeed;

    event Funded(address indexed funder, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
        emit Funded(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        uint256 totalAmount = address(this).balance;
        (bool callSuccess, ) = payable(msg.sender).call{value: totalAmount}("");
        require(callSuccess, "Call failed");
        emit Withdrawn(msg.sender, totalAmount);
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return funders[index];
    }

    function getFundersLength() external view returns (uint256) {
        return funders.length;
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
