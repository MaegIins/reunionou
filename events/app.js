const express = require('express');
const logger = require('morgan');
const helmet = require("helmet");

const indexRouter = require('./routes/index');
const ordersRouter = require('./routes/events');
const placesRouter = require('./routes/places');
const invitesRouter = require('./routes/invites');

const app = express();

const env = process.env.NODE_ENV;

app.use(helmet());

if (env === "development")
    app.use(logger('dev'));

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/', indexRouter);
app.use('/events', ordersRouter);
app.use('/places', placesRouter);
app.use('/invites', invitesRouter);

// 404 
app.use((req, res, next) => {
    res.status(404).json({type: "error", error: 404, message: "not found " + req.originalUrl});
});

module.exports = app;
