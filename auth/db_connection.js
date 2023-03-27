const knex = require('knex')({
    client: 'mysql',
    connection: {
        host: process.env.DB_AUTH_HOST,
        port: 3306,
        user: process.env.AUTH_DATABASE_USER,
        password: process.env.AUTH_DATABASE_PASSWORD,
        database: process.env.AUTH_DATABASE_ROOT_PASSWORD

    }
});

module.exports = knex;