const express = require('express');
const router = express.Router();

const db = require("../db_connection");

router.get('/', async (req, res, next) => {
    try {
        const users = await db('user').select('id', 'user_name', 'user_mail');
        res.json({ users });
    } catch (error) {
        console.error(error);
        next(error);
    }
});

// search for a user by mail
router.post('/search', async (req, res, next) => {
    try {
        const { mail } = req.body;
        if (!mail) {
            res.status(400).json({ type: "error", error: 400, message: "missing mail parameter" });
        }
        else {
            const user = await db('user').select('id', 'user_name', 'user_mail').where({ user_mail: mail }).first();
            if (!user) {
                res.status(404).json({ type: "error", error: 404, message: "USER IS NOT EXIST" });
            } else {
                res.status(200).json({ user_mail: user.user_mail, user_name: user.user_name});
            }
        }
    } catch (error) {
        console.error(error);
        next(error);
    }
});

// GET /users/:id
router.get('/:id', async (req, res, next) => {
    try {
        const { id } = req.params;
        const user = await db('user').select('id', 'user_name', 'user_mail').where({ id }).first();

        if (!user) {
            res.status(404).json({ type: "error", error: 404, message: "user not found " + req.originalUrl });
        } else {
            res.json({ user });
        }
    } catch (error) {
        console.error(error);
        next(error);
    }
});

module.exports = router;
