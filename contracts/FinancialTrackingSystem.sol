// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10.0;
// contract


contract FinancialTrackingSystem {
    // storing transaction details

    // constructor() public payable{

    // }
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

        //  array to store all the transactions
    DisburseTransaction[] public disbursedTransactions;

    //  creating new transactions
    function createTransaction(address _donor, address _usaid, uint256 _amount, string memory _purpose) public {
        require(_donor != _usaid, "Donor can not be same as USAID");
        Transaction memory newTransaction = Transaction({
            donor: _donor,
            usaid: _usaid,
            amount: _amount,
            purpose: _purpose,
            timestamp: block.timestamp
        });
        transactions.push(newTransaction);
    }
    
    //  retrieving all transactions
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



    // creating new disburse transactions
    function createDisburseTransaction(address _usaid, address _receiver_org, uint256 _amount, string memory _organization_purpose) public {
        DisburseTransaction memory newTransaction = DisburseTransaction({
            usaid: _usaid,
            receiver_org: _receiver_org,
            amount: _amount,
            organization_purpose: _organization_purpose,
            timestamp: block.timestamp
        });
        disbursedTransactions.push(newTransaction);
    }
    
    //  retrieving all disburse transactions
    function getDisburseTransactions() public view returns (DisburseTransaction[] memory) {
        return disbursedTransactions;
    }
    
    // transactions by disburser
    function getTransactionsByDisburser(address _usaid) public view returns (DisburseTransaction[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < disbursedTransactions.length; i++) {
            if (disbursedTransactions[i].usaid == _usaid) {
                count++;
            }
        }
        DisburseTransaction[] memory result = new DisburseTransaction[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < disbursedTransactions.length; i++) {
            if (disbursedTransactions[i].usaid == _usaid) {
                result[index] = disbursedTransactions[i];
                index++;
            }
        }
        return result;
    }
    
    // retrieving all transactions by orgs
    function getTransactionsByReceiver_orgORG(address _receiver_org) public view returns (DisburseTransaction[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < disbursedTransactions.length; i++) {
            if (disbursedTransactions[i].receiver_org == _receiver_org) {
                count++;
            }
        }
        DisburseTransaction[] memory result = new DisburseTransaction[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < disbursedTransactions.length; i++) {
            if (disbursedTransactions[i].receiver_org == _receiver_org) {
                result[index] = disbursedTransactions[i];
                index++;
            }
        }
        return result;
    }
}
