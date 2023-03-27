const express = require('express');
const router = express.Router();

router.get('/', (req, res, next) => {
  res.json({ message: "Auth Service" });
});

module.exports = router;
