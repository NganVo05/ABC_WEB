'use strict';
const utils = require('../utils');
const config = require('../../config');
const sql = require('mssql');

const listRestaurantsByPartnerID = async(ParnerID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('restaurants');
        const listRes = await pool.request()
                            .input('masothue', sql.Char(15), ParnerID)
                            .query(sqlQueries.listRestaurantsByPartnerID);
        return listRes.recordset;
    } catch (error) {
        return error.message;
    }
}

const addRestaurant = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('restaurants');
        const insert = await pool.request()
                            .input('macuahang', sql.Char(15), data.macuahang)
                            .input('masothue', sql.Char(15), data.masothue)
                            .input('stk', sql.Char(15), data.stk)
                            .input('nganhang', sql.NChar(35), data.nganhang)
                            .input('tenquan', sql.NChar(35), data.tenquan)
                            .input('giomocua', sql.VarChar(8), data.giomocua)
                            .input('giodongcua', sql.VarChar(8), data.giodongcua)
                            .input('tinhtrang', sql.NChar(20), data.tinhtrang)
                            .input('diachi', sql.NChar(50), data.diachi)
                            .query(sqlQueries.addRestaurant);                            
        return insert.recordset;
    } catch (error) {
        return error.message;
    }
}
const updateRestaurant = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('restaurants');
        const update = await pool.request()
                            .input('macuahang', sql.Char(15), data.macuahang)
                            .input('masothue', sql.Char(15), data.masothue)
                            .input('stk', sql.Char(15), data.stk)
                            .input('nganhang', sql.NChar(35), data.nganhang)
                            .input('giomocua', sql.VarChar(8), data.giomocua)
                            .input('giodongcua', sql.VarChar(8), data.giodongcua)
                            .input('tinhtrang', sql.NChar(20), data.tinhtrang)
                            .query(sqlQueries.updateRestaurant); 
        return update.recordset;
    } catch (error) {
        return error.message;
    }
}

const getRestaurantsByResID = async(ResID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('restaurants');
        const Res = await pool.request()
                            .input('macuahang', sql.Char(15), ResID)
                            .query(sqlQueries.getrestaurantbyresid);
        return Res.recordset;
    } catch (error) {
        return error.message;
    }
}
module.exports = {
    listRestaurantsByPartnerID, addRestaurant, updateRestaurant, getRestaurantsByResID
}