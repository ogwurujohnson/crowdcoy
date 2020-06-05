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

const getUserCampaigns = async (username) => {
    try {
        const campaigns = await Campaign.find({username: username}).sort({
            createdAt: 1
        });
        responses = {status: 200, data: campaigns }
        return responses;
    } catch (err) {
        responses = {status: 500, message: err.message }
        return responses;
    }
}

const newFunder = async (data) => {
    try {
        const campaign = await Campaign.findById(data.id);
        const newFunder = {
            address: data.address,
            amount: data.amount
        }
        campaign.funders = [...campaign.funders, newFunder];
        const funder = await campaign.save();
        responses = {status: 201, data: funder }
        return responses;
    } catch (err) {
        responses = {status: 500, message: err.message }
        return responses;
    }
}

const getCampaign = async (id) => {
    try {
        const campaign = await Campaign.findOne({_id: id})
        if (campaign) {
            responses = {status: 200, data: campaign }
            return responses;
        } else {
            responses = {status: 404, message: 'campaign not found' }
            return responses;
        }
    } catch (err) {
        responses = {status: 500, message: err.message }
        return responses;
    }
}

const createCampaign = async (data) => {
    // user id would be gotten from payload from jwt after decoding token
    try {
        const newCampaign = new Campaign({
            name: data.name,
            budget: data.budget,
            received: data.received,
            deadline: data.deadline,
            isActive: data.isActive,
            username: data.username,
            createdAt: new Date().toISOString(),
            user: data.userId
        });
        const campaign = await newCampaign.save();
        responses = {status: 201, data: campaign }
        return responses;
    } catch (err) {
        responses = {status: 500, message: err.message }
        return responses;
    }
}

module.exports = {
    getCampaigns,
    getCampaign,
    getUserCampaigns,
    createCampaign,
    newFunder
}