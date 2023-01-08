'use strict';

const ParnerData = require('../data/partners');
const MenuData = require('../data/menu');
const MenuItemsData = require('../data/menuitems');
const RestaurantsData = require('../data/restaurants');
const LoginData = require('../data/login');

//--------------------------Partner-------------------------------------------
const getAllParners = async (req, res, next) => {
    try {

        const Parnerlist = await ParnerData.getParners();
        res.send(Parnerlist);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const getParnerID = async (req, res, next) => {
    try {
        const ParnerId = req.params.id;
        const parner = await ParnerData.getParnerById(ParnerId);
        res.send(parner);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const addParner = async (req, res, next) => {
    try {
        const data = req.body;
        const insert = await ParnerData.creatParner(data);
        res.send(insert);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const update_Menu_Item_For_Partner = async (req, res, next) => {
    try {
        const data = req.body;
        const updated = await ParnerData.updateMenuItemForPartner(data);
        res.send(updated);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const get_Menu_Item_By_PartnerID = async (req, res, next) => {
    try {
        const data = req.body;
        const food = await ParnerData.getMenuItemByPartnerID(data);
        res.send(food);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const list_Contracts_By_PartnerID = async (req, res, next) => {
    try {
        const ParnerId = req.params.id;
        const listContracts = await ParnerData.listContractByPartnerID(ParnerId);
        res.send(listContracts);        
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const find_Food_By_Name = async (req, res, next) => {
    try {
        const data = req.body;
        const foods = await ParnerData.findFoodByName(data);
        res.send(foods);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const add_Food_For_Restaurant = async (req, res, next) => {
    try {
        const data = req.body;
        const insertedresult = await ParnerData.addFoodForRestaurant(data);
        res.send(insertedresult);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const list_Food_For_Restaurant = async (req, res, next) => {
    try {
        const data = req.body;
        const foods = await ParnerData.listFoodForRestaurant(data);
        res.send(foods);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const delete_Food_For_Restaurant = async (req, res, next) => {
    try {
        const data = req.body;
        const deleteResult = await ParnerData.deleteFoodForRestaurant(data);
        res.send(deleteResult);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const update_Password = async (req, res, next) => {
    try {
        const data = req.body;
        const result = await ParnerData.updatePassword(data);
        res.send(result);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
//-----------------------menu------------------------------------
const getMenuByParnerID = async (req, res, next) => {
    try {
        const ParnerId = req.params.id;
        const menu = await MenuData.getMenuByPartner(ParnerId);
        res.send(menu);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
//-----------------------menuitems------------------------------
const get_Menu_Item_By_Name = async (req, res, next) => {
    try {
        const tenmon = req.params.id;
        const menuitem = await MenuItemsData.getMenuItemByName(tenmon);
        res.send(menuitem);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const add_Menu_Item = async (req, res, next) => {
    try {
        const data = req.body;
        const insert = await MenuItemsData.addMenuItem(data);
        res.send(insert);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const delete_Menu_Item = async (req, res, next) => {
    try {
        const tenmon = req.params.id;
        const deleted = await MenuItemsData.deleteMenuItem(tenmon);
        res.send(deleted);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const update_Menu_Item = async (req, res, next) => {
    try {
        const tenmon =  req.params.id;
        const data = req.body;
        const updated = await MenuItemsData.updateMenuItem(tenmon, data);
        res.send(updated);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
//---------------------------Restaurants --------------------
const list_Restaurants_By_PartnerID = async (req, res, next) => {
    try {
        const masothue = req.params.id;
        const listRes = await RestaurantsData.listRestaurantsByPartnerID(masothue);
        res.send(listRes);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const add_Restaurant = async (req, res, next) => {
    try {
        const data = req.body;
        const insert = await RestaurantsData.addRestaurant(data);
        res.send(insert);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const update_Restaurant = async (req, res, next) => {
    try {
        const data = req.body;
        const updated = await RestaurantsData.updateRestaurant(data);
        res.send(updated);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const get_Restaurant_ResID = async (req, res, next) => {
    try {
        const ResId = req.params.id;
        const restaurant = await RestaurantsData.getRestaurantsByResID(ResId);
        res.send(restaurant);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
// ----------------------------Login-------------------------------------------------
const login_partner = async (req, res, next) => {
    try {
        const data = req.body;
        const username = await LoginData.loginPartner(data);
        res.send(username);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const login_driver = async (req, res, next) => {
    try {
        const data = req.body;
        const username = await LoginData.loginDriver(data);
        res.send(username);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

const login_customer = async (req, res, next) => {
    try {
        const data = req.body;
        const username = await LoginData.loginCustomer(data);
        res.send(username);
    } catch (error) {
        res.status(400).send(error.message);
    }
}
const login_staff = async (req, res, next) => {
    try {
        const data = req.body;
        const username = await LoginData.loginStaff(data);
        res.send(username);
    } catch (error) {
        res.status(400).send(error.message);
    }
}

module.exports = {
    getAllParners, getParnerID, addParner, getMenuByParnerID, add_Menu_Item, 
    delete_Menu_Item, get_Menu_Item_By_Name, update_Menu_Item, list_Restaurants_By_PartnerID,
    update_Menu_Item_For_Partner, get_Menu_Item_By_PartnerID, list_Contracts_By_PartnerID, add_Restaurant,
    update_Restaurant, get_Restaurant_ResID, find_Food_By_Name, add_Food_For_Restaurant, list_Food_For_Restaurant,
    delete_Food_For_Restaurant, login_partner, login_driver, login_customer, login_staff, update_Password
}