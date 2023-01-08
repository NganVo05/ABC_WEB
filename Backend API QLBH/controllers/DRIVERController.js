'use strict';

const DriverData = require('../data/driver')

const select_Driver = async (req, res, next) => {
    try {
        const DriverId = req.params.id;
        const driver = await DriverData.selectDriver(DriverId);
        res.send(driver);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const select_DONCHO = async (req, res, next) => {
    try {
        const DONCHOlist = await DriverData.selectDONCHO();
        res.send(DONCHOlist);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const update_TINHTRANGCHO = async (req, res, next) => {
    try {
        const data = req.body;
        const result = await DriverData.updateTINHTRANGCHO(data);
        res.send(result);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const update_TINHTRANGDH = async (req, res, next) => {
    try {
        const data = req.body;
        const result = await DriverData.updateTINHTRANGDH(data);
        res.send(result);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const select_DHTHANHCONG = async (req, res, next) => {
    try {
        const DriverId = req.params.id;
        const driver = await DriverData.selectDHTHANHCONG(DriverId);
        res.send(driver);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const select_DHDANGGIAO = async (req, res, next) => {
    try {
        const DriverId = req.params.id;
        const driver = await DriverData.selectDHDANGGIAO(DriverId);
        res.send(driver);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const update_NOPPHI = async (req, res, next) => {
    try {
        const DriverId = req.params.id;
        const result = await DriverData.updateNOPPHI(DriverId);
        res.send(result);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const create_Driver = async (req, res, next) => {
    try {
        const data = req.body;
        const insert = await DriverData.createDriver(data);
        res.send(insert);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const select_CTDH = async (req, res, next) => {
    try {
        const billCode = req.params.id;
        const result = await DriverData.selectCTDH(billCode);
        res.send(result);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const get_DriverbyID = async (req, res, next) => {
    try {
        const DriverId = req.params.id;
        const driver = await DriverData.getDriverbyID(DriverId);
        res.send(driver);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const update_PasswordDriver = async (req, res, next) => {
    try {
        const data = req.body;
        const result = await DriverData.updatePasswordDriver(data);
        res.send(result);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
module.exports = {
    select_Driver, select_DONCHO, update_TINHTRANGCHO, update_TINHTRANGDH, 
    select_DHTHANHCONG, select_DHDANGGIAO, update_NOPPHI, create_Driver,
    select_CTDH, get_DriverbyID, update_PasswordDriver
}