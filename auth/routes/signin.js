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


// route de connexion avec basic auth
router.post('/', async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader) {
            res.status(401).json({ type: "error", error: 401, message: "no authorization header present" });
        } else {
            const [type, credentials] = authHeader.split(' ');
            const [mail, password] = Buffer.from(credentials, 'base64').toString().split(':');
            console.log('mail : ' + mail + 'pass : ' + password)
            const result = await db('user').select('id', 'user_name', 'user_mail', 'passwd').where('user_mail', mail);
            if (result.length > 0) {
                const hash = result[0].passwd;
                const match = await bcrypt.compare(password, hash);
                if (match) {
                    const payload = {
                        id: result[0].id,
                        name: result[0].user_name,
                        mail: result[0].user_mail
                    };
                    // access token
                    const token = jwt.sign(payload, secretKey, { expiresIn: '1h' });

                    // refresh token
                    const refreshToken = randtoken.uid(50);
                    await db('user').update({ refresh_token: refreshToken }).where('id', result[0].id);
                    console.log(refreshToken);
                    console.log(token);
                    res.status(200).json({ "access-token": token, "refresh-token": refreshToken });
                } else {
                    res.status(401).json({ type: "error", error: 401, message: "wrong password" });
                }
            } else {
                res.status(401).json({ type: "error", error: 401, message: "wrong mail" });
            }
        }
    }
    catch (err) {
        res.status(500).json(err);
    }
}
);



module.exports = router;