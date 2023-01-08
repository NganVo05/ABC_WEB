﻿----------------TỔNG HỢP PROCEDURE---------------------
--PROCEDURE ĐĂNG NHẬP

-------------------------------LOGIN---------------------------------------
	-----------Partner -------------------------------------
CREATE
--ALTER
PROC loginForPartner
	@username CHAR(15),
	@password CHAR(20)
AS
BEGIN
	IF NOT EXISTS(SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @username AND MK = @password)
	BEGIN
		SELECT 'USERNAME OR PASSWORD INCORRECT' AS 'ERROR'
		RETURN 0
	END
	SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @username AND MK = @password
END

GO
	-----------Driver -------------------------------------
CREATE
--ALTER
PROC loginForDriver
	@username CHAR(15),
	@password CHAR(20)
AS
BEGIN
	Declare @hoten nchar(30), @sdt char(15), @stk char(15), @matx char(15), @tinhtrangnopphi nchar(10)
	SELECT @matx = MATX, @hoten = HOTEN, @sdt = SDT, @stk = STK, @tinhtrangnopphi = TINHTRANGNOPPHI FROM TAIXE WHERE USERNAME = @username AND MK = @password
	IF (@matx is null)
	BEGIN
		SELECT 'USERNAME OR PASSWORD INCORRECT' AS 'ERROR'
		RETURN 0
	END
	SELECT @matx MATX, @hoten HOTEN, @sdt SDT, @stk STK, @tinhtrangnopphi TINHTRANGNOPPHI
END

go

		-----------Customer -------------------------------------
CREATE
--ALTER
PROC loginForCustomer
	@username VARCHAR(50),
	@password VARCHAR(20)
AS
BEGIN
	Declare @hoten nchar(30), @sdt char(15), @makh char(15), @sldoncho int
	SELECT @makh = MAKH, @hoten = HOTEN, @sdt = SDT 
	FROM KHACHHANG WHERE SDT = @username AND MK = @password
	IF (@makh is null)
	BEGIN
		SELECT 'USERNAME OR PASSWORD INCORRECT' AS 'ERROR'
		RETURN 0
	END
	set @sldoncho = (select count(MADONHANG) from DONDATHANG where MAKH = @makh and TINHTRANG <> N'Đã Giao             ')
	SELECT @makh MAKH, @hoten HOTEN, @sdt SDT, @sldoncho SLDONCHO
END

GO

----------------------Staff---------------------------------------
CREATE
--ALTER
PROC loginForStaff
	@username VARCHAR(50),
	@password VARCHAR(20)
AS
BEGIN
	Declare @hoten nchar(30), @sdt char(15), @manv char(15), @role nchar(20), @slnvql int
	SELECT @manv = MANV, @hoten = HOTEN, @sdt = SDT 
	FROM NHANVIENCONGTY WHERE MANV = @username AND MK = @password
	IF (@manv is null)
	BEGIN
		SELECT 'USERNAME OR PASSWORD INCORRECT' AS 'ERROR'
		RETURN 0
	END

	set @slnvql = (select count(MANV) from NHANVIENCONGTY where NVQL = @manv)
	if @slnvql > 0
	begin
		set @role = N'NVQL'
	end
	else
	begin
		set @role = N'Nhân Viên'
	end
	SELECT @manv MANV, @hoten HOTEN, @sdt SDT, @role VAITRO
END

GO


-------1. ĐỐI TÁC------------
--1. Đăng ký đối tác
	------create Partner------------
CREATE
--ALTER
PROC addPartner
	@masothue char(15),
	@nguoidaidien nchar(30),
	@email char(30),
	@tendoitac nchar(30), 
	@quan nchar(20),
	@slchinhanh int,
	@sldonhangdukien int,
	@loaithucpham nchar(20),
	@diachi nchar(50),
	@sdt char(15),
	@thoigianhopdong int
AS
Begin Tran
	Begin Try
	--check exists
		If EXISTS(select *from DOITAC WITH(XLOCK) where MASOTHUE = @masothue)
		Begin
			Select 'Partner already exists' AS ERROR
			Rollback Tran
			Return 0
		End
	-- check null
		IF @nguoidaidien is null	or @email is null or @tendoitac is null	or @quan is null
		or @slchinhanh is null	or @sldonhangdukien is null or @loaithucpham is null or @diachi is null or @sdt is null
		Begin
			Select 'forced fields is not null' AS ERROR
			Rollback Tran
			Return 0
		End
	-- check valid data
		IF(@slchinhanh <= 0 OR @sldonhangdukien <= 0 OR @thoigianhopdong < 6 OR @thoigianhopdong > 36)
		Begin
			Select 'Invalid datal' AS ERROR
			Rollback Tran
			Return 0
		End
	-- insert 
		-- generate MAHOPDONG
		declare @mahopdong char(15) = (SELECT 'DH' + LEFT(REPLACE(NEWID(),'-',''),10) AS Random10 )
		declare @mk char(20) = (SELECT LEFT(REPLACE(NEWID(),'-',''),10) AS Random10 )
		declare @ngaybatdau datetime = DATEADD(day, 3, GETDATE())
		While EXISTS(select *from HOPDONG WHERE MAHOPDONG = @mahopdong)
		begin
			set @mahopdong = (SELECT 'DH' + LEFT(REPLACE(NEWID(),'-',''),10) AS Random10 )
		end
		--insert DOITAC
		insert DOITAC values (@masothue,null,@nguoidaidien,@email, @tendoitac, @quan, @slchinhanh, @sldonhangdukien, @loaithucpham, @diachi, @sdt,@mk)
		--insert HOPDONG
		insert HOPDONG values (@mahopdong, @masothue, null, GETDATE(),0.1,0.2,@slchinhanh,@ngaybatdau,DATEADD(MONTH, @thoigianhopdong, @ngaybatdau))
		--return result
		select *from DOITAC where MASOTHUE = @masothue
		select MAHOPDONG from HOPDONG where MAHOPDONG = @mahopdong and MASOTHUE = @masothue
	End Try
	Begin Catch
			Select 'Add-Parner Failed' AS ERROR
			Rollback Tran
	End Catch
Commit Tran
Return 1
GO


--2.Danh sách món ăn của đối tác
CREATE
--ALTER
proc listMonAnByDoiTac
	@masothue char(15)
as
begin
	if not exists(select *from DOITAC where MASOTHUE = @masothue)
	begin
		select 'Partner Is Not Found' AS 'ERROR'
	end
	select MA.TENMON, MA.MIEUTA, MA.GIA, MA.TINHTRANG, MA.SLDABAN, MA.GHICHU from MENU M join MONAN MA on M.MASOTHUE = @masothue and M.TENMON = MA.TENMON
end
GO

--3. Thêm món ăn (đối tác)
CREATE
--ALTER
PROC addMonAnDoiTac
	@tenmon nchar(80),
	@mieuta nchar(30),
	@gia float,
	@tinhtrang nchar(20),
	@ghichu nchar(50),
	@masothue char(15)
AS
BEGIN TRAN
	IF(@tenmon IS NULL OR @mieuta IS NULL OR @gia IS NULL OR @tinhtrang IS NULL OR @ghichu IS NULL OR @masothue IS NULL)
	BEGIN 
		SELECT 'INFOMATION OF DISH IS NOT NULL' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END

	IF EXISTS(SELECT TENMON FROM MONAN WITH(XLOCK) WHERE TENMON = @tenmon)
	OR EXISTS(SELECT TENMON FROM MENU WITH(XLOCK) WHERE TENMON = @tenmon AND MASOTHUE = @masothue)
	BEGIN
		SELECT 'Name Of Dish Already Exists' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END

	IF NOT EXISTS(SELECT MASOTHUE FROM DOITAC WITH(XLOCK) WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'Partner Does Not Exist' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END

	INSERT MONAN VALUES(@tenmon, @mieuta, @gia, @tinhtrang, 0, @ghichu)
	INSERT MENU VALUES(@masothue, @tenmon)
	SELECT MASOTHUE, MA.TENMON, MA.MIEUTA, MA.GIA, MA.TINHTRANG, MA.SLDABAN, MA.GHICHU  
	FROM MENU ME JOIN MONAN MA ON ME.MASOTHUE = @masothue AND MA.TENMON = ME.TENMON and ME.TENMON = @tenmon
COMMIT TRAN
RETURN 1
GO


--4. Xóa món ăn (đối tác)
CREATE
--ALTER
PROC deleteMonAnDoiTac
	@tenmon NCHAR(80)
AS
BEGIN TRAN
	---check food is found
	IF NOT EXISTS(SELECT TENMON FROM MONAN WITH(XLOCK) WHERE TENMON = @tenmon)
	BEGIN
		SELECT 'Food Is Not Found' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	---check food was served
	if EXISTS(SELECT TENMON FROM PHUCVU WHERE TENMON =  @tenmon)
	OR EXISTS(SELECT TENMON FROM CHITIETDONHANG WHERE TENMON =  @tenmon)
	BEGIN
		SELECT 'Can not delete Food was served' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END

	DELETE MENU
	WHERE TENMON = @tenmon

	DELETE MONAN
	WHERE TENMON = @tenmon

	SELECT 'DELETED FOOD SUCCESSFULLY' AS '1'
COMMIT TRAN
RETURN 1
GO

--5. Tìm món ăn theo tên
CREATE
--ALTER
PROC findMonAnofPartner
	@masothue CHAR(15),
	@tenmon NCHAR(80)
AS
BEGIN
	IF NOT EXISTS(SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT FOUND' AS 'ERROR'
		RETURN 0
	END

	IF NOT EXISTS(SELECT TENMON FROM MONAN WHERE TENMON = @tenmon)
	BEGIN
		SELECT 'FOOD IS NOT FOUND' AS 'ERROR'
		RETURN 0
	END

	IF EXISTS (SELECT * FROM MENU WHERE MASOTHUE = @masothue AND TENMON = @tenmon)
	BEGIN
		SELECT * FROM MONAN WHERE TENMON = @tenmon
	END
	ELSE
	BEGIN
		SELECT 'PARTNER HAS NOT THIS FOOD' AS 'ERROR'
		RETURN 0
	END
END
RETURN 1
GO

--6.Cặp nhật món ăn
CREATE
PROC updateMonAnForPartner
	@masothue CHAR(15),
	@tenmon NCHAR(80),
	@mieuta nchar(30),
	@gia float,
	@tinhtrang nchar(20),
	@sldaban INT,
	@ghichu nchar(50)
AS
BEGIN TRAN
	IF NOT EXISTS(SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT FOUND' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF NOT EXISTS (SELECT TENMON FROM MONAN WITH(XLOCK) WHERE TENMON = @tenmon)
	BEGIN
		SELECT 'NAME OF FOOD IS NOT FOUND' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF NOT EXISTS(SELECT TENMON FROM MENU WITH(XLOCK) WHERE TENMON = @tenmon AND MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER HAS NOT THIS FOOD' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	-----------UPDATE--------------
	IF (@mieuta IS NOT NULL) -- UPDATE MIEU TA 
		AND (@mieuta <> '')
	BEGIN
		UPDATE MONAN
		SET MIEUTA = @mieuta
		WHERE TENMON = @tenmon
	END
	IF (@gia IS NOT NULL) -- UPDATE GIA
		AND (@gia <> '')
	BEGIN
		UPDATE MONAN
		SET GIA = @gia
		WHERE TENMON = @tenmon
	END
	IF (@tinhtrang IS NOT NULL)-- UPDATE TINH TRANG
	AND (@tinhtrang <> '')
	BEGIN
		UPDATE MONAN
		SET TINHTRANG = @tinhtrang
		WHERE TENMON = @tenmon
	END
	IF (@sldaban IS NOT NULL) -- UPDATE SL DA BAN
	AND (@sldaban <> '')
	BEGIN
		UPDATE MONAN
		SET SLDABAN = @sldaban
		WHERE TENMON = @tenmon
	END
	IF @ghichu IS NOT NULL -- UPDATE GHI CHU
	AND (@ghichu <> '')
	BEGIN
		UPDATE MONAN
		SET GHICHU = @ghichu
		WHERE TENMON = @tenmon
	END
	SELECT *FROM MONAN WHERE TENMON = @tenmon
COMMIT TRAN
RETURN 1
GO

--7. Tìm danh sách cửa hàng của đối tác
CREATE
PROC ListRestaurantsForPartner
	@masothue CHAR(15)
AS
BEGIN
	IF NOT EXISTS (SELECT MASOTHUE FROM DOITAC WITH(XLOCK) WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT FOUND' AS 'ERROR'
	END
	IF NOT EXISTS (SELECT MASOTHUE FROM CUAHANG WITH(XLOCK) WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER HAS NO RESTAURANT' AS 'ERROR'
	END
	SELECT * FROM CUAHANG WHERE MASOTHUE = @masothue
END
GO

--8. Tìm danh sách cửa hàng theo tên
CREATE
--ALTER
PROC getRestaurantbyRESID
	@macuahang CHAR(15)
AS 
BEGIN
	IF NOT EXISTS(SELECT MACUAHANG FROM CUAHANG WITH(XLOCK) WHERE MACUAHANG = @macuahang)
	BEGIN
		SELECT 'RESTAURANT IS NOT EXISTS'AS 'ERROR'
		RETURN 0
	END
	SELECT *FROM CUAHANG WHERE MACUAHANG = @macuahang
END
RETURN 1
GO

--9.Cập nhật cửa hàng
CREATE
--ALTER
PROC updateRestaurant
	@macuahang CHAR(15),
	@masothue CHAR(15),
	@stk CHAR(15),
	@nganhang NCHAR(35),
	@giomocua TIME,
	@giodongcua TIME,
	@tinhtrang NCHAR(20)
AS
BEGIN TRAN
	IF NOT EXISTS(SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT EXISTS' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF NOT EXISTS(SELECT MACUAHANG FROM CUAHANG WITH(XLOCK) WHERE MACUAHANG = @macuahang AND MASOTHUE = @masothue)
	BEGIN
		SELECT 'RESTAURANT IS NOT EXISTS' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF(len(@stk) <> 0) --UPDATE STK
	BEGIN 
		UPDATE CUAHANG
		SET STK = @stk
		WHERE MACUAHANG = @macuahang
	END

	IF(len(@nganhang) <> 0) --UPDATE TEN NGAN HANG
	BEGIN 
		UPDATE CUAHANG
		SET NGANHANG = @nganhang
		WHERE MACUAHANG = @macuahang
	END
	IF(@giomocua is not null) and (@giodongcua is not null) --UPDATE GMC, GDC
	BEGIN 
		IF ((SELECT DATEPART(hour, @giodongcua)) <= (SELECT DATEPART(hour, @giomocua)))
		BEGIN
			SELECT ' OPENING HOUR IS NOT GREATER THAN CLOSING HOUR' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END
		ELSE
			UPDATE CUAHANG
			SET GIOMOCUA = @giomocua, GIODONGCUA = @giodongcua
			WHERE MACUAHANG = @macuahang
	END
	IF (@giomocua is not null) AND (@giodongcua is null)-- UPDATE GMC
	BEGIN
		declare @giodongcuahientai time
		set @giodongcuahientai = (SELECT GIODONGCUA FROM CUAHANG WHERE MACUAHANG = @macuahang)
		IF ( (SELECT DATEPART(hour, @giodongcuahientai)) <= (SELECT DATEPART(hour, @giomocua)))
		BEGIN
			SELECT ' OPENING HOUR IS NOT GREATER THAN CLOSING HOUR' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END
		ELSE
			UPDATE CUAHANG
			SET GIOMOCUA = @giomocua
			WHERE MACUAHANG = @macuahang
	END
	IF ( @giodongcua is not null) AND ( @giomocua is null) -- UPDATE GDC
	BEGIN
		declare @giomocuahientai time
		set @giomocuahientai = (SELECT GIOMOCUA FROM CUAHANG WHERE MACUAHANG = @macuahang)
		IF ( (SELECT DATEPART(hour, @giomocuahientai)) >= (SELECT DATEPART(hour, @giodongcua)))
		BEGIN
			SELECT ' CLOSING HOUR MUST BE GREATER THAN OPENING HOUR' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END
		ELSE
			UPDATE CUAHANG
			SET GIODONGCUA = @giodongcua
			WHERE MACUAHANG = @macuahang
	END
	IF(len(@tinhtrang)  <> 0) --UPDATE TINH TRANG
	BEGIN 
		UPDATE CUAHANG
		SET TINHTRANG = @tinhtrang
		WHERE MACUAHANG = @macuahang
	END

	SELECT * FROM CUAHANG WHERE MACUAHANG = @macuahang	
COMMIT TRAN
RETURN 1
GO

--10. Thêm cửa hàng
CREATE
--ALTER
PROC addRestaurantForPartner
	@macuahang CHAR(15),
	@masothue CHAR(15),
	@stk CHAR(15),
	@nganhang NCHAR(35),
	@tenquan NCHAR(35),
	@giomocua TIME,
	@giodongcua TIME,
	@tinhtrang NCHAR(20),
	@diachi NCHAR(50)
AS
BEGIN TRAN
	IF NOT EXISTS(SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT EXISTS' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF EXISTS(SELECT MACUAHANG FROM CUAHANG WITH(XLOCK) WHERE MACUAHANG = @macuahang)
	BEGIN
		SELECT 'RESTAURANT IS EXISTS' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF ((SELECT DATEPART(hour, @giodongcua)) <= (SELECT DATEPART(hour, @giomocua)))
	BEGIN
		SELECT ' OPENING HOUR IS NOT GREATER THAN CLOSING HOUR' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	INSERT CUAHANG VALUES(@macuahang, @masothue, @stk, @nganhang, @tenquan, @giomocua, @giodongcua, null, @tinhtrang, @diachi)
	SELECT *FROM CUAHANG WHERE MACUAHANG = @macuahang
COMMIT TRAN
RETURN 1
GO

--11. Danh sách hợp đồng của đối tác
CREATE
--ALTER
PROC listContractsByPartnerID
	@masothue CHAR(15)
AS
BEGIN
	IF NOT EXISTS(SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT FOUND' AS 'ERROR'
		RETURN 0
	END
	SELECT *FROM HOPDONG WHERE MASOTHUE = @masothue
END
RETURN 1
GO

--12. Tìm món theo tên món của đối tác
CREATE
--ALTER
PROC findFoodbyNameandPartnerID
	@tenmon NVARCHAR(80),
	@masothue CHAR(15)
AS
BEGIN
	IF NOT EXISTS(SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT EXISTS' AS 'ERROR'
		RETURN 0
	END
	SELECT M.MASOTHUE, M.TENMON, MA.GIA, MA.TINHTRANG FROM MENU M JOIN MONAN MA on M.MASOTHUE = @masothue AND M.TENMON LIKE '%'+ @tenmon +'%' AND MA.TENMON = M.TENMON
END
GO

--13. Thêm món ăn cho cửa hàng
CREATE
--ALTER
PROC addFoodForRestaurant
	@masothue CHAR(15),
	@macuahang CHAR(15),
	@tenmon nchar(80)
AS
BEGIN TRAN
	IF NOT EXISTS (SELECT MASOTHUE FROM DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT EXISTS' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF NOT EXISTS (SELECT MACUAHANG FROM CUAHANG WHERE MASOTHUE = @masothue AND MACUAHANG = @macuahang)
	BEGIN
		SELECT 'RESTAURANT IS NOT MANAGED BY THIS PARTNER' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF EXISTS(SELECT * FROM PHUCVU WHERE MACUAHANG = @macuahang AND TENMON = @tenmon)
	BEGIN
		SELECT 'RESTAURANT WAS ADDED THIS FOOD' AS 'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END

	INSERT PHUCVU VALUES(@tenmon,@macuahang)
	SELECT *FROM PHUCVU WHERE TENMON = @tenmon AND MACUAHANG = @macuahang
COMMIT TRAN
RETURN 1

GO

--14. Danh sách món ăn của cửa hàng
CREATE
--ALTER
PROC listFoodForRestaurant
	@masothue CHAR(15),
	@macuahang CHAR(15)
AS
BEGIN
	IF NOT EXISTS (SELECT MASOTHUE from DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT EXISTS' AS 'ERROR'
		RETURN 0
	END

	IF NOT EXISTS (SELECT MACUAHANG from CUAHANG WHERE MACUAHANG = @macuahang AND MASOTHUE= @masothue )
	BEGIN
		SELECT 'RESTAURANT IS NOT EXISTS' AS 'ERROR'
		RETURN 0
	END
	SELECT PV.MACUAHANG, M.TENMON, M.MIEUTA, M.TINHTRANG, M.GIA, M.SLDABAN, M.GHICHU 
	FROM PHUCVU PV JOIN MONAN M ON MACUAHANG = @macuahang AND PV.TENMON = M.TENMON
END

GO

--15. Xóa món ăn cửa hàng
CREATE
--ALTER
PROC deleteFoodFromRestaurant
	@tenmon NCHAR(80),
	@macuahang CHAR(15),
	@masothue CHAR(15)
AS
BEGIN TRAN
	IF NOT EXISTS(SELECT *FROM MENU WHERE MASOTHUE = @masothue AND TENMON = @tenmon )
	BEGIN
		SELECT 'PARTNER HAS NO THIS FOOD' AS'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	IF NOT EXISTS(SELECT *FROM PHUCVU WHERE MACUAHANG = @macuahang AND TENMON = @tenmon )
	BEGIN
		SELECT 'RESTAURANT HAS NO THIS FOOD' AS'ERROR'
		ROLLBACK TRAN
		RETURN 0
	END
	DELETE PHUCVU
	WHERE TENMON = @tenmon AND MACUAHANG = @macuahang

	SELECT P.MACUAHANG, P.TENMON, M.MIEUTA, M.TINHTRANG, M.GIA, M.SLDABAN, M.GHICHU
	FROM PHUCVU P JOIN MONAN M ON P.MACUAHANG = @macuahang AND P.TENMON = M.TENMON
COMMIT TRAN
RETURN 1

--16. Đổi Mật Khẩu Cho Đối Tác----------------
create 
--alter
proc updatePassword
	@masothue char(15),
	@newpass char(20)
AS
Begin tran
	if not exists(select MASOTHUE from DOITAC where MASOTHUE = @masothue) 
	begin
		select 'PARTNER IS NOT EXISTS' AS 'ERROR'
		rollback tran
		return 0
	end
	if(len(@newpass) < 8 )
	begin
		select 'Length of password is too short' AS 'ERROR'
		rollback tran
		return 0
	end
	update DOITAC 
	set MK = @newpass
	where MASOTHUE = @masothue
	select 'Changed password successfully' as 'RESULT'
commit tran
return 1
-------2. KHÁCH HÀNG------------
--1. Đăng ký khách hàng
create
--alter 
proc createCustomer
	@makh char(15), 
	@hoten nchar(30), 
	@email char(50), 
	@mk char(20), 
	@sdt char(15), 
	@diachi nchar(50)
as
begin tran
	begin try
		if (@makh is NULL or @hoten is NULL 
			or @sdt is NULL or @email is null
			or @mk is null or @diachi is NULL)
			begin
				select 'Not NULL for column' as 'ERROR'
				Rollback Transaction
				return 0
			end
		if exists (select * from KHACHHANG where @hoten = HOTEN and @email = EMAIL )
			begin
				select 'Khách hàng đã tồn tại' as 'ERROR'
				Rollback Transaction
				return 0
			end

	end try
	begin catch
		print(N'Tạo tài khoản không thành công')
		rollback transaction
	end catch
	insert into KHACHHANG values (@makh, @hoten, @email, @mk , @sdt, @diachi)
	select * from KHACHHANG where MAKH = @makh
commit tran
go

--2.Danh sách món ăn của 1 cửa hàng (Tìm món ăn theo tên cửa hàng)
--DROP PROC IF EXISTS USP_GetStoreByName
--GO

CREATE 
--ALTER 
PROC USP_GetStoreByName
	@Name NCHAR(35)
AS
BEGIN TRAN
	IF NOT EXISTS (SELECT TENQUAN FROM CUAHANG WHERE TRIM(TENQUAN) = TRIM(@Name))
		BEGIN
			SELECT 'TENQUAN IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0;
		END
	
	-- tình trạng của của hàng có đang hoạt động không
	DECLARE @TEMP TABLE (MACH CHAR(15), GIOMC DATETIME, GIODC DATETIME)
	INSERT INTO @TEMP SELECT CH.MACUAHANG, CH.GIOMOCUA, CH.GIODONGCUA FROM CUAHANG CH WHERE TRIM(CH.TENQUAN) = TRIM(@Name) AND TRIM(CH.TINHTRANG) = N'HĐ'
	--SELECT * FROM @TEMP
	IF NOT EXISTS (SELECT MACH FROM @TEMP)
		BEGIN
			SELECT N'Cửa hàng hiện không hoạt động' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	-- cửa hàng có phục vụ món ăn nào chưa
	IF TRIM(@Name) IN (SELECT TRIM(CH.TENQUAN) FROM CUAHANG CH
						WHERE CH.MACUAHANG NOT IN (SELECT PV.MACUAHANG FROM PHUCVU PV))
		BEGIN
			SELECT N'Cửa hàng hiện chưa phục vụ' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	-- kiểm tra cửa hàng còn mở của hay không
	DECLARE @CURRENT TIME
	SELECT @CURRENT = CONVERT(TIME, GETDATE())
	DECLARE @STORE TABLE (MACH CHAR(15))
	INSERT INTO @STORE SELECT MACH FROM @TEMP WHERE (@CURRENT > CONVERT(TIME, GIOMC)) AND (@CURRENT < CONVERT(TIME, GIODC))
	IF NOT EXISTS (SELECT * FROM @STORE)
		BEGIN
			DECLARE @ST TABLE (TENQUAN NCHAR(35))
			INSERT INTO @ST SELECT TENQUAN FROM CUAHANG WHERE TRIM(MACUAHANG) IN (SELECT TRIM(MACH) FROM @STORE)
			SELECT N'Cửa hàng chưa mở cửa' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0;
		END

	SELECT C.TENQUAN, M.TENMON, M.MIEUTA, M.GIA, C.MACUAHANG, C.GIOMOCUA, C.GIODONGCUA 
	FROM (MONAN M JOIN PHUCVU P ON M.TENMON = P.TENMON) JOIN CUAHANG C ON C.MACUAHANG = P.MACUAHANG
	WHERE TRIM(C.MACUAHANG) IN (SELECT TRIM(MACH) FROM @TEMP) AND TRIM(M.TINHTRANG) = TRIM(N'Còn Hàng')
	SELECT 'GET STORE SUCCESSFULL' AS '1'
COMMIT TRAN
RETURN 1
GO

--3. Danh sách các cửa hàng có phục vụ món ăn (Tìm cửa hàng theo tên món ăn)
--DROP PROC IF EXISTS USP_GetDiskByName
--GO

CREATE 
--ALTER 
PROC USP_GetDiskByName
	@NAME NVARCHAR(80)
AS
BEGIN TRAN
	IF NOT EXISTS (SELECT TENMON FROM MONAN WHERE TRIM(TENMON) = TRIM(@Name))
		BEGIN
			SELECT 'TENMON IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END
	
	-- món ăn có đang còn hàng không
	DECLARE @STATE NCHAR(20)
	SELECT @STATE = TINHTRANG FROM MONAN WHERE TRIM(TENMON) = TRIM(@Name)
	IF TRIM(@STATE) = N'Hết Hàng'
		BEGIN
			SELECT N'Món ăn hiện đang hết hàng' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END
	IF TRIM(@STATE) = N'Tạm Ngưng'
		BEGIN
			SELECT N'Món ăn hiện đang tạm ngưng' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	-- tình trạng của của hàng có đang hoạt động không
	DECLARE @TEMP TABLE (MACH CHAR(15), GIOMC DATETIME, GIODC DATETIME)
	INSERT INTO @TEMP SELECT PV.MACUAHANG, CH.GIOMOCUA, CH.GIODONGCUA FROM PHUCVU PV JOIN CUAHANG CH ON CH.MACUAHANG = PV.MACUAHANG WHERE TRIM(PV.TENMON) = TRIM(@NAME) AND TRIM(CH.TINHTRANG) = N'HĐ'
	--SELECT * FROM @TEMP
	IF NOT EXISTS (SELECT MACH FROM @TEMP)
		BEGIN
			SELECT N'Cửa hàng hiện không hoạt động' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	-- kiểm tra cửa hàng còn mở cửa hay không
	DECLARE @CURRENT TIME
	SELECT @CURRENT = CONVERT(TIME, GETDATE())
	DECLARE @STORE TABLE (MACH CHAR(15))
	INSERT INTO @STORE SELECT MACH FROM @TEMP WHERE (@CURRENT > CONVERT(TIME, GIOMC)) AND (@CURRENT < CONVERT(TIME, GIODC))
	IF NOT EXISTS (SELECT * FROM @STORE)
		BEGIN
			DECLARE @ST TABLE (TENQUAN NCHAR(35))
			INSERT INTO @ST SELECT TENQUAN FROM CUAHANG WHERE TRIM(MACUAHANG) IN (SELECT TRIM(MACH) FROM @STORE)
			SELECT N'Cửa hàng chưa mở cửa' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0;
		END

	SELECT C.TENQUAN, M.TENMON, M.MIEUTA, M.GIA, C.MACUAHANG, C.GIOMOCUA, C.GIODONGCUA 
	FROM (MONAN M JOIN PHUCVU P ON M.TENMON = P.TENMON) JOIN CUAHANG C ON C.MACUAHANG = P.MACUAHANG
	WHERE TRIM(C.MACUAHANG) IN (SELECT TRIM(MACH) FROM @STORE) AND TRIM(M.TENMON) = TRIM(@NAME)
	SELECT 'GET DISK SUCCESSFULL' AS '1'
COMMIT TRAN
RETURN 1
GO

--4. Lấy danh sách các đơn hảng của khách hàng
--DROP PROC IF EXISTS USP_GetOrders
--GO

CREATE 
--ALTER 
PROC USP_GetOrders
	@ID CHAR(15)
AS
BEGIN TRAN
	IF NOT EXISTS (SELECT MAKH FROM KHACHHANG WHERE TRIM(MAKH) = TRIM(@ID))
		BEGIN
			SELECT 'MAKH IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	SELECT MADONHANG, TONGGIA, TINHTRANG, NGAYLAP, TRIM(DANHGIA) AS DANHGIA  
	FROM DONDATHANG 
	WHERE TRIM(MAKH) = TRIM(@ID) 
	ORDER BY NGAYLAP DESC
	SELECT 'GET PERSONAL ORDERS SUCCESSFULL' AS '1'
COMMIT TRAN
RETURN 1
GO

--5. Thêm đơn đặt hàng
--DROP PROC IF EXISTS USP_AddOrder
--GO

CREATE 
--ALTER 
PROC USP_AddOrder
	@MADH CHAR(15),
	@MAKH CHAR(15),
	@SHIP FLOAT,
	@STATE NCHAR(20),
	@ADDRESS NCHAR(50),
	@METHOD NCHAR(15),
	@SUM FLOAT,
	@DANHGIA CHAR(30)

AS
BEGIN TRAN
	IF NOT EXISTS (SELECT MAKH FROM KHACHHANG WHERE TRIM(MAKH) = TRIM(@MAKH))
		BEGIN
			SELECT 'MAKH IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF EXISTS (SELECT MADONHANG FROM DONDATHANG WHERE TRIM(MADONHANG) = TRIM(@MADH))
		BEGIN
			SELECT 'DONHANG IS EXISTED' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF(@MADH IS NULL OR @MAKH IS NULL OR @SHIP IS NULL OR @STATE IS NULL 
	OR @ADDRESS IS NULL OR @METHOD IS NULL OR @SUM IS NULL)
		BEGIN 
			SELECT 'SOME OF THESE INPUTS WERE EMPTY' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	--DONDATHANG
	INSERT INTO DONDATHANG (MADONHANG, MAKH, PHIVANCHUYEN, TINHTRANG, DIACHI, NGAYLAP, HINHTHUCTHANHTOAN, TONGGIA, DANHGIA) VALUES (@MADH, @MAKH, @SHIP, @STATE, @ADDRESS, GETDATE(), @METHOD, @SUM, @DANHGIA)

	SELECT 'INSERT ORDER SUCCESSFULL' AS '1'
COMMIT TRAN
RETURN 1
GO


--6. Thêm DONHANG_CUAHANG
--DROP PROC IF EXISTS USP_AddOrderStore
--GO

CREATE 
--ALTER 
PROC USP_AddOrderStore
	@MADH CHAR(15),
	@MACH CHAR(15)

AS
BEGIN TRAN
	IF EXISTS (SELECT * FROM DONHANG_CUAHANG WHERE TRIM(MADONHANG) = TRIM(@MADH) AND TRIM(MACUAHANG) = TRIM(@MACH))
		BEGIN
			SELECT 'DONHANG_CUAHANG IS EXISTED' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF NOT EXISTS (SELECT MADONHANG FROM DONDATHANG WHERE TRIM(MADONHANG) = TRIM(@MADH))
		BEGIN
			SELECT 'DONHANG IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF NOT EXISTS (SELECT MACUAHANG FROM CUAHANG WHERE TRIM(MACUAHANG) = TRIM(@MACH))
		BEGIN
			SELECT 'CUAHANG IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF(@MADH IS NULL OR @MACH IS NULL)
		BEGIN 
			SELECT 'SOME OF THESE INPUTS WERE EMPTY' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	--DONHANG_CUAHANG
	INSERT INTO DONHANG_CUAHANG (MACUAHANG, MADONHANG) VALUES (@MACH, @MADH)

	SELECT 'INSERT ORDER-STORE SUCCESSFULL' AS '1'
COMMIT TRAN
RETURN 1
GO


--7. Thêm CHITIETDONHANG
--DROP PROC IF EXISTS USP_AddOrderDetail
--GO

CREATE 
--ALTER 
PROC USP_AddOrderDetail
	@MADH CHAR(15),
	@TENMON NCHAR(80),
	@DONGIA FLOAT,
	@SOLUONG INT

AS
BEGIN TRAN
	IF NOT EXISTS (SELECT MADONHANG FROM DONDATHANG WHERE TRIM(MADONHANG) = TRIM(@MADH))
		BEGIN
			SELECT 'DONHANG IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF EXISTS (SELECT * FROM CHITIETDONHANG WHERE TRIM(MADONHANG) = TRIM(@MADH) AND TRIM(TENMON) = TRIM(@TENMON))
		BEGIN
			SELECT 'CHITIETDONHANG IS EXISTED' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF NOT EXISTS (SELECT TENMON FROM MONAN WHERE TRIM(TENMON) = TRIM(@TENMON))
		BEGIN
			SELECT 'TENMON IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF(@MADH IS NULL OR @TENMON IS NULL OR @DONGIA IS NULL OR @SOLUONG IS NULL)
		BEGIN 
			SELECT 'SOME OF THESE INPUTS WERE EMPTY' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	--CHITIETDONHANG
	INSERT INTO CHITIETDONHANG (TENMON, MADONHANG, SOLUONG, DONGIA) VALUES (@TENMON, @MADH, @SOLUONG, @DONGIA)
	UPDATE MONAN SET SLDABAN = SLDABAN + @SOLUONG WHERE TRIM(TENMON) = TRIM(@TENMON)
	SELECT 'INSERT ORDER DETAIL SUCCESSFULL' AS '1'
COMMIT TRAN
RETURN 1
GO

--SELECT * FROM CHITIETDONHANG WHERE MADONHANG = 'DH222096167912'
--SELECT TENQUAN FROM CUAHANG WHERE MACUAHANG = (SELECT MACUAHANG FROM DONHANG_CUAHANG WHERE MADONHANG = 'DH222096167912')

--8. Cập nhật đánh giá của 1 đơn hàng
--DROP PROC IF EXISTS USP_UpdateFeedback
--GO

CREATE 
--ALTER 
PROC USP_UpdateFeedback
	@MADONHANG CHAR(15),
	@MAKH CHAR(15),
	@DANHGIA CHAR(30)

AS
BEGIN TRAN
	IF NOT EXISTS (SELECT MAKH FROM KHACHHANG WHERE TRIM(MAKH) = TRIM(@MAKH))
		BEGIN
			SELECT 'MAKH IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF NOT EXISTS (SELECT MADONHANG, MAKH FROM DONDATHANG WHERE TRIM(MAKH) = TRIM(@MAKH) AND TRIM(MADONHANG) = TRIM(@MADONHANG))
		BEGIN
			SELECT 'THIS ORDER IS NOT EXIST' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	IF(@MADONHANG IS NULL OR @MAKH IS NULL)
		BEGIN 
			SELECT 'SOME OF THESE INPUTS WERE EMPTY' AS 'ERROR'
			ROLLBACK TRAN
			RETURN 0
		END

	--DONDATHANG
	UPDATE DONDATHANG SET DANHGIA = @DANHGIA WHERE MADONHANG = @MADONHANG AND MAKH = @MAKH
	DECLARE @MACH CHAR(15)
	SELECT @MACH = MACUAHANG FROM DONHANG_CUAHANG WHERE MADONHANG = @MADONHANG
	UPDATE CUAHANG SET DANHGIA = CAST((CAST(LEFT(@DANHGIA, 1) AS INT) * 100 + CAST(LEFT(DANHGIA, 1) AS INT) * 100) / 200 AS VARCHAR) + '/5' WHERE MACUAHANG = @MACH
	SELECT 'UPDATE SUCCESSFULL' AS '1'
COMMIT TRAN
RETURN 1
GO

-------3. TÀI XẾ------------
--1.Danh sách tài xế
create 
--alter 
proc selectDriver
	@matx char(15)
as
begin tran
	select MATX,HOTEN,SDT, STK from TAIXE
	where MATX = @matx
commit tran
go

--2.Đăng kí tài xế ROLE TÀI XẾ
create 
--alter 
proc createDriver
	@matx char(15), 
	@cmnd char(15), 
	@hoten nchar(30), 
	@sdt char(15), 
	@bienso char(15), 
	@khuvuchd nchar(30), 
	@email char(30),
	@username char(20),
	@mk char(20), 
	@stk char(15),
	@phidangky float,
	@tinhtrangnopphi nchar(10)
as
begin tran
	begin try
		if (@matx is NULL or @cmnd is NULL or @hoten is NULL 
			or @sdt is NULL or @bienso is NULL or @khuvuchd is NULL or @email is null
			or @mk is null or @stk is null)
			begin
				select 'Not NULL for column' as 'ERROR'
				Rollback Transaction
				return 0
			end
		if exists(select MATX from TAIXE where CMND = @cmnd or USERNAME = @username or MATX = @matx)
		begin
			select 'Username already exists' as 'ERROR'
			Rollback Transaction
			return 0
		end

	end try
	begin catch
		print(N'Tạo tài khoản không thành công')
		rollback transaction
		return 0
	end catch
	insert into TAIXE values (@matx, @cmnd, @hoten, @sdt, @bienso, @khuvuchd, @email,@username ,
	@mk , @stk ,@phidangky,@tinhtrangnopphi)
	select * from TAIXE where MATX = @matx
commit tran
go

-------3.Cập nhật tình trạng nộp phí
create
--alter 
proc updateNOPPHI
	@matx char(15)
as
begin tran
	begin try
		if not exists (select * from TAIXE where MATX = @matx )
		begin
			select 'Driver does not exists' as 'ERROR'
			Rollback Transaction
			return 0
		end
	end try

	begin catch
			select' Driver does not exists' as 'ERROR'
			Rollback Transaction
			return 0
	end catch
	
	update TAIXE set TINHTRANGNOPPHI = N'Đã nộp' where MATX = @matx
	select N'Kích Hoạt Tài Khoản Thành Công' AS 'RESULT'
commit tran
go

-------4.Hiển thị tình trạng nộp phí
create 
--alter 
proc selectTINHTRANGNOPPHI
	@matx char(15)
as
begin tran
	select MATX,HOTEN,SDT, STK, TINHTRANGNOPPHI from TAIXE where MATX = @matx
commit tran
go

-------5.Danh sách đơn hàng chờ xác nhận-----------
create 
--alter 
proc selectDONCHO
as
begin tran
	select  MADONHANG, DIACHI, PHIVANCHUYEN,(PHIVANCHUYEN+TONGGIA) as TONGGIA from DONDATHANG 
	where TINHTRANG = N'Chờ vận chuyển' and TONGGIA is not null
commit tran
go

-------6.Danh Sách Đơn Đang Giao------
create
--alter
proc selectDONDANGGIAO
	@matx char(15)
as
begin tran
	if not exists(select MATX from TAIXE where MATX = @matx)
	begin
		select 'DRIVER IS NOT EXISTS' AS 'ERROR'
		return 0
	end
	
	select  MADONHANG, DIACHI, PHIVANCHUYEN,(PHIVANCHUYEN+TONGGIA) as TONGGIA from DONDATHANG 
	where TINHTRANG = N'Đang Vận Chuyển' and MATX = @matx
commit tran
go

---------7.Danh sách đơn hàng giao thành công--------
create 
--alter 
proc selectDHTHANHCONG
	@matx char(15)
as
begin tran
	select MADONHANG, NGAYLAP, PHIVANCHUYEN from DONDATHANG 
	where MATX = @matx and TINHTRANG = N'Đã Giao             ' 
	order by NGAYLAP desc
commit tran
go

-----------8.In hóa đơn----------
create 
--alter 
proc selectKHDH
	@madh char(15)
as
begin tran
	select DH.MADONHANG, NGAYLAP, HOTEN, SDT
	from KHACHHANG KH JOIN
	DONDATHANG DH ON DH.MAKH = KH.MAKH 
	where DH.MADONHANG = @madh
commit tran
go

--------9.Chi tiết món trong hóa đơn ---------
create 
--alter 
proc selectCTDH
	@madh char(15)
as
begin tran
	select CT.TENMON, CT.SOLUONG, CT.DONGIA from DONDATHANG DH 
	join CHITIETDONHANG CT on  DH.MADONHANG = CT.MADONHANG
	where  DH.MADONHANG = @madh
commit tran
go
                                                                       
select * from CHITIETDONHANG where TENMON = ' Bánh HSM                                                                       '

-----------10.IN RA DIACHI, TINHTRANG, PHIVANCHUYEN, TONGGIA TRONG GIAO DIỆN BÊN TÀI XẾ,
create 
--alter 
proc selectDIACHI
	@madh char(15)
as
begin tran
	
	select DIACHI, PHIVANCHUYEN, (PHIVANCHUYEN+TONGGIA) as TONGGIA
	from DONDATHANG
	where MADONHANG = @madh

commit tran
go


------------------11.Cập nhật tình trạng đơn hàng THÀNH ĐÃ GIAO
create 
--alter 
proc updateTINHTRANGDH
	@madh char(15),
	@matx char(15)
as
begin tran
	begin try
	declare @tinhtrang varchar(20), @madhcheck char(15), @matxcheck char(15)
		select @madhcheck = MADONHANG, @matxcheck = MATX , @tinhtrang = TINHTRANG 
		from DONDATHANG where MADONHANG = @madh
		if	@madhcheck is null
		begin
			select 'Đơn Hàng Không Tồn Tại' as 'ERROR'
			Rollback Transaction
			return 0
		end
		if	@matxcheck <> @matx
		begin
			select 'Tài Xế Không Có Đơn Hàng Này' as 'ERROR'
			Rollback Transaction
			return 0
		end
		if	@tinhtrang <> 'Đang Vận Chuyển'
		begin
			select N'Tình Trạng Đơn Hàng Không Hợp Lệ' as 'ERROR'
			Rollback Transaction
			return 0
		end
	end try

	begin catch
			select 'update error' as 'ERROR'
			Rollback Transaction
			return 0
	end catch
	update DONDATHANG set TINHTRANG = N'Đã Giao' where MADONHANG = @madh and MATX = @matx
	select N'Xác Nhận Đã Giao'AS'RESULT'
commit tran
go

----------12.Cập nhật tình trạng đơn hàng CHỜ THÀNH ĐANG VẬN CHUYỂN
create 
--alter 
proc updateTINHTRANGCHO
	@madh char(15),
	@matx char(15)
as
begin tran
	begin try
		declare @tinhtrang varchar(20), @madhcheck char(15)
		select @madhcheck = MADONHANG , @tinhtrang = TINHTRANG from DONDATHANG where @madh = MADONHANG
		if not exists (select * from DONDATHANG where @madh = MADONHANG)
		begin
			select 'BILL does not exists' as 'ERROR'
			Rollback Transaction
		end
		if	@tinhtrang <> 'Chờ Vận Chuyển'
		begin
			select N'Tình Trạng Không Hợp Lệ' as 'ERROR'
			Rollback Transaction
			return 0
		end
	end try

	begin catch
			select 'update error' as 'ERROR'
			Rollback Transaction
			return 0
	end catch
	update DONDATHANG set TINHTRANG = N'Đang Vận Chuyển', MATX = @matx where MADONHANG = @madh
	select N'Nhận Đơn Hàng Thành Công'AS'RESULT'
commit tran
go

--13.hiển thị tình trạng, phí, giá ở giao diện theo dõi đơn
create 
--alter 
proc sp1_updateTINHTRANG
	@madh char(15)
as
begin tran
	select TINHTRANG, PHIVANCHUYEN,  TONGGIA 
	from DONDATHANG DH
	where DH.MADONHANG = @madh
commit tran
go


--14.hiện mã đơn, địa chỉ, họ tên, sđt ở giao diện theo dõi đơn
create
--alter 
proc sp2_updateTINHTRANG
	@madh char(15)
as
begin tran
	select DH.MADONHANG, DH.DIACHI, HOTEN, SDT
	from KHACHHANG KH JOIN
	DONDATHANG DH ON DH.MAKH = KH.MAKH 
	where DH.MADONHANG = @madh
commit tran
go


---15------update mật khẩu cho tài xế---------------
create 
--alter
proc updatePasswordDriver
	@matx char(15),
	@newpass char(20)
AS
Begin tran
	if not exists(select MATX from TAIXE where MATX = @matx) 
	begin
		select 'DRIVER IS NOT EXISTS' AS 'ERROR'
		rollback tran
		return 0
	end
	if(len(@newpass) < 8 )
	begin
		select 'Length of password is too short' AS 'ERROR'
		rollback tran
		return 0
	end
	update TAIXE 
	set MK = @newpass
	where MATX = @matx
	select 'Changed password successfully' as 'RESULT'
commit tran
return 1
---16-------------XEM THÔNG TIN CHUNG TÀI XẾ------------------------------------

create
--alter 
proc getDriverbyID
	@matx char(15)
as
begin
	if not exists(select MATX from TAIXE where MATX = @matx)
	begin
		select N'Tài Xế Không Tồn Tại'as 'ERROR'
		return 0
	end
	select *from TAIXE where MATX = @matx
end

-------4. NHÂN VIÊN------------
------1. THỐNG KÊ HÓA ĐƠN THEO NGÀY THÁNG NĂM
CREATE 
--ALTER
PROC ThongKeHD
	@masothue CHAR(15),
	@ngaythangnam DATETIME,
	@type CHAR(10)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM DOITAC WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER IS NOT EXISTS' AS 'ERROR'
		RETURN 0
	END
	IF NOT EXISTS (SELECT *FROM CUAHANG WHERE MASOTHUE = @masothue)
	BEGIN
		SELECT 'PARTNER HAS NO RESTAURANT' AS 'ERROR'
		RETURN 0
	END

	IF(@type = 'DAY')
	BEGIN
		
		SELECT DDH.MADONHANG, MAKH, DDH.DANHGIA, TONGGIA
		FROM CUAHANG CH JOIN DONHANG_CUAHANG DC 
		ON CH.MASOTHUE = @masothue AND CH.MACUAHANG = DC.MACUAHANG 
		JOIN DONDATHANG DDH ON DC.MADONHANG = DDH.MADONHANG
		where  day(DDH.NGAYLAP) = day(@ngaythangnam) 
			and month(DDH.NGAYLAP) = month(@ngaythangnam)  and year(DDH.NGAYLAP) = year(@ngaythangnam) 

	END

	ELSE IF(@type = 'MONTH' )
	BEGIN
		
		SELECT DDH.MADONHANG, MAKH, DDH.DANHGIA, TONGGIA
		FROM CUAHANG CH JOIN DONHANG_CUAHANG DC 
		ON CH.MASOTHUE = @masothue AND CH.MACUAHANG = DC.MACUAHANG 
		JOIN DONDATHANG DDH ON DC.MADONHANG = DDH.MADONHANG
		where  month(DDH.NGAYLAP) = month(@ngaythangnam)  and year(DDH.NGAYLAP) = year(@ngaythangnam) 
	END

	ELSE IF(@type = 'YEAR' AND DATEPART(YEAR, @ngaythangnam) <= DATEPART(YEAR, GETDATE()))
	BEGIN
		
		SELECT DDH.MADONHANG, MAKH, DDH.DANHGIA, TONGGIA
		FROM CUAHANG CH JOIN DONHANG_CUAHANG DC 
		ON CH.MASOTHUE = @masothue AND CH.MACUAHANG = DC.MACUAHANG 
		JOIN DONDATHANG DDH ON DC.MADONHANG = DDH.MADONHANG
		where year(DDH.NGAYLAP) = year(@ngaythangnam) 
	END

	ELSE
	BEGIN
		SELECT 'TYPE IS INVAILD'
	END
END


--2. Liệt kê hợp đồng chưa được duyệt
CREATE 
--ALTER
PROC NV_LietKeHopDong
AS
BEGIN
	SELECT MAHOPDONG, MASOTHUE, MANV ,DATEDIFF(MONTH,GETDATE(),NGAYKETTHUC) THOIGIANCONLAI
	FROM HOPDONG 
	where DATEDIFF(month,GETDATE(),NGAYKETTHUC) between 1 and 3  or MANV is null
END
EXEC NV_LietKeHopDong

--3. Nhân viên duyệt hợp đồng
CREATE 
--ALTER
PROC NV_DuyetHopDong
	@manv char(15),
	@mahd char(15),
	@masothue char(15)
AS
BEGIN tran
	if not exists(select MANV from NHANVIENCONGTY where MANV = @manv)
	begin
		select N'Nhân Viên Không Tồn Tại' as 'ERROR'
		rollback tran
		return 0
	end
	update DOITAC 
	set MANV = @manv
	where MASOTHUE = @masothue

	update HOPDONG 
	set MANV = @manv
	where MAHOPDONG = @mahd and MASOTHUE = @masothue

	select N'Duyệt Hợp Đồng Thành Công' as 'RESULT'
commit tran
return 1

--4. Liệt kê hợp đồng phụ trách
CREATE 
--ALTER
PROC NV_LietKeHopDongPhuTrach
	@manv char(15)
AS
BEGIN
	SELECT MAHOPDONG, MASOTHUE, MANV ,DATEDIFF(MONTH,GETDATE(),NGAYKETTHUC) THOIGIANCONLAI
	FROM HOPDONG 
	where MANV  = @manv
END

--5. Tìm hợp đồng theo mã đối tác
CREATE 
--alter
PROC GetContractsByName
	@Madoitac varchar(15) 
AS
BEGIN TRAN
	DECLARE @nam int, @thang int, @tghluc nvarchar(10), @trangthai nvarchar(10)

	SET @nam=(SELECT DATEDIFF(YEAR,NGAYBATDAU,NGAYKETTHUC ) FROM HOPDONG WHERE MASOTHUE=@Madoitac)
		
	IF @nam<=0
	begin
		set @thang=(SELECT DATEDIFF(month,NGAYBATDAU,NGAYKETTHUC ) FROM HOPDONG  WHERE MASOTHUE=@Madoitac)
		set	@trangthai=N'Sắp hết hạn'
		set	@tghluc= cast(@thang as varchar(2)) + N'Tháng'
	end
	ELSE
	begin 
		set @trangthai=N'Còn hạn'
		set	@tghluc= cast(@nam as varchar(2)) + N'Năm'
	end
		

	SELECT MAHOPDONG,MASOTHUE,@tghluc, @trangthai
	FROM HOPDONG 
COMMIT TRAN 
GO



go
-------5.NHÂN VIÊN QUẢN TRỊ------------
--1.Tạo tài khoản nhân viên
create 
--alter 
proc createEMP
	@manv char(15), 
	@cmnd char(15), 
	@hoten nchar(30), 
	@diachi nchar(50), 
	@stk char(15),
	@email char(50), 
	@mk char(20),
	@sdt char(15)
as
begin tran
	begin try
		if (@manv is NULL or @cmnd is NULL or @hoten is NULL 
			or @sdt is NULL or @email is null or @diachi is NULL
			or @mk is null or @stk is null )
			begin
				select 'Not NULL for column' as 'ERROR'
				Rollback Transaction
				return 0
			end
		if exists (select * from NHANVIENCONGTY where @cmnd = CMND OR @manv = MANV)
			begin
				select 'Nhân viên đã tồn tại' as 'ERROR'
				Rollback Transaction
				return 0
			end

	end try
	begin catch
		print(N'Tạo tài khoản không thành công')
		rollback transaction
		return 0
	end catch
	insert into NHANVIENCONGTY values (@manv, @cmnd, @hoten, @diachi, @stk, @email, @mk, @sdt, null)
	select * from NHANVIENCONGTY where MANV = @manv
commit tran
go

--------2 Danh Sách Nhân Viên của Nhân Viên Quản Lý-----------------
create 
--alter
proc NV_danhsachnvQL
  @manv char(15)
as
begin	
	select MANV, HOTEN, CMND, SDT from NHANVIENCONGTY where NVQL = @manv
end

---------3 Danh Sách Nhân Viên Chờ Duyệt--------------------------
create
--alter
proc NV_danhsachnvduyet
AS
begin
	select NV1.MANV, NV1.HOTEN, NV1.CMND, nv1.SDT from NHANVIENCONGTY NV1 where NVQL is null
	--and not exists( select NV2.MANV from NHANVIENCONGTY NV2 where NV1.MANV = NV2.NVQL)
end

-----------4 Nhân Viên Quản Lý Duyệt Nhân Viên--------------
create
--alter
proc	
	@nvduyet char(15),
	@nv char(15)
as
begin tran
	if not exists(select MANV from NHANVIENCONGTY where MANV = @nv)
	begin
		SELECT N'Không Tồn Tại Nhân Viên' as'ERROR'
		rollback tran
		return 0
	end
	update NHANVIENCONGTY
	set NVQL = @nvduyet
	where MANV = @nv
	select N'Duyệt Nhân Viên Thành Công' as 'RESULT'
commit tran
return 1
---5-------Xem Thông Tin Nhân viên bằng id--------------------
create
--alter
proc getstaffbyid
	@manv char(15)
as
begin
	if not exists(select MANV from NHANVIENCONGTY where MANV = @manv)
	begin
		select N'Nhân Viên Không Tồn Tại'as 'ERROR'
		return 0
	end
	select *from NHANVIENCONGTY where MANV = @manv
end
----6-----------update nhân viên--------------------
create 
--alter
proc NV_capnhatthongtin
	@manv char(15),
	@diachi nchar(50),
	@stk char(15),
	@email char(30),
	@mk char(20),
	@sdt char(15)
AS
begin tran

	if not exists(select MANV from NHANVIENCONGTY where MANV = @manv)
	begin
		select N'Nhân Viên Không Tồn Tại'as 'ERROR'
		rollback tran
		return 0
	end
	if(len(@diachi) <> 0)
	begin
		update NHANVIENCONGTY 
		set DIACHI = @diachi
		where MANV = @manv
	end
	if(len(@stk) <> 0)
	begin
		update NHANVIENCONGTY 
		set STK = @stk
		where MANV = @manv
	end
	if(len(@email) <> 0)
	begin
		update NHANVIENCONGTY 
		set EMAIL = @email
		where MANV = @manv
	end
	if(len(@mk) <> 0)
	begin
		update NHANVIENCONGTY 
		set MK = @mk
		where MANV = @manv
	end
	if(len(@sdt) <> 0)
	begin
		update NHANVIENCONGTY 
		set SDT = @sdt
		where MANV = @manv
	end
	select N'Cập Nhật Thông Tin Thành Công' as 'RESULT'
commit tran
return 1

select * from DOITAC