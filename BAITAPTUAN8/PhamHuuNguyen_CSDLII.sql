--l?nh if exists ð? xóa database n?u ð? t?n t?i trý?c ðó
USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Nhom7_Tuan8')
BEGIN
    ALTER DATABASE Nhom7_Tuan8 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Nhom7_Tuan8;
END;
create database Nhom7_Tuan8
go
use Nhom7_Tuan8
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
	NGAYCHUYENHANG date not null,
	NOIGIAOHANG nvarchar(100) not null,
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
--=======================================================TU?N 6====================================================================================-
--2. B? sung ràng bu?c thi?t l?p giá tr? m?c ð?nh b?ng 1 cho c?t SOLUONG  và b?ng 0 cho c?t MUCGIAMGIA trong b?ng CHITIETDATHANG
alter table CHITIETDATHANG
	add
		constraint DF_CHITIETDONHANG_SOLUONG 
			default 1 for SOLUONG,
		constraint DF_CHITIETDATHANG_MUCGIAMGIA
			default 0 for MUCGIAMGIA;
--3. B? sung cho b?ng DONDATHANG ràng bu?c ki?m tra ngày giao hàng và ngày chuy?n hàng ph?i sau ho?c b?ng v?i ngày ð?t hàng.
alter table DONDATHANG
	add 
		constraint CK_DONDATHANG_NGAYGIAOHANG 
			check(NGAYGIAOHANG >= NGAYDATHANG),
		constraint CK_DONDATHANG_NGAYCHUYENHANG
			check(NGAYCHUYENHANG >= NGAYDATHANG);
--4. B? sung ràng bu?c cho b?ng NHANVIEN ð? ð?m b?o r?ng m?t nhân viên ch? có th? làm vi?c trong công ty khi ð? 18 tu?i và không quá 60 tu?i
--Thêm các ràng bu?c c?a b?ng NHANVIEN
alter table NHANVIEN
	add
		constraint CK_NHANVIEN_NGAYSINH 
			check(datediff(year,NGAYSINH,getdate())>=18 and datediff(year,NGAYSINH,getdate())<=60),
		constraint CK_NHANVIEN_DIENTHOAI
			check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
--Thêm các ràng bu?c c?a b?ng KHACHHANG
alter table KHACHHANG
	add
		constraint CK_KHACHHANG_EMAIL
			check  (Email like '[A-Za-z]%@gmail.com'),
		constraint CK_KHACHHANG_DIENTHOAI
			check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
-- B? sung ràng bu?c cho b?ng NHACUNGCAP
ALTER TABLE NHACUNGCAP
ADD
    CONSTRAINT CK_NHACUNGCAP_DIENTHOAI CHECK (DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_NHACUNGCAP_FAX CHECK (FAX LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_NHACUNGCAP_EMAIL CHECK (Email like '[A-Za-z]%@gmail.com');
-- B? sung ràng bu?c cho b?ng LOAIHANG
ALTER TABLE LOAIHANG
ADD
    CONSTRAINT UQ_LOAIHANG_TENLOAIHANG UNIQUE (TENLOAIHANG);
--B? sung ràng bu?c cho b?ng CHITIETDATHANG
ALTER TABLE CHITIETDATHANG
ADD 
   CONSTRAINT CK_CHITIETDATHANG_GIABAN CHECK (GIABAN > 0);

--=====================================================TU?N 7==========================================================================----
--==============B? SUNG PH?N RÀNG BU?C ? ph?n TU?N 6 (? trên !!!!!!!)!!!!!!=========-----------------------------------------
/*Caìc nhoìm raÌ soaìt laòi tuâÌn 5 vaÌ tuâÌn 6 ðêÒ hoaÌn thaÌnh file baìo caìo tôÒng hõòp vaÌ duÌng lêònh INSERT ðêÒ
câòp nhâòt dýÞ liêòu vaÌo caìc baÒng cuÒa miÌnh sao cho phuÌ hõòp võìi kiêÒu giýÞ liêòu vaÌ raÌng buôòc maÌ miÌnh ðaÞ taòo ra õÒ 2 tuâÌn trýõìc.*/
--==Thêm d? li?u ? ðây !!!!!==-
set dateformat dmy
insert into NHANVIEN
	values
		('nvso000001',N'Tr?n Vãn Th?',N'Khang','15/05/2005',getdate(),N'Trà My','0977289870',Default,200000),
		('nvso000002',N'Ph?m H?u',N'Nguyên','15/02/2005',default,N'Phu Ngan','0977289871',6000000,200000),
		('nvso000003',N'Dýõng Thành',N'Long','15/01/2005',getdate(),N'Phú Xuân','0977289872',7000000,200000),
		('nvso000004',N'Ngô Hoàng',N'Huy','15/03/2005',getdate(),N'Phu Th?nh','0977289873',Default,200000),
		('nvso000005',N'Nguy?n Tr?n Minh',N'Trí','15/04/2005',getdate(),N'Phu Xuân','0977289874',9000000,200000),
		('nvso000006',N'Tr?n Ð?ng Tu?n',N'Khanh','15/03/2005',getdate(),N'Phu Ng?n','0977289875',default,200000),
		('nvso000007',N'Nguy?n',N'Hu?nh','15/07/2005',getdate(),N'Phu Lýõng','0977289876',Default,200000),
		('nvso000008',N'Ð?ng Hoàng Kim',N'H?nh','12/10/2005',getdate(),N'Phu Th?nh','0977289877',8000000,200000),
		('nvso000009',N'Ngô Kim',N'Huy','15/12/2005',getdate(),N'Phu M?','0977289878',Default,200000),
		('nvso000010',N'Lê Ng?c Phúc',N'Ân','15/10/2005',getdate(),N'Phu Th?nh','0977289879',1500000,200000);
--select *from NHANVIEN
insert into KHACHHANG
	values
		('khso000001',N'Công ty Ánh Sao',N'giao d?ch ví ði?n t?',N'Cà Mau','khangheheqt1@gmail.com','0112233440','kh12345670'),
		('khso000002',N'Công ty Ánh Viên',N'giao d?ch bitcoin',N'Th?a Thiên Hu?','khangheheqt2@gmail.com','0112233441','kh12345671'),
		('khso000003',N'Công ty Mai Mai',N'giao d?ch ti?n m?t',N'H? Chí Minh','khangheheqt3@gmail.com','0112233442','kh12345672'),
		('khso000004',N'Công ty Ánh Ánh',N'giao d?ch thanh toán qua app',N'Biên H?a','khangheheqt4@gmail.com','0112233443','kh12345673'),
		('khso000005',N'Công ty Phông B?t',N'giao d?ch ví ði?n t?',N'B?nh Ð?nh','khangheheqt5@gmail.com','0112233444','kh12345674'),
		('khso000006',N'Công ty Trý?ng Phát',N'giao d?ch ti?n ?o',N'Hà N?i','khangheheqt6@gmail.com','0112233445','kh12345675'),
		('khso000007',N'Công ty Trý?ng T?n',N'giao d?ch gi?i ngân',N'Buôn Mê Thu?t','khangheheqt7@gmail.com','0112233446','kh12345676'),
		('khso000008',N'Công ty Mái ?m',N'giao d?ch trung gian',N'Playku','khangheheqt8@gmail.com','0112233447','kh12345677'),
		('khso000009',N'Công ty Mái Tôn',N'giao d?ch ví ði?n t?',N'Cam Ranh','khangheheqt9@gmail.com','0112233448','kh12345678'),
		('khso000010',N'Công ty Hoa Sen',N'giao d?ch ví ði?n t?',N'Qu?ng Nam','khangheheqt10@gmail.com','0112233449','kh12345679');
--select *from KHACHHANG
-- Thêm d? li?u vào b?ng NHACUNGCAP
INSERT INTO NHACUNGCAP (MACONGTY, TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI, FAX, EMAIL)
VALUES
    ('CTso000001', N'Công ty A', N'Nguy?n Vãn A', N'Ð?a ch? A', '0123456789', '0987654321', 'emailA@gmail.com'),
    ('CTso000002', N'Công ty B', N'Tr?n Vãn B', N'Ð?a ch? B', '0123756789', '0987654322', 'emailB@gmail.com'),
    ('CTso000003', N'Công ty C', N'Ph?m Vãn C', N'Ð?a ch? D', '0193457787', '0987654323', 'emailC@gmail.com'),
	('CTso000004', N'Công ty D', N'Ph?m Vãn D', N'Ð?a ch? B', '0193457788', '0987694323', 'emailD@gmail.com'),
	('CTso000005', N'Công ty A', N'Ph?m Tu?n C', N'Ð?a ch? C', '0193457773', '0987604323', 'emailE@gmail.com'),
	('CTso000006', N'Công ty A', N'Nguy?n Kim A', N'Ð?a ch? C', '0193459887', '0980650323', 'emailF@gmail.com'),
	('CTso000007', N'Công ty C', N'Ph?m Vãn K', N'Ð?a ch? A', '0193459987', '0987054323', 'emailG@gmail.com'),
	('CTso000008', N'Công ty B', N'Ph?m Vãn R', N'Ð?a ch? E', '0197457787', '0987604023', 'emailH@gmail.com'),
	('CTso000009', N'Công ty C', N'Ph?m Vãn T', N'Ð?a ch? F', '0103457787', '0987650323', 'emailI@gmail.com'),
	('CTso000010', N'Công ty B', N'Ph?m Vãn U', N'Ð?a ch? N', '0191257787', '0987004323', 'emailJ@gmail.com');
-- Thêm d? li?u vào b?ng LOAIHANG
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG)
VALUES
    ('LHso000001', N'Lo?i hàng A9'),
    ('LHso000002', N'Lo?i hàng B9'),
    ('LHso000003', N'Lo?i hàng C9'),
	('LHso000004', N'Lo?i hàng D9'),
	('LHso000005', N'Lo?i hàng E9'),
	('LHso000006', N'Lo?i hàng F9'),
	('LHso000007', N'Lo?i hàng C1'),
	('LHso000008', N'Lo?i hàng C2'),
	('LHso000009', N'Lo?i hàng C3'),
	('LHso000010', N'Lo?i hàng C4');
--Thêm d? li?u vào b?ng MATHANG
INSERT INTO MATHANG
VALUES 
	('MH00000001', N'Tivi Sony', 'CTso000001', 'LHso000001', 120, N'Máy', 5000000),
	('MH00000002', N'Tivi Samsung', 'CTso000001', 'LHso000002', 100, N'Máy', 6000000),
	('MH00000003', N'Iphone 16', 'CTso000002', 'LHso000003', 111, N'Máy', 26000000),
	('MH00000004', N'Máy c?t tóc', 'CTso000003', 'LHso000002', 130, N'Máy', 1500000),
	('MH00000005', N'Laptop Asus', 'CTso000004', 'LHso000001', 140, N'Máy', 18000000),
	('MH00000006', N'Tivi Casper', 'CTso000005', 'LHso000004', 99, N'Máy', 6000000),
	('MH00000007', N'Whey Rule 1', 'CTso000002', 'LHso000005', 107, N'H?', 1600000),
	('MH00000008', N'Giày Bitis', 'CTso000006', 'LHso000006', 106, N'Ðôi', 300000),
	('MH00000009', N'Banh ð?ng l?c', 'CTso000007', 'LHso000007', 101, N'Qu?', 150000),
	('MH00000010', N'Máy s?y tóc', 'CTso000009', 'LHso000008', 100, N'Máy', 1200000)
--Thêm d? li?u vào b?ng DONDATHANG
set dateformat dmy
INSERT INTO DONDATHANG
VALUES
	('SHD0000001', 'khso000001', 'nvso000001', '21-2-2023', '23-2-2023', '22-2-2023', N'99 Tr?n Duy Hýng'),
	('SHD0000002', 'khso000001', 'nvso000002', '21-3-2023', '23-3-2023', '22-3-2023', N'98 Trý?ng Chinh'),
	('SHD0000003', 'khso000002', 'nvso000003', '21-4-2023', '23-4-2023', '22-4-2023', N'277 Nguy?n T?t Thành'),
	('SHD0000004', 'khso000003', 'nvso000004', '21-5-2023', '23-5-2023', '22-5-2023', N'100 Lê Ð?'),
	('SHD0000005', 'khso000004', 'nvso000005', '21-6-2023', '23-6-2023', '22-6-2023', N'99 Hà Huy T?p'),
	('SHD0000006', 'khso000005', 'nvso000005', '21-7-2023', '23-7-2023', '22-7-2023', N'13/48 Dýõng Thành Long'),
	('SHD0000007', 'khso000003', 'nvso000006', '21-8-2023', '23-8-2023', '22-8-2023', N'20 Nguy?n Lýõng Bin'),
	('SHD0000008', 'khso000004', 'nvso000007', '21-9-2023', '23-9-2023', '22-9-2023', N'78 Th? Khang'),
	('SHD0000009', 'khso000006', 'nvso000008', '21-10-2023', '23-10-2023', '22-10-2023', N'12 Tôn Ð?n'),
	('SHD0000010', 'khso000007', 'nvso000002', '21-11-2023', '23-11-2023', '22-11-2023', N'90 Dinh Ð?c L?p')
--Thêm d? li?u c?a các b?ng CHITIETDATHANG.
INSERT INTO CHITIETDATHANG 
VALUES 
    ('SHD0000001', 'MH00000003', 26000000, 1, 0), 
    ('SHD0000002', 'MH00000002', 6000000, 1, 1),  
    ('SHD0000003', 'MH00000005', 18000000, 1, 2), 
    ('SHD0000004', 'MH00000006', 6000000, 4, 3),  
    ('SHD0000005', 'MH00000007', 1600000, 5, 2), 
    ('SHD0000006', 'MH00000008', 300000, 10, 1), 
    ('SHD0000007', 'MH00000009', 150000, 8, 0), 
    ('SHD0000008', 'MH00000010', 1200000, 6, 1),
    ('SHD0000009', 'MH00000001', 5000000, 3, 2), 
    ('SHD0000010', 'MH00000004', 1500000, 2, 3);
--C?p nh?t l?i giá tr? trý?ng NGAYCHUYENHANG c?a nh?ng b?n ghi có NGAYCHUYENHANG chýa xác ð?nh (NULL) trong b?ng DONDATHANG b?ng v?i giá tr? c?a trý?ng NGAYDATHANG.
UPDATE DONDATHANG
SET NGAYCHUYENHANG = NGAYDATHANG
WHERE NGAYCHUYENHANG IS NULL;
--Tãng s? lý?ng hàng c?a nh?ng m?t hàng do công ty VINAMILK cung c?p lên g?p ðôi.
UPDATE CHITIETDATHANG
SET SOLUONG = SOLUONG * 2
WHERE MATHANGNO IN (
    SELECT MAHANG FROM MATHANG
    WHERE NHACUNGCAPNO = (
        SELECT NHACUNGCAPNO FROM NHACUNGCAP WHERE TENCONGTY = 'VINAMILK'
    )
);
--C?p nh?t giá tr? c?a trý?ng NOIGIAOHANG trong b?ng DONDATHANG b?ng ð?a ch? c?a khách hàng ð?i v?i nh?ng ðõn ð?t hàng chýa xác ð?nh ðý?c nõi giao hàng (giá tr? trý?ng NOIGIAOHANG b?ng NULL).
UPDATE DONDATHANG
SET NOIGIAOHANG = (
    SELECT DIACHI FROM KHACHHANG WHERE DONDATHANG.KHACHHANGNO = KHACHHANG.MAKHACHHANG
)
WHERE NOIGIAOHANG IS NULL;
--C?p nh?t l?i d? li?u trong b?ng KHACHHANG sao cho n?u tên công ty và tên giao d?ch c?a khách hàng trùng v?i tên công ty và tên giao d?ch c?a m?t nhà cung c?p nào ðó th? ð?a ch?, ði?n tho?i, fax và e-mail ph?i gi?ng nhau.
UPDATE KHACHHANG
SET DIACHI = NCC.DIACHI,
    DIENTHOAI = NCC.DIENTHOAI,
    FAX = NCC.FAX,
    EMAIL = NCC.EMAIL
FROM NHACUNGCAP AS NCC
WHERE KHACHHANG.TENCONGTY = NCC.TENCONGTY
AND KHACHHANG.TENGIAODICH = NCC.TENGIAODICH;
--Tãng lýõng lên g?p rý?i cho nh?ng nhân viên bán ðý?c s? lý?ng hàng nhi?u hõn 100 trong nãm 2022.
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 1.5
WHERE MANHANVIEN IN (
    SELECT MANHANVIEN
    FROM DONDATHANG
    WHERE YEAR(NGAYDATHANG) = 2022 
    GROUP BY MANHANVIEN
    HAVING SUM(SOLUONG) > 100 
);
--Tãng ph? c?p lên b?ng 50% lýõng cho nh?ng nhân viên bán ðý?c hàng nhi?u nh?t.
UPDATE NHANVIEN
SET PHUCAP = LUONGCOBAN * 0.5
WHERE MANHANVIEN = (
    SELECT TOP 1 MANHANVIEN
    FROM DONDATHANG
    GROUP BY MANHANVIEN
    ORDER BY SUM(SOLUONG) DESC
);
--Gi?m 25% lýõng c?a nh?ng nhân viên trong nãm 2023 không l?p ðý?c b?t k? ðõn ð?t hàng nào
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 0.75
WHERE MANHANVIEN NOT IN (
    SELECT DISTINCT MANHANVIEN
    FROM DONDATHANG
    WHERE YEAR(NGAYDATHANG) = 2023
);
