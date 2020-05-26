let Utils = artifacts.require('./Utils.sol');
let CrowdFunding = artifacts.require('./CrowdFunding.sol');
let TestCrowdFunding = artifacts.require('./TestCrowdFunding.sol');

module.exports = async (deployer) => {
    await deployer.deploy(Utils);
    deployer.link(Utils, CrowdFunding);
    deployer.link(Utils, TestCrowdFunding);
}