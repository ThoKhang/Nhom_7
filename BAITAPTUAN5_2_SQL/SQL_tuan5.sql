create database Nhom7_Tuan5
go
use Nhom7_Tuan5
go
create table NHACUNGCAP
(
	MACONGTY char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50) null,
	DIACHI nvarchar(50) not null,
	DIENTHOAI char(12) not null,
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
	TENCONGTY nvarchar(30) not null,
	TENGIAODICH nvarchar(30) not null,
	DIACHI nvarchar(30) not null,
	EMAIL nvarchar(30) not null,
	DIENTHOAI char(11) not null,
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
	DIENTHOAI char(15) not null,
	LUONGCOBAN decimal(10,20) not null,
	PHUCAP decimal(10,20) not null,
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
	MAGIAMGIA varchar(20) not null,
)
