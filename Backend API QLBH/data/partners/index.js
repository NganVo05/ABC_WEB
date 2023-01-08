'use strict';
const utils = require('../utils');
const config = require('../../config');
const sql = require('mssql');

const getParners = async () => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const parnerslist = await pool.request().query(sqlQueries.parnerslist);
        console.log(parnerslist)
        return parnerslist.recordset;
    } catch (error) {
        console.log(error.message);
    }
}

const getParnerById = async(ParnerID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const parner = await pool.request()
                            .input('masothue', sql.Char(15), ParnerID)
                            .query(sqlQueries.getparnerbyid);
        return parner.recordset;
    } catch (error) {
        return error.message;
    }
}

const creatParner = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const insert = await pool.request()
                            .input('masothue', sql.Char(15), data.masothue)
                            .input('nguoidaidien', sql.NChar(30), data.nguoidaidien)
                            .input('email', sql.Char(30), data.email)
                            .input('tendoitac', sql.NChar(30), data.tendoitac)
                            .input('quan', sql.NChar(20), data.quan)
                            .input('slchinhanh', sql.Int, data.slchinhanh)
                            .input('sldonhangdukien', sql.Int, data.sldonhangdukien)
                            .input('loaiamthuc', sql.NChar(20), data.loaiamthuc)
                            .input('diachi', sql.NChar(50), data.diachi)
                            .input('sdt', sql.Char(15), data.sdt)
                            .input('thoigianhopdong', sql.Int, data.thoigianhopdong)
                            .query(sqlQueries.createparner);                            
        return insert.recordsets;
    } catch (error) {
        return error.message;
    }
}

const updateMenuItemForPartner = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const update = await pool.request()
                            .input('masothue', sql.Char(15), data.masothue)
                            .input('tenmon', sql.NChar(80), data.tenmon)
                            .input('mieuta', sql.NChar(30), data.mieuta)
                            .input('gia', sql.Float, data.gia)
                            .input('tinhtrang', sql.NChar(20), data.tinhtrang)
                            .input('sldaban', sql.Int, data.sldaban)
                            .input('ghichu', sql.NChar(50), data.ghichu)
                            .query(sqlQueries.updatemenuitem);
        return update.recordset;
    } catch (error) {
        return error.message;
    }
}

const getMenuItemByPartnerID = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const food = await pool.request()
                            .input('masothue', sql.Char(15), data.masothue)
                            .input('tenmon', sql.NChar(80), data.tenmon)
                            .query(sqlQueries.getmenuitembypartnerid);
        return food.recordset;
    } catch (error) {
        return error.message;
    }
}

const listContractByPartnerID = async(ParnerID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const contracts = await pool.request()
                            .input('masothue', sql.Char(15), ParnerID)
                            .query(sqlQueries.listcontractsbypartnerid);
        return contracts.recordset;
    } catch (error) {
        return error.message;
    }
}

const findFoodByName = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const listfoods = await pool.request()
                            .input('tenmon', sql.NVarChar(80), data.tenmon)
                            .input('masothue', sql.Char(15), data.masothue)
                            .query(sqlQueries.findfoodbyname);
        return listfoods.recordset;
    } catch (error) {
        return error.message;
    }
}

const addFoodForRestaurant = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const addfoodforres = await pool.request()
                            .input('masothue', sql.Char(15), data.masothue)
                            .input('macuahang', sql.Char(15), data.macuahang)
                            .input('tenmon', sql.NVarChar(80), data.tenmon)
                            .query(sqlQueries.addfoodforrestaurant);
        return addfoodforres.recordset;
    } catch (error) {
        return error.message;
    }
}

const listFoodForRestaurant = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const foods = await pool.request()
                            .input('masothue', sql.Char(15), data.masothue)
                            .input('macuahang', sql.Char(15), data.macuahang)
                            .query(sqlQueries.listfoodforrestaurant);
        return foods.recordset;
    } catch (error) {
        return error.message;
    }
}

const deleteFoodForRestaurant = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const deleteResult = await pool.request()
                            .input('tenmon', sql.NChar(80), data.tenmon)
                            .input('masothue', sql.Char(15), data.masothue)
                            .input('macuahang', sql.Char(15), data.macuahang)
                            .query(sqlQueries.deletefoodfromrestaurant);
        return deleteResult.recordset;
    } catch (error) {
        return error.message;
    }
}

const updatePassword = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('partners');
        const result = await pool.request()
                            .input('newpass', sql.Char(20), data.newpass)
                            .input('masothue', sql.Char(15), data.masothue)
                            .query(sqlQueries.updatepassword);
        return result.recordset;
    } catch (error) {
        return error.message;
    }
}
module.exports = {
    getParners, getParnerById, creatParner, updateMenuItemForPartner, getMenuItemByPartnerID,
    listContractByPartnerID, findFoodByName, addFoodForRestaurant, listFoodForRestaurant,
    deleteFoodForRestaurant, updatePassword
}