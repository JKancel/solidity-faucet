// SPDX-License-Identifier: MIT
pragma solidity >=0.6.1 <0.9.0;

contract Owned {
  address public owner;

  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner, "Only owner can call this function");
    _;
  }
}
