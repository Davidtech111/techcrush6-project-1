//SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract bankProject1 {
    error FeeIsLow(uint256 _userFee);

    address public immutable bankOwner;

uint256 public constant FEE = 1e18;
uint public totalFee;

    struct accounts {
        string name;
        uint256 accountBalance;
        address accountAddress;
        bool AccountStatus;
        // bytes bvn;
    }

    uint256 public totalAmountInBank;
    // mapping key address to the value accounts
    mapping (address => accounts) public differentAccounts;
    // 1. bank can create different bank accounts
    // account creator
    // 

    // constructor
    // set bank owner
    constructor(address _owner) {
        bankOwner = _owner;
    }

    modifier onlyBankOwner(address _owner) {
        require(bankOwner == _owner, "baba you are not the bank owner joor" );
        _;
    }
    function createAccount(string memory _name) public payable onlyBankOwner(bankOwner) {
       if (msg.value < FEE) {
    revert FeeIsLow(msg.value);
}
totalFee += msg.value;
        differentAccounts[msg.sender] = accounts({
            name: _name,
            accountBalance: 0,
            accountAddress: msg.sender,
            AccountStatus: true
        });
    }

    // 2. user deposit money into differnt bank acccounts
        // payable 
        // msg.value
    function userDeposit() public payable {
        require(msg.value > 0, "you must send more than zero amount to the bank"); 
        // pull out his bank account
        differentAccounts[msg.sender].accountBalance = differentAccounts[msg.sender].accountBalance + msg.value;

        // totalAmountInBank = totalAmountInBank + msg.value;
        totalAmountInBank += msg.value;
    }


    // 3. owner of account can withdraw money from an account
    function userWIthdraw(uint256 amount) public {
        //CEI CHECK- EFFECT - INTERACTION
        // EFFECT
        differentAccounts[msg.sender].accountBalance = differentAccounts[msg.sender].accountBalance - amount;
        //INTERACTION
        (bool isWithdrawn, ) = payable(msg.sender).call{value:amount}("");
        require(isWithdrawn, "it cancelled joor");

        totalAmountInBank -= amount;
        
    }

    // 4. owner a can transfer to owner b 
    function transferToUsers(address user, uint256 amount) public payable {
        // transfer from 1 user to anouther
        // monet must be removed from my account
        differentAccounts[msg.sender].accountBalance = differentAccounts[msg.sender].accountBalance - amount;
        // New amount = old amount - amount
        differentAccounts[user].accountBalance = differentAccounts[user].accountBalance + amount;
        // we are adding the money to the users account
    }
    // 5.  close an account
    function closeAccount() public {
        // withdraw all the money to the user
            // a. get the amount of the user that want to close an account
        uint256 _amount = differentAccounts[msg.sender].accountBalance;
            // withdraw money from the contract for the user that want to close an account 
        userWIthdraw(_amount);
        // delete the account from the mapping
        delete differentAccounts[msg.sender];
    }
}