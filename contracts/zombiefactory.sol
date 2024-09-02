// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Ownable.sol";

contract ZombieFactory is Ownable {

    event NewZombie(uint indexed zombieId, string name, uint dna);

    uint public dnaDigits = 16;
    uint public dnaModulus = 10 ** dnaDigits;
    uint public cooldownTime = 1 days;

    struct Zombie {
        string name;
        uint dna;
        uint32 level;
        uint32 readyTime;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) public ownerZombieCount;

    function _createZombie(string memory _name, uint _dna) internal {
        uint futureTime = block.timestamp + cooldownTime;
        require(futureTime <= type(uint32).max, "Cooldown time exceeds uint32 range");
        uint32 readyTime = uint32(futureTime);
        
        uint id = zombies.length; // Using length to get the index for the new zombie
        zombies.push(Zombie(_name, _dna, 1, readyTime));
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        emit NewZombie(id, _name, _dna);
    }

    function _generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    function createRandomZombie(string memory _name) public {
        require(ownerZombieCount[msg.sender] == 0, "You already own a zombie.");
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100; // Ensure DNA ends in 00
        _createZombie(_name, randDna);
    }

}