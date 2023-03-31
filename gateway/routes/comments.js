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

router.get('/', async (req, res, next) => {
    res.status(200).json({ message: 'Hello' });
});



module.exports = router;
