﻿-----------------PHÂN QUYỀN---------------------
USE QLBH_1

---TẠO 5 ROLES
--1.Nhân viên quản lý (Quản trị): NVQL
--2.Nhân viên: NV
--3.Đối tác: DT
--4.Khách hàng: KH
--5.Tài Xế: TX

CREATE ROLE NVQL
GO

CREATE ROLE NV
GO

CREATE ROLE DT
GO

CREATE ROLE KH
GO

CREATE ROLE TX
GO

------------------------------------Tạo LOGIN ----------------------
---NVQL
create login NVQL01
with password = 'NVQL01',
default_database = QLBH_1;

---NV
create login NV01
with password = 'NV01',
default_database = QLBH_1;


--DOITAC
create login DT01
with password = 'DT01',
default_database = QLBH_1;

--KHACHHANG
create login KH01
with password = 'KH01',
default_database = QLBH_1;

--TAIXE
create login TX01
with password = 'TX01',
default_database = QLBH_1;

------------------------------USER--------------------------------
--QUẢN TRỊ
create user NVQL01 for login NVQL01

--NHÂN VIÊN
create user NV01 for login NV01

--ĐỐI TÁC
create user DT01 for login DT01

---KHÁCH HÀNG
create user KH01 for login KH01
			
--TÀI XẾ
create user TX01 for login TX01

---Thêm vào nhóm người dùng
ALTER ROLE NVQL 
ADD MEMBER NVQL01

ALTER ROLE NV
ADD MEMBER NV01

ALTER ROLE DT 
ADD MEMBER DT01

ALTER ROLE KH 
ADD MEMBER KH01

ALTER ROLE TX 
ADD MEMBER TX01

-------
GRANT EXEC ON loginForPartner TO DT
GRANT EXEC ON loginForDriver TO TX
GRANT EXEC ON loginForCustomer TO KH
GRANT EXEC ON loginForStaff TO NV
GRANT EXEC ON loginForStaff TO NVQL


----------1. ĐỐI TÁC-------------
--1. Đăng ký đối tác
GRANT EXEC ON addPartner TO DT

--2.Danh sách món ăn của đối tác
GRANT EXEC ON listMonAnByDoiTac TO DT

--3. Thêm món ăn (đối tác)
GRANT EXEC ON addMonAnDoiTac TO DT

--4. Xóa món ăn (đối tác)
GRANT EXEC ON deleteMonAnDoiTac TO DT

--5. Tìm món ăn theo tên
GRANT EXEC ON findMonAnofPartner TO DT

--6.Cặp nhật món ăn
GRANT EXEC ON updateMonAnForPartner TO DT

--7.Tìm danh sách cửa hàng của đối tác
GRANT EXEC ON ListRestaurantsForPartner TO DT

--8. Tìm danh sách cửa hàng theo tên
GRANT EXEC ON getRestaurantbyRESID TO DT

--9.Cập nhật cửa hàng
GRANT EXEC ON updateRestaurant TO DT

--10. Thêm cửa hàng
GRANT EXEC ON addRestaurantForPartner TO DT

--11. Danh sách hợp đồng của đối tác
GRANT EXEC ON listContractsByPartnerID TO DT

--12. Tìm món theo tên món của đối tác
GRANT EXEC ON findFoodbyNameandPartnerID TO DT

--13. Thêm món ăn cho cửa hàng
GRANT EXEC ON addFoodForRestaurant TO DT

--14. Danh sách món ăn của cửa hàng
GRANT EXEC ON listFoodForRestaurant TO DT

--15. Xóa món ăn cửa hàng
GRANT EXEC ON deleteFoodFromRestaurant TO DT


----------2. KHÁCH HÀNG-------------
--1. Đăng ký khách hàng
GRANT EXEC ON createCustomer TO KH

--2.Danh sách món ăn của 1 cửa hàng 
--(Tìm món ăn theo tên cửa hàng)
GRANT EXEC ON USP_GetStoreByName TO KH

--3. Danh sách các cửa hàng có phục vụ món ăn 
--(Tìm cửa hàng theo tên món ăn)
GRANT EXEC ON USP_GetDiskByName TO KH

--4. Lấy danh sách các đơn hảng của khách hàng
GRANT EXEC ON USP_GetOrders TO KH

--5. Thêm đơn đặt hàng
GRANT EXEC ON USP_AddOrder TO KH

--6.Thêm DONHANG_CUAHANG
GRANT EXEC ON USP_AddOrderStore TO KH

--7. Thêm CHITIETDONHANG
GRANT EXEC ON USP_AddOrderDetail TO KH

--8. Cập nhật đánh giá của 1 đơn hàng
GRANT EXEC ON USP_UpdateFeedback TO KH



----------3. TÀI XẾ-------------
--1.Danh sách tài xế
GRANT EXEC ON selectDriver TO TX

--2.Đăng kí tài xế 
GRANT EXEC ON createDriver TO TX

--3.Cập nhật tình trạng nộp phí
GRANT EXEC ON updateNOPPHI TO TX

--4.Hiển thị tình trạng nộp phí
GRANT EXEC ON selectTINHTRANGNOPPHI TO TX

--5.Danh sách đơn hàng chờ xác nhận
GRANT EXEC ON selectDONCHO TO TX

--6.Danh Sách Đơn Đang Giao------
GRANT EXEC ON selectDONDANGGIAO TO TX

--7.Danh sách đơn hàng giao thành công
GRANT EXEC ON selectDHTHANHCONG TO TX


--8.In hóa đơn
GRANT EXEC ON selectKHDH TO TX

--9.Chi tiết món trong hóa đơn
GRANT EXEC ON selectCTDH TO TX

--10.IN RA DIACHI, TINHTRANG, PHIVANCHUYEN, 
--TONGGIA TRONG GIAO DIỆN BÊN TÀI XẾ
GRANT EXEC ON selectDIACHI TO TX

--11.Cập nhật tình trạng đơn hàng THÀNH ĐÃ GIAO
GRANT EXEC ON updateTINHTRANGDH TO TX

--12.Cập nhật tình trạng đơn hàng CHỜ THÀNH ĐANG VẬN CHUYỂN
GRANT EXEC ON updateTINHTRANGCHO TO TX

--13.hiển thị tình trạng, phí, giá ở giao diện theo dõi đơn
GRANT EXEC ON sp1_updateTINHTRANG TO TX

--14.hiện mã đơn, địa chỉ, họ tên, sđt ở giao diện theo dõi đơn
GRANT EXEC ON sp2_updateTINHTRANG TO TX



----------4. NHÂN VIÊN----------
go
--1. THỐNG KÊ HÓA ĐƠN THEO NGÀY THÁNG NĂM
GRANT EXEC ON ThongKeHD TO NV

--2. Danh sách hợp đồng chưa được duyệt
GRANT EXEC ON NV_LietKeHopDong TO NV

--3. Liệt kê hợp đồng phụ trách
GRANT EXEC ON NV_LietKeHopDongPhuTrach TO NV

--4. Tạo hợp đồng
--GRANT EXEC ON Add_Contract TO NV

 ---------5. QUẢN TRỊ------------
--1/ Cấp quyền thực hiện trên bảng NV,DT,KH,TX
GRANT SELECT,UPDATE, DELETE ON NHANVIENCONGTY TO NVQL WITH GRANT OPTION
GO

GRANT SELECT,UPDATE, DELETE ON DOITAC TO NVQL WITH GRANT OPTION
GO

GRANT SELECT,UPDATE, DELETE ON KHACHHANG TO NVQL WITH GRANT OPTION
GO

GRANT SELECT,UPDATE, DELETE ON TAIXE TO NVQL WITH GRANT OPTION
GO

--2.Tạo tài khoản cho nhân viên
GRANT EXEC ON createEMP TO NVQL