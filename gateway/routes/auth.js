const express = require('express');
const router = express.Router();
const axios = require('axios');

router.post('/signup', async (req, res, next) => {
    try {
        await axios.post('http://auth:3000/signup', req.body)
        .then((response) => {
            res.status(response.status).json(response.data);
        })
        .catch((error) => {
            res.status(error.response.status).json(error.response.data);
        });
    }
    catch (err) {
        res.status(500).json(err);
    }
});

router.post('/signin', async (req, res, next) => {
    try {
        await axios.post('http://auth:3000/signin', { }, { headers: { 'Authorization': req.headers.authorization } })
        .then((response) => {
            res.status(response.status).json(response.data);
        })
        .catch((error) => {
            res.status(error.response.status).json(error.response.data);
        });
    }
    catch (err) {
        res.status(500).json(err);
    }
});

router.get('/validate', async (req, res, next) => {
    try {
        await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
        .then((response) => {
            res.status(response.status).json(response.data);
        })
        .catch((error) => {
            res.status(error.response.status).json(error.response.data);
        });
    }
    catch (err) {
        res.status(500).json(err);
    }
});

router.post('/refresh', async (req, res, next) => {
    try {
        await axios.post('http://auth:3000/refresh', { }, { headers: { 'Authorization': req.headers.authorization } })
        .then((response) => {
            res.status(response.status).json(response.data);
        })
        .catch((error) => {
            res.status(error.response.status).json(error.response.data);
        });
    }
    catch (err) {
        res.status(500).json(err);
    }
});

module.exports = router;
