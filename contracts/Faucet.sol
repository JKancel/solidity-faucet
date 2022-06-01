// SPDX-License-Identifier: MIT
pragma solidity >=0.6.1 <0.9.0;

contract Faucet {
  event Log(string func, address sender, uint value, bytes data);
  // storage variables
  uint public funds = 1000; // positive values only
  int public counter = -10;
  uint[] public array;
  uint public numOfFunders;
  // address[] private funders;
  mapping(uint => address) private funders;

  // private -> can be accessible only within the smart contract
  // internal -> can be accessible within smart contract and also derived smart contract

  function add() public {}

  function withdraw() public {}

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

  function addFunds() external payable {
    // funders.push(msg.sender);
    uint index = numOfFunders++;
    funders[index] = msg.sender;
  }

  function justTesting() external pure returns(uint) {
    return 2 + 2;
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
    return funders[index];
  }
  function getAllFunders() external view returns(address[] memory) {
    address[] memory _funders = new address[](numOfFunders);
    for (uint256 i = 0; i < numOfFunders; i++) {
      _funders[i] = funders[i];
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
