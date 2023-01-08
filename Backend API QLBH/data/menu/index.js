'use strict';
const utils = require('../utils');
const config = require('../../config');
const sql = require('mssql');

const getMenuByPartner = async(ParnerID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('menu');
        const menu = await pool.request()
                            .input('masothue', sql.Char(15), ParnerID)
                            .query(sqlQueries.getmenubypartner);
        return menu.recordset;
    } catch (error) {
        return error.message;
    }
}


module.exports = {
    getMenuByPartner
}