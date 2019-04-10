create database QuanLyThuVien
use QuanLyThuVien

--1a

create table Sach(
Masach varchar(10) primary key,
tensach nvarchar(50),
tacgia nvarchar(50),
nhaxuatban nvarchar(50),
soluong int
)

create table DocGia(
MaDG varchar(10) primary key,
tendocgia nvarchar(50),
ngaytaothe date,
dienthoai varchar(10)
)
create table MuonSach(
MaDG varchar(10),
Masach varchar(10),
ngaymuon date,
ngaytra date
primary key(MaDG,Masach,ngaymuon)
)

alter table MuonSach add constraint FK_MuonSach_MaDG foreign key (MaDG) references DocGia(MaDG)
alter table MuonSach add constraint FK_MuonSach_Masach foreign key (Masach) references Sach(Masach)

--1b

insert into Sach values ('ST1',N'Ô Long Viện',N'ZinShao',N'Tuổi Trẻ',10)
insert into Sach values ('ST2',N'Tư tưởng Hồ Chí Minh',N'Nhiều tác giả',N'Chính Trị',20)
insert into Sach values ('ST3',N'Trạng Quỳnh',N'Nguyễn Bính',N'Kim Đồng',30)
insert into Sach values ('ST4',N'Kimochi',N'Yamate',N'Nhật Mới',40)
insert into Sach values ('ST5',N'Làm sao để đẹp trai hơn',N'Anh Ba Nổ',N'Tre Làng Mới',50)
insert into Sach values ('ST6',N'7 Ngày Quậy',N'Tre',N'Trẻ Cười',50)
insert into Sach values ('ST7',N'Hội Ăn Mặn',N'Thích Ăn Mặn',N'Trẻ',25)
insert into Sach values ('ST8',N'Khẩu Ngôn',N'Slient An',N'Nhật Nguyệt',15)

insert into DocGia values ('DGS1',N'Tui là Đẹp ','10/3/2019','0913433333')
insert into DocGia values ('DGS2',N'Đừng Có Mơ','8/3/2019','0313453229')
insert into DocGia values ('DGS3',N'Văn Quyết','1/4/2019','0613454225')
insert into DocGia values ('DGS4',N'Dell Alien','11/10/2019','0683463726')
insert into DocGia values ('DGS5',N'Lâm Tây','2/7/2019','0993473227')
insert into DocGia values ('DGS6',N'Thanh Niên Xã','10/8/2019','0992273927')

insert into MuonSach values ('DGS1','ST2','2/1/2019',null)
insert into MuonSach values ('DGS5','ST3','4/6/2019',null)
insert into MuonSach values ('DGS3','ST4','7/8/2019',null)
insert into MuonSach values ('DGS4','ST5','9/2/2019',null)
insert into MuonSach values ('DGS2','ST1','10/3/2019',null)
insert into MuonSach values ('DGS6','ST6','1/8/2019',null)

--1c

select Masach,tensach from Sach where nhaxuatban= N'Trẻ'

--1d

select * from Sach where Masach not in (select Masach from MuonSach)

--1e


select * from Sach where Masach in ( select Masach from MuonSach where (day(getdate()) - day(ngaymuon) <= 10 and month(getdate()) - month(ngaymuon) = 0))

--2

create procedure ThemDocGia
(
    @MaDG varchar(10),
    @tendocgia nvarchar(50),
	@dienthoai int
)
as
begin
    if not exists(select top 1 MaDG from DocGia where MaDG = @MaDG)
        insert into DocGia(MaDG,tendocgia,ngaytaothe,dienthoai) values(@MaDG,@tendocgia,getdate(),@dienthoai)
	else
	print N'Trùng Mã Đọc Giả'
end
exec ThemDocGia 'DGS9', N'Am Đờ Bét','0912443513'


--3 
create trigger Trigger_MuonSach on MuonSach
for insert
as
begin
declare @MaDG varchar(10)
declare @Masach varchar(10)
declare @ngaymuon date
if not exists(select MaDG,Masach,ngaymuon
from MuonSach
where (MaDG = @MaDG and Masach = @Masach and @ngaymuon = ngaymuon))
set @MaDG = (select MaDG from inserted)
set @Masach = (select Masach from inserted)
set @ngaymuon = (select ngaymuon from inserted)
if(@MaDG != null and @Masach != null and @ngaymuon != null)
update Sach
set soluong = soluong - 1
rollback tran
end


--4

create trigger Trigger_Trasach on MuonSach
for update
as
begin
declare @ngaytra date
declare @soluong int
declare @Masach varchar(10)
set @Masach = (select Masach from inserted)
set @soluong = (select soluong from Sach where Masach = @Masach)
set @ngaytra = (select ngaytra from inserted)
if(@ngaytra != null)
update Sach
set soluong = @soluong + 1
end




