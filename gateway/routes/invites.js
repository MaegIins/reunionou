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



module.exports = router;
