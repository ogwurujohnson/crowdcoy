const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const { SECRET_KEY } = require('../config/index');

let responses = {};
function generateToken(user) {
    return jwt.sign({
            id: user.id,
            email: user.email,
            username: user.username
        },
        SECRET_KEY, {
            expiresIn: '24h'
        }
    )
}

const register = async ({username, password, email}) => {
    const user = await User.findOne({
        username
    });

    if (user) {
        responses = { status: 403, message: 'user with username already exists' }
        return responses;
    }
    password = await bcrypt.hash(password, 12);

    const newUser = new User({
        username,
        password,
        email,
        createdAt: new Date().toISOString()
    });

    const res = await newUser.save();
    const token = generateToken(res);
    responses = { status: 201, data: {...res._doc, id: res.id}, token }
    return responses;
}

const login = async ({username, password}) => {
    const user = await User.findOne({
        username
    });
    if (!user) {
        responses = { status: 404, message: 'user not found' }
        return responses;
    }

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
        responses = { status: 401, message: 'wrong credentials' }
        return responses;
    }

    const token = generateToken(user);

    responses = { status: 200, data: {...user._doc, id: user.id}, token }
    return responses;
}

module.exports = {
    register,
    login
}