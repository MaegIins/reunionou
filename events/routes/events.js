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
            res.json({ type: "collection", count: allEvents.length, size: events.length, links: { next: { href: "/events?page=" + nextPage }, prev: { href: "/events?page=" + prevPage }, last: { href: "/events?page=" + lastPage }, first: { href: "/events?page=1" } }, events: data });
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



const Joi = require('joi')
    .extend(require('@joi/date'));

const schema = Joi.object({
    nom: Joi.string().max(30),
    mail: Joi.string().max(20).email(),
    livraison: Joi.date().format('YYYY-MM-DD').utc(),
    paiement_date: Joi.date().format('YYYY-MM-DD HH:mm').utc(),
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
