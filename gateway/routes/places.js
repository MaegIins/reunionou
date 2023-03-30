const express = require('express');
const router = express.Router();
const axios = require('axios');


// get places
router.get('/', async (req, res, next) => {
    try {
        await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
            .then(async (validateResponse) => {
                await axios.get('http://events:3000/places')
                    .then((response) => {
                        res.json(response.data);
                    })
                    .catch((error) => {
                        res.status(404).json(error.response.data);
                    });
            })
            .catch((error) => {
                res.status(401).json(error.response.data);
            });
    }
    catch (error) {
        res.status(500).json(error);
    }
});



module.exports = router;
