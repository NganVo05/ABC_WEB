'use strict';
const utils = require('../utils');
const config = require('../../config');
const sql = require('mssql');

const NVLietKeHopDong = async () => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const list = await pool.request().query(sqlQueries.lietkehopdong);
        return list.recordset;
    } catch (error) {
        console.log(error.message);
    }
}
const updateNVDuyetHD = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const update = await pool.request()
                            .input('manv', sql.Char(15), data.manv)
                            .input('mahd', sql.Char(15), data.mahd)
                            .input('masothue', sql.Char(15), data.masothue)
                            .query(sqlQueries.updatenvduyethd); 
        return update.recordset;
    } catch (error) {
        return error.message;
    }
}
const lietKeHopDongPhuTrach = async(staffID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const list = await pool.request()
                            .input('manv', sql.Char(15), staffID)
                            .query(sqlQueries.lietkehopdongphutrach);
        return list.recordset;
    } catch (error) {
        return error.message;
    }
}
const thongkeHD = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const list = await pool.request()
                            .input('masothue', sql.Char(15),data.MASOTHUE)
                            .input('ngaythangnam', sql.DateTime,data.NGAYTHANGNAM)
                            .input('loai', sql.VarChar(10),data.LOAI)
                            .query(sqlQueries.thongkehd);
        return list.recordset;
    } catch (error) {
        return error.message;
    }
}
const createStaff = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const insert = await pool.request()
                            .input('manv'       , sql.Char(15), data.MANV)
                            .input('cmnd'       , sql.Char(15), data.CMND)
                            .input('hoten'      , sql.NChar(30), data.HOTEN)
                            .input('diachi'     , sql.NChar(50), data.DIACHI)
                            .input('stk'        , sql.Char(15), data.STK)
                            .input('email'      , sql.Char(50), data.EMAIL)
                            .input('mk'         , sql.Char(20), data.MK)
                            .input('sdt'        , sql.Char(15), data.SDT)
                            .query(sqlQueries.createstaff);                            
        return insert.recordset;
    } catch (error) {
        return error.message;
    }
}
const lietKeNhanVienQL = async(staffID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const list = await pool.request()
                            .input('manv', sql.Char(15), staffID)
                            .query(sqlQueries.danhsachnvql);
        return list.recordset;
    } catch (error) {
        return error.message;
    }
}
const lietkeDanhSachNVDuyet = async () => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const list = await pool.request().query(sqlQueries.danhsachnvduyet);
        return list.recordset;
    } catch (error) {
        console.log(error.message);
    }
}

const duyetNhanVien = async(data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const result = await pool.request()
                            .input('nvduyet', sql.Char(15), data.nvduyet)
                            .input('nv', sql.Char(15), data.nv)
                            .query(sqlQueries.nhanvienduyetnv);
        return result.recordset;
    } catch (error) {
        return error.message;
    }
}

const NV_capnhatthongtin = async (data) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const update = await pool.request()
                            .input('manv', sql.Char(15), data.manv)
                            .input('diachi', sql.NChar(50), data.diachi)
                            .input('stk', sql.Char(15), data.stk)
                            .input('email', sql.Char(30), data.email)
                            .input('mk', sql.Char(20), data.mk)
                            .input('sdt', sql.Char(15), data.sdt)
                            .query(sqlQueries.capnhatthongtin); 
        return update.recordset;
    } catch (error) {
        return error.message;
    }
}
const getStaffbyID = async(staffID) => {
    try {
        let pool = await sql.connect(config.sql);
        const sqlQueries = await utils.loadSqlQueries('staff');
        const staff = await pool.request()
                            .input('manv', sql.Char(15), staffID)
                            .query(sqlQueries.getstaffbyid);
        return staff.recordset;
    } catch (error) {
        return error.message;
    }
}
module.exports = {
    NVLietKeHopDong, updateNVDuyetHD, lietKeHopDongPhuTrach, thongkeHD, createStaff,
    lietKeNhanVienQL, lietkeDanhSachNVDuyet, duyetNhanVien, NV_capnhatthongtin,getStaffbyID
    
}