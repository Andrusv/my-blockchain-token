# my-blockchain-token
This is my first smart contract / blockchain token developed with Solidity, containing all basic public functions for a token such as: balanceOf, transfer, aprove, transferFrom and so on.

Also, added a function called 'claimPayment' that will serve as a withdrawal service that will take the funds from the base account of the contract.

# claimPayment Function props (Smart contract)
claimPayment(uint256 amount, uint256 nonce, bytes memory signature)

# Nonce and Signature
Created a script in JavaScript that will sign the transfer to automate the user's withdrawals in the file 'index.js':

signPayment(recipient,amount,nonce,contractAddress, response => response.signature)
// recipient is the address that should be paid.
// amount, in wei, specifies how much ether should be sent.
// nonce can be any unique number to prevent replay attacks
// contractAddress is used to prevent cross-contract replay attacks
