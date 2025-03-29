// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiChainTransaction {
    struct Transaction {
        address sender;
        address receiver;
        uint256 amount;
        uint256 timestamp;
    }

    address public owner;

    mapping(address => Transaction[]) private sentTransactions;
    mapping(address => Transaction[]) private receivedTransactions;

    event TransactionSent(address indexed sender, address indexed receiver, uint256 amount, uint256 timestamp);
    event TransactionReceived(address indexed sender, address indexed receiver, uint256 amount, uint256 timestamp);
    event OwnerChange(address indexed oldOwner, address indexed newOwer);

    modifier onlyOwner{
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "Invalid owner address");
        emit OwnerChange(owner, _newOwner);
        owner = _newOwner;
    }

    function sendTransaction(address _receiver) external payable {
        require(msg.value > 0, "Amount must be greater than zero");
        require(_receiver != address(0), "Invalid receiver address");

        Transaction memory newTransaction = Transaction({
            sender: msg.sender,
            receiver: _receiver,
            amount: msg.value,
            timestamp: block.timestamp
        });

        sentTransactions[msg.sender].push(newTransaction);
        receivedTransactions[_receiver].push(newTransaction);

        emit TransactionSent(msg.sender, _receiver, msg.value, block.timestamp);
        emit TransactionReceived(msg.sender, _receiver, msg.value, block.timestamp);

        payable(_receiver).transfer(msg.value);
    }

    function getSentTransactions() external view returns (Transaction[] memory) {
        return sentTransactions[msg.sender];
    }

    function getReceivedTransactions() external view returns (Transaction[] memory) {
        return receivedTransactions[msg.sender];
    }
}
