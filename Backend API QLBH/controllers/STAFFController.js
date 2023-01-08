'use strict';

const StaffData = require('../data/staff')

const NV_LietKeHopDong = async (req, res, next) => {
    try {
        const list = await StaffData.NVLietKeHopDong();
        res.send(list);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const update_NVDuyetHD = async (req, res, next) => {
    try {
        const data = req.body;
        const update = await StaffData.updateNVDuyetHD(data);
        res.send(update);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const lietKe_HopDongPhuTrach = async (req, res, next) => {
    try {
        const staffId = req.params.id;
        const list = await StaffData.lietKeHopDongPhuTrach(staffId);
        res.send(list);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const thongke_HD = async (req, res, next) => {
    try {
        const data = req.body;
        const update = await StaffData.thongkeHD(data);
        res.send(update);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const create_Staff = async (req, res, next) => {
    try {
        const data = req.body;
        const insert = await StaffData.createStaff(data);
        res.send(insert);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const lietKe_NhanVienQL = async (req, res, next) => {
    try {
        const staffId = req.params.id;
        const list = await StaffData.lietKeNhanVienQL(staffId);
        res.send(list);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const lietke_DanhSachNVDuyet = async (req, res, next) => {
    try {
        const list = await StaffData.lietkeDanhSachNVDuyet();
        res.send(list);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const duyet_NhanVien = async (req, res, next) => {
    try {
        const data = req.body;
        const result = await StaffData.duyetNhanVien(data);
        res.send(result);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const capnhat_thongtin = async (req, res, next) => {
    try {
        const data = req.body;
        const result = await StaffData.NV_capnhatthongtin(data);
        res.send(result);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const get_StaffbyID = async (req, res, next) => {
    try {
        const staffId = req.params.id;
        const staff = await StaffData.getStaffbyID(staffId);
        res.send(staff);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
module.exports = {
    NV_LietKeHopDong, update_NVDuyetHD, lietKe_HopDongPhuTrach, thongke_HD,
    create_Staff, lietKe_NhanVienQL, lietke_DanhSachNVDuyet, duyet_NhanVien,
    capnhat_thongtin, get_StaffbyID
}