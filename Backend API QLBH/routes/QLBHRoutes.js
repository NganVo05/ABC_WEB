'use strict';

const express = require('express');
const QLBHControll = require('../controllers/QLBHController');
const DRIVERControll = require('../controllers/DRIVERController');
const CUSTOMERControll = require('../controllers/CUSTOMERController');
const STAFFControll = require('../controllers/STAFFController');
const router = express.Router();

//----------------------partner---------------------
router.get('/allparners', QLBHControll.getAllParners);
router.get('/parnersByID/:id', QLBHControll.getParnerID);
router.post('/addparner', QLBHControll.addParner);
router.put('/partner/updatemenuitem',QLBHControll.update_Menu_Item_For_Partner)
router.post('/partner/findmenuitem', QLBHControll.get_Menu_Item_By_PartnerID)
router.get('/partner/listcontracts/:id', QLBHControll.list_Contracts_By_PartnerID);
router.post('/partner/findfoodbyname', QLBHControll.find_Food_By_Name);
router.post('/partner/addfoodforrestaurant', QLBHControll.add_Food_For_Restaurant);
router.post('/partner/listfoodforrestaurant', QLBHControll.list_Food_For_Restaurant);
router.delete('/partner/deletefoodforrestaurant', QLBHControll.delete_Food_For_Restaurant);
router.post('/partner/updatepassword', QLBHControll.update_Password);
//-------------------------menu----------------------
router.get('/menu/:id', QLBHControll.getMenuByParnerID);
//-------------------------menuitems----------------------
router.get('/getnumeitembyname/:id', QLBHControll.get_Menu_Item_By_Name);
router.post('/addmenuitem', QLBHControll.add_Menu_Item);
router.delete('/deletemenuitem/:id', QLBHControll.delete_Menu_Item);
router.put('/updatemenuitem/:id', QLBHControll.update_Menu_Item);
//-------------------------restaurants------------------
router.get('/restaurantbyresid/:id', QLBHControll.get_Restaurant_ResID);
router.get('/restaurants/:id', QLBHControll.list_Restaurants_By_PartnerID);
router.post('/addrestaurants', QLBHControll.add_Restaurant);
router.put('/updaterestaurant', QLBHControll.update_Restaurant);
//-----------------------------login---------------------------------
router.post('/login/partner', QLBHControll.login_partner);
router.post('/login/driver', QLBHControll.login_driver);
router.post('/login/customer', QLBHControll.login_customer);
router.post('/login/staff', QLBHControll.login_staff);
//----------------------------driver-------------------------------
router.get('/driver/getdriverbyid/:id', DRIVERControll.get_DriverbyID);
router.get('/driver/selectdriver/:id', DRIVERControll.select_Driver);
router.get('/driver/selectdoncho', DRIVERControll.select_DONCHO);
router.post('/driver/updatetinhtrangcho', DRIVERControll.update_TINHTRANGCHO);
router.post('/driver/updatetinhtrangdh', DRIVERControll.update_TINHTRANGDH);
router.get('/driver/selectdonhangthanhcong/:id', DRIVERControll.select_DHTHANHCONG);
router.get('/driver/selectdonhangdanggiao/:id', DRIVERControll.select_DHDANGGIAO);
router.get('/driver/updatenopphi/:id', DRIVERControll.update_NOPPHI);
router.post('/driver/createdriver', DRIVERControll.create_Driver);
router.get('/driver/selectctdh/:id', DRIVERControll.select_CTDH);
router.post('/driver/updatepassword', DRIVERControll.update_PasswordDriver);
//---------------------------customer----------------------------
router.get('/customer/:id', CUSTOMERControll.getStoreByName);
router.get('/customer/disk/:id', CUSTOMERControll.getDiskById);
router.get('/customer/order/:id', CUSTOMERControll.getOrderByID);
router.post('/customer/addOrder', CUSTOMERControll.postOrder);
router.post('/customer/addOrderStore', CUSTOMERControll.postOrderStore);
router.post('/customer/addOrderDetail', CUSTOMERControll.postOrderDetail);
router.post('/customer/addFeedback',CUSTOMERControll.postFeedback);
router.post('/customer/signup',CUSTOMERControll.create_Customer);
//--------------------------Staff------------------------------
router.get('/staff/listcontract', STAFFControll.NV_LietKeHopDong);
router.post('/staff/updatenvduyethd', STAFFControll.update_NVDuyetHD);
router.get('/staff/listcontract/:id', STAFFControll.lietKe_HopDongPhuTrach);
router.post('/staff/statisticbill', STAFFControll.thongke_HD);
router.post('/staff/createstaff', STAFFControll.create_Staff);
router.get('/staff/listmanagedstaff/:id', STAFFControll.lietKe_NhanVienQL);
router.get('/staff/listapprovalstaff', STAFFControll.lietke_DanhSachNVDuyet);
router.post('/staff/duyetnhanvien', STAFFControll.duyet_NhanVien);
router.post('/staff/update', STAFFControll.capnhat_thongtin);
router.get('/staff/getstaffID/:id', STAFFControll.get_StaffbyID);
module.exports = {
    routes: router
}