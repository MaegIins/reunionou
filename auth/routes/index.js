const express = require('express');
const router = express.Router();

router.get('/', (req, res, next) => {
  res.json({ message: "API Auth Service" });
});

module.exports = router;
