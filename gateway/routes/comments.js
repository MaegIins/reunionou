const express = require('express');
const router = express.Router();
const axios = require('axios');


// get comments by id events
router.get('/events/:id', async (req, res, next) => {
    try {
        await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
            .then(async (validateResponse) => {
                await axios.get('http://events:3000/comments/events/'+ req.params.id)
                    .then((response) => {
                        res.status(response.status).json(response.data);
                    })
                    .catch((error) => {
                        res.status(error.response.status).json(error.response.data);
                    });
            })
            .catch((error) => {
                res.status(error.response.status).json(error.response.data);
            });
    }
    catch (error) {
        res.status(500).json(error);
    }
});
router.post('/add', async (req, res, next) => {
    try {
        const { data } = await axios.get('http://auth:3000/validate', {
            headers: { 'Authorization': req.headers.authorization }
        });

        const { mail: userEmail, name: userName } = data;

        const { headers: { location } } = await axios.post('http://events:3000/comments/add', {
            ...req.body
        }, {
            headers: { 'user-mail': userEmail, 'user-name': userName }
        });

        res.set('Location', `http://events:3000/${location}`);
        res.redirect(location);
    } catch (error) {
        if (error.response) {
            const { status, data } = error.response;
            res.status(status).json(data);
        } else {
            res.status(500).json(error);
        }
    }
});



module.exports = router;
