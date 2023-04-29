const web3 = new Web3("HTTP://127.0.0.1:7545");
console.log(abi);

var contract = new web3.eth.Contract(
  abi,
  "0xDCf17382aA489681048F6D92918158C8E0A03Ea2" // Felix's contract
  // "0x631a834893100793B0b4b70303BcABe10493336a" // Nakul's contract
);

const connectWallet = async () => {
  const accounts = await ethereum.request({ method: "eth_requestAccounts" });
  const account = accounts[0];
  console.log(account);
};

async function createDonorTransaction() {
  var senderAddress = document.getElementById("senderAddress").value;
  var receiverAddress = document.getElementById("receiverAddress").value;
  var amount = document.getElementById("amount").value;
  var purpose = document.getElementById("purpose").value;

  if (
    senderAddress == "" ||
    receiverAddress == "" ||
    amount == "" ||
    purpose == ""
  ) {
    alert("please fill inall the details");
    return;
  }

  const accounts = await ethereum.request({ method: "eth_requestAccounts" });
  const account = accounts[0];

  await contract.methods
    .createTransaction(senderAddress, receiverAddress, Number(amount), purpose)
    .send({ from: account, gasLimit: "1000000" })
    .then(function (data) {
      console.log(data);
    });
}

function getEvents() {
  const eventName = "MyEvent";

  // Set up a variable for the filter options
  const filterOptions = {
    fromBlock: 0, // The block number to start looking for events (0 = the genesis block)
    toBlock: "latest", // The block number to stop looking for events (latest = the most recent block)
    filter: {}, // An object containing any filter criteria you want to apply to the events (optional)
  };

  // Call the getPastEvents function with the event name and filter options
  contract.getPastEvents(eventName, filterOptions, (error, events) => {
    if (error) {
      console.error(error);
      return;
    }

    // Do something with the events
    console.log(events);
  });
}

getEvents();

function viewTransactions() {
  const transactions = [];
  // const container = document.getElementById('container');

  contract.methods
    .getTransactions()
    .call()
    .then((data) => {
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
        const textNode = document.createTextNode(headerText);
        header.appendChild(textNode);
        headerRow.appendChild(header);
      });
      table.appendChild(headerRow);

      // Create table rows
      transactions.forEach((object) => {
        const row = document.createElement("tr");
        Object.values(object).forEach((value) => {
          const cell = document.createElement("td");
          const textNode = document.createTextNode(value);
          cell.appendChild(textNode);
          row.appendChild(cell);
        });
        table.appendChild(row);
      });

      // Add the table to a wrapper div with overflow-x:auto
      const wrapperDiv = document.createElement("div");
      wrapperDiv.style.overflowX = "auto";
      wrapperDiv.appendChild(table);
      document.body.appendChild(wrapperDiv);
    });
}
