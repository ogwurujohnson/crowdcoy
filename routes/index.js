const campaigns = require('./campaigns');

function routes (app) {
    app.use('/api/campaigns', campaigns);
    app.get('/', (req, res) => {
        res.status(200).json({
            api: "running"
        });
    });
}

module.exports = routes;