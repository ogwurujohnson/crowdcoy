const Campaign = require('../models/Campaign');

let responses = {};
const getCampaigns = async () => {
    try {
        const campaigns = await Campaign.find().sort({
            createdAt: 1
        });
        responses = {status: 200, data: campaigns }
        return responses;
    } catch (err) {
        responses = {status: 500, message: err.message }
        return responses;
    }
}
