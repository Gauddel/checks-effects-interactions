const VulnerableToken = artifacts.require("VulnerableToken");
const AttackerContract = artifacts.require("AttackerContract");
const SafeToken = artifacts.require("SafeToken");
var Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:9545"));
module.exports = function(deployer) {
    deployer.deploy(VulnerableToken).then((token) => {
        deployer.deploy(SafeToken).then((safeToken) => {
            deployer.deploy(AttackerContract, safeToken.address).catch((err) => {
                console.log(err);
            });
        });
    });
  };