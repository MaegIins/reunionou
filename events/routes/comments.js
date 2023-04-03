const express = require('express');
const router = express.Router();
const db = require("../db_connection");
const { v4: uuidv4 } = require('uuid');

const Joi = require('joi')
    .extend(require('@joi/date'));


const jwt = require('jsonwebtoken');


const validUuid = Joi.string().guid().required();

const schema = Joi.object({
    id_event: Joi.string().guid().required(),
    mail_attendee: Joi.string().max(35).email(),
    date: Joi.date().format('YYYY-MM-DD').utc(),
    text: Joi.string().max(256),
});


//list all the comments 
router.get('/events/:id', async (req, res, next) => {
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
                // vérifie si l'utilisateur est bien inscrit à l'événement ou si il est l'organisateur
                const userEmail = req.headers['user-mail'];
                const user = await db('Attendee').where({ id_event: id, mail_user: userEmail });
                const organizer = await db('Event').where({ id: id, mail_orga: userEmail });
                if (user.length === 0 && organizer.length === 0) {
                    res.status(403).json({ type: "error", error: "403", message: "Attendee not associate at this event" })
                } else {
                    //sinon on interroge la base de données 
                    const attendee = await db.select("id_attendee", "text", "date").from('Comments').where({ id_event: id })

                    if (attendee.length !== 0) {
                        for (let i = 0; i < attendee.length; i++) {
                            const user = await db.select("name_user").from('Attendee').where({ id: attendee[i].id_attendee })
                            attendee[i].username = user[0].name_user
                        }
                        res.status(200).json(attendee);
                    } else { //sinon on renvoie une erreur
                        res.status(400).json({ type: "error", error: 404, message: "No comments" });
                    }
                }
            }
        } else {//l'id n'est pas renseigné
            res.status(400).json({ type: "error", error: 400, message: "The request is invalid" });
        }

    } catch (error) {
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }

});

/**
 * Ajoute un commentaire a un evenement verifie si l'utilisateur qui saisie le commentaire participe a l'evenement
 * Exemple de body remplir id_event et mail_attendee :
 * {
    "id_event":"",
    "text":"Super evenement, j'espère pouvoir recommencer"
}
 */
router.post('/add', async (req, res, next) => {

    try {
        if (req.body.id_event === undefined || req.body.text === undefined) {
            res.status(400).json({ type: "error", error: 400, message: "The request is invalid" });
        } else {

            try {
                const userEmail = req.headers['user-mail'];
                console.log(userEmail)
                console.log(req.body)
                const date = new Date().toISOString().slice(0, 19).replace('T', ' ');
                let result = await schema.validateAsync({ id_event: req.body.id_event, mail_attendee: userEmail, text: req.body.text });
                if (result) {
                    //regarde si l'utilisateur est asscoier au bon id_event
                    const attendee = await db.select("id").from("Attendee").where({ id_event: req.body.id_event, mail_user: userEmail });
                    //si oui alors on utilise son id pour créer le commentaires
                    if (attendee.length !== 0) {
                        const uuid = uuidv4();

                        await db('Comments').insert({
                            'id': uuid,
                            'id_event': req.body.id_event,
                            'id_attendee': attendee[0].id,
                            'text': req.body.text,
                            'date': date,

                        });
                        res.status(201).set('Location', '/comments/events/' + req.body.id_event).json({ type: "sucess", message: "CREATED" });
                        // Retourne un code 201 (created) et Location sur /events/{id}
                    } else {
                        res.status(403).json({ type: "error", error: "403", message: "Attendee not associate at this event" })
                    }
                }
            } catch (error) {
                console.log(error)
                res.status(400).json({ type: "error", error: "400", message: "Non-compliant data" })

            }
        }
    } catch (error) {
        console.log(error)
        res.status(500).json({ type: "error", error: 500, message: "erreur serveur", details: error });
        next(error);
    }

});

module.exports = router;
