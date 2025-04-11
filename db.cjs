const sql = require("mssql");
require("dotenv").config()

const config = {
    server: "DESKTOP-S10M3AT\\BARTENDER",
    user: "baiastan",
    password: "V146495c",
    database: "baias",
    port: parseInt(process.env.DB_PORT),
    options: {
        trustServerCertificate: true
      }
}

const poolPromise = new sql.ConnectionPool(config)
    .connect(sql)
    .then(pool => {
        console.log("Connected to db");
        return pool;
    })
    .catch(err => {
        console.log("Error connecting to db");
        console.log(err);
        return err;
    })

module.exports = {
    sql,
    poolPromise
}

