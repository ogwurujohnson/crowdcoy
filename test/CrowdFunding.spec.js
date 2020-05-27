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

    const createCampaign = async () => {
        await contract.create(title, ONE_ETH, 10, beneficiary, id, {
            from: beneficiary
        })
    }

    const contribute = async () => {
        await contract.contribute(id, {
            from: donor,
            value: ONE_ETH
        });
    }

    it('contract is initialized', async () => {
        let campaignsLength = await contract.getCampaignCount();
        expect(campaignsLength.toNumber()).to.equal(0);
    });

    it('create campaign', async () => {
        createCampaign();
        let campaignsLength = await contract.getCampaignCount();
        expect(campaignsLength.toNumber()).to.equal(1);

        let campaign = await contract.userCampaign.call(id);
        expect(campaign.name).to.equal(title);
        expect(campaign.beneficiary).to.equal(beneficiary);
        expect(campaign.isActive).to.equal(true);
        expect(campaign.success).to.equal(false);
        expect(ONE_ETH.isEqualTo(campaign.budget)).to.equal(true);
    });
