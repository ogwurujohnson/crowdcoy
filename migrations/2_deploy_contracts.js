let Utils = artifacts.require('./Utils.sol');
let CrowdFund = artifacts.require('CrowdFund');

module.exports = async (deployer) => {
    await deployer.deploy(Utils);
    await deployer.link(Utils, CrowdFund);
    await deployer.deploy(CrowdFund);

    const crowd = await CrowdFund.deployed();
    await crowd.create('test', 'test2', 10, 10000);
    const campaigns = await crowd.getCampaigns();
    console.log(campaigns)
}