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
    username: String,
    createdAt: String,
    funders: [{
        address: String,
        amount: String
    }],
    user: {
        type: Schema.Types.ObjectId,
        ref: 'users'
    }
});

module.exports = model('Campaign', campaignSchema);