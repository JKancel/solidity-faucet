// SPDX-License-Identifier: MIT
pragma solidity >=0.6.1 <0.9.0;

// It's a way to designer to say that any child of the abstract contract has to implements specified methods

abstract contract Logger {
  uint public testNum;

  constructor() internal {
    testNum = 1000;
  }

  function emitLog() public pure virtual returns(bytes32);
  function test3() public pure returns(uint) {
    return 100;
  }
}
