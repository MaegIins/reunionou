const express = require('express');
const router = express.Router();
const db = require("../db_connection");
const { v4: uuidv4 } = require('uuid');


const Joi = require('joi')
    .extend(require('@joi/date'));

const schema = Joi.object({
    key: Joi.string().max(250),
    name: Joi.string().max(30),
    mail: Joi.string().max(20).email(),
    status: Joi.bool(),
    comment: Joi.string().max(100)
});

const jwt = require('jsonwebtoken');

const secretKey = process.env.SECRET_KEY;



// conirm, refuse our update invite
router.post('/confirm', async (req, res, next) => {
    try {
        const { key, name, mail, status, comment } = req.body;
        const { error } = schema.validate({ key, name, mail, status, comment });
        if (error) {
            res.status(400).json({ type: "error", error: 400, message: "bad request", details: error.details });
        } else {
            const decoded = jwt.verify(key, secretKey);
            const event = await db('Event').where({ id: decoded.id }).first();
            if (!event) {
                res.status(404).json({ type: "error", error: 404, message: "event not found " + req.originalUrl });
            } else {
                let participate;
                console.log(status);
                if (status == true) {
                    participate = 2;
                } else {
                    participate = 1;
                }
                const attendee = await db('Attendee').where({ id_event: decoded.id, mail_user: mail }).first();
                if (!attendee) {
                    await db('Attendee').insert({ id_event: decoded.id, name_user: name, mail_user: mail, status: participate, details: comment });
                    const newAttendee = await db('Attendee').where({ id_event: decoded.id, name_user: name, mail_user: mail, status: participate, details: comment }).first();
                    res.status(200).json({ type: "sucess", message: "INVITE OK", attendee: newAttendee });
                } else {
                    await db('Attendee').where({ id_event: decoded.id, mail_user: mail }).update({ status: participate, details: comment });
                    const newAttendee = await db('Attendee').where({ id_event: decoded.id, mail_user: mail }).first();
                    res.status(200).json({ type: "sucess", message: "UPDATE INVITE OK", attendee: newAttendee });
                }
            }
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});


// get details of an event
router.get('/details', async (req, res, next) => {
    try {
        const { key } = req.query;
        const decoded = jwt.verify(key, secretKey);
        const event = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').where({ id: decoded.id }).first();
        if (!event) {
            res.status(404).json({ type: "error", error: 404, message: "event not found " + req.originalUrl });
        } else {
            const id_place = event.id_place;
            if (id_place) {
                const place = await db.select('id', 'name', 'adress', 'lat', 'lon').from('Place').where({ id: id_place });
                event.place = place;
                const data = {
                        id_event: event.id,
                        name: event.name,
                        description: event.description,
                        date: event.date,
                        name_orga: event.name_orga,
                        mail_orga: event.mail_orga,
                        place: {
                            id_place: place[0].id,
                            name: place[0].name,
                            adress: place[0].adress,
                            lat: place[0].lat,
                            lon: place[0].lon,
                        },
                }
                res.status(200).json({ type: "sucess", message: "INVITE OK", event: data });

            } else {
                res.status(200).json({ type: "sucess", message: "INVITE OK", event: event });
        }
    }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});

                




    // router.get('/', async (req, res, next) => {
    //     try {
    //         const { key } = req.query;
    //         const decoded = jwt.verify(key, secretKey);
    //         const event = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').where({ id: decoded.id }).first();
    //         if (!event) {
    //             res.status(404).json({ type: "error", error: 404, message: "event not found " + req.originalUrl });
    //         } else {
    //             res.status(200).json({ type: "sucess", message: "INVITE OK", event: event });
    //         }
    //     } catch (error) {
    //         res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
    //         next(error);
    //     }
    // });







    module.exports = router;
