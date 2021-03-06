module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 7545,
      network_id: '*' // Match any network id
    },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0xfdb2f6dffd5e4a5f5ea6843ee292f10fe8b8c7e0",
      network_id: 4,
      gas: 4063170 // Gas limit used for deploys
    }
  }
};