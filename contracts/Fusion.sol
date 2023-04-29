// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.10.0;
// contract


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

        //  array to store all the transactions
    DisburseTransaction[] public disbursedTransactions;

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

     event DisbursementCreated(
        address usaid,
        address receiver_org,
        string organization_purpose,
        uint256 amount,
        uint256 timestamp
    );

     // creating new disburse transactions
    function createDisburseTransaction(address _usaid, address _receiver_org, uint256 _amount, string memory _organization_purpose) public {
        // create ChiToken instance
        ChiToken chi = ChiToken(0x0000000000000000000000000000000000000000); // Replace with the address of the ChiToken contract on your network
        // wrap ETH to CHI tokens
        chi.wrap{value: _amount}();
        // transfer CHI tokens to the receiver organization
        chi.transfer(_receiver_org, _amount);
        DisburseTransaction memory newTransaction = DisburseTransaction({
            usaid: _usaid,
            receiver_org: _receiver_org,
            amount: _amount,
            organization_purpose: _organization_purpose,
            timestamp: block.timestamp
        });
        disbursedTransactions.push

        emit DisbursementCreated(_usaid, _receiver_org, _amount, _organization_purpose, block.timestamp);
    }

    function getDisbursedTransactions() public view returns (DisburseTransaction[] memory) {
        return disbursedTransactions;
    }

    function getDisbursedTransactionsCount() public view returns (uint256) {
        return disbursedTransactions.length;
    }
    contract ChiToken {
        function wrap() public payable {}
        function transfer(address _recipient, uint256 _amount) public {}
    }

    // Fusion Protocol
    contract Fusion {
        // define a struct to represent a fusion transaction
        struct FusionTransaction {
            address sender;
            address receiver;
            uint256 amount;
            uint256 timestamp;
        }
    }

    // define an array to store all the fusion transactions
    FusionTransaction[] fusionTransactions;

    // define an event to emit when a new fusion transaction is created
    event FusionCreated(address indexed sender, address indexed receiver, uint256 amount, uint256 timestamp);

    // define a function to create a new fusion transaction
    function createFusionTransaction(address _sender, address _receiver, uint256 _amount) public {
        // create ChiToken instance
        ChiToken chi = ChiToken(0x0000000000000000000000000000000000000000); // Replace with the address of the ChiToken contract on your network
        // transfer CHI tokens from sender to receiver
        chi.transferFrom(_sender, _receiver, _amount);
        FusionTransaction memory newTransaction = FusionTransaction({
            sender: _sender,
            receiver: _receiver,
            amount: _amount,
            timestamp: block.timestamp
        });
        fusionTransactions.push(newTransaction);

        emit FusionCreated(_sender, _receiver, _amount, block.timestamp);
    }

    // define a function to get all the fusion transactions
    function getFusionTransactions() public view returns (FusionTransaction[] memory) {
        return fusionTransactions;
    }

    // define a function to get the count of fusion transactions
    function getFusionTransactionsCount() public view returns (uint256) {
        return fusionTransactions.length;
    }


}
