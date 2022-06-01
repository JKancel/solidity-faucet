// SPDX-License-Identifier: MIT
pragma solidity >=0.6.1 <0.9.0;

import "./Owned.sol";
import "./Logger.sol";
import "./IFaucet.sol";

contract Faucet is Owned, Logger, IFaucet {
  event Log(string func, address sender, uint value, bytes data);
  // storage variables
  uint public funds = 1000; // positive values only
  int public counter = -10;
  uint[] public array;
  uint public numOfFunders;
  // address[] private funders;
  mapping(address => bool) private funders; // lut = look up table
  mapping(uint => address) private lutFunders; // lut = look up table

  modifier limitWithdraw(uint withdrawAmount) {
    require(withdrawAmount <= 1000000000000000000, "Cannot withdraw more than 1 eth");
    _;
  }

  // private -> can be accessible only within the smart contract
  // internal -> can be accessible within smart contract and also derived smart contract

  function pushToArr(uint val) public returns(uint[] memory res) {
    array.push(val);
    res = array;
  }

  function getFundsVal(uint val) view public returns(uint res) {
    res = funds + val;
  }

  // @notice Will receive any eth sent to the contract
  fallback() external payable {
    emit Log("fallback", msg.sender, msg.value, msg.data);
  }

  receive() external payable {
    emit Log("receive", msg.sender, msg.value, "");
  }

  function emitLog() public override pure returns(bytes32) {
    return "Hello world";
  }

  function transferOwnership(address newOwner) external onlyOwner {
    owner = newOwner;
  }

  function addFunds() override external payable {
    // funders.push(msg.sender);
    // uint index = numOfFunders++;
    // lutFunders[index] = msg.sender;
    address funder = msg.sender;
    if(!funders[funder]) {
      // numOfFunders++;
      funders[funder] = true;
      lutFunders[numOfFunders++] = funder;
    }
  }

  function withdraw(uint withdrawAmount) override external limitWithdraw(withdrawAmount) {
    payable(msg.sender).transfer(withdrawAmount);
  }

  function justTesting() external pure returns(uint) {
    return 2 + 2;
  }

  function test1() external onlyOwner {
    // some managing stuff that only admin should have access to
  }

  function test2() external onlyOwner {
    // some managing stuff that only admin should have access to
  }

 // retrieve all funders (cannot get directly all funders from the property)
  // function getAllFunders() public view returns(address[] memory) {
  //   return funders;
  // }

  // function getFunderAtIndex(uint8 index) external view returns(address) {
  //   address[] memory _funders = gellAllFunders();
  //   return _funders[index];
  // }

// with mapping
  function getFunderAtIndex(uint8 index) external view returns(address) {
    return lutFunders[index];
  }
  function getAllFunders() external view returns(address[] memory) {
    address[] memory _funders = new address[](numOfFunders);
    for (uint256 i = 0; i < _funders.length; i++) {
      _funders[i] = lutFunders[i];
    }
    return _funders;
  }
}

// pure, view - read-only call, no gas fees
// view - it indicates that the function will not alter the storage state in any way
// pure - even more strict, indicating that it won't even read the storage state

// Transactions (can generate state changes) and require gas fees
// read-only call, no gas fees

// to talk to the node on the network you can make JSON-RPC http calls
