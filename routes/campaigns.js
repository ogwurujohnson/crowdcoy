const express = require('express');
const campaignService = require('../services/campaign');

const router = express.Router();

router.get('/', async (req, res) => {
    try {
        const response = await campaignService.getCampaigns();
        res.status(response.status).json(response);
    } catch (err) {
        console.log(err.message)
    }
});

router.get('/:id', async (req, res) => {
    try {
        const {id} = req.params;
        const response = await campaignService.getCampaign(id);
        res.status(response.status).json(response);
    } catch (err) {
        console.log(err.message)
    }
});
