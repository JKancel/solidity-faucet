// SPDX-License-Identifier: MIT
pragma solidity >=0.6.1 <0.9.0;

contract Test {

  function test(uint testNum) external pure returns (uint data) {

    assembly {
    //   let _num := 4
    //   let _fmp := mload(0x40)
    //   mstore(0x40, 0x90)
        mstore(0x40, 0xd2)
    }

    uint8[3] memory items = [1,2,3];

    assembly {
        data := mload(add(0x90, 0x20))
    }
  }

  function test2() external pure returns (bytes32 data) {

    assembly {
        let fmp := mload(0x40)
        //hello
        mstore(add(fmp, 0x00), 0x68656C6C6F)
        data := mload(add(fmp, 0x00))
    }
  }
}

// 0x40
// 0x0000000000000000000000000000000000000000000000000000000000000080


// 0x29e99f070000000000000000000000000000000000000000000000000000000000000003