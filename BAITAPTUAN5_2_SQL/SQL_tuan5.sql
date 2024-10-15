create table NHACUNGCAP
(
	MACONGTY char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH varchar(50) null,
	DIACHI varchar(50) not null,
	DIENTHOAI varchar(10) not null,
	FAX varchar(10) not null,
	EMAIL varchar(50) not null
)
create table MATHANG
(
	MAHANG char(10) primary key,
	TENHANG varchar(50) not null,
	MACONGTY char(10) not null,
	MALOAIHANG varchar(10) not null,
	SOLUONG int check(SOLUONG>=0),
	DONVITINH varchar(20) not null,
	GIAHANG money not null,
	foreign key (MACONGTY) references NHACUNGCAP(MACONGTY)
)