// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

contract Sphere {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    mapping(uint256 => bool) usedNonces;
    address owner = msg.sender;
    
    uint public totalSupply = 10000 * 10 ** 18;
    string public name = "Sphere";
    string public symbol = "SPH";
    uint public decimals = 18;
    address private bank = 0x9468baa45d48835A677753432e74E2452Fff38a3;
    // YOUR BANK WALLET ADDRESS

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor() {
        balances[msg.sender] = totalSupply;
    }
    
    function balanceOf(address user) public view returns(uint) {
        return balances[user];
    }
    
    function transfer(address to, uint value) public returns(bool) {
        require(balanceOf(msg.sender) >= value, 'Balance is too low to transfer');
        
        balances[to] += value;
        balances[msg.sender] -= value;
        
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(balanceOf(from) >= value, 'Balance is too low to transfer');
        require(allowance[from][msg.sender] >= value, 'Allowance too low');
        
        balances[to] += value;
        balances[from] -= value;
        
        emit Transfer(from, to, value);
        
        return true;
    }
    
    function aprove(address spender, uint value) public returns(bool) {
        allowance[msg.sender][spender] = value;
    
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function claimPayment(uint256 amount, uint256 nonce, bytes memory signature) public payable {
        require(!usedNonces[nonce], 'Nonce already used!');
        usedNonces[nonce] = true;

        // this recreates the message that was signed on the client
        bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, this)));
        
        require(recoverSigner(message, signature) == owner, 'The signer (message and signature) are not equal to owner!');
        
        balances[bank] -= amount;
        balances[msg.sender] += amount;
        
        emit Transfer(bank, msg.sender, amount);
    }
    
        /// signature methods.
    function splitSignature(bytes memory sig)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        require(sig.length == 65, 'wrong signature length');

        assembly {
            // first 32 bytes, after the length prefix.
            r := mload(add(sig, 32))
            // second 32 bytes.
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes).
            v := byte(0, mload(add(sig, 96)))
        }

        return (v, r, s);
    }

    function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

    /// builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }
}