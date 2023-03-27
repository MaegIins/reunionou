const express = require('express');
const router = express.Router();

const db = require("../db_connection");

const bcrypt = require('bcrypt');
const saltRounds = 10;

const Joi = require('joi')
    .extend(require('@joi/date'));

const schema = Joi.object({
    nom: Joi.string().max(25),
    mail: Joi.string().max(20).email(),
    password: Joi.string().max(20).min(8),
});


router.post('/', async (req, res, next) => {
    try {
        const { client_name, client_mail, password } = req.body;
        try {
            const result = await schema.validateAsync({ nom: client_name, mail: client_mail, password: password });
            if (result) {
                const client = await db('client').where({ mail_client: client_mail });
                if (client.length > 0) {
                    res.status(409).json({ type: "error", error: 409, message: "EMAIL EXIST" });
                    return;
                } else {
                    const hash = await bcrypt.hash(password, saltRounds);
                    await db('client').insert({ nom_client: client_name, mail_client: client_mail, passwd: hash, created_at: new Date() });
                    res.status(201).json({ type: "sucess", error: 201, message: "CREATED" });
                }
            }
        }
        catch (err) {
            res.status(500).json({ type: "error", error: err });
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }
});





module.exports = router;