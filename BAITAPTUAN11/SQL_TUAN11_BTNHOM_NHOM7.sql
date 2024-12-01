--lệnh if exists để xóa database nếu đã tồn tại trước đó 
USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Nhom7_Tuan11')
BEGIN
    ALTER DATABASE Nhom7_Tuan11 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Nhom7_Tuan11;
END;
create database Nhom7_Tuan11
go
use Nhom7_Tuan11
go
create table NHACUNGCAP
(
	MACONGTY char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50) not null,
	DIACHI nvarchar(50) not null,
	DIENTHOAI varchar(10) unique not null,
	FAX varchar(10) unique not null,
	EMAIL varchar(30) unique not null,
)
create table LOAIHANG 
(
	MALOAIHANG char(10) primary key,
	TENLOAIHANG nvarchar (30) not null,
)
create table MATHANG
(
	MAHANG char(10) primary key,
	TENHANG nvarchar(30) not null,
	NHACUNGCAPNO char(10) not null 
		foreign key references NHACUNGCAP(MACONGTY)
		on 
			delete cascade 
		on 
			update cascade,
	LOAIHANGNO char(10) not null 
		foreign key references LOAIHANG(MALOAIHANG)
		on 
			delete cascade 
		on 
			update cascade,
	SOLUONG int check(SOLUONG>=0) not null,
	DONVITINH nvarchar(20) not null,
	GIAHANG money check(GIAHANG>=0) not null,
)
create table KHACHHANG
(
	MAKHACHHANG char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50) not null,
	DIACHI nvarchar(100) not null,
	EMAIL varchar(50) unique not null ,
	DIENTHOAI char(10) unique not null,
	FAX char (10) unique not null,
)
create table NHANVIEN
(
	MANHANVIEN char(10) primary key,
	HO nvarchar(50) not null,
	TEN nvarchar(50) not null,
	NGAYSINH date not null,
	NGAYLAMVIEC datetime default getdate() null,
	DIACHI nvarchar(100) not null,
	DIENTHOAI char(10) unique not null,
	LUONGCOBAN decimal(10,2) default 5000000.00 null,
	PHUCAP decimal(10,2) not null,
)
create table DONDATHANG
(
	SOHOADON char(10) primary key,
	KHACHHANGNO char(10) not null 
		foreign key references KHACHHANG(MAKHACHHANG)
		on 
			delete cascade 
		on 
			update cascade,
	MANHANVIEN char(10) not null 
		foreign key references NHANVIEN(MANHANVIEN)
		on 
			delete cascade 
		on 
			update cascade,
	NGAYDATHANG date not null,
	NGAYGIAOHANG date not null,
	NGAYCHUYENHANG date null,
	NOIGIAOHANG nvarchar(100) null,
)
create table CHITIETDATHANG
(
	DONDATHANGNO char(10) not null 
		foreign key references DONDATHANG(SOHOADON)
		on 
			delete cascade 
		on 
			update cascade,
	MATHANGNO char(10) not null 
		foreign key references MATHANG(MAHANG)
		on 
			delete cascade 
		on 
			update cascade,
	primary key(DONDATHANGNO,MATHANGNO),
	GIABAN decimal(10,2) not null,
	SOLUONG float not null,
	MUCGIAMGIA decimal(6,4) not null,
)
--=======================================================TUẦN 6====================================================================================-
--2. Bổ sung ràng buộc thiết lập giá trị mặc định bằng 1 cho cột SOLUONG  và bằng 0 cho cột MUCGIAMGIA trong bảng CHITIETDATHANG
alter table CHITIETDATHANG
	add
		constraint DF_CHITIETDONHANG_SOLUONG 
			default 1 for SOLUONG,
		constraint DF_CHITIETDATHANG_MUCGIAMGIA
			default 0 for MUCGIAMGIA;
--3. Bổ sung cho bảng DONDATHANG ràng buộc kiểm tra ngày giao hàng và ngày chuyển hàng phải sau hoặc bằng với ngày đặt hàng.
alter table DONDATHANG
	add 
		constraint CK_DONDATHANG_NGAYGIAOHANG 
			check(NGAYGIAOHANG >= NGAYDATHANG),
		constraint CK_DONDATHANG_NGAYCHUYENHANG
			check(NGAYCHUYENHANG >= NGAYDATHANG);
--4. Bổ sung ràng buộc cho bảng NHANVIEN để đảm bảo rằng một nhân viên chỉ có thể làm việc trong công ty khi đủ 18 tuổi và không quá 60 tuổi
--Thêm các ràng buộc của bảng NHANVIEN
alter table NHANVIEN
	add
		constraint CK_NHANVIEN_NGAYSINH 
			check(datediff(year,NGAYSINH,getdate())>=18 and datediff(year,NGAYSINH,getdate())<=60),
		constraint CK_NHANVIEN_DIENTHOAI
			check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
--Thêm các ràng buộc của bảng KHACHHANG
alter table KHACHHANG
	add
		constraint CK_KHACHHANG_EMAIL
			check  (Email like '[A-Za-z]%@gmail.com'),
		constraint CK_KHACHHANG_DIENTHOAI
			check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
-- Bổ sung ràng buộc cho bảng NHACUNGCAP
ALTER TABLE NHACUNGCAP
ADD
    CONSTRAINT CK_NHACUNGCAP_DIENTHOAI CHECK (DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_NHACUNGCAP_FAX CHECK (FAX LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_NHACUNGCAP_EMAIL CHECK (Email like '[A-Za-z]%@gmail.com');
-- Bổ sung ràng buộc cho bảng LOAIHANG
ALTER TABLE LOAIHANG
ADD
    CONSTRAINT UQ_LOAIHANG_TENLOAIHANG UNIQUE (TENLOAIHANG);
--Bổ sung ràng buộc cho bảng CHITIETDATHANG
ALTER TABLE CHITIETDATHANG
ADD 
   CONSTRAINT CK_CHITIETDATHANG_GIABAN CHECK (GIABAN > 0);

--=====================================================TUẦN 7==========================================================================----
--==============BỔ SUNG PHẦN RÀNG BUỘC Ở phần TUẦN 6 (ở trên !!!!!!!)!!!!!!=========-----------------------------------------
/*Các nhóm rà soát lại tuần 5 và tuần 6 để hoàn thành file báo cáo tổng hợp và dùng lệnh INSERT để
cập nhật dữ liệu vào các bảng của mình sao cho phù hợp với kiểu giữ liệu và ràng buộc mà mình đã tạo ra ở 2 tuần trước.*/
--==Thêm dữ liệu ở đây !!!!!==-
set dateformat dmy
insert into NHANVIEN
	values
		('nvso000001',N'Trần Văn Thọ',N'Khang','15/05/2005',getdate(),N'Trà My','0977289870',Default,200000),
		('nvso000002',N'Phạm Hữu',N'Nguyên','15/02/2005',default,N'Phu Ngan','0977289871',6000000,200000),
		('nvso000003',N'Dương Thành',N'Long','15/01/2005',getdate(),N'Phú Xuân','0977289872',7000000,200000),
		('nvso000004',N'Ngô Hoàng',N'Huy','15/03/2005',getdate(),N'Phu Thạnh','0977289873',Default,200000),
		('nvso000005',N'Nguyễn Trần Minh',N'Trí','15/04/2005',getdate(),N'Phu Xuân','0977289874',3000000,200000),
		('nvso000006',N'Trần Đặng Tuấn',N'Khanh','15/03/2005',getdate(),N'Phu Ngạn','0977289875',default,200000),
		('nvso000007',N'Nguyễn',N'Huỳnh','15/07/2005',getdate(),N'Phu Lương','0977289876',Default,200000),
		('nvso000008',N'Đặng Hoàng Kim',N'Hạnh','12/10/2005',getdate(),N'Phu Thạnh','0977289877',9000000,200000),
		('nvso000009',N'Ngô Kim',N'Huy','15/12/2005',getdate(),N'Phu Mã','0977289878',Default,200000),
		('nvso000010',N'Lê Ngọc Phúc',N'Ân','15/10/2005',getdate(),N'Phu Thạnh','0977289879',1500000,200000),
		('nvso000011',N'Lê Ngọc Phúc',N'Hoang','15/10/2005',getdate(),N'Phu Thạnh','0977289819',1500000,200000),
		('nvso000012',N'Lê Ngọc Phúc',N'Kim','15/10/2005',getdate(),N'Phu Thạnh','0977289829',1500000,200000);

--select *from NHANVIEN
insert into KHACHHANG
	values
		('khso000001',N'Công ty VINAMILK',N'giao dịch ví điện tử',N'Cà Mau','khangheheqt1@gmail.com','0112233440','kh12345670'),
		('khso000002',N'Công ty Ánh Viên',N'giao dịch bitcoin',N'Thừa Thiên Huế','khangheheqt2@gmail.com','0112233441','kh12345671'),
		('khso000003',N'Công ty Mai Mai',N'giao dịch tiền mặt',N'Hồ Chí Minh','khangheheqt3@gmail.com','0112233442','kh12345672'),
		('khso000004',N'Công ty Ánh Ánh',N'giao dịch thanh toán qua app',N'Biên Hòa','khangheheqt4@gmail.com','0112233443','kh12345673'),
		('khso000005',N'Công ty Hoan Thai',N'giao dịch ví điện tử',N'Bình Định','khangheheqt5@gmail.com','0112233444','kh12345674'),
		('khso000006',N'Công ty Trường Phát',N'giao dịch tiền ảo',N'Hà Nội','khangheheqt6@gmail.com','0112233445','kh12345675'),
		('khso000007',N'Công ty Trường Tồn',N'giao dịch giải ngân',N'Buôn Mê Thuột','khangheheqt7@gmail.com','0112233446','kh12345676'),
		('khso000008',N'Công ty Kim Lan',N'giao dịch trung gian',N'Playku','khangheheqt8@gmail.com','0112233447','kh12345677'),
		('khso000009',N'Công ty Mái Tôn',N'giao dịch ví điện tử',N'Cam Ranh','khangheheqt9@gmail.com','0112233448','kh12345678'),
		('khso000010',N'Công ty Hoa Sen',N'giao dịch ví điện tử',N'Quảng Nam','khangheheqt10@gmail.com','0112233449','kh12345679');
--select *from KHACHHANG
-- Thêm dữ liệu vào bảng NHACUNGCAP
INSERT INTO NHACUNGCAP (MACONGTY, TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI, FAX, EMAIL)
VALUES
    ('CTso000001', N'công ty VINAMILK', N'Giao dịch VINAMILK', N'Địa chỉ A', '0123456789', '0987654321', 'emailA@gmail.com'),
    ('CTso000002', N'Công ty Phương Lĩnh', N'giao dịch tiền ảo', N'Địa chỉ B', '0123756789', '0987654322', 'emailB@gmail.com'),
    ('CTso000003', N'Công ty C', N'giao dịch ví điện tử', N'Địa chỉ D', '0193457787', '0987654323', 'emailC@gmail.com'),
	('CTso000004', N'Công ty Việt Tiến', N'giao dịch thương mại', N'Địa chỉ B', '0193457788', '0987694323', 'emailD@gmail.com'),
	('CTso000005', N'Công ty A', N'giao dịch giải ngân', N'Địa chỉ C', '0193457773', '0987604323', 'emailE@gmail.com'),
	('CTso000006', N'Công ty A', N'giao dịch trung gian', N'Địa chỉ C', '0193459887', '0980650323', 'emailF@gmail.com'),
	('CTso000007', N'Công ty Ánh Ánh', N'Giao dịch thanh toán qua app', N'Địa chỉ A', '0193459987', '0987054323', 'emailG@gmail.com'),
	('CTso000008', N'Công ty Mai Mai', N'Giao dịch tiền mặt', N'Địa chỉ E', '0197457787', '0987604023', 'emailH@gmail.com'),
	('CTso000009', N'công ty VINAHOUSE', N'Giao dịch tiền ảo', N'Địa chỉ F', '0103457787', '0987650323', 'emailI@gmail.com'),
	('CTso000010', N'Công ty B', N'Giao dịch ví điện tử', N'Địa chỉ N', '0191257787', '0987004323', 'emailJ@gmail.com');
-- Thêm dữ liệu vào bảng LOAIHANG
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG)
VALUES
    ('LHso000001', N'Loại hàng thực phẩm'),
    ('LHso000002', N'Loại hàng B9'),
    ('LHso000003', N'Loại hàng C9'),
	('LHso000004', N'Loại hàng D9'),
	('LHso000005', N'Loại hàng E9'),
	('LHso000006', N'Loại hàng F9'),
	('LHso000007', N'Loại hàng C1'),
	('LHso000008', N'Loại hàng C2'),
	('LHso000009', N'Loại hàng C3'),
	('LHso000010', N'Loại hàng cá');
--Thêm dữ liệu vào bảng MATHANG
INSERT INTO MATHANG
VALUES 
	('MH00000001', N'Tivi Sony', 'CTso000001', 'LHso000001', 120, N'Máy', 5000000),
	('MH00000002', N'Tivi Samsung', 'CTso000001', 'LHso000002', 100, N'Máy', 6000000),
	('MH00000003', N'Iphone 16', 'CTso000002', 'LHso000003', 111, N'Máy', 26000000),
	('MH00000004', N'Máy cắt tóc', 'CTso000003', 'LHso000002', 130, N'Máy', 1500000),
	('MH00000005', N'Laptop Asus', 'CTso000004', 'LHso000001', 140, N'Máy', 18000000),
	('MH00000006', N'Tivi Casper', 'CTso000004', 'LHso000004', 45, N'Máy', 6000000),
	('MH00000007', N'Whey Rule 1', 'CTso000002', 'LHso000005', 107, N'Hũ', 1600000),
	('MH00000008', N'Giày Bitis', 'CTso000004', 'LHso000006', 106, N'Đôi', 300000),
	('MH00000009', N'Sữa hộp XYZ', 'CTso000007', 'LHso000007', 20, N'Quả', 150000),
	('MH00000010', N'Máy sấy tóc', 'CTso000009', 'LHso000008', 100, N'Máy', 1200000)
--Thêm dữ liệu vào bảng DONDATHANG
set dateformat dmy
INSERT INTO DONDATHANG
VALUES
	('SHD0000001', 'khso000001', 'nvso000001', '21-2-2022', '23-2-2022', null, N'Tại nơi đặt hàng'),
	('SHD0000002', 'khso000001', 'nvso000002', '21-2-2022', '23-3-2022', '22-3-2023', null),
	('SHD0000003', 'khso000002', 'nvso000002', '21-4-2022', '23-4-2022', null, null),
	('SHD0000004', 'khso000003', 'nvso000004', '21-5-2022', '23-5-2022', '22-5-2023', N'Tại nơi đặt hàng'),
	('SHD0000005', 'khso000004', 'nvso000001', '21-6-2022', '23-6-2022', null, N'99 Hà Huy Tập'),
	('SHD0000006', 'khso000005', 'nvso000005', '21-7-2022', '23-7-2022', '22-7-2023', N'13/48 Dương Thành Long'),
	('SHD0000007', 'khso000003', 'nvso000006', '21-8-2022', '23-8-2022', '22-8-2023',null),
	('SHD0000008', 'khso000004', 'nvso000007', '21-8-2022', '23-9-2023', '22-9-2023', N'78 Thọ Khang'),
	('SHD0000009', 'khso000006', 'nvso000008', '21-10-2023', '23-10-2023', '22-10-2023', N'12 Tôn Đản'),
	('SHD0000010', 'khso000007', 'nvso000002', '21-11-2023', '23-11-2023', '22-11-2023', N'90 Dinh Độc Lập')
--Thêm dữ liệu của các bảng CHITIETDATHANG.
INSERT INTO CHITIETDATHANG 
VALUES 
    ('SHD0000001', 'MH00000003', 26000000, 110, 0), 
    ('SHD0000002', 'MH00000002', 6000000, 110, 1),  
    ('SHD0000003', 'MH00000005', 18000000, 110, 2), 
    ('SHD0000004', 'MH00000006', 6000000, 120, 3),  
    ('SHD0000005', 'MH00000007', 1600000, 110, 2), 
    ('SHD0000006', 'MH00000008', 300000, 80, 1), 
    ('SHD0000007', 'MH00000009', 150000, 70, 0), 
    ('SHD0000008', 'MH00000010', 1200000, 54, 1),
    ('SHD0000009', 'MH00000001', 5000000, 60, 2), 
    ('SHD0000010', 'MH00000003', 1500000, 80, 3); 
--==============================================TUẦN 8===========================================================
--Câua. Cập nhật lại giá trị trường NGAYCHUYENHANG của những bản ghi 
--có NGAYCHUYENHANG chưa xác định (NULL) trong bảng DONDATHANG bằng với giá trị của trường NGAYDATHANG.
update DONDATHANG
set NGAYCHUYENHANG = NGAYDATHANG
where NGAYCHUYENHANG is null;
--Câub. Tăng số lượng hàng của những mặt hàng do công ty VINAMILK cung cấp lên gấp đôi.
UPDATE CHITIETDATHANG
SET SOLUONG = SOLUONG * 2
WHERE MATHANGNO IN (
    SELECT MAHANG FROM MATHANG
    WHERE NHACUNGCAPNO = (
        SELECT NHACUNGCAPNO FROM NHACUNGCAP WHERE TENCONGTY = N' công ty VINAMILK'
    )
);
--CâuC.Cập nhật giá trị của trường NOIGIAOHANG trong bảng DONDATHANG bằng địa chỉ của khách hàng đối với những đơn
--đặt hàng chưa xác định được nơi giao hàng (giá trị trường NOIGIAOHANG bằng NULL).
UPDATE DONDATHANG
SET NOIGIAOHANG = (
    SELECT DIACHI FROM KHACHHANG WHERE DONDATHANG.KHACHHANGNO = KHACHHANG.MAKHACHHANG
)
WHERE NOIGIAOHANG IS NULL;
--CâuD. Cập nhật lại dữ liệu trong bảng KHACHHANG sao cho nếu tên công ty và tên giao dịch của khách hàng trùng với tên công ty và
--tên giao dịch của một nhà cung cấp nào đó thì địa chỉ, điện thoại, fax và e-mail phải giống nhau.
UPDATE KHACHHANG
SET DIACHI = NCC.DIACHI,
    DIENTHOAI = NCC.DIENTHOAI,
    FAX = NCC.FAX,
    EMAIL = NCC.EMAIL
FROM NHACUNGCAP AS NCC
WHERE KHACHHANG.TENCONGTY = NCC.TENCONGTY
AND KHACHHANG.TENGIAODICH = NCC.TENGIAODICH;
--CâuE. Tăng lương lên gấp rưỡi cho những nhân viên bán được số lượng hàng nhiều hơn 100 trong năm 2022.
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 1.5
WHERE MANHANVIEN IN (
    SELECT MANHANVIEN
    FROM DONDATHANG, CHITIETDATHANG
    WHERE YEAR(NGAYDATHANG) = 2022 
    GROUP BY MANHANVIEN
    HAVING SUM(SOLUONG) > 100
);

--Câu F.Tăng phụ cấp lên bằng 50% lương cho những nhân viên bán được hàng nhiều nhất.
UPDATE NHANVIEN
SET PHUCAP = LUONGCOBAN * 0.5
WHERE MANHANVIEN IN (
    SELECT MANHANVIEN
    FROM DONDATHANG, CHITIETDATHANG
	WHERE DONDATHANG.SOHOADON = CHITIETDATHANG.DONDATHANGNO
    GROUP BY MANHANVIEN
    HAVING SUM(SOLUONG) = (
        SELECT MAX(TongSoLuong)
        FROM (
            SELECT SUM(CHITIETDATHANG.SOLUONG) AS TongSoLuong
            FROM DONDATHANG, CHITIETDATHANG
			WHERE DONDATHANG.SOHOADON = CHITIETDATHANG.DONDATHANGNO
            GROUP BY MANHANVIEN
        ) AS Subquery
    )
);
--CâuG. Giảm 25% lương của những nhân viên trong năm 2023 không lập được bất kỳ đơn đặt hàng nào.
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 0.75
WHERE MANHANVIEN NOT IN (
    SELECT DISTINCT MANHANVIEN
    FROM DONDATHANG
    WHERE YEAR(NGAYDATHANG) = 2023
);
--============================================BÀI TẬP CÁ NHÂN==============================================-
--Câu 1. Họ tên và địa chỉ và năm bắt đầu làm việc của các nhân viên trong công ty
select Ho, TEN, DIACHI, year (NGAYLAMVIEC)
from NHANVIEN
--Câu 2. Công ty [Việt Tiến] đã cung cấp những mặt hàng nào?
select MACONGTY, TENCONGTY, MAHANG, TENHANG
from MATHANG, NHACUNGCAP
where NHACUNGCAP.MACONGTY = MATHANG.NHACUNGCAPNO and TENCONGTY = N'Công ty Việt Tiến';
--3. Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty (tức là có cùng tên giao dịch).
select kh.MAKHACHHANG, kh.TENCONGTY, kh.TENGIAODICH
from KHACHHANG kh, NHACUNGCAP ncc
where kh.TENCONGTY = ncc.TENCONGTY and kh.TENGIAODICH= ncc.TENGIAODICH
--Câu 4. Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào
select MANHANVIEN, HO, TEN
from NHANVIEN
where MANHANVIEN not in(
	select MANHANVIEN
	from DONDATHANG);
	
--Câu 5. Mỗi một nhân viên của công ty đã lập  bao nhiêu đơn đặt hàng (nếu nhân viên chưa hề lập một hoá đơn nào thì cho kết quả là 0)
SELECT nv.MANHANVIEN, nv.HO, nv.TEN, COUNT(ddh.MANHANVIEN) AS SoLuongDonDat
FROM NHANVIEN nv
LEFT JOIN DONDATHANG ddh ON nv.MANHANVIEN = ddh.MANHANVIEN
GROUP BY nv.MANHANVIEN, nv.HO, nv.TEN;

select nv.MANHANVIEN, nv.HO, nv.TEN, 
		(Select count(*)
		from DONDATHANG ddh
		where ddh.MANHANVIEN = nv.MANHANVIEN) as SoluongDon
from NHANVIEN nv;

SELECT nhanvien.manhanvien,ho,ten,COUNT(sohoadon)   FROM nhanvien LEFT OUTER JOIN dondathang 
 	 	ON nhanvien.manhanvien=dondathang.manhanvien 
  GROUP BY nhanvien.manhanvien,ho,ten
--Câu 6. biết tổng số tiền hàng mà cửa hàng thu được trong mỗi tháng của năm 2022 (thời được gian tính theo ngày đặt hàng).
SELECT MONTH(DONDATHANG.NGAYDATHANG) AS Thang, SUM(CHITIETDATHANG.GIABAN * CHITIETDATHANG.SOLUONG - CHITIETDATHANG.GIABAN * CHITIETDATHANG.SOLUONG*MUCGIAMGIA/100) AS TongTien
FROM DONDATHANG, CHITIETDATHANG
WHERE DONDATHANG.SOHOADON = CHITIETDATHANG.DONDATHANGNO AND YEAR(DONDATHANG.NGAYDATHANG) = 2022
GROUP BY MONTH(DONDATHANG.NGAYDATHANG);

SELECT MONTH(ngaydathang) AS thang, 
 	      SUM(soluong*giaban-soluong*giaban*mucgiamgia/100) 
  FROM dondathang INNER JOIN chitietdathang  
 	     ON dondathang.SOHOADON =chitietdathang.DONDATHANGNO
  WHERE year(ngaydathang)=2022 
 GROUP BY MONTH(NgayDatHang);
 --===========================================BÀI TẬP TUẦN 10============================================
 --1. Địa chỉ và điện thoại của nhà cung cấp có tên giao dịch [VINAMILK] 
select NHACUNGCAP.DIACHI, NHACUNGCAP.DIENTHOAI
from NHACUNGCAP
where TENGIAODICH= N'Giao dịch VINAMILK';
--2. Loại hàng thực phẩm do những công ty nào cung cấp và địa chỉ công ty đó là gì  
select ncc.MACONGTY, ncc.TENCONGTY, ncc.DIACHI
from MATHANG mh, LOAIHANG lh, NHACUNGCAP ncc
where mh.LOAIHANGNO = lh.MALOAIHANG and ncc.MACONGTY = mh.NHACUNGCAPNO and lh.TENLOAIHANG = N'Loại hàng thực phẩm';
--3.Những khách hàng nào (tên giao dịch) đã đặt mua mặt hàng sữa hộp XYZ của công ty
select KHACHHANG.MAKHACHHANG, KHACHHANG.TENCONGTY, KHACHHANG.TENGIAODICH
from DONDATHANG, KHACHHANG, CHITIETDATHANG, MATHANG
where KHACHHANG.MAKHACHHANG	= DONDATHANG.KHACHHANGNO and DONDATHANG.SOHOADON = CHITIETDATHANG.DONDATHANGNO and CHITIETDATHANG.MATHANGNO = MATHANG.MAHANG
and MATHANG.TENHANG = N'Sữa hộp XYZ';
--4. Những đơn hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những công ty đó là công ty nào
select KHACHHANG.MAKHACHHANG, KHACHHANG.TENCONGTY, DONDATHANG.NOIGIAOHANG
from DONDATHANG, KHACHHANG
where DONDATHANG.KHACHHANGNO = KHACHHANG.MAKHACHHANG and DONDATHANG.NOIGIAOHANG = N'Tại nơi đặt hàng'
--5. tổng số tiền mà khách hàng phải trả cho mỗi đơn hàng là bao nhiêu
select kh.MAKHACHHANG, kh.TENCONGTY, kh.TENGIAODICH, sum(ctdh.GIABAN*ctdh.SOLUONG - ctdh.GIABAN*ctdh.SOLUONG*ctdh.MUCGIAMGIA/100)
from CHITIETDATHANG ctdh, DONDATHANG ddh, KHACHHANG kh
where ctdh.DONDATHANGNO = ddh.SOHOADON and ddh.KHACHHANGNO = kh.MAKHACHHANG
group by kh.MAKHACHHANG, kh.TENCONGTY, kh.TENGIAODICH;
--6 Hãy cho biết tổng số tiền lời mà công ty thu được từ mỗi mặt hàng trong năm 2022
select mh.MAHANG, mh.TENHANG , sum(ctdh.GIABAN*ctdh.SOLUONG - ctdh.GIABAN*ctdh.SOLUONG*ctdh.MUCGIAMGIA/100 - mh.GIAHANG*ctdh.SOLUONG) as thunhap
from  MATHANG mh, CHITIETDATHANG ctdh, DONDATHANG ddh
where mh.MAHANG = ctdh.MATHANGNO and ctdh.DONDATHANGNO = ddh.SOHOADON and year(ddh.NGAYDATHANG) = 2022
group by mh.MAHANG, mh.TENHANG;
--===============================================TUẦN 11===============================================-
--câu 1. Cho biết danh sách các đối tác cung cấp hàng cho công ty
select ncc.MACONGTY, ncc.TENCONGTY, mh.TENHANG
from NHACUNGCAP ncc, MATHANG mh
where ncc.MACONGTY = mh.NHACUNGCAPNO
--câu 2. Mã hàng, tên hàng và số lượng của các mặt hàng hiện có trong công ty.
select MAHANG, TENHANG, SOLUONG
from MATHANG 
--câu 3. Họ tên và địa chỉ và năm bắt đầu làm việc của các nhân viên trong công ty
select Ho, TEN, DIACHI, year (NGAYLAMVIEC)
from NHANVIEN
--câu 4.	Địa chỉ và điện thoại của nhà cung cấp có tên giao dịch [VINAMILK]  là gì?
select NHACUNGCAP.DIACHI, NHACUNGCAP.DIENTHOAI
from NHACUNGCAP
where TENGIAODICH= N'Giao dịch VINAMILK';
--câu 5.	Cho biết mã và tên của các mặt hàng có giá lớn hơn 100000 và số lượng hiện có ít hơn 50.
select MAHANG, TENHANG, GIAHANG, SOLUONG
from MATHANG 
where GIAHANG > 100000 and SOLUONG < 50
--câu 6.	Cho biết mỗi mặt hàng trong công ty do ai cung cấp
select mh.MAHANG, mh.TENHANG, ncc.MACONGTY, ncc.TENCONGTY
from MATHANG mh, NHACUNGCAP ncc
where mh.NHACUNGCAPNO = ncc.MACONGTY
--câu 7.	Công ty [Việt Tiến] đã cung cấp những mặt hàng nào?
select MACONGTY, TENCONGTY, MAHANG, TENHANG
from MATHANG, NHACUNGCAP
where NHACUNGCAP.MACONGTY = MATHANG.NHACUNGCAPNO and TENCONGTY = N'Công ty Việt Tiến';
--câu 8.	Loại hàng thực phẩm do những công ty nào cung cấp và địa chỉ của các công ty đó là gì?
select ncc.MACONGTY, ncc.TENCONGTY, ncc.DIACHI
from MATHANG mh, LOAIHANG lh, NHACUNGCAP ncc
where mh.LOAIHANGNO = lh.MALOAIHANG and ncc.MACONGTY = mh.NHACUNGCAPNO and lh.TENLOAIHANG = N'Loại hàng thực phẩm';
--câu 9.	Những khách hàng nào (tên giao dịch) đã đặt mua mặt hàng Sữa hộp XYZ của công ty?
select KHACHHANG.MAKHACHHANG, KHACHHANG.TENCONGTY, KHACHHANG.TENGIAODICH
from DONDATHANG, KHACHHANG, CHITIETDATHANG, MATHANG
where KHACHHANG.MAKHACHHANG	= DONDATHANG.KHACHHANGNO and DONDATHANG.SOHOADON = CHITIETDATHANG.DONDATHANGNO and CHITIETDATHANG.MATHANGNO = MATHANG.MAHANG
and MATHANG.TENHANG = N'Sữa hộp XYZ';
--câu 10.	Đơn đặt hàng số 1 do ai đặt và do nhân viên nào lập, thời gian và địa điểm giao hàng là ở đâu?
select nv.MANHANVIEN, nv.HO, nv.TEN, ddh.NGAYDATHANG, ddh.NGAYGIAOHANG, ddh.NOIGIAOHANG
from DONDATHANG ddh, NHANVIEN nv
where ddh.MANHANVIEN = nv.MANHANVIEN 
and ddh.SOHOADON = 'SHD0000001'
--câu 11.	Hãy cho biết số tiền lương mà công ty phải trả cho mỗi nhân viên là bao nhiêu (lương = lương cơ bản + phụ cấp).
select MANHANVIEN, HO, TEN, (LUONGCOBAN + PHUCAP) as N'Tiền lương'
from NHANVIEN
--câu 12.	Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty (tức là có cùng tên giao dịch).
select kh.MAKHACHHANG, kh.TENCONGTY, kh.TENGIAODICH
from KHACHHANG kh, NHACUNGCAP ncc
where kh.TENCONGTY = ncc.TENCONGTY and kh.TENGIAODICH= ncc.TENGIAODICH
--câu 13.	Trong công ty có những nhân viên nào có cùng ngày sinh?
select distinct nv1.MANHANVIEN, nv1.HO, nv1.TEN,  nv1.NGAYSINH
from NHANVIEN nv1
join NHANVIEN nv2 ON nv1.NGAYSINH = nv2.NGAYSINH
and nv1.MANHANVIEN <> nv2.MANHANVIEN
--câu 14.	Những đơn đặt hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những đơn đó là của công ty nào?
select KHACHHANG.MAKHACHHANG, KHACHHANG.TENCONGTY, DONDATHANG.NOIGIAOHANG
from DONDATHANG, KHACHHANG
where DONDATHANG.KHACHHANGNO = KHACHHANG.MAKHACHHANG and DONDATHANG.NOIGIAOHANG = N'Tại nơi đặt hàng'
--câu 15.	Cho biết tên công ty,  tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà cung cấp hàng cho công ty.
select TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI
from KHACHHANG
union
select TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI
from NHACUNGCAP
--câu 16.	Những mặt hàng nào chưa từng được khách hàng đặt mua?
select MAHANG, TENHANG
from MATHANG
where MAHANG not in 
(
	select MATHANGNO
	from CHITIETDATHANG
)
--câu 17.	Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?
select MANHANVIEN, HO, TEN
from NHANVIEN
where MANHANVIEN not in(
	select MANHANVIEN
	from DONDATHANG);
--câu 18.	Những nhân viên nào của công ty có lương cơ bản cao nhất?
select MANHANVIEN, HO, TEN, LUONGCOBAN
from NHANVIEN
where LUONGCOBAN >= (
	select max( LUONGCOBAN)
	from NHANVIEN
)