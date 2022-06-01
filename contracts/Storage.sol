// SPDX-License-Identifier: MIT
pragma solidity >=0.6.1 <0.9.0;

contract Storage {
  // storage variables
  uint8 public a = 7; // 1 byte
  uint16 public b = 10; // 2 bytes
  address public c = 0x803aE903178f21AD36955d082f4F3dDE75A64D7b; // 20 bytes
  bool d = true; // 1 byte
  uint64 public e = 15; // 8 bytes
// 32 bytes, so all values will be stored in slot 0
// 0x 0f 01 803ae903178f21ad36955d082f4f3dde75a64d7b 000a 07  -> result of for the slot 0 web3.eth.getStorageAt("0xDf126147885826Ff4BA92E6B98fc3aCdcaE82fdA", 0)

  uint256 public f = 200; // 32 bytes -> slot 1
  uint8 public g = 40; // 1 byte -> slot 2
  uint256 public h = 789; // 32 bytes -> slot 3
}
