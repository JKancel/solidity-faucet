// SPDX-License-Identifier: MIT
pragma solidity >=0.6.1 <0.9.0;

import "./Owned.sol";
import "./Logger.sol";

// they cannt inherit from other smart contracts 
// they can only inherit from other interfaces

// they cannot declare constructor and state variables
// all declared functions have to be external

interface IFaucet {
  function addFunds() external payable;
  function withdraw(uint withdrawAmount) external;
}