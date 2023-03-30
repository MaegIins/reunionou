const express = require('express');
const router = express.Router();
const axios = require('axios');


// confirm invite
router.post('/confirm', async (req, res, next) => {
    try {
      await axios.post('http://events:3000/invites/confirm', req.body)
        .then((response) => {
          res.json(response.data);
        })
        .catch((error) => {
          res.status(404).json(error.response.data);
        });
    }
    catch (error) {
      res.status(500).json(error);
    }
  });

  // get details of an event
router.get('/', async (req, res, next) => {
    try {
      const { key } = req.query;
          await axios.get('http://events:3000/invites/details', { params: { key } })
            .then((response) => {
              res.json(response.data);
            })
            .catch((error) => {
              res.status(404).json(error.response.data);
            });
    }
    catch (error) {
      res.status(500).json(error);
    }
  });
  


module.exports = router;
