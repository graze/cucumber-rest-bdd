module.exports = (req, res, next) => {
    if (req.path == '/errors/list') {
        res.status(404)
        res.locals.data = {
            errors: [{ message: 'Not Found' }]
        }
    } else if (req.path == '/errors/single') {
        res.status(400)
        res.locals.data = {
            error: { message: 'Bad Request' }
        }
    }
    next()
}
