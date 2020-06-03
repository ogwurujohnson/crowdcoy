const express = require('express');
const campaignService = require('../services/campaign');
const { authenticate } = require('./utils');

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

router.post('/:id/fund', authenticate, async (req, res) => {
    try {
        const {id} = req.params;
        const {address, amount} = req.body;
        const response = await campaignService.newFunder({id, address, amount});
        res.status(response.status).json(response);
    } catch (err) {
        console.log(err.message)
    }
});

router.get('/user/list', authenticate, async (req, res) => {
    try {
        const user = req.user;
        const response = await campaignService.getUserCampaigns(user.username);
        res.status(response.status).json(response);
    } catch (err) {
        console.log(err.message)
    }
});

router.post('/', authenticate, async (req, res) => {
    try {
        const user = req.user;
        console.log(user);
        // const {} = req.body;
        const requestBody = {...req.body, username: user.username, userId: user.id}
        const response = await campaignService.createCampaign(requestBody);
        res.status(response.status).json(response);
    } catch (err) {
        console.log(err.message)
    }
});

module.exports = router;