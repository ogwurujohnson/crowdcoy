const jwt = require('jsonwebtoken');
const { SECRET_KEY } = require('../config/index');

function authenticate(req, res, next) {
    const token = req.headers['authorization'];
    if (token) {
        jwt.verify(token, SECRET_KEY, (err, decoded) => {
            if (err)
                return res.status(401).json({
                message: 'User not authenticated',
            });

            req.user = decoded;

            next();
        });
    } else {
        return res.status(401).json({
            error: 'No token provided, token is required in the Authorization Header',
        });
    }
}

module.exports = {
    authenticate
}