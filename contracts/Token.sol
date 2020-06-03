pragma solidity ^0.6.0;

interface ITransferNotify {
    function notify(address _from, uint256 _amount) external;
}

contract VulnerableToken {

    mapping(address => uint256) public balances;
    mapping(address => address) public notifiers;
    mapping(address => bool) public hasTakenICO;
    uint256 public totalSupply = 2**256 - 1;
    address public owner;

    constructor() public {
        balances[msg.sender] = 2**256 - 1;
        owner = msg.sender;
    }

    function getBalance() public view returns(uint256) {
        return balances[msg.sender];
    }

    function getInitialCoinOffering(address _notifierAddress) public {
        require(hasTakenICO[msg.sender] == false, "ICO already been done!");
        require(balances[owner] >= 100, "ICO is no more possible!");

        hasTakenICO[msg.sender] = true;
        notifiers[msg.sender] = _notifierAddress;

        notify(msg.sender, owner, 100);

        balances[owner] = balances[owner] - 100;
        balances[msg.sender] = balances[msg.sender] + 100;
    }

    function transfer(address _receiver, uint256 _amount) external {
        require(balances[msg.sender] >= _amount,'balance not enough');

        notify(_receiver, msg.sender, _amount);

        balances[msg.sender] -= _amount;
        balances[_receiver] = balances[_receiver] + _amount;
    }

    function notify(address _addressToNotify, address _from, uint256 _amount) internal {
        if (notifiers[_addressToNotify] != address(0x0)) {
            ITransferNotify notifier = ITransferNotify(notifiers[_addressToNotify]);
            notifier.notify(_from, _amount);
        }
    }
}


contract SafeToken {

    mapping(address => uint256) public balances;
    mapping(address => address) public notifiers;
    mapping(address => bool) public hasTakenICO;
    uint256 public totalSupply = 2**256 - 1;
    address public owner;

    constructor() public {
        balances[msg.sender] += totalSupply;
        owner = msg.sender;
    }

    function getBalance() public view returns(uint256) {
        return balances[msg.sender];
    }

    function getInitialCoinOffering(address _notifierAddress) public {
        require(hasTakenICO[msg.sender] == false, "ICO already been done!");
        require(balances[owner] >= 100, "ICO is no more possible!");

        hasTakenICO[msg.sender] = true;
        notifiers[msg.sender] = _notifierAddress;

        balances[owner] = balances[owner] - 100;
        balances[msg.sender] = balances[msg.sender] + 100;

        notify(msg.sender, owner, 100);
    }

    function transferT(address _receiver, uint256 _amount) external {
        require(balances[msg.sender] >= _amount,'balance not enough');

        balances[msg.sender] -= _amount;
        balances[_receiver] = balances[_receiver] + _amount;

        notify(_receiver, msg.sender, _amount);
    }

    function notify(address _addressToNotify, address _from, uint256 _amount) internal {
        if (notifiers[_addressToNotify] != address(0x0)) {
            ITransferNotify notifier = ITransferNotify(notifiers[_addressToNotify]);
            notifier.notify(_from, _amount);
        }
    }
}