'use strict';
const utils = require('../utils');
const config = require('../../config');
const sql = require('mssql');


const getOneStore = async(StoreName) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('customer');
        const store = await pool.request()
                            .input('NAME', sql.NChar(35), StoreName)
                            .query(sqlQueries.getStoreByName);
        return store.recordset;
    } catch (error) {
        return error.message;
    }
}

const getOneDisk = async(DiskName) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('customer');
        const disk = await pool.request()
                            .input('NAME', sql.NVarChar(80), DiskName)
                            .query(sqlQueries.getDiskByName);
        return disk.recordset;
    } catch (error) {
        return error.message;
    }
}

const getOneOrders = async(UserID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('customer');
        const orderList = await pool.request()
                            .input('ID', sql.Char(15), UserID)
                            .query(sqlQueries.oneOrderList);
        return orderList.recordset;
    } catch (error) {
        return error.message;
    }
}

const postOneOrder = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('customer');
        const order = await pool.request()
                            .input('MADONHANG', sql.Char(15), data.MADONHANG)
                            .input('MAKH', sql.Char(15), data.MAKH)
                            .input('PHIVANCHUYEN', sql.Float, data.PHIVANCHUYEN)
                            .input('TINHTRANG', sql.NChar(20), data.TINHTRANG)
                            .input('DIACHI', sql.NChar(50), data.DIACHI)
                            .input('HINHTHUCTHANHTOAN', sql.NChar(15), data.HINHTHUCTHANHTOAN)
                            .input('TONGGIA', sql.Float, data.TONGGIA)
                            .input('DANHGIA', sql.Char(30), data.DANHGIA)
                            .query(sqlQueries.postOrder);
        return order.recordset;
    } catch (error) {
        return error.message;
    }
}

const postOneOrderStore = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('customer');
        const order = await pool.request()
                            .input('MADONHANG', sql.Char(15), data.MADONHANG)
                            .input('MACH', sql.Char(15), data.MACH)
                            .query(sqlQueries.postOrderStore);
        return order.recordset;
    } catch (error) {
        return error.message;
    }
}

const postOneOrderDetail = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('customer');
        const order = await pool.request()
                            .input('MADONHANG', sql.Char(15), data.MADONHANG)
                            .input('TENMON', sql.NChar(80), data.TENMON)
                            .input('DONGIA', sql.Float, data.DONGIA)
                            .input('SOLUONG', sql.Int, data.SOLUONG)
                            .query(sqlQueries.postOrderDetail);
        return order.recordset;
    } catch (error) {
        return error.message;
    }
}

const postOneFeedback = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('customer');
        const feedback = await pool.request()
                            .input('MADONHANG', sql.Char(15), data.MADONHANG)
                            .input('MAKH', sql.Char(15), data.MAKH)
                            .input('DANHGIA', sql.Char(30), data.DANHGIA)
                            .query(sqlQueries.postFeedback);
        return feedback.recordset;
    } catch (error) {
        return error.message;
    }
}

const createCustomer = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('customer');
        const insert = await pool.request()
                            .input('makh'   , sql.Char(15), data.MAKH)
                            .input('hoten'  , sql.NChar(30), data.HOTEN)
                            .input('email'  , sql.Char(50), data.EMAIL)
                            .input('mk'     , sql.Char(20), data.MK)
                            .input('sdt'    , sql.Char(15), data.SDT)
                            .input('diachi' , sql.NChar(50), data.DIACHI)
                            .query(sqlQueries.createCustomer);                            
        return insert.recordset;
    } catch (error) {
        return error.message;
    }
}

module.exports = {
    getOneStore, getOneDisk, getOneOrders, postOneFeedback, postOneOrder, postOneOrderDetail,
    postOneOrderStore, createCustomer
}   