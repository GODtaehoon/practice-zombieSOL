// SPDX-License-Identifier: GPL-MIT
pragma solidity ^0.8.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level, "Zombie level too low");
    _;
  }

  function changeName(uint _zombieId, string memory _newName) external aboveLevel(2, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId], "Not the owner of the zombie");
    zombies[_zombieId].name = _newName;
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    require(msg.sender == zombieToOwner[_zombieId], "Not the owner of the zombie");
    zombies[_zombieId].dna = _newDna;
  }

  function getZombiesByOwner(address _owner) external view returns(uint[] memory) {
    uint count = ownerZombieCount[_owner];
    uint[] memory result = new uint[](count);
    uint counter = 0;
    for (uint i = 0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }

}