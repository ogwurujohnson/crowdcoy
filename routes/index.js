const campaigns = require('./campaigns');
const auth = require('./auth');

function routes (app) {
    app.use('/api/campaigns', campaigns);
    app.use('/api/auth', auth);
    app.get('/', (req, res) => {
        res.status(200).json({
            api: "running"
        });
    });
}

module.exports = routes;