const express = require('express');
const router = express.Router();
const db = require("../db_connection");
const { v4: uuidv4 } = require('uuid');


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
                    event: event,
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
            res.json({ type: "collection", count: allEvents.length, size: events.length, links: { next: { href: "/events?page=" + nextPage}, prev: { href: "/events?page=" + prevPage}, last: { href: "/events?page=" + lastPage}, first: { href: "/events?page=1" } }, events: data } );
        }

    } catch (error) {
        console.error(error);
        next(error);
    }

});

// GET events/:id
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
                res.status(200).json({ event: event, place: places });

            } else {
                res.status(200).json({ event: event });
            }
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "server error", details: error });
        next(error);
    }
});



const Joi = require('joi')
    .extend(require('@joi/date'));

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
        const { id } = req.params
        const commande = await db('commande').where({ id }).first();
        if (!commande) {
            res.status(404).json({ type: "error", error: 404, message: "la commande n'existe pas " + req.originalUrl });
        } else {
            const { nom, mail, livraison } = req.body;
            try {
                const result = await schema.validateAsync({ nom: nom, mail: mail, livraison: livraison });
                if (result) {
                    await db('commande').where({ id }).update({ nom, mail, livraison });
                    res.status(204).json({ type: "sucess", error: 204, message: "NO CONTENT" });
                }
            }
            catch (err) {
                res.status(500).json(err);

            };
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }
});

router.patch('/:id/payment', async (req, res, next) => {
    try {
        const { id } = req.params
        const commande = await db('commande').where({ id }).first();
        if (!commande) {
            res.status(404).json({ type: "error", error: 404, message: "la commande n'existe pas " + req.originalUrl });
        } else {
            const { moyen_de_paiement, paiement_date, status_commande } = req.body;
            try {
                const uuid = uuidv4();
                const result = await schema.validateAsync({ paiement_date: paiement_date });
                if (await db('mode_paiement').where({ id: moyen_de_paiement }).first() === undefined) return res.status(404).json({ type: "error", error: 404, message: "le mode de paiement n'existe pas " });
                if (result) {
                    await db('commande').where({ id }).update({ mode_paiement: moyen_de_paiement, date_paiement: paiement_date, ref_paiement: uuid, status: status_commande });
                    res.status(200).json({ type: "succes", message: "SUCCES" });
                }
            }
            catch (err) {
                res.status(500).json(err);

            };
        }
    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }
});



router.get('/:id/items', async (req, res, next) => {
    try {
        const { id } = req.params;
        const items = await db.select('id', 'uri', 'libelle', 'tarif', 'quantite').from('item').where({ command_id: id });
        if (!items) {
            res.status(404).json({ type: "error", error: 404, message: "La commande n'existe pas : " + req.originalUrl });
        } else {
            res.status(200).json({ type: "collection", count: items.length, items: items });
        }

    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }
});

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
                if (result.details !== undefined) {
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
                            });

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
