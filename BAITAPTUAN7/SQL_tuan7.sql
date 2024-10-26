--lệnh if exists để xóa database nếu đã tồn tại trước đó 
USE master;
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Nhom7_Tuan7')
BEGIN
    ALTER DATABASE Nhom7_Tuan7 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Nhom7_Tuan7;
END;
create database Nhom7_Tuan7
go
use Nhom7_Tuan7
go
create table NHACUNGCAP
(
	MACONGTY char(10) primary key,
	TENCONGTY nvarchar(50) not null,
	TENGIAODICH nvarchar(50) not null,
	DIACHI nvarchar(50) not null,
	DIENTHOAI char(10) unique not null,
	FAX char(10) unique not null,
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
	SOLUONG float not null,
	DONVITINH varchar(20) not null,
	GIAHANG money not null,
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
		('nvso000005',N'Nguyễn Trần Minh',N'Trí','15/04/2005',getdate(),N'Phu Xuân','0977289874',9000000,200000),
		('nvso000006',N'Trần Đặng Tuấn',N'Khanh','15/03/2005',getdate(),N'Phu Ngạn','0977289875',default,200000),
		('nvso000007',N'Nguyễn',N'Huỳnh','15/07/2005',getdate(),N'Phu Lương','0977289876',Default,200000),
		('nvso000008',N'Đặng Hoàng Kim',N'Hạnh','12/10/2005',getdate(),N'Phu Thạnh','0977289877',8000000,200000),
		('nvso000009',N'Ngô Kim',N'Huy','15/12/2005',getdate(),N'Phu Mã','0977289878',Default,200000),
		('nvso000010',N'Lê Ngọc Phúc',N'Ân','15/10/2005',getdate(),N'Phu Thạnh','0977289879',1500000,200000);
--select *from NHANVIEN
insert into KHACHHANG
	values
		('khso000001',N'Công ty Ánh Sao',N'giao dịch ví điện tử',N'Cà Mau','khangheheqt1@gmail.com','0112233440','kh12345670'),
		('khso000002',N'Công ty Ánh Viên',N'giao dịch bitcoin',N'Thừa Thiên Huế','khangheheqt2@gmail.com','0112233441','kh12345671'),
		('khso000003',N'Công ty Mai Mai',N'giao dịch tiền mặt',N'Hồ Chí Minh','khangheheqt3@gmail.com','0112233442','kh12345672'),
		('khso000004',N'Công ty Ánh Ánh',N'giao dịch thanh toán qua app',N'Biên Hòa','khangheheqt4@gmail.com','0112233443','kh12345673'),
		('khso000005',N'Công ty Phông Bạt',N'giao dịch ví điện tử',N'Bình Định','khangheheqt5@gmail.com','0112233444','kh12345674'),
		('khso000006',N'Công ty Trường Phát',N'giao dịch tiền ảo',N'Hà Nội','khangheheqt6@gmail.com','0112233445','kh12345675'),
		('khso000007',N'Công ty Trường Tồn',N'giao dịch giải ngân',N'Buôn Mê Thuột','khangheheqt7@gmail.com','0112233446','kh12345676'),
		('khso000008',N'Công ty Mái Ấm',N'giao dịch trung gian',N'Playku','khangheheqt8@gmail.com','0112233447','kh12345677'),
		('khso000009',N'Công ty Mái Tôn',N'giao dịch ví điện tử',N'Cam Ranh','khangheheqt9@gmail.com','0112233448','kh12345678'),
		('khso000010',N'Công ty Hoa Sen',N'giao dịch ví điện tử',N'Quảng Nam','khangheheqt10@gmail.com','0112233449','kh12345679');
select *from KHACHHANG



