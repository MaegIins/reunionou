const express = require('express');
const router = express.Router();

const db = require("../db_connection");

const bcrypt = require('bcrypt');
const saltRounds = 10;

const Joi = require('joi')
    .extend(require('@joi/date'));

const jwt = require('jsonwebtoken');

const randtoken = require('rand-token');

// La clé secrète pour la signature
const secretKey = process.env.SECRET_KEY;


// refresh token with refresh_token
router.post('/', async (req, res, next) => {
        try {
            const authHeader = req.headers.authorization;

            if (!authHeader) {
                res.status(401).json({ type: "error", error: 401, message: "no authorization header present"});
            } else {
                const [type, token] = authHeader.split(' ');
                const result = await db('user').select('id','user_name', 'user_mail', 'passwd', 'refresh_token').where('refresh_token', token);
                if (result.length > 0) {
                    const payload = {
                        id: result[0].id,
                        name: result[0].user_name,
                        mail: result[0].user_mail
                    };
                    // access token
                    const accessToken = jwt.sign(payload, secretKey, { expiresIn: '1h' });

                    // refresh token
                    const refreshToken = randtoken.uid(50);
                    await db('user').update({ refresh_token: refreshToken }).where('id', result[0].id);

                    res.status(200).json({ "access_token": accessToken, "refresh_token": refreshToken});
                } else {
                    res.status(401).json({ type: "error", error: 401, message: "wrong refresh token" });
                }
            }
        }
        catch (err) {
            console.log(err);
            res.status(500).json({ type: "error", error: 500, message: err.message });
        }
    }
);




module.exports = router;