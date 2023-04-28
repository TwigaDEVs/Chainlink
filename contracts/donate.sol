// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
//  contract
contract FinancialTrackingSystem {

    //storing transaction details
    struct Transaction {
        address donor;
        address usaid;
        uint256 amount;
        string purpose;
        uint256 timestamp;
    }
    
    // an array to store all the transactions
    Transaction[] public transactions;

    //  creating new transactions
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
    
    // retrieving all transactions by donor
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
}