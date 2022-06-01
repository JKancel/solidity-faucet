// SPDX-License-Identifier: MIT
pragma solidity >=0.6.1 <0.9.0;

contract Storage {

  // keccak256(key . slot)
  mapping(uint => uint) public aa; // slot 0
  mapping(address => uint) public bb; // slot 1

  // keccak256(slot) + index of the item
  uint[] public cc; // slot 2

  // storage variables
  uint8 public a = 7; // 1 byte
  uint16 public b = 10; // 2 bytes
  address public c = 0x803aE903178f21AD36955d082f4F3dDE75A64D7b; // 20 bytes
  bool d = true; // 1 byte
  uint64 public e = 15; // 8 bytes
// 32 bytes, so all values will be stored in slot 3
// 0x 0f 01 803ae903178f21ad36955d082f4f3dde75a64d7b 000a 07  -> result of for the slot 0 web3.eth.getStorageAt("0xDf126147885826Ff4BA92E6B98fc3aCdcaE82fdA", 0)

  uint256 public f = 200; // 32 bytes -> slot 4
  uint8 public g = 40; // 1 byte -> slot 5
  uint256 public h = 789; // 32 bytes -> slot 6

  constructor() public {
    cc.push(1);
    cc.push(10);
    cc.push(100);

    aa[2] = 4;
    aa[3] = 10;
    bb[0x803aE903178f21AD36955d082f4F3dDE75A64D7b] = 100;
  }
}


// 0x00000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000
// convert in Hex with keccak256 : abbb5caa7dda850e60932de0934eb1f9d0f59695050f761dc64e443e5030a569
// so to get storage : web3.eth.getStorageAt("0xc4ea3ed5cf1c88995fe368429f617dF388C44588", "0xabbb5caa7dda850e60932de0934eb1f9d0f59695050f761dc64e443e5030a569") = 4


// web3.eth.getStorageAt("0xc4ea3ed5cf1c88995fe368429f617dF388C44588", "0x405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace") = 1 in uint array
