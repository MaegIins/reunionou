const express = require('express');
const router = express.Router();

router.get('/', (req, res, next) => {
  res.json({ message: "Events Service" });
});

module.exports = router;
