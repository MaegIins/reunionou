const express = require('express');
const router = express.Router();

const db = require("../db_connection");

router.get('/', async (req, res, next) => {
    try {
        const users = await db('client');
        res.json({ data: users });
    } catch (error) {
        console.error(error);
        next(error);
    }
});

// GET /api/users/:id
router.get('/:id', async (req, res, next) => {
    try {
        const { id } = req.params;
        const user = await db('client').where({ id }).first();

        if(!user) {
            res.status(404).json({type: "error", error: 404, message: "ressource non disponible " + req.originalUrl});
        } else {
            res.json({ data: user });
        }
    } catch (error) {
        console.error(error);
        next(error);
    }
});

module.exports = router;
