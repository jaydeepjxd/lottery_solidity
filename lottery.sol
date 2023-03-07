// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery
{
    address public manager;
    address payable[] public players;

    constructor()
    {
        manager = msg.sender;   // address of person who deploys the contract
    }


    // to receive payment | can be called only once | always used with external keyword
    receive() external payable  
    {   require(msg.value == 1 ether);
        players.push(payable(msg.sender));  //pushing add as a payable in array
    }

    // to check balance | only accessible to manager
    function getBalance() public view returns(uint)
    {
        require(msg.sender== manager);
        return address(this).balance;  //getting balance
    }

    function random() public view returns(uint)
    {
        return uint(keccak256(abi.encode(block.timestamp,  players)));
    }

    function selectWinner() public
    {
        require(players.length>= 3);   
        require(msg.sender== manager);

        uint rand = random();
        uint index = rand % players.length;
        address winner = payable (players[index]); //payable keyword before

        payable (winner).transfer(getBalance());  //transferring eth to winner

        players= new address payable[](0);  //emptying the players array
    }
}
