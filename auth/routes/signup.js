const express = require('express');
const router = express.Router();

const db = require("../db_connection");

const bcrypt = require('bcrypt');
const saltRounds = 10;

const Joi = require('joi')
    .extend(require('@joi/date'));

const schema = Joi.object({
    name: Joi.string().max(25),
    mail: Joi.string().max(20).email(),
    password: Joi.string().max(20).min(8),
});


router.post('/', async (req, res, next) => {
    try {
        let { name, mail, password } = req.body;
        mail = mail.toLowerCase();
        try {
            const result = await schema.validateAsync({ name: name, mail: mail, password: password });
            if (result) {
                const user = await db('user').where({ user_mail: mail });
                if (user.length > 0) {
                    res.status(409).json({ type: "error", error: 409, message: "EMAIL EXIST" });
                    return;
                } else {
                    const hash = await bcrypt.hash(password, saltRounds);
                    await db('user').insert({ user_name: name, user_mail: mail, passwd: hash });
                    res.status(201).json({ type: "success", error: 201, message: "CREATED" });
                }
            }
        }
        catch (err) {
            res.status(500).json({ type: "error", error: err });
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});





module.exports = router;