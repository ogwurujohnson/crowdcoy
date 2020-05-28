const express = require('express');
const { connectDb, models } = require('./models');

const app = express();

connectDb().then(async () => {
    console.log('MongoDB connected')
    app.listen(5000, () => {
        console.log(`Example app listening on port 5000!`);
    });
})