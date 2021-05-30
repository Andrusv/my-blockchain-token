const Web3 = require('web3');
const abi = require('ethereumjs-abi')

const { config } = require('./config/index.js')


const blockchainProvider = config.blockchainProvider;
const contractAddress = config.contractAddress;
const privateKey = config.privateKey;

let web3 = new Web3(blockchainProvider);

function signPayment(_recipient, _amount, _nonce, _contractAddress, callback) {
    var hash = "0x" + abi.soliditySHA3(
        ["address", "uint256", "uint256", "address"],
        [_recipient, _amount, _nonce, _contractAddress]
    ).toString("hex");

    const sign = web3.eth.accounts.sign(hash, privateKey)
    
    callback(sign)
}