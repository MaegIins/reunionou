const express = require('express');
const router = express.Router();
const db = require("../db_connection");
const { v4: uuidv4 } = require('uuid');

const Joi = require('joi')
    .extend(require('@joi/date'));


const jwt = require('jsonwebtoken');

const randtoken = require('rand-token');

// La clé secrète pour la signature
const secretKey = process.env.SECRET_KEY;



// Voir tous les events
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

        // Récupérer les détails des événements auxquels l'utilisateur participe
        events = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').whereIn('id', eventIds);

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
        const event = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').where({ id }).first();
        const id_place = event.id_place;

        if (!event) {
            res.status(404).json({ type: "error", error: 404, message: "event not found " + req.originalUrl });
            // affiche lien de la ressource
        } else {
            if (id_place) {
                const places = await db.select('id', 'name', 'adress', 'lat', 'lon').from('Place').where({ id: id_place });
                const data = {
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
                        },
                    },
                }
                res.status(200).json(data);

            } else {
                res.status(200).json({ event: event });
            }
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});

//Get all the comments from a 
router.get('/:id/comments', async (req, res, next) => {

    try {
        const { id } = req.params;

        //verifie que l'utilisateur a renseigner un id d'event
        if (id !== undefined) {
            const result = validUuid.validate(id)
            //on regarde si id saisie est un uuid valide
            if (result.error) {
                //si non valide on renvoie une erreur
                res.status(404).json({ type: "error", error: 404, message: "Event not found : " + id });
            } else {
                //sinon on interroge la base de données 
                const attendee = await db.select("id_attendee", "text", "date").from('Comments').where({ id_event: id })

                //on regarde si il y a des commentaires dans l'evenement
                if (attendee.length !== 0) {//si oui on retourne les commentaires
                    res.status(200).json(attendee)
                } else { //sinon on renvoie une erreur
                    res.status(400).json({ type: "error", error: 404, message: "No comments" });
                }
            }
        } else {//l'id n'est pas renseigné
            res.status(400).json({ type: "error", error: 400, message: "The request is invalid" });
        }

    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }
})




const validUuid = Joi.string().guid().required();

const schema = Joi.object({
    title: Joi.string().max(100),
    description: Joi.string().max(256),
    date: Joi.date().format('YYYY-MM-DD').utc(),
    name_orga: Joi.string().max(30),
    name_place: Joi.string().max(100),
    mail_orga: Joi.string().max(35).email(),
});

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

        //verifie que l'utilisateur a renseigner un id d'event
        if (id !== undefined) {
            const result = validUuid.validate(id)
            //on regarde si id saisie est un uuid valide
            if (result.error) {
                //si non valide on renvoie une erreur
                res.status(404).json({ type: "error", error: 404, message: "Event not found : " + id });
            } else {
                //sinon on interroge la base de données 
                const attendee = await db.select("name_user", "mail_user", "status").from('Attendee').where({ id_event: id })

                //on regarde si il y a des participant dans l'evenement
                if (attendee.length !== 0) {//si oui on retourne les participants
                    res.status(200).json(attendee)
                } else { //sinon on renvoie une erreur
                    res.status(400).json({ type: "error", error: 404, message: "No attendee" });
                }
            }
        } else {//l'id n'est pas renseigné
            res.status(400).json({ type: "error", error: 400, message: "The request is invalid" });
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});

/**
 * Route qui permet de créer un event
 * Les champs doivent etre rensigné obligatoirement : title, description, date/time, name_orga, name_place, mail_orga
 * Si le name_place n'existe pas dans la base => on créé une nouvelle place avec l'adresse qu'il faut alors renseigné : street/ city
 * Donc l'adress est nécessaire si la place n'existe pas 
 */
router.post('/', async (req, res, next) => {
    try {
        if (req.body.title === undefined || req.body.description === undefined || req.body.date.date === undefined || req.body.date.time === undefined || req.body.name_orga === undefined || req.body.name_place === undefined || req.body.mail_orga === undefined) {
            res.status(400).json({ type: "error", error: 400, message: "The request is invalid" });
        } else {
            try {
                const uuid = uuidv4();

                const date = new Date(req.body.date.date + "T" + req.body.date.time + ":00.000Z");
                // Permet la validation des valeurs présentes dans le body
                const result = await schema.validateAsync({ title: req.body.title, description: req.body.description, date: date, name_orga: req.body.name_orga, name_place: req.body.name_place, mail_orga: req.body.mail_orga });
                console.log(result.error)
                if (result.error === undefined) {
                    //regarde si le lieu existe deja
                    const place = await db.select("id").from("Place").where({ name: req.body.name_place });
                    //si oui alors on utilise son id pour créer l'evenement
                    if (place[0] !== undefined) {
                        await db('Event').insert({
                            'id': uuid,
                            'name': req.body.title,
                            'description': req.body.description,
                            'date': date,
                            'name_orga': req.body.name_orga,
                            'mail_orga': req.body.mail_orga,
                            'id_place': place[0].id
                        });
                        //null quand l'utilisateur n'a pas saisie d'adresse
                    } else if (req.body.adress.street !== null || req.body.adress.city !== null) {
                        // sinon on créer le lieu et on le ratache a l'événement

                        //api qui recup les coordonnées gps a partie d'une adress
                        const gps = await fetch('https://nominatim.openstreetmap.org/search?street=+' + req.body.adress.street.replace(/\s+/g, '+') + '&city=' + req.body.adress.city + '&format=json')
                        const data = await gps.json()
                        if (data.length !== 0) {
                            let uuidPlace = uuidv4();

                            //insertion du lieu
                            await db('Place').insert({
                                'id': uuidPlace,
                                'name': req.body.name_place,
                                'adress': req.body.adress.street + ", " + req.body.adress.city,
                                'lat': data[0].lat,
                                'lon': data[0].lon,
                            })
                            //insertion de l'evenement
                            await db('Event').insert({
                                'id': uuid,
                                'name': req.body.title,
                                'description': req.body.description,
                                'date': date,
                                'name_orga': req.body.name_orga,
                                'mail_orga': req.body.mail_orga,
                                'id_place': uuidPlace
                            });
                            // Retourne un code 201 (created) et Location sur /events/{id}
                            res.status(201).set('Location', '/events/' + uuid).json({ type: "sucess", error: 201, message: "CREATED" });
                        } else {
                            res.status(404).json({ type: "error", error: "404", message: "Adress not found" })
                        }
                    } else {
                        res.status(400).json({ type: "error", error: "400", message: "The request is invalid" })
                    }
                } else {
                    console.log(result)
                    res.status(400).json({ type: "error", error: "400", message: "Non-compliant data" })
                }
            }
            catch (err) {
                console.log(err)
                res.status(500).json(err);

            };
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }
})


module.exports = router;
