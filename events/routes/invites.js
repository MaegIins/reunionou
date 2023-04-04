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
                    participate = 1;
                } else {
                    participate = 2;
                }
                const attendee = await db('Attendee').where({ id_event: decoded.id, mail_user: mail }).first();
                if (!attendee) {
                    await db('Attendee').insert({ id_event: decoded.id, name_user: name, mail_user: mail, status: participate, details: comment });
                    const newAttendee = await db('Attendee').where({ id_event: decoded.id, name_user: name, mail_user: mail, status: participate, details: comment }).first();
                    res.status(200).json({ type: "success", message: "INVITE OK", attendee: newAttendee });
                } else {
                    await db('Attendee').where({ id_event: decoded.id, mail_user: mail }).update({ status: participate, details: comment });
                    const newAttendee = await db('Attendee').where({ id_event: decoded.id, mail_user: mail }).first();
                    res.status(200).json({ type: "success", message: "UPDATE INVITE OK", attendee: newAttendee });
                }
            }
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});

// POST /invites/confirm/user
router.post('/confirm/user', async (req, res, next) => {
    try {
        const { event, status, comment } = req.body;
        const userName = req.headers['user-name'];
        const userEmail = req.headers['user-mail'];
        console.log(event, userName, userEmail, status, comment)
        if (!event || status == undefined || !userName || !userEmail) {
            res.status(400).json({ type: "error", error: 400, message: "bad request", details: "missing parameters" });
        }
        else {
            const { error } = schema.validate({ key: event, name: userName, mail: userEmail, status: status, comment: comment });
            if (error) {
                res.status(400).json({ type: "error", error: 400, message: "bad request", details: error.details });
            } else {
                const eventExist = await db('Event').where({ id: event }).first();
                if (!eventExist) {
                    res.status(400).json({ type: "error", error: 400, message: "event " + event + " is no exist" });
                }
                else {
                    let participate;
                    if (status == true) {
                        participate = 1;
                    } else {
                        participate = 2;
                    }
                    // verify if attendee exist for this event
                    const attendee = await db('Attendee').where({ id_event: event, mail_user: userEmail }).first();
                    if (!attendee) {
                        res.status(400).json({ type: "error", error: 400, message: "bad request", details: "attendee not exist for this event" });
                    }
                    else {
                        await db('Attendee').where({ id_event: event, mail_user: userEmail }).update({ status: participate, details: comment });
                        const newAttendee = await db('Attendee').where({ id_event: event, mail_user: userEmail }).first();
                        res.status(200).json({ type: "success", message: "INVITE OK", attendee: newAttendee });
                    }
                }
            }
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});

// POST /invites/user for add a user to an event
router.post('/user', async (req, res, next) => {
    try {
        const { event, attendee_name, attendee_mail } = req.body;
        const userEmail = req.headers['user-mail'];
        if (!event || !attendee_name || !attendee_mail) {
            res.status(400).json({ type: "error", error: 400, message: "bad request", details: "missing parameters" });
        }
        else {
            const { error } = schema.validate({ key: event, name: attendee_name, mail: attendee_mail });
            if (error) {
                res.status(400).json({ type: "error", error: 400, message: "bad request", details: error.details });
            } else {
                const userIsOrga = await db('Event').where({ id: event, mail_orga: userEmail }).first();
                if (!userIsOrga) {
                    res.status(400).json({ type: "error", error: 400, message: "user " + userEmail + " is not orga of event " + event });
                }
                else {
                    // verif if attendee exist with id_event and mail_user
                    const attendee = await db('Attendee').where({ id_event: event, mail_user: attendee_mail }).first();
                    if (attendee) {
                        res.status(400).json({ type: "error", error: 400, message: "bad request", details: "attendee already exist" });
                    }
                    else {
                        // verif if event exist
                        const eventExist = await db('Event').where({ id: event }).first();
                        if (!eventExist) {
                            res.status(400).json({ type: "error", error: 400, message: "event " + event + " is no exist" });
                        }
                        else {
                            // add attendee
                            await db('Attendee').insert({ id_event: event, name_user: attendee_name, mail_user: attendee_mail, status: 0 });
                            const newAttendee = await db('Attendee').where({ id_event: event, name_user: attendee_name, mail_user: attendee_mail }).first();
                            res.status(200).json({ type: "success", message: "INVITE SUCCESS USER", attendee: newAttendee });

                        }
                    }
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


// get invite on waiting for user logged
router.get('/', async (req, res, next) => {
    try {
        // filter state
        const { state } = req.query;
        if (state != 0 && state != 1 && state != 2) {
            res.status(400).json({ type: "error", error: 400, message: "bad request", details: "state must be 0, 1 or 2" });
        }
        else {
            const userEmail = req.headers['user-mail'];
            const userInvites = await db.select('id_event', 'name_user', 'mail_user', 'status').from('Attendee').where({ mail_user: userEmail, status: state });
            if (!userInvites) {
                res.status(404).json({ type: "error", error: 404, message: "user " + userEmail + " don't have any invite" });
            } else {
                const eventDetails = await db.select('id', 'name', 'description', 'date', 'id_place').from('Event').whereIn('id', userInvites.map(invite => invite.id_event));
                const eventDetailsWithPlace = await Promise.all(eventDetails.map(async (event) => {
                    const id_place = event.id_place;
                    if (id_place) {
                        const place = await db.select('id', 'name', 'adress', 'lat', 'lon').from('Place').where({ id: id_place });
                        event.place = place;
                        const data = {
                            id_event: event.id,
                            name: event.name,
                            date: event.date,
                            place: {
                                id_place: place[0].id,
                                name: place[0].name,
                                adress: place[0].adress,
                                lat: place[0].lat,
                                lon: place[0].lon,
                            },
                        }
                        return data;
                    } else {
                        return event;
                    }
                }));
                const data = userInvites.map((invite) => {
                    const event = eventDetailsWithPlace.find(event => event.id_event === invite.id_event);
                    return {
                        status: invite.status,
                        event,
                    }
                });
                res.status(200).json({ mail_user: userEmail, events: data });
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
