const web3 = new Web3(window.ethereum);
console.log(abi);

var contract = new web3.eth.Contract(
  abi,
  "0xADCC001204CF677b94E3662af074ef166607B6b4" // Felix's contract
  // "0x631a834893100793B0b4b70303BcABe10493336a" // Nakul's contract
);

const connectWallet = async () => {
  const accounts = await ethereum.request({ method: "eth_requestAccounts" });
  const account = accounts[0];
  console.log(account);
};

async function createDonorTransaction() {
  var amount = document.getElementById("amount").value;
  var purpose = document.getElementById("purpose").value;

  if (amount == "" || purpose == "") {
    alert("please fill inall the details");
    return;
  }

  const accounts = await ethereum.request({ method: "eth_requestAccounts" });
  const account = accounts[0];

  await contract.methods
    .createTransaction(purpose)
    .send({
      from: account,
      gasLimit: "1000000",
      value: web3.utils.toWei(amount, "ether"),
    })
    .then(function (data) {
      console.log(data);
    });
}

async function getEvents(object) {
  let myArray = [];
  const eventName = object;

  // Set up a variable for the filter options
  const filterOptions = {
    fromBlock: 0, // The block number to start looking for events (0 = the genesis block)
    toBlock: "latest", // The block number to stop looking for events (latest = the most recent block)
    filter: {
      transactionHash:
        "0xa409551a7c4e9560825ab64471e3c79765a5cc427689f7163aca0cfc35332e32",
    }, // An object containing any filter criteria you want to apply to the events (optional)
  };

  // Call the getPastEvents function with the event name and filter options
  await contract.getPastEvents(eventName, filterOptions, (error, events) => {
    if (error) {
      console.error(error);

      return;
    }

    // Do something with the events
    // console.log(events);
    myArray.push(...events);
  });
  return myArray;
}

function viewTransactions() {
  const transactions = [];
  // const container = document.getElementById('container');

  contract.methods
    .getTransactions()
    .call()
    .then((data) => {
      for ({ donor, timestamp, purpose, amount } of data) {
        const timestamp2 = timestamp;
        const date = new Date(timestamp2 * 1000);
        const formattedDate = date.toLocaleString();
        const formatter = new Intl.NumberFormat("en-US", {
          style: "currency",
          currency: "KES",
        });
        const formattedAmount = web3.utils.fromWei(amount, "ether");
        transactions.push({
          donor,
          formattedDate,
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
      const headers = ["Donor", "Timestamp", "Purpose", "Amount"];
      const headerRow = document.createElement("tr");
      headers.forEach((headerText) => {
        const header = document.createElement("th");
        const textNode = document.createTextNode(headerText);
        header.appendChild(textNode);
        headerRow.appendChild(header);
      });
      table.appendChild(headerRow);

      // Create table rows
      transactions.forEach((object, index) => {
        const row = document.createElement("tr");
        Object.values(object).forEach((value) => {
          const cell = document.createElement("td");
          const textNode = document.createTextNode(value);
          cell.appendChild(textNode);
          row.appendChild(cell);
        });

        row.addEventListener("click", () => {
          // Call function to display events
          displayEvents(index);
        });

        table.appendChild(row);
      });

      function displayEvents(index) {
        // Call getEvents function to get events for the clicked row
        console.log(index);
        let events = getEvents("TransactionAddedSuccess").then((data) => {
          console.log(data[index]);
          document.getElementById("transactionModal").style.display = "block";
          document.getElementById("transactionModal").innerHTML = `
          <div class="w3-modal-content w3-padding" style="
          overflow: hidden;
          word-wrap: break-word;
          hyphens: auto;">
              <span class='w3-right' onclick="closeModal()">&times;</span>
            <h2>${data[index].transactionHash}</h2>
            <hr />
            <p>Block Hash: ${data[index].blockHash}</p>
            <p>TransactionHash: ${data[index].blockNumber}</p>
            <p>Signature: ${data[index].signature}</p>
            <p>data: ${JSON.stringify(data[index].returnValues)}</p>

          </div>
          `;
        });
        // Display events
        // console.log(events); // Replace with code to display events in your UI
      }

      // Add the table to a wrapper div with overflow-x:auto
      const wrapperDiv = document.createElement("div");
      wrapperDiv.style.overflowX = "auto";
      wrapperDiv.appendChild(table);
      document.body.appendChild(wrapperDiv);
    });
}

const disburseTransaction = async () => {
  const accounts = await ethereum.request({ method: "eth_requestAccounts" });
  const account = accounts[0];
  const organizationalAddress = document.getElementById(
    "organizationalAddress"
  ).value;
  const amount = document.getElementById("amount").value;
  const purpose = document.getElementById("purpose").value;

  if (amount == "" || purpose == "" || organizationalAddress == "") {
    alert("please fill in the form");
    return;
  }

  const amoutToWei = web3.utils.toWei(amount, "ether");

  await contract.methods
    .createDisburseTransaction(organizationalAddress, purpose, amoutToWei)
    .send({
      from: account,
      gasLimit: "1000000",
    })
    .then(function (data) {
      console.log(data);
    });
};

function closeModal(id) {
  document.getElementById("transactionModal").style.display = "none";
}

function viewDisbursements() {
  const transactions = [];
  // const container = document.getElementById('container');

  contract.methods
    .getDisburseTransactions()
    .call()
    .then((data) => {
      for ({ receiver_org, timestamp, organization_purpose, amount } of data) {
        const timestamp2 = timestamp;
        const date = new Date(timestamp2 * 1000);
        const formattedDate = date.toLocaleString();
        const formatter = new Intl.NumberFormat("en-US", {
          style: "currency",
          currency: "KES",
        });
        const formattedAmount = web3.utils.fromWei(amount, "ether") + " DNE";
        transactions.push({
          receiver_org,
          timestamp,
          organization_purpose,
          formattedAmount,
        });
      }
      console.log(JSON.stringify(transactions));
      const table = document.createElement("table");
      table.classList.add("w3-table");
      table.classList.add("w3-bordered");
      table.classList.add("w3-auto");

      // Create table headers
      const headers = ["Receiver", "Timestamp", "Purpose", "Amount"];
      const headerRow = document.createElement("tr");
      headers.forEach((headerText) => {
        const header = document.createElement("th");
        const textNode = document.createTextNode(headerText);
        header.appendChild(textNode);
        headerRow.appendChild(header);
      });
      table.appendChild(headerRow);

      // Create table rows
      transactions.forEach((object, index) => {
        const row = document.createElement("tr");
        Object.values(object).forEach((value) => {
          const cell = document.createElement("td");
          const textNode = document.createTextNode(value);
          cell.appendChild(textNode);
          row.appendChild(cell);
        });

        row.addEventListener("click", () => {
          // Call function to display events
          displayEvents(index);
        });

        table.appendChild(row);
      });

      function displayEvents(index) {
        // Call getEvents function to get events for the clicked row
        console.log(index);
        let events = getEvents("DisbursementAddedSuccess").then((data) => {
          console.log(data[index]);
          document.getElementById("transactionModal").style.display = "block";
          document.getElementById("transactionModal").innerHTML = `
          <div class="w3-modal-content w3-padding" style="
          overflow: hidden;
          word-wrap: break-word;
          hyphens: auto;">
              <span class='w3-right' onclick="closeModal()">&times;</span>
            <h2>${data[index].transactionHash}</h2>
            <hr />
            <p>Block Hash: ${data[index].blockHash}</p>
            <p>TransactionHash: ${data[index].blockNumber}</p>
            <p>Signature: ${data[index].signature}</p>
            <p>data: ${JSON.stringify(data[index].returnValues)}</p>

          </div>
          `;
        });
        // Display events
        // console.log(events); // Replace with code to display events in your UI
      }

      // Add the table to a wrapper div with overflow-x:auto
      const wrapperDiv = document.createElement("div");
      wrapperDiv.style.overflowX = "auto";
      wrapperDiv.appendChild(table);
      document.body.appendChild(wrapperDiv);
    });
}
