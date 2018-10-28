pragma solidity ^0.4.24;

import "./Ownable.sol";
import "./SafeMath.sol";

// State variables are permanently stored in contract storage. This means they are written to
// the Ethereum block chain. Think of them like writing to a DB

// uint is alias for uint256, smaller versions as uint8, uint16 and uint32
// generally we use uint unless we need for specific  cases.

// There are two types of arrays in Solidity
// Fixed Array and Dynamic Arrays
// uint[2] fixedArray;
// uint[] dynamicArray;

// function parameters starts with _ in order to differentiate them from global variables.

// Private and Public functions
// in Solidity functions are public by default. This means anyone can call your contract function and execute its code
// incase you dont want your function to be public, add private by default
// private functions starts with _ in their name as standard convention.

// Return values from functions. When a function returns a value, the function signature has return type in the signature

// When a function does not change the state of data in Solidity, we can declare such functions with view. These functions are
// are read only.

// Pure functions when the function does not even assess the state in block chain.

//Ethereum has a hash function keccak256 which is SHA3
// Typecasting is to convert data between different data types

// Events are a way for your contracts to communicate that something happened on the blockchain to your app

// Mappings and Addressess

// Addresses
// The Ethereum blockchain is made up of accounts, which you can think of ike bank accounts.
// The account will have ether which can send and received to and from the account.
// Each of these account has an address which can be thought of as account number.

// An Address is owned by a specific user or a smart contract.

// So when a user creates a new zombies by interacting with our app. we will set ownership of theose
// zombies to the ethereum address that called the function.

// Mapping
// like stucts and arrays, Mappings are another way of storing organized data in Solidity.
// Mapping is essentaillay a key value store for storin and looking up data.

// Msg.sender
// in Solidity, there are certain global variables that are available to all functions.  msg.sender
// is such funcion which refers to the person who called the current function.
// msg.sender gives you the security of Ethereum blockchain. The only way someone can modify some else data
// is only if they steal the private key associated with their Ethereum Address.

// Require
// makes it so that the function will throw an error and stop executing if some condition is not true.

// inheritance
// similar to c++, the functionality in parent is inherited to derived classes.

// Interacting with other Contracts
// for or contract to talk to another contract on the block chain that we dont own, we need to define
// an interface


contract ZombieFactory is Ownable {
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    uint dnaDigits=16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint   dna;
        uint32 level;
        uint32 readyTime;
        uint16 winCount;
        uint16 lossCount;
    }

    Zombie[] public zombies;

    mapping (uint => address)  public zombieToOwner;
    mapping (address => uint) public ownerZombieCount;

    event NewZombie(uint zombieId, string name, uint dna);

    constructor(){
    }

    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name,_dna,1, uint32(now + cooldownTime),0 ,0)) -1;

        zombieToOwner[id]= msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender]++;
        emit NewZombie(id,_name,_dna);
    }

    function _generateRandomDna(string _str) private view returns (uint){
       uint  rand = uint(keccak256(_str));
       return rand %  dnaModulus;
    }

    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}

