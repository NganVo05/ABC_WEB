'use strict';
const CustomerData = require('../data/customer');


const getStoreByName = async (req, res, next) => {
    try {
        const StoreId = req.params.id;
        const store = await CustomerData.getOneStore(StoreId);
        res.send(store);
    } catch (error) {
        res.status(400).send(error.message);
    }
}


const getDiskById = async (req, res, next) => {
    try {
        const DiskId = req.params.id;
        const disk = await CustomerData.getOneDisk(DiskId);
        res.send(disk);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const getOrderByID = async (req, res, next) => {
    try {
        const UserId = req.params.id;
        const orderList = await CustomerData.getOneOrders(UserId);
        res.send(orderList);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const postOrder = async (req, res, next) => {
    try {
        const data = req.body;
        const order = await CustomerData.postOneOrder(data);
        res.send(order);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const postOrderStore = async (req, res, next) => {
    try {
        const data = req.body;
        const order = await CustomerData.postOneOrderStore(data);
        res.send(order);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const postOrderDetail = async (req, res, next) => {
    try {
        const data = req.body;
        const order = await CustomerData.postOneOrderDetail(data);
        res.send(order);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const postFeedback = async (req, res, next) => {
    try {
        const data = req.body;
        const order = await CustomerData.postOneFeedback(data);
        res.send(order);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const create_Customer = async (req, res, next) => {
    try {
        const data = req.body;
        const insert = await CustomerData.createCustomer(data);
        res.send(insert);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
module.exports = {
    getStoreByName, getDiskById, getOrderByID, postFeedback, postOrderDetail, postOrderStore, postOrder,
    create_Customer
}