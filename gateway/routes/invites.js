const express = require('express');
const router = express.Router();
const axios = require('axios');


// confirm invite
router.post('/confirm', async (req, res, next) => {
  try {
    await axios.post('http://events:3000/invites/confirm', req.body)
      .then((response) => {
        res.status(response.status).json(response.data);
      })
      .catch((error) => {
        res.status(error.response.status).json(error.response.data);
      });
  }
  catch (error) {
    res.status(500).json(error);
  }
});

router.get('/list', async (req, res, next) => {
  try {
    await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
      .then(async (response) => {
        const { mail: userMail } = response.data;
        await axios.get('http://events:3000/invites', { headers: { 'user-mail': userMail } })
          .then((response) => {
            res.status(response.status).json(response.data);
          })
          .catch((error) => {
            res.status(error.response.status).json(error.response.data);
          });
      })
      .catch((error) => {
        res.status(error.response.status).json(error.response.data);
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
        res.status(response.status).json(response.data);
      })
      .catch((error) => {
        res.status(error.response.status).json(error.response.data);
      });
  }
  catch (error) {
    res.status(500).json(error);
  }
});

// invite a existing user
router.post('/user', async (req, res, next) => {
  try {
    await axios.get('http://auth:3000/validate', { headers: { 'Authorization': req.headers.authorization } })
      .then(async (response) => {
        const { mail: userMail } = response.data;
        const { event, mail } = req.body;
        if (!event || !mail) {
          res.status(400).json({ type: "error", error: 400, message: "missing event or mail parameter" });
        }
        else {
          await axios.post('http://auth:3000/users/search', { mail })
            .then((response) => {
              // user exist
              if (response.status === 200) {
                const attendee_mail = response.data.user_mail;
                const attendee_name = response.data.user_name;

                // invite user
                axios.post('http://events:3000/invites/user', { event, attendee_mail, attendee_name }, { headers: { 'user-mail': userMail } })
                  .then((response) => {
                    res.status(response.status).json(response.data);
                  })
                  .catch((error) => {
                    res.status(error.response.status).json(error.response.data);
                  });
              }
              else {
                res.status(response.status).json(response.data);
              }
            })
            .catch((error) => {
              res.status(error.response.status).json(error.response.data);
            });
        }
      })
      .catch((error) => {
        res.status(error.response.status).json(error.response.data);
      });
  }
  catch (error) {
    res.status(500).json(error);
  }
});



module.exports = router;
