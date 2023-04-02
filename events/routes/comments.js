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

});

/**
 * Ajoute un commentaire a un evenement verifie si l'utilisateur qui saisie le commentaire participe a l'evenement
 * Exemple de body remplir id_event et mail_attendee :
 * {
    "id_event":"",
    "mail_attendee":"",
    "date":{
        "date":"2023-03-29",
        "time":"16:56"
    },
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
                let result = await schema.validateAsync({ id_event: req.body.id_event, mail_attendee: userEmail, date: date, text: req.body.text });
                if (result) {
                    //regarde si l'utilisateur est asscoier au bon id_event
                    const attendee = await db.select("id").from("Attendee").where({ id_event: req.body.id_event, mail_user: userEmail });
                    //si oui alors on utilise son id pour créer le commentaires
                    if (attendee[0] !== undefined) {
                        const uuid = uuidv4();

                        await db('Comments').insert({
                            'id': uuid,
                            'id_event': req.body.id_event,
                            'id_attendee': attendee[0].id,
                            'text': req.body.text,
                            'date': date,

                        });
                        res.status(201).set('Location', '/comments/events/' + req.body.id_event).json({ type: "sucess", error: 201, message: "CREATED" });
                        // Retourne un code 201 (created) et Location sur /events/{id}
                    } else {
                        res.status(404).json({ type: "error", error: "404", message: "Attendee not associate at this event" })
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
