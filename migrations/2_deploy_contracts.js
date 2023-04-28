var Financial = artifacts.require("./Financial.sol");

module.exports = function(deployer) {
    deployer.deploy(Financial);
};