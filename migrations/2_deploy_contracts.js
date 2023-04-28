var FinancialTrackingSystem = artifacts.require("./FinancialTrackingSystem.sol");

module.exports = function(deployer) {
    deployer.deploy(FinancialTrackingSystem);
};