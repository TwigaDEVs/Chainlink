// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "./ChiToken.sol";

contract FinancialTrackingSystem {
    // storing transaction details
    struct Transaction {
        address donor;
        address usaid;
        uint256 amount;
        string purpose;
        uint256 timestamp;
    }

    // storing disburse transaction details
    struct DisburseTransaction {
        address usaid;
        address receiver_org;
        uint256 amount;
        string organization_purpose;
        uint256 timestamp;
    }

    // array to store all the transactions
    Transaction[] public transactions;

    // array to store all the disburse transactions
    DisburseTransaction[] public disbursedTransactions;

    // creating new transactions
    function createTransaction(address _donor, address _usaid, uint256 _amount, string memory _purpose) public {
        Transaction memory newTransaction = Transaction({
            donor: _donor,
            usaid: _usaid,
            amount: _amount,
            purpose: _purpose,
            timestamp: block.timestamp
        });
        transactions.push(newTransaction);
    }

    // retrieving all transactions
    function getTransactions() public view returns (Transaction[] memory) {
        return transactions;
    }

    // transactions by donor
    function getTransactionsByDonor(address _donor) public view returns (Transaction[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].donor == _donor) {
                count++;
            }
        }
        Transaction[] memory result = new Transaction[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].donor == _donor) {
                result[index] = transactions[i];
                index++;
            }
        }
        return result;
    }

    // retrieving all transactions by USAID
    function getTransactionsByUSAID(address _usaid) public view returns (Transaction[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].usaid == _usaid) {
                count++;
            }
        }
        Transaction[] memory result = new Transaction[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].usaid == _usaid) {
                result[index] = transactions[i];
                index++;
            }
        }
        return result;
    }

     function createDisburseTransaction(address _usaid, address _receiver_org, uint256 _amount, string memory _organization_purpose) public {
        // create ChiToken instance
        ChiToken chi = ChiToken(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4); // Replace with the address of the ChiToken contract on your network
        // wrap ETH to CHI tokens
        chi.wrap{value: _amount}();
        // transfer CHI tokens to the receiver organization
        chi.transfer(_receiver_org, _amount);
        // create the disburse transaction
        DisburseTransaction memory newTransaction = DisburseTransaction({
            usaid: _usaid,
            receiver_org: _receiver_org,
            amount: _amount,
            organization_purpose: _organization_purpose,
            timestamp: block.timestamp
        });
        disbursedTransactions.push(newTransaction);
    }

}
