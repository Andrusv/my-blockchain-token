require('dotenv').config()

const config = {
    blockchainProvider: process.env.BLOCKCHAIN_PROVIDER,
    contractAddress: process.env.CONTRACT_ADDRESS,
    privateKey: process.env.PRIVATE_KEY
}

module.exports = { config }