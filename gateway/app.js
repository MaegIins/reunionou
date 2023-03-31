const express = require('express');
const logger = require('morgan');
const helmet = require("helmet");
var cors = require('cors');

const indexRouter = require('./routes/index');
const authRouter = require('./routes/auth');
const eventsRouter = require('./routes/events');
const invitesRouter = require('./routes/invites');
const placesRouter = require('./routes/places');
const commentsRouter = require('./routes/comments');


const app = express();
app.use(cors());

const env = process.env.NODE_ENV;

app.use(helmet());

if (env === "development")
    app.use(logger('dev'));

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/', indexRouter);
app.use('/auth', authRouter);
app.use('/events', eventsRouter);
app.use('/invites', invitesRouter);
app.use('/places', placesRouter);
app.use('/comments', commentsRouter);


// 404 
app.use((req, res, next) => {
    res.status(404).json({type: "error", error: 404, message: "ressource non disponible " + req.originalUrl});
});

module.exports = app;
