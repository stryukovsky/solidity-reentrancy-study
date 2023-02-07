// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract Victim {

    error VictimBadInitSupply(uint256 expected, uint256 actual);
    error VictimBadDepositSupply(uint256 expected, uint256 actual);
    error VictimBadWithdrawal(address user, uint256 amount);

    uint256 public constant INITIAL_SUPPLY = 10 ether;

    bool internal _lock;

    mapping(address => uint256) public  balances;

    constructor(){

    }

    function provideInitialSupply() external payable {
        uint256 providedSupply = msg.value;
        if (providedSupply != INITIAL_SUPPLY) {
            revert VictimBadInitSupply(INITIAL_SUPPLY, providedSupply);
        }
    }

    function deposit() external payable {
        uint256 providedSupply = msg.value;
        if (providedSupply == 0) {
            revert VictimBadDepositSupply(INITIAL_SUPPLY, providedSupply);
        }
        balances[msg.sender] += providedSupply;
    }

    // add reentrancyProtected modifier to protect
    function withdraw() public {
        address sender = msg.sender;
        uint256 amount = balances[sender];
        (bool sent,) = sender.call{value : amount}("");
        if (!sent) {
            revert VictimBadWithdrawal(sender, amount);
        }
        balances[msg.sender] = 0;
    }

    modifier reentrancyProtected() {
        require(!_lock);
        _lock = true;
        _;
    }
}
