const express = require('express');
const authService = require('../services/auth');

const router = express.Router();

router.post('/register', async (req, res) => {
    try {
        const {username, email, password} = req.body;
        const response = await authService.register({username, password, email});
        res.status(response.status).json(response);
    } catch (err) {
        console.log(err.message)
    }
});

router.post('/login', async (req, res) => {
    try {
        const {username, password} = req.body;
        const response = await authService.login({username, password});
        res.status(response.status).json(response);
    } catch (err) {
        console.log(err.message)
    }
});

module.exports = router;