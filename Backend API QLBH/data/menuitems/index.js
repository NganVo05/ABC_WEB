'use strict';
const utils = require('../utils');
const config = require('../../config');
const sql = require('mssql');

const getMenuItemByName = async(name) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('menuitems');
        const menuitem = await pool.request()
                            .input('tenmon', sql.Char(15), name)
                            .query(sqlQueries.getmenuitembyname);
        return menuitem.recordset;
    } catch (error) {
        return error.message;
    }
}

const addMenuItem = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('menuitems');
        const insert = await pool.request()
                            .input('tenmon', sql.NChar(80), data.tenmon)
                            .input('mieuta', sql.NChar(30), data.mieuta)
                            .input('gia', sql.Float, data.gia)
                            .input('tinhtrang', sql.NChar(20), data.tinhtrang)
                            .input('ghichu', sql.NChar(50), data.ghichu)
                            .input('masothue', sql.Char(15), data.masothue)
                            .query(sqlQueries.addmenuitem);                            
        return insert.recordset;
    } catch (error) {
        return error.message;
    }
}

const deleteMenuItem = async (tenmon) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('menuitems');
        const deleteitem = await pool.request()
                            .input('tenmon', sql.NChar(80), tenmon)
                            .query(sqlQueries.deletemenuitem);
        return deleteitem.recordset;
    } catch (error) {
        return error.message;
    }
}

const updateMenuItem = async (tenmon, data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('menuitems');
        const update = await pool.request()
                            .input('tenmon', sql.NChar(80), tenmon)
                            .input('mieuta', sql.NChar(30), data.MIEUTA)
                            .input('gia', sql.Float, data.GIA)
                            .input('tinhtrang', sql.NChar(20), data.TINHTRANG)
                            .input('sldaban', sql.Int, data.SLDABAN)
                            .input('ghichu', sql.NChar(50), data.GHICHU)
                            .query(sqlQueries.updatemenuitem);
        return update.recordset;
    } catch (error) {
        return error.message;
    }

}
module.exports = {
    addMenuItem, deleteMenuItem, getMenuItemByName, updateMenuItem
}