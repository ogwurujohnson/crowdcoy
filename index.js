const express = require('express');
const { connectDb, models } = require('./models');
const routes = require('./routes');

const app = express();
app.use(express.json());

routes(app);

connectDb().then(async () => {
    console.log('MongoDB connected')
    app.listen(5000, () => {
        console.log(`Example app listening on port 5000!`);
    });
})