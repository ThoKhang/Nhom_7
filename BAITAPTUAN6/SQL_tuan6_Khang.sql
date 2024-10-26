--lệnh if exists để xóa database nếu đã tồn tại trước đó 
USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Nhom7_Tuan6')
BEGIN
    ALTER DATABASE Nhom7_Tuan6 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Nhom7_Tuan6;
END;
create database Nhom7_Tuan6
go
use Nhom7_Tuan6
go
create table NHACUNGCAP
(
	MACONGTY char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50) not null,
	DIACHI nvarchar(50) not null,
	DIENTHOAI char(10) not null,
	FAX char(10) not null,
	EMAIL varchar(30) not null,
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
	NHACUNGCAPNO char(10) not null foreign key references NHACUNGCAP(MACONGTY),
	LOAIHANGNO char(10) not null foreign key references LOAIHANG(MALOAIHANG),
	SOLUONG int check(SOLUONG>=0),
	DONVITINH varchar(20) not null,
	GIAHANG money not null,
)
create table KHACHHANG
(
	MAKHACHHANG char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50) not null,
	DIACHI nvarchar(100) not null,
	EMAIL varchar(50) not null,
	DIENTHOAI char(10) not null,
	FAX char (11) null,
)
create table NHANVIEN
(
	MANHANVIEN char(10) primary key,
	HO nvarchar(50) not null,
	TEN nvarchar(50) not null,
	NGAYSINH date not null,
	NGAYLAMVIEC date not null,
	DIACHI nvarchar(100) not null,
	DIENTHOAI char(10) not null,
	LUONGCOBAN decimal(10,2) not null,
	PHUCAP decimal(10,2) not null,
)
create table DONDATHANG
(
	SOHOADON char(10) primary key,
	KHACHHANGNO char(10) not null foreign key references KHACHHANG(MAKHACHHANG),
	MANHANVIEN char(10) not null foreign key references NHANVIEN(MANHANVIEN),
	NGAYDATHANG date not null,
	NGAYGIAOHANG date not null,
	NGAYCHUYENHANG date not null,
	NOIGIAOHANG nvarchar(100) not null,
)
create table CHITIETDATHANG
(
	DONDATHANGNO char(10) not null foreign key references DONDATHANG(SOHOADON),
	MATHANGNO char(10) not null foreign key references MATHANG(MAHANG),
	primary key(DONDATHANGNO,MATHANGNO),
	GIABAN decimal(10,2) not null,
	SOLUONG int not null,
	MUCGIAMGIA decimal(7,4) not null,
)
--=======================================================TUẦN 6====================================================================================-
/*1. Thiết lập  mối quan hệ giữa các bảng.
2.Bổ sung ràng buộc thiết lập giá trị mặc định bằng 1 cho cột SOLUONG  và bằng 0 cho cột MUCGIAMGIA trong bảng CHITIETDATHANG
3.Bổ sung cho bảng DONDATHANG ràng buộc kiểm tra ngày giao hàng và ngày chuyển hàng phải sau hoặc bằng với ngày đặt hàng.
4.Bổ sung ràng buộc cho bảng NHANVIEN để đảm bảo rằng một nhân viên chỉ có thể làm việc trong công ty khi đủ 18 tuổi và không quá 60 tuổi*/

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
alter table NHANVIEN
	add
		constraint CK_NHANVIEN 
			check(datediff(year,NGAYSINH,getdate())>=18 and datediff(year,NGAYSINH,getdate())<=60);