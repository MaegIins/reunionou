const express = require('express');
const router = express.Router();
const db = require("../db_connection");
const { v4: uuidv4 } = require('uuid');
const axios = require('axios');

const Joi = require('joi')
    .extend(require('@joi/date'));


const jwt = require('jsonwebtoken');

const randtoken = require('rand-token');

// La clé secrète pour la signature
const secretKey = process.env.SECRET_KEY;



// Voir tous les events (uniquement participant ou organisateur)
router.get('/', async (req, res, next) => {
    try {
        let events;

        // Récupérer l'adresse e-mail donnée par le gateway
        const userEmail = req.headers['user-email'];
        console.log("userEmail", userEmail);

        // Trouver les événements auxquels l'utilisateur participe
        const attendingEvents = await db.select('id_event').from('Attendee').where({ mail_user: userEmail });

        // Extraire uniquement les ID d'événements
        const eventIds = attendingEvents.map(event => event.id_event);

        // Trouver les événements dont l'utilisateur est l'organisateur
        const organizedEvents = await db.select('id').from('Event').where({ mail_orga: userEmail });

        // Extraire uniquement les ID d'événements
        const organizedEventIds = organizedEvents.map(event => event.id);

        // Fusionner les tableaux d'ID d'événements
        const combinedEventIds = [...new Set([...eventIds, ...organizedEventIds])];

        // Récupérer les détails des événements auxquels l'utilisateur participe ou qu'il organise
        events = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').whereIn('id', combinedEventIds);
        if (!events) {
            res.status(404).json({ type: "error", error: 404, message: "events not found" });
        } else {
            let data = [];
            for (const event of events) {
                const id_place = event.id_place;
                const places = await db.select('id', 'name', 'adress', 'lat', 'lon').from('Place').where({ id: id_place });
                if (places && places.length > 0) {
                    data.push({
                        event: {
                            id_event: event.id,
                            name: event.name,
                            description: event.description,
                            date: event.date,
                            name_orga: event.name_orga,
                            mail_orga: event.mail_orga,
                            place: {
                                id_place: places[0].id,
                                name: places[0].name,
                                adress: places[0].adress,
                                lat: places[0].lat,
                                lon: places[0].lon,
                            }
                        },
                        links: { self: { href: "/events/" + event.id } }
                    });
                }
            }
            res.json({ type: "collection", count: events.length, events: data });
        }
    } catch (error) {
        console.error(error);
        next(error);
    }
});
// Voir un event avec son id
router.get('/:id', async (req, res, next) => {
    try {
        const { id } = req.params;
        const userEmail = req.headers['user-email'];

        // Si l'utilisateur participe à l'événement ou qu'il est l'organisateur
        const attendingEvent = await db.select('id_event').from('Attendee').where({ mail_user: userEmail, id_event: id });
        const organizedEvent = await db.select('id').from('Event').where({ mail_orga: userEmail, id: id });
        if (attendingEvent.length > 0 || organizedEvent.length > 0) {
            const event = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').where({ id }).first();
            const id_place = event.id_place;
            if (!event) {
                res.status(404).json({ type: "error", error: 404, message: "event not found " + req.originalUrl });
            } else {
                if (id_place) {
                    const places = await db.select('id', 'name', 'adress', 'lat', 'lon').from('Place').where({ id: id_place });
                    res.status(200).json({
                        event: {
                            id_event: event.id,
                            name: event.name,
                            description: event.description,
                            date: event.date,
                            name_orga: event.name_orga,
                            mail_orga: event.mail_orga,
                            place: {
                                id_place: places[0].id,
                                name: places[0].name,
                                adress: places[0].adress,
                                lat: places[0].lat,
                                lon: places[0].lon,
                            }
                        }
                    });

                } else {
                    res.status(200).json({
                        event: {
                            id_event: event.id,
                            name: event.name,
                            description: event.description,
                            date: event.date,
                            name_orga: event.name_orga,
                            mail_orga: event.mail_orga,
                        }
                    });


                }
            }
        } else {
            res.status(403).json({ type: "error", error: 403, message: "access denied, user is not participating in this event" });
        }
    } catch (error) {
        console.error(error);
        next(error);
    }
});




const validUuid = Joi.string().guid().required();

const schema = Joi.object({
    title: Joi.string().max(100),
    description: Joi.string().max(256),
    name_orga: Joi.string().max(30),
    name_place: Joi.string().max(100),
    mail_orga: Joi.string().max(35).email(),
    street: Joi.string().max(100),
    city: Joi.string().max(50),
});

const dateJ = Joi.object({ date: Joi.date().format('YYYY-MM-DD').utc().greater('now') })

router.put('/:id', async (req, res, next) => {
    try {
        const { id } = req.params;
        const event = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').where({ id }).first();
        if (!event) {
            res.status(404).json({ type: "error", error: 404, message: "event not found " + req.originalUrl });
        } else {
            const { name, description, date, name_orga, mail_orga, id_place } = req.body;
            console.log(name, description, date, name_orga, mail_orga, id_place)
            // if (!name || !description || !date || !name_orga || !mail_orga || !id_place) {
            //     res.status(400).json({ type: "error", error: 400, message: "Bad request" });
            // } else {
            const result = await db('Event').where({ id }).update({ name, description, date, name_orga, mail_orga, id_place });
        };
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }
});




// uri share event with JWT token
router.get('/:id/share', async (req, res, next) => {
    try {
        const { id } = req.params;
        const event = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').where({ id }).first();
        if (!event) {
            res.status(404).json({ type: "error", error: 404, message: "event not found " + req.originalUrl });
        } else {
            const payload = { id: event.id };
            const token = jwt.sign(payload, secretKey, { expiresIn: '72h' });
            res.status(200).json({ type: "sucess", message: "URI Created", shared_uri: "/invites?key=" + token });
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});

router.get('/:id/attendees', async (req, res, next) => {
    try {
        const { id } = req.params;
        const userEmail = req.headers['user-email'];

        //verifie que l'utilisateur a renseigné un id d'event
        if (id !== undefined) {
            const result = validUuid.validate(id)
            //on regarde si id saisie est un uuid valide
            if (result.error) {
                //si non valide on renvoie une erreur
                res.status(404).json({ type: "error", error: 404, message: "Event not found : " + id });
            } else {
                const attendingEvent = await db.select('id_event').from('Attendee').where({ mail_user: userEmail, id_event: id });
                const organizedEvent = await db.select('id').from('Event').where({ mail_orga: userEmail, id: id });

                if (attendingEvent.length > 0 || organizedEvent.length > 0) {
                    const attendee = await db.select("name_user", "mail_user", "status").from('Attendee').where({ id_event: id })
                    if (attendee.length !== 0) {
                        res.status(200).json(attendee)
                    } else {
                        res.status(400).json({ type: "error", error: 404, message: "No attendee" });
                    }
                } else {
                    res.status(403).json({ type: "error", error: 403, message: "access denied, user is not participating in this event" });
                }
            }
        }
        else {
            res.status(400).json({ type: "error", error: 400, message: "The request is invalid" });
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});

/**
 * Route qui permet de créer un event
 * Les champs doivent etre rensigné obligatoirement : title, description, date/time, name_place, adress:street/city
 * Renseigner tjrs une adresse meme si le lieu existe deja
 */
router.post('/', async (req, res, next) => {
    try {
        console.log(req.body)
        if (req.body.title === undefined || req.body.description === undefined || req.body.date.date === undefined || req.body.date.time === undefined || req.body.name_place === undefined || req.body.adress.city === undefined || req.body.adress.street === undefined) {
            res.status(400).json({ type: "error", error: 400, message: "The request is invalid" });
        } else {
            try {
                const uuid = uuidv4();
                const date = new Date(req.body.date.date + "T" + req.body.date.time + ":00.000Z");
                const resdate = dateJ.validate({ date: date })
                // Permet la validation des valeurs présentes dans le body
                const result = await schema.validateAsync({ title: req.body.title, description: req.body.description, name_place: req.body.name_place, street: req.body.adress.street, city: req.body.adress.city });

                const mailOrga = req.headers['user-mail'];
                const nameOrga = req.headers['user-name'];

                if (resdate.error === undefined) {
                    if (result.error === undefined) {
                        //regarde si le lieu existe deja
                        const place = await db.select("id").from("Place").where({ name: req.body.name_place });
                        //si oui alors on utilise son id pour créer l'evenement
                        if (place[0] !== undefined) {
                            // Check if the event already exists at the same place and date
                            const existingEvent = await db.select('*')
                                .from('Event')
                                .where({ 'id_place': place[0].id, 'date': date });
                            if (existingEvent.length > 0) {
                                res.status(409).json({ type: "error", error: "409", message: "Event already exists at the same place and date" });
                            } else {
                                await db('Event').insert({
                                    'id': uuid,
                                    'name': req.body.title,
                                    'description': req.body.description,
                                    'date': date,
                                    'name_orga': nameOrga,
                                    'mail_orga': mailOrga,
                                    'id_place': place[0].id
                                });
                                try {
                                    await db('Attendee').insert({
                                        'id_event': uuid,
                                        'name_user': nameOrga,
                                        'mail_user': mailOrga,
                                        'status': 3,
                                    });
                                } catch (error) {
                                    res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
                                    next(error);
                                }
                                // Retourne un code 201 (created) et Location sur /events/{id}
                                res.status(201).set('Location', '/events/' + uuid).json({ type: "sucess", error: 201, message: "CREATED" });
                            }
                        } else {
                            // sinon on créer le lieu et on le ratache a l'événement

                            //api qui recup les coordonnées gps a partie d'une adress
                            if (req.body.adress.street == "null" || req.body.adress.city == "null") {
                                res.status(404).json({ type: "error", error: "404", message: "Adress incorrect" })
                            } else {
                                // axios and proxy with async/await and try/catch
                                try {
                                    const gps = await axios.get('https://nominatim.openstreetmap.org/search?street=' + req.body.adress.street.replace(/\s+/g, '+') + '&city=' + req.body.adress.city + '&format=json',
                                        {
                                            proxy: {
                                                protocol: 'http',
                                                host: 'www-cache.iutnc.univ-lorraine.fr',
                                                port: 3128
                                            }
                                        },
                                    );
                                    console.log(gps.data[0])

                                    if (gps.data[0] !== undefined) {
                                        let uuidPlace = uuidv4();

                                        //insertion du lieu
                                        await db('Place').insert({
                                            'id': uuidPlace,
                                            'name': req.body.name_place,
                                            'adress': req.body.adress.street + ", " + req.body.adress.city,
                                            'lat': gps.data[0].lat,
                                            'lon': gps.data[0].lon,
                                        })
                                        //insertion de l'evenement
                                        await db('Event').insert({
                                            'id': uuid,
                                            'name': req.body.title,
                                            'description': req.body.description,
                                            'date': date,
                                            'name_orga': nameOrga,
                                            'mail_orga': mailOrga,
                                            'id_place': uuidPlace
                                        });
                                        try {
                                            await db('Attendee').insert({
                                                'id_event': uuid,
                                                'name_user': nameOrga,
                                                'mail_user': mailOrga,
                                                'status': 3,
                                            });
                                        } catch (error) {
                                            res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
                                            next(error);
                                        }
                                        // Retourne un code 201 (created) et Location sur /events/{id}
                                        res.status(201).set('Location', '/events/' + uuid).json({ type: "sucess", error: 201, message: "CREATED" });
                                    } else {
                                        res.status(404).json({ type: "error", error: "404", message: "Adress incorrect" })
                                    }
                                } catch (error) {
                                    console.log(error)
                                    res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
                                    next(error);
                                }
                            }
                        }
                    } else {
                        res.status(400).json({ type: "error", error: "400", message: "Non-compliant data" })
                    }
                } else {
                    res.status(409).json({ type: "error", error: "409", message: "Passed date" })
                }
            }
            catch (err) {
                console.log(err)
                res.status(500).json(err);
            };
        }
    } catch (error) {
        console.log(error)
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});



module.exports = router;