const express = require('express');
const router = express.Router();
const db = require("../db_connection");
const { v4: uuidv4 } = require('uuid');

const Joi = require('joi')
    .extend(require('@joi/date'));

const schema = Joi.object({
    nom: Joi.string().max(30),
    mail: Joi.string().max(20).email(),
    livraison: Joi.date().format('YYYY-MM-DD').utc(),
    paiement_date: Joi.date().format('YYYY-MM-DD HH:mm').utc(),
});

const jwt = require('jsonwebtoken');

const randtoken = require('rand-token');

// La clé secrète pour la signature
const secretKey = process.env.SECRET_KEY;



// Voir tous les events
router.get('/', async (req, res, next) => {
    try {
        let page = req.query.page;
        if (page < 1 || !page) {
            page = 1;
        }
        const limit = 10;
        let events;
        const allEvents = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event');
        if (page > Math.ceil(allEvents.length / limit)) {
            page = Math.ceil(allEvents.length / limit);
        }
        events = await db.select('id', 'name', 'description', 'date', 'name_orga', 'mail_orga', 'id_place').from('Event').limit(limit).offset((page - 1) * limit);

        if (!events) {
            res.status(404).json({ type: "error", error: 404, message: "events not found" });
            // res.sendStatus(404);
            //  next();
        } else {
            // Affiche les données
            let data = [];
            events.forEach(event => {
                data.push({
                    event: {
                        id_event: event.id,
                        name: event.name,
                        description: event.description,
                        date: event.date,
                        attendee_name: event.name_orga,
                        attendee_mail: event.mail_orga,
                        place: event.id_place,
                    },
                    links: { self: { href: "/events/" + event.id } }
                })
            });
            let nextPage = parseInt(page) + 1;
            let prevPage = page - 1;
            let lastPage = Math.ceil(allEvents.length / limit);
            if (prevPage < 1) {
                prevPage = 1;
            }
            if (nextPage > lastPage) {
                nextPage = lastPage;
            }
            res.json({ type: "collection", count: allEvents.length, size: events.length, links: { next: { href: "/events?page=" + nextPage }, prev: { href: "/events?page=" + prevPage }, last: { href: "/events?page=" + lastPage }, first: { href: "/events?page=1" } }, events: data });
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
                        attendee_name: event.name_orga,
                        attendee_mail: event.mail_orga,
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

// Update event
router.patch('/:id', async (req, res, next) => {
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

                if (result) {
                    res.status(201).set('Location', '/events/' + id).json({ type: "sucess", error: 201, message: "CREATED" });

                } else {
                    res.status(500).json({ type: "error", error: 500, message: "server error" });
                }
            }
        // }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
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
            const token = jwt.sign( payload, secretKey, { expiresIn: '72h' });
            res.status(200).json({ type: "sucess", message: "URI Created", shared_uri: "/invites?key=" + token });
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});



router.post('/', async (req, res, next) => {
    try {
        if (req.body.nom === undefined || req.body.mail === undefined || req.body.delivery === undefined || req.body.delivery.date === undefined || req.body.delivery.time === undefined) {
            res.status(400).json({ type: "error", error: 400, message: "La requête est invalide" });
        } else {
            try {
                const uuid = uuidv4();
                let montant = 0.0;
                const created_at = new Date();
                const fullDateDelivery = new Date(req.body.delivery.date + "T" + req.body.delivery.time + ":00.000Z");
                // Permet la validation des valeurs présentes dans le body
                const result = await schema.validateAsync({ nom: req.body.nom, mail: req.body.mail, livraison: req.body.delivery.date });

                if (result) {
                    // Ajoute la commande en base de données
                    await db('commande').insert({
                        'id': uuid,
                        'created_at': created_at,
                        'livraison': fullDateDelivery,
                        'nom': req.body.nom,
                        'mail': req.body.mail,
                        'montant': montant
                    });
                }
                if (req.body.items) {
                    // Ajoute tous les items présents dans le body en base de données
                    req.body.items.forEach(async (item) => {
                        montant += item.price;
                        await db('item').insert({
                            'uri': item.uri,
                            'libelle': item.name,
                            'tarif': item.price,
                            'quantite': item.quantite,
                            'command_id': uuid
                        });
                    });
                    console.log(montant);
                    // Modifie le champ montant dans la base de données
                    await db('commande').where({ id: uuid }).update({
                        'montant': montant
                    });
                }

                // Retourne un code 201 (created) et Location sur /orders/{id}
                res.status(201).set('Location', '/orders/' + uuid).json({ type: "sucess", error: 201, message: "CREATED" });
            }
            catch (err) {
                res.status(500).json(err);

            };
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }
})


module.exports = router;
