// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

contract Lottery { 
    address public owner;

    address payable[] public players;

    uint public lotteryID;

    mapping  (uint => address payable ) public  lotteryHistory;

    constructor() {
        owner = msg.sender;
    }

    function getWinnerByLottery (uint _id) public view returns (address payable) {
        return lotteryHistory[_id];
    }

    function getBalnce() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function enterLottery() public payable  {
        require( msg.value > .01 ether, "Not enough funds to enter the lottery");
        
        //  address of palyers entrying the lottery...

        players.push(payable (msg.sender));
    }

    function getRanNumber() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }
        
    function pickWinner() public onlyOwner {
        uint index = getRanNumber() % players.length; 
        players[index].transfer(address(this).balance);

        lotteryHistory[lotteryID] = players[index];
        
        lotteryID++;

        // Reset contract 
        players = new address payable[](0);
    }

    modifier onlyOwner () {
        require (msg.sender == owner, "Not the owner");
        _;
    }
}