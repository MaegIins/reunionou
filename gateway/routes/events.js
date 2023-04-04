const express = require('express');
const router = express.Router();
const axios = require('axios');
const Joi = require('joi')
    .extend(require('@joi/date'));


const schema = Joi.object({
    title: Joi.string().max(100),
    description: Joi.string().max(256),
    date: Joi.date().format('YYYY-MM-DD').utc(),
    name_orga: Joi.string().max(30),
    name_place: Joi.string().max(100),
    mail_orga: Joi.string().max(35).email(),
});

// Liste des événements par utilisateur (GET)
router.get('/', async (req, res, next) => {
    try {
        await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
            .then(async (response) => {
                const userEmail = response.data.mail; // Get the user email from the auth service response
                await axios.get('http://events:3000/events', { headers: { 'user-email': userEmail } }) // Pass the user email in the headers
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

router.post('/', async (req, res, next) => {
    try {
        const { data } = await axios.get('http://auth:3000/validate', {
            headers: { 'Authorization': req.headers.authorization }
        });

        const { mail: userEmail, name: userName } = data;
        
        const { headers: { location } } = await axios.post('http://events:3000/events', {
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


router.get('/:id', async (req, res, next) => {
    try {
        await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
            .then(async (response) => {
                const userEmail = response.data.mail;
                await axios.get('http://events:3000/events/' + req.params.id, { headers: { 'user-email': userEmail } })
                    .then((response) => {
                        res.json(response.data);
                    }
                    )
                    .catch((error) => {
                        res.status(error.response.status).json(error.response.data);
                    }
                    );
            })
            .catch((error) => {
                res.status(error.response.status).json(error.response.data);
            });
    }
    catch (error) {
        res.status(500).json(error);
    }
});

router.get('/:id/attendees', async (req, res, next) => {
    try {
        await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
            .then(async (response) => {
                const userEmail = response.data.mail;
                try {
                    await axios.get('http://events:3000/events/' + req.params.id + '/attendees', { headers: { 'user-email': userEmail } })
                        .then((response) => {
                            res.json(response.data);
                        })
                        .catch((error) => {
                            res.status(error.response.status).json(error.response.data);
                        });
                }
                catch (error) {
                    res.status(error.response.status).json(error);
                }
            })
            .catch((error) => {
                res.status(error.response.status).json(error.response.data);
            });
    }
    catch (error) {
        res.status(500).json(error);
    }
});

// partager un événement
router.get('/:id/share', async (req, res, next) => {
    try {
        await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
            .then(async (response) => {
                try {
                    await axios.get('http://events:3000/events/' + req.params.id + '/share', req.body)
                        .then((response) => {
                            res.status(response.status).json(response.data);
                        })
                        .catch((error) => {
                            res.status(error.response.status).json(error.response.data);
                        });
                }
                catch (error) {
                    res.status(error.response.status).json(error);
                }
            })
            .catch((error) => {
                res.status(error.response.status).json(error.response.data);
            });
    }
    catch (error) {
        res.status(500).json(error);
    }
});


module.exports = router;
