--l?nh if exists �? x�a database n?u �? t?n t?i tr�?c ��
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
--2. B? sung r�ng bu?c thi?t l?p gi� tr? m?c �?nh b?ng 1 cho c?t SOLUONG  v� b?ng 0 cho c?t MUCGIAMGIA trong b?ng CHITIETDATHANG
alter table CHITIETDATHANG
	add
		constraint DF_CHITIETDONHANG_SOLUONG 
			default 1 for SOLUONG,
		constraint DF_CHITIETDATHANG_MUCGIAMGIA
			default 0 for MUCGIAMGIA;
--3. B? sung cho b?ng DONDATHANG r�ng bu?c ki?m tra ng�y giao h�ng v� ng�y chuy?n h�ng ph?i sau ho?c b?ng v?i ng�y �?t h�ng.
alter table DONDATHANG
	add 
		constraint CK_DONDATHANG_NGAYGIAOHANG 
			check(NGAYGIAOHANG >= NGAYDATHANG),
		constraint CK_DONDATHANG_NGAYCHUYENHANG
			check(NGAYCHUYENHANG >= NGAYDATHANG);
--4. B? sung r�ng bu?c cho b?ng NHANVIEN �? �?m b?o r?ng m?t nh�n vi�n ch? c� th? l�m vi?c trong c�ng ty khi �? 18 tu?i v� kh�ng qu� 60 tu?i
--Th�m c�c r�ng bu?c c?a b?ng NHANVIEN
alter table NHANVIEN
	add
		constraint CK_NHANVIEN_NGAYSINH 
			check(datediff(year,NGAYSINH,getdate())>=18 and datediff(year,NGAYSINH,getdate())<=60),
		constraint CK_NHANVIEN_DIENTHOAI
			check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
--Th�m c�c r�ng bu?c c?a b?ng KHACHHANG
alter table KHACHHANG
	add
		constraint CK_KHACHHANG_EMAIL
			check  (Email like '[A-Za-z]%@gmail.com'),
		constraint CK_KHACHHANG_DIENTHOAI
			check (DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');
-- B? sung r�ng bu?c cho b?ng NHACUNGCAP
ALTER TABLE NHACUNGCAP
ADD
    CONSTRAINT CK_NHACUNGCAP_DIENTHOAI CHECK (DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_NHACUNGCAP_FAX CHECK (FAX LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    CONSTRAINT CK_NHACUNGCAP_EMAIL CHECK (Email like '[A-Za-z]%@gmail.com');
-- B? sung r�ng bu?c cho b?ng LOAIHANG
ALTER TABLE LOAIHANG
ADD
    CONSTRAINT UQ_LOAIHANG_TENLOAIHANG UNIQUE (TENLOAIHANG);
--B? sung r�ng bu?c cho b?ng CHITIETDATHANG
ALTER TABLE CHITIETDATHANG
ADD 
   CONSTRAINT CK_CHITIETDATHANG_GIABAN CHECK (GIABAN > 0);

--=====================================================TU?N 7==========================================================================----
--==============B? SUNG PH?N R�NG BU?C ? ph?n TU?N 6 (? tr�n !!!!!!!)!!!!!!=========-----------------------------------------
/*Ca�c nho�m ra� soa�t la�i tu��n 5 va� tu��n 6 ��� hoa�n tha�nh file ba�o ca�o t��ng h��p va� du�ng l��nh INSERT ���
c��p nh��t d�� li��u va�o ca�c ba�ng cu�a mi�nh sao cho phu� h��p v��i ki��u gi�� li��u va� ra�ng bu��c ma� mi�nh �a� ta�o ra �� 2 tu��n tr���c.*/
--==Th�m d? li?u ? ��y !!!!!==-
set dateformat dmy
insert into NHANVIEN
	values
		('nvso000001',N'Tr?n V�n Th?',N'Khang','15/05/2005',getdate(),N'Tr� My','0977289870',Default,200000),
		('nvso000002',N'Ph?m H?u',N'Nguy�n','15/02/2005',default,N'Phu Ngan','0977289871',6000000,200000),
		('nvso000003',N'D��ng Th�nh',N'Long','15/01/2005',getdate(),N'Ph� Xu�n','0977289872',7000000,200000),
		('nvso000004',N'Ng� Ho�ng',N'Huy','15/03/2005',getdate(),N'Phu Th?nh','0977289873',Default,200000),
		('nvso000005',N'Nguy?n Tr?n Minh',N'Tr�','15/04/2005',getdate(),N'Phu Xu�n','0977289874',9000000,200000),
		('nvso000006',N'Tr?n �?ng Tu?n',N'Khanh','15/03/2005',getdate(),N'Phu Ng?n','0977289875',default,200000),
		('nvso000007',N'Nguy?n',N'Hu?nh','15/07/2005',getdate(),N'Phu L��ng','0977289876',Default,200000),
		('nvso000008',N'�?ng Ho�ng Kim',N'H?nh','12/10/2005',getdate(),N'Phu Th?nh','0977289877',8000000,200000),
		('nvso000009',N'Ng� Kim',N'Huy','15/12/2005',getdate(),N'Phu M?','0977289878',Default,200000),
		('nvso000010',N'L� Ng?c Ph�c',N'�n','15/10/2005',getdate(),N'Phu Th?nh','0977289879',1500000,200000);
--select *from NHANVIEN
insert into KHACHHANG
	values
		('khso000001',N'C�ng ty �nh Sao',N'giao d?ch v� �i?n t?',N'C� Mau','khangheheqt1@gmail.com','0112233440','kh12345670'),
		('khso000002',N'C�ng ty �nh Vi�n',N'giao d?ch bitcoin',N'Th?a Thi�n Hu?','khangheheqt2@gmail.com','0112233441','kh12345671'),
		('khso000003',N'C�ng ty Mai Mai',N'giao d?ch ti?n m?t',N'H? Ch� Minh','khangheheqt3@gmail.com','0112233442','kh12345672'),
		('khso000004',N'C�ng ty �nh �nh',N'giao d?ch thanh to�n qua app',N'Bi�n H?a','khangheheqt4@gmail.com','0112233443','kh12345673'),
		('khso000005',N'C�ng ty Ph�ng B?t',N'giao d?ch v� �i?n t?',N'B?nh �?nh','khangheheqt5@gmail.com','0112233444','kh12345674'),
		('khso000006',N'C�ng ty Tr�?ng Ph�t',N'giao d?ch ti?n ?o',N'H� N?i','khangheheqt6@gmail.com','0112233445','kh12345675'),
		('khso000007',N'C�ng ty Tr�?ng T?n',N'giao d?ch gi?i ng�n',N'Bu�n M� Thu?t','khangheheqt7@gmail.com','0112233446','kh12345676'),
		('khso000008',N'C�ng ty M�i ?m',N'giao d?ch trung gian',N'Playku','khangheheqt8@gmail.com','0112233447','kh12345677'),
		('khso000009',N'C�ng ty M�i T�n',N'giao d?ch v� �i?n t?',N'Cam Ranh','khangheheqt9@gmail.com','0112233448','kh12345678'),
		('khso000010',N'C�ng ty Hoa Sen',N'giao d?ch v� �i?n t?',N'Qu?ng Nam','khangheheqt10@gmail.com','0112233449','kh12345679');
--select *from KHACHHANG
-- Th�m d? li?u v�o b?ng NHACUNGCAP
INSERT INTO NHACUNGCAP (MACONGTY, TENCONGTY, TENGIAODICH, DIACHI, DIENTHOAI, FAX, EMAIL)
VALUES
    ('CTso000001', N'C�ng ty A', N'Nguy?n V�n A', N'�?a ch? A', '0123456789', '0987654321', 'emailA@gmail.com'),
    ('CTso000002', N'C�ng ty B', N'Tr?n V�n B', N'�?a ch? B', '0123756789', '0987654322', 'emailB@gmail.com'),
    ('CTso000003', N'C�ng ty C', N'Ph?m V�n C', N'�?a ch? D', '0193457787', '0987654323', 'emailC@gmail.com'),
	('CTso000004', N'C�ng ty D', N'Ph?m V�n D', N'�?a ch? B', '0193457788', '0987694323', 'emailD@gmail.com'),
	('CTso000005', N'C�ng ty A', N'Ph?m Tu?n C', N'�?a ch? C', '0193457773', '0987604323', 'emailE@gmail.com'),
	('CTso000006', N'C�ng ty A', N'Nguy?n Kim A', N'�?a ch? C', '0193459887', '0980650323', 'emailF@gmail.com'),
	('CTso000007', N'C�ng ty C', N'Ph?m V�n K', N'�?a ch? A', '0193459987', '0987054323', 'emailG@gmail.com'),
	('CTso000008', N'C�ng ty B', N'Ph?m V�n R', N'�?a ch? E', '0197457787', '0987604023', 'emailH@gmail.com'),
	('CTso000009', N'C�ng ty C', N'Ph?m V�n T', N'�?a ch? F', '0103457787', '0987650323', 'emailI@gmail.com'),
	('CTso000010', N'C�ng ty B', N'Ph?m V�n U', N'�?a ch? N', '0191257787', '0987004323', 'emailJ@gmail.com');
-- Th�m d? li?u v�o b?ng LOAIHANG
INSERT INTO LOAIHANG (MALOAIHANG, TENLOAIHANG)
VALUES
    ('LHso000001', N'Lo?i h�ng A9'),
    ('LHso000002', N'Lo?i h�ng B9'),
    ('LHso000003', N'Lo?i h�ng C9'),
	('LHso000004', N'Lo?i h�ng D9'),
	('LHso000005', N'Lo?i h�ng E9'),
	('LHso000006', N'Lo?i h�ng F9'),
	('LHso000007', N'Lo?i h�ng C1'),
	('LHso000008', N'Lo?i h�ng C2'),
	('LHso000009', N'Lo?i h�ng C3'),
	('LHso000010', N'Lo?i h�ng C4');
--Th�m d? li?u v�o b?ng MATHANG
INSERT INTO MATHANG
VALUES 
	('MH00000001', N'Tivi Sony', 'CTso000001', 'LHso000001', 120, N'M�y', 5000000),
	('MH00000002', N'Tivi Samsung', 'CTso000001', 'LHso000002', 100, N'M�y', 6000000),
	('MH00000003', N'Iphone 16', 'CTso000002', 'LHso000003', 111, N'M�y', 26000000),
	('MH00000004', N'M�y c?t t�c', 'CTso000003', 'LHso000002', 130, N'M�y', 1500000),
	('MH00000005', N'Laptop Asus', 'CTso000004', 'LHso000001', 140, N'M�y', 18000000),
	('MH00000006', N'Tivi Casper', 'CTso000005', 'LHso000004', 99, N'M�y', 6000000),
	('MH00000007', N'Whey Rule 1', 'CTso000002', 'LHso000005', 107, N'H?', 1600000),
	('MH00000008', N'Gi�y Bitis', 'CTso000006', 'LHso000006', 106, N'��i', 300000),
	('MH00000009', N'Banh �?ng l?c', 'CTso000007', 'LHso000007', 101, N'Qu?', 150000),
	('MH00000010', N'M�y s?y t�c', 'CTso000009', 'LHso000008', 100, N'M�y', 1200000)
--Th�m d? li?u v�o b?ng DONDATHANG
set dateformat dmy
INSERT INTO DONDATHANG
VALUES
	('SHD0000001', 'khso000001', 'nvso000001', '21-2-2023', '23-2-2023', '22-2-2023', N'99 Tr?n Duy H�ng'),
	('SHD0000002', 'khso000001', 'nvso000002', '21-3-2023', '23-3-2023', '22-3-2023', N'98 Tr�?ng Chinh'),
	('SHD0000003', 'khso000002', 'nvso000003', '21-4-2023', '23-4-2023', '22-4-2023', N'277 Nguy?n T?t Th�nh'),
	('SHD0000004', 'khso000003', 'nvso000004', '21-5-2023', '23-5-2023', '22-5-2023', N'100 L� �?'),
	('SHD0000005', 'khso000004', 'nvso000005', '21-6-2023', '23-6-2023', '22-6-2023', N'99 H� Huy T?p'),
	('SHD0000006', 'khso000005', 'nvso000005', '21-7-2023', '23-7-2023', '22-7-2023', N'13/48 D��ng Th�nh Long'),
	('SHD0000007', 'khso000003', 'nvso000006', '21-8-2023', '23-8-2023', '22-8-2023', N'20 Nguy?n L��ng Bin'),
	('SHD0000008', 'khso000004', 'nvso000007', '21-9-2023', '23-9-2023', '22-9-2023', N'78 Th? Khang'),
	('SHD0000009', 'khso000006', 'nvso000008', '21-10-2023', '23-10-2023', '22-10-2023', N'12 T�n �?n'),
	('SHD0000010', 'khso000007', 'nvso000002', '21-11-2023', '23-11-2023', '22-11-2023', N'90 Dinh �?c L?p')
--Th�m d? li?u c?a c�c b?ng CHITIETDATHANG.
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
--C?p nh?t l?i gi� tr? tr�?ng NGAYCHUYENHANG c?a nh?ng b?n ghi c� NGAYCHUYENHANG ch�a x�c �?nh (NULL) trong b?ng DONDATHANG b?ng v?i gi� tr? c?a tr�?ng NGAYDATHANG.
UPDATE DONDATHANG
SET NGAYCHUYENHANG = NGAYDATHANG
WHERE NGAYCHUYENHANG IS NULL;
--T�ng s? l�?ng h�ng c?a nh?ng m?t h�ng do c�ng ty VINAMILK cung c?p l�n g?p ��i.
UPDATE CHITIETDATHANG
SET SOLUONG = SOLUONG * 2
WHERE MATHANGNO IN (
    SELECT MAHANG FROM MATHANG
    WHERE NHACUNGCAPNO = (
        SELECT NHACUNGCAPNO FROM NHACUNGCAP WHERE TENCONGTY = 'VINAMILK'
    )
);
--C?p nh?t gi� tr? c?a tr�?ng NOIGIAOHANG trong b?ng DONDATHANG b?ng �?a ch? c?a kh�ch h�ng �?i v?i nh?ng ��n �?t h�ng ch�a x�c �?nh ��?c n�i giao h�ng (gi� tr? tr�?ng NOIGIAOHANG b?ng NULL).
UPDATE DONDATHANG
SET NOIGIAOHANG = (
    SELECT DIACHI FROM KHACHHANG WHERE DONDATHANG.KHACHHANGNO = KHACHHANG.MAKHACHHANG
)
WHERE NOIGIAOHANG IS NULL;
--C?p nh?t l?i d? li?u trong b?ng KHACHHANG sao cho n?u t�n c�ng ty v� t�n giao d?ch c?a kh�ch h�ng tr�ng v?i t�n c�ng ty v� t�n giao d?ch c?a m?t nh� cung c?p n�o �� th? �?a ch?, �i?n tho?i, fax v� e-mail ph?i gi?ng nhau.
UPDATE KHACHHANG
SET DIACHI = NCC.DIACHI,
    DIENTHOAI = NCC.DIENTHOAI,
    FAX = NCC.FAX,
    EMAIL = NCC.EMAIL
FROM NHACUNGCAP AS NCC
WHERE KHACHHANG.TENCONGTY = NCC.TENCONGTY
AND KHACHHANG.TENGIAODICH = NCC.TENGIAODICH;
--T�ng l��ng l�n g?p r�?i cho nh?ng nh�n vi�n b�n ��?c s? l�?ng h�ng nhi?u h�n 100 trong n�m 2022.
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 1.5
WHERE MANHANVIEN IN (
    SELECT MANHANVIEN
    FROM DONDATHANG
    WHERE YEAR(NGAYDATHANG) = 2022 
    GROUP BY MANHANVIEN
    HAVING SUM(SOLUONG) > 100 
);
--T�ng ph? c?p l�n b?ng 50% l��ng cho nh?ng nh�n vi�n b�n ��?c h�ng nhi?u nh?t.
UPDATE NHANVIEN
SET PHUCAP = LUONGCOBAN * 0.5
WHERE MANHANVIEN = (
    SELECT TOP 1 MANHANVIEN
    FROM DONDATHANG
    GROUP BY MANHANVIEN
    ORDER BY SUM(SOLUONG) DESC
);
--Gi?m 25% l��ng c?a nh?ng nh�n vi�n trong n�m 2023 kh�ng l?p ��?c b?t k? ��n �?t h�ng n�o
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 0.75
WHERE MANHANVIEN NOT IN (
    SELECT DISTINCT MANHANVIEN
    FROM DONDATHANG
    WHERE YEAR(NGAYDATHANG) = 2023
);
