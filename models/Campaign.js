const {
    model,
    Schema
} = require('mongoose');

const campaignSchema = new Schema({
    id: String,
    name: String,
    budget: String,
    received: String,
    deadline: String,
    isActive: Boolean,
    funders: [{
        address: String,
        amount: String
    }]
});

module.exports = model('Campaign', campaignSchema);