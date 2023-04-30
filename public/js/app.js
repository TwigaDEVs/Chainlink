const App = {
    web3Provider: null,
    contracts: {},
  
    initWeb3: async function() {
      if (window.ethereum) {
        App.web3Provider = window.ethereum;
        try {
          await window.ethereum.enable();
        } catch (error) {
          console.error("User denied account access");
        }
      } else if (window.web3) {
        App.web3Provider = window.web3.currentProvider;
      } else {
        App.web3Provider = new Web3.providers.HttpProvider("http://localhost:7545");
      }
      web3 = new Web3(App.web3Provider);
      return App.initContract();
    },
  
    initContract: function() {
      $.getJSON("Donation.json", function(data) {
        const DonationArtifact = data;
        App.contracts.Donation = TruffleContract(DonationArtifact);
        App.contracts.Donation.setProvider(App.web3Provider);
        App.contracts.Donation.deployed().then(function(instance) {
          console.log("Donation contract deployed at address:", instance.address);
        });
      });
      return App.bindEvents();
    },
  
    bindEvents: function() {
      $(document).on("click", "#create-transaction-button", App.createDonorTransaction);
      $(document).on("click", "#view-transactions-button", App.viewTransactions);
    },
  
    createDonorTransaction: function(event) {
      event.preventDefault();
      const senderAddress = $("#senderAddress").val();
      const receiverAddress = $("#receiverAddress").val();
      const amount = $("#amount").val();
      const purpose = $("#purpose").val();
      if (senderAddress == "" || receiverAddress == "" || amount == "" || purpose == "") {
        alert("Please fill in all the details");
        return;
      }
      web3.eth.getAccounts(function(error, accounts) {
        if (error) {
          console.log(error);
        }
        const account = accounts[0];
        App.contracts.Donation.deployed().then(function(instance) {
          return instance.createTransaction(senderAddress, receiverAddress, Number(amount), purpose, { from: account, gas: 1000000 });
        }).then(function(result) {
          console.log(result);
        }).catch(function(error) {
          console.log(error);
        });
      });
    },
  
    viewTransactions: function(event) {
      event.preventDefault();
      const transactions = [];
      App.contracts.Donation.deployed().then(function(instance) {
        return instance.getTransactions.call();
      }).then(function(data) {
        for ({ donor, timestamp, usaid, purpose, amount } of data) {
          const timestamp2 = timestamp;
          const date = new Date(timestamp2 * 1000);
          const formattedDate = date.toLocaleString();
          const formatter = new Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "KES",
          });
          const formattedAmount = formatter.format(amount);
          transactions.push({
            donor,
            formattedDate,
            usaid,
            purpose,
            formattedAmount,
          });
        }
        console.log(JSON.stringify(transactions));
        const table = document.createElement("table");
        table.classList.add("w3-table");
        table.classList.add("w3-bordered");
        table.classList.add("w3-auto");
  
        // Create table headers
        const headers = ["Donor", "Timestamp", "USAID", "Purpose", "Amount"];
        const headerRow = document.createElement("tr");
        headers.forEach((headerText) => {
          const header = document.createElement("th");
         
          const table = document.createElement("table");
          table.classList.add("w3-table");
          table.classList.add("w3-bordered");
          table.classList.add("w3-auto");
          
          // Create table headers
          const headers = ["Donor", "Timestamp", "USAID", "Purpose", "Amount"];
          const headerRow = document.createElement("tr");
          headers.forEach((headerText) => {
            const header = document.createElement("th");
            const textNode = document.createTextNode(headerText);
            header.appendChild(textNode);
            headerRow.appendChild(header);
          });
          table.appendChild(headerRow);
          
          // Create table rows
          transactions.forEach(({ donor, timestamp, usaid, purpose, amount }) => {
            const row = document.createElement("tr");
          
            const donorCell = document.createElement("td");
            const donorTextNode = document.createTextNode(donor);
            donorCell.appendChild(donorTextNode);
            row.appendChild(donorCell);
          
            const timestampCell = document.createElement("td");
            const timestampTextNode = document.createTextNode(timestamp);
            timestampCell.appendChild(timestampTextNode);
            row.appendChild(timestampCell);
          
            const usaidCell = document.createElement("td");
            const usaidTextNode = document.createTextNode(usaid);
            usaidCell.appendChild(usaidTextNode);
            row.appendChild(usaidCell);
          
            const purposeCell = document.createElement("td");
            const purposeTextNode = document.createTextNode(purpose);
            purposeCell.appendChild(purposeTextNode);
            row.appendChild(purposeCell);
          
            const amountCell = document.createElement("td");
            const formatter = new Intl.NumberFormat("en-US", {
              style: "currency",
              currency: "KES",
            });
            const formattedAmount = formatter.format(amount);
            const amountTextNode = document.createTextNode(formattedAmount);
            amountCell.appendChild(amountTextNode);
            row.appendChild(amountCell);
          
            table.appendChild(row);
          });
          
          // Add the table to the HTML document
          document.body.appendChild(table);
        });
    
    }
};
};
