const mongoose = require('mongoose');
const Campaign = require('./Campaign');

const config = require('../config')

const connectDb = () => {
    return mongoose.connect(config.MONGODB, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    })
}

const models = {Campaign};

module.exports = {
    connectDb,
    models
} 