const VulnerableToken = artifacts.require("VulnerableToken");
const AttackerContract = artifacts.require("AttackerContract");
const SafeToken = artifacts.require("SafeToken");

module.exports = function(deployer) {
    deployer.deploy(VulnerableToken).then((token) => {
        deployer.deploy(SafeToken).then((safeToken) => {
            deployer.deploy(AttackerContract, safeToken.address).catch((err) => {
                console.log(err);
            });
        });
    });
  };