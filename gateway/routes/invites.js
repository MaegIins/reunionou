const express = require('express');
const router = express.Router();
const axios = require('axios');


router.get('/', async (req, res, next) => {
  try {
    await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
    try {
      await axios.get('http://directus:8055/items/sandwiches')
        .then((response) => {
          res.status(200).json(response.data);
        })
        .catch((error) => {
          res.status(500).json(error.response.data);
        });
    }
    catch (err) {
      res.status(500).json(err);
    }
  }
  catch (err) {
    res.status(401).json(err.response.data);
  }
});

router.get('/:id', async (req, res, next) => {
  try {
    await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
    try {
      await axios.get('http://directus:8055/items/sandwiches/' + req.params.id)
        .then((response) => {
          res.status(200).json(response.data);
        })
        .catch((error) => {
          res.status(404).json(error.response.data);
        });
    }
    catch (err) {
      res.status(500).json(err);
    }
  }
  catch (err) {
    res.status(401).json(err.response.data);
  }
});

module.exports = router;
