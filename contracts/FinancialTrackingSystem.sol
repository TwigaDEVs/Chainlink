// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10.0;
// contract


contract FinancialTrackingSystem {
    // storing transaction details

    constructor() payable{}

    struct Transaction {
        address donor;
        uint256 amount;
        string purpose;
        uint256 timestamp;
    }

        //the event emitted when a transaction is successfully created
    event TransactionAddedSuccess (
        address donor,
        uint256 amount,
        string purpose,
        uint256 timestamp
    );

            // storing disburse transaction details
    struct DisburseTransaction {
        address receiver_org;
        uint256 amount;
        string organization_purpose;
        uint256 timestamp;
    }
    

    event DisbursementAddedSuccess (
        address receiver_org,
        uint256 amount,
        string organization_purpose,
        uint256 timestamp
    );

    uint256 contractFee = 0.01 ether;
    // array to store all the transactions
    Transaction[] public transactions;

        //  array to store all the transactions
    DisburseTransaction[] public disbursedTransactions;

    //  creating new transactions
    function createTransaction(string memory _purpose) external  payable  {
        
        require(msg.value > 0, "Donation amount must be greater than 0");
        
        Transaction memory newTransaction = Transaction({
            donor: msg.sender,
            amount: msg.value,
            purpose: _purpose,
            timestamp: block.timestamp
        });
        transactions.push(newTransaction);

        emit TransactionAddedSuccess(
            msg.sender,
            msg.value,
            _purpose,
            block.timestamp
            
        );
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
    
    // // retrieving all transactions by USAID
    // function getTransactionsByUSAID(address _usaid) public view returns (Transaction[] memory) {
    //     uint256 count = 0;
    //     for (uint256 i = 0; i < transactions.length; i++) {
    //         if (transactions[i].usaid == _usaid) {
    //             count++;
    //         }
    //     }
    //     Transaction[] memory result = new Transaction[](count);
    //     uint256 index = 0;
    //     for (uint256 i = 0; i < transactions.length; i++) {
    //         if (transactions[i].usaid == _usaid) {
    //             result[index] = transactions[i];
    //             index++;
    //         }
    //     }
    //     return result;
    // }



    // creating new disburse transactions
    function createDisburseTransaction(address payable  _receiver_org, string memory _organization_purpose) external  payable  {
        require(msg.value  > 0, "Donation amount must be greater than 0");

        uint256 usaidAmount = msg.value - contractFee;
        
        DisburseTransaction memory newTransaction = DisburseTransaction({
            receiver_org: _receiver_org,
            amount: msg.value,
            organization_purpose: _organization_purpose,
            timestamp: block.timestamp
        });
        disbursedTransactions.push(newTransaction);

        payable(_receiver_org).transfer(usaidAmount);

        emit DisbursementAddedSuccess(
            _receiver_org,
            msg.value,
            _organization_purpose,
            block.timestamp
            
        );
    }
    
    //  retrieving all disburse transactions
    function getDisburseTransactions() public view returns (DisburseTransaction[] memory) {
        return disbursedTransactions;
    }
    
    // // transactions by disburser
    // function getTransactionsByDisburser(address _usaid) public view returns (DisburseTransaction[] memory) {
    //     uint256 count = 0;
    //     for (uint256 i = 0; i < disbursedTransactions.length; i++) {
    //         if (disbursedTransactions[i].usaid == _usaid) {
    //             count++;
    //         }
    //     }
    //     DisburseTransaction[] memory result = new DisburseTransaction[](count);
    //     uint256 index = 0;
    //     for (uint256 i = 0; i < disbursedTransactions.length; i++) {
    //         if (disbursedTransactions[i].usaid == _usaid) {
    //             result[index] = disbursedTransactions[i];
    //             index++;
    //         }
    //     }
    //     return result;
    // }
    
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