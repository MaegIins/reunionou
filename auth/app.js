const express = require('express');
const logger = require('morgan');
const helmet = require("helmet");

const indexRouter = require('./routes/index');
const usersRouter = require('./routes/users');
const signupRouter = require('./routes/signup');
const signinRouter = require('./routes/signin');
const validateRouter = require('./routes/validate');
const refreshRouter = require('./routes/refresh');

const app = express();

const env = process.env.NODE_ENV;

app.use(helmet());

if (env === "development")
    app.use(logger('dev'));

app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/signup', signupRouter);
app.use('/signin', signinRouter);
app.use('/validate', validateRouter);
app.use('/refresh', refreshRouter);

// 404 
app.use((req, res, next) => {
    res.status(404).json({type: "error", error: 404, message: "not found " + req.originalUrl});
});

module.exports = app;
