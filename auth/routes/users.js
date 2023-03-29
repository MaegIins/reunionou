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

// GET /users/:id
router.get('/:id', async (req, res, next) => {
    try {
        const { id } = req.params;
        const user = await db('user').select('id', 'user_name', 'user_mail').where({ id }).first();

        if(!user) {
            res.status(404).json({type: "error", error: 404, message: "user not found " + req.originalUrl});
        } else {
            res.json({ user });
        }
    } catch (error) {
        console.error(error);
        next(error);
    }
});

module.exports = router;
