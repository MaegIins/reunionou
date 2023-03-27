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

// controle de la validité du token
router.get('/', async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;

        if (!authHeader) {
            res.status(401).json({ type: "error", error: 401, message: "no authorization header present"});
        } else {
            const [type, token] = authHeader.split(' ');
            console.log(token);
            jwt.verify(token, secretKey, async (err, decoded) => {
                if (err) {
                    res.status(401).json({ type: "error", error: 401, message: err});
                } else {
                    const result = await db('user').select('id','user_name', 'user_mail', 'passwd').where('id', decoded.id);
                    if (result.length > 0) {
                        res.status(200).json({ user_id: result[0].id, mail: result[0].user_mail, name: result[0].user_name });
                    } else {
                        res.status(401).json({ type: "error", error: 401, message: "error while retrieving user" });
                    }
                }
            });
        }
    }
    catch (err) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: err });
    }
});





module.exports = router;