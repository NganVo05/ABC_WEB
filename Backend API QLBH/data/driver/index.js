'use strict';
const utils = require('../utils');
const config = require('../../config');
const sql = require('mssql');

const selectDriver = async(driverID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const driver = await pool.request()
                            .input('matx', sql.Char(15), driverID)
                            .query(sqlQueries.selectDriver);
        return driver.recordset;
    } catch (error) {
        return error.message;
    }
}
const selectDONCHO = async () => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const DONCHOlist = await pool.request().query(sqlQueries.selectDHCHO);
        return DONCHOlist.recordset;
    } catch (error) {
        console.log(error.message);
    }
}

const updateTINHTRANGCHO = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const result = await pool.request()
                            .input('madh', sql.Char(15), data.madh)
                            .input('matx', sql.Char(15), data.matx)
                            .query(sqlQueries.updateTINHTRANGCHO);
        return result.recordset;
    } catch (error) {
        console.log(error.message);
    }
}

const updateTINHTRANGDH = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const result = await pool.request()
                            .input('madh', sql.Char(15), data.madh)
                            .input('matx', sql.Char(15), data.matx)
                            .query(sqlQueries.updateTINHTRANGDH);
        return result.recordset;
    } catch (error) {
        console.log(error.message);
    }
}

const selectDHTHANHCONG = async (drvierID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const result = await pool.request()
                            .input('matx', sql.Char(15), drvierID)
                            .query(sqlQueries.selectDHThanhCong);
        return result.recordset;
    } catch (error) {
        console.log(error.message);
    }
}

const selectDHDANGGIAO = async (drvierID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const result = await pool.request()
                            .input('matx', sql.Char(15), drvierID)
                            .query(sqlQueries.selectDHDANGGIAO);
        return result.recordset;
    } catch (error) {
        console.log(error.message);
    }
}

const updateNOPPHI = async (drvierID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const result = await pool.request()
                            .input('matx', sql.Char(15), drvierID)
                            .query(sqlQueries.updateNOPPHI);
        return result.recordset;
    } catch (error) {
        console.log(error.message);
    }
}

const createDriver = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const insert = await pool.request()
                            .input('matx'               , sql.Char(15), data.MATX)
                            .input('cmnd'               , sql.Char(15), data.CMND)
                            .input('hoten'              , sql.NChar(30), data.HOTEN)
                            .input('sdt'                , sql.Char(15), data.SDT)
                            .input('bienso'             , sql.Char(15), data.BIENSO)
                            .input('khuvuchd'           , sql.NChar(30), data.KHUVUCHD)
                            .input('email'              , sql.Char(30), data.EMAIL)
                            .input('username'           , sql.Char(20), data.USERNAME)
                            .input('mk'                 , sql.Char(20), data.MK)
                            .input('stk'                , sql.Char(15), data.STK)
                            .input('phidk'              , sql.Float,    data.PHIDANGKY)
                            .input('tinhtrangnopphi'    , sql.NChar(10), data.TINHTRANGNOPPHI)
                            .query(sqlQueries.createDriver);                            
        return insert.recordset;
    } catch (error) {
        return error.message;
    }
}

const selectCTDH = async (billCode) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const result = await pool.request()
                            .input('madh', sql.Char(15), billCode)
                            .query(sqlQueries.selectCTDH);
        return result.recordsets;
    } catch (error) {
        console.log(error.message);
    }
}

const getDriverbyID = async(driverID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const driver = await pool.request()
                            .input('matx', sql.Char(15), driverID)
                            .query(sqlQueries.getdriverbyid);
        return driver.recordset;
    } catch (error) {
        return error.message;
    }
}

const updatePasswordDriver = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('driver');
        const result = await pool.request()
                            .input('newpass', sql.Char(20), data.newpass)
                            .input('matx', sql.Char(15), data.matx)
                            .query(sqlQueries.updatepassworddriver);
        return result.recordset;
    } catch (error) {
        return error.message;
    }
}
module.exports = {
    selectDriver, selectDONCHO, updateTINHTRANGCHO, updateTINHTRANGDH, 
    selectDHTHANHCONG, selectDHDANGGIAO, updateNOPPHI, createDriver,
    selectCTDH, getDriverbyID, updatePasswordDriver
}