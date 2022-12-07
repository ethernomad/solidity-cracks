// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.8;

import "ds-test/test.sol";

contract StoreValue {

    mapping (address => uint) public values;

    error IsContract(address notContract);

    function isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    function storeValue(uint value) public {
        if (isContract(msg.sender)) revert IsContract(msg.sender);
        values[msg.sender] = value;
    }
}

contract Crack {

    constructor(StoreValue storeValue, uint value) {
        storeValue.storeValue(value);
    }
}

contract IsContractTest is DSTest {
    StoreValue storeValue;

    function setUp() public {
        storeValue = new StoreValue();
    }

    function testFailCheckValue() public {
        storeValue.storeValue(5);
    }

    function testCrack() public {
        Crack crack = new Crack(storeValue, 5);
        assertEq(storeValue.values(address(crack)), 5);
    }

}
