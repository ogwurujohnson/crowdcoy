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
