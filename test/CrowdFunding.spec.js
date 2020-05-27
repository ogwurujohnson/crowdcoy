let CrowdFunding = artifacts.require('./TestCrowdFunding.sol');
const BigNumber = require('bignumber.js');

contract('CrowdFunding', (accounts) => {
    let contract,
        contractCreator = accounts[0],
        beneficiary = accounts[1],
        donor = accounts[2],
        title = 'testing',
        id = '110e36f1-e61c-4106-8e27-83a9b6addf9e';

    const ONE_ETH = new BigNumber(1000000000000000000),
        ERROR_MSG = 'Returned error: VM Exception while processing transaction: revert Cannot end campaign before a deadline -- Reason given: Cannot end campaign before a deadline.',
        APPROVE_ERROR_MSG = 'Returned error: VM Exception while processing transaction: revert Not a funder of this campaign -- Reason given: Not a funder of this campaign.';

    beforeEach(async () => {
        contract = await CrowdFunding.new({
            from: contractCreator,
            gas: 2000000
        })
    });
