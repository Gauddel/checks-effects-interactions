const VulnerableToken = artifacts.require("VulnerableToken");
const SafeToken = artifacts.require("SafeToken");
const AttackerContract = artifacts.require("AttackerContract");
const truffleAssertion = require('truffle-assertions');

contract("Hacking Token Contract", async (accounts) => {
    it("Hacker Ether account balance should be greater than 200 tokens", async () => {
        const token = await VulnerableToken.new({from: accounts[0]});
        const attackerContract = await AttackerContract.new(token.address, {from: accounts[1]});

        await token.getInitialCoinOffering(attackerContract.address, {from: accounts[1]});
        await attackerContract.attackToken();
        const tokenBalanceOfAccount1 = (await token.getBalance({from: accounts[1]})).toNumber();
        assert.equal(tokenBalanceOfAccount1 > 1000, true, "Token is Safe");
    });

    it("Hacker Ether account balance should not be greater than it's initial account balance", async () => {
        const token = await SafeToken.new({from: accounts[0]});
        const attackerContract = await AttackerContract.new(token.address, {from: accounts[1]});

        await token.getInitialCoinOffering(attackerContract.address, {from: accounts[1]})
        await truffleAssertion.fails(
            attackerContract.attackToken(),
            truffleAssertion.ErrorType.REVERT)
    });
});