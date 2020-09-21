const HDWalletProvider = require('truffle-hdwallet-provider');
const config = require('./secrets.js');

// we can either make use of our mnemonic or make use private key
// const mnemonic = config.MNEMONIC;
const privateKey = config.WALLET_PRIVATE;

module.exports = {
  networks: {
    test: {
      host: 'localhost',
      port: 7545,
      gas: 50000,
      network_id: '*',
      from: config.CREATOR_ADDRESS,
    },

    energiTestnet: {
      provider: () => new HDWalletProvider(privateKey, config.RPC_LINK),
      network_id: 49797,
      gas: 40000000,
      blockLimit: 50000000,
      from: config.CREATOR_ADDRESS,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.6.9",    // Fetch exact version from solc-bin (default: truffle's version)
      docker: false,        // Use "0.5.1" you've installed locally with docker (default: false)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
        optimizer: {
          enabled: true,
          runs: 200
        },
        evmVersion: "istanbul"
      }
    },
  },
};
