const express = require('express');
const router = express.Router();
const db = require("../db_connection");
const { v4: uuidv4 } = require('uuid');


// get places
router.get('/', async (req, res, next) => {
    try {
        const places = await db.select('id', 'name', 'adress', 'lat', 'lon').from('Place');
        if (!places) {
            res.status(404).json({ type: "error", error: 404, message: "places not found" });
        } else {
            let data = [];
            places.forEach(place => {
                data.push({
                    place: {
                        id_place: place.id,
                        name: place.name,
                        adress: place.adress,
                        lat: place.lat,
                        lon: place.lon,
                    }
                })
            });
            res.json({ type: "collection", count: places.length, places: data });
        }
    } catch (error) {
        console.error(error);
        next(error);
    }
});

module.exports = router;
