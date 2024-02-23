-- tạo mới
create database [học kỳ 2a]

--chuyển qua [học kỳ 2a] để sử dụng
use [học kỳ 2a]

-- tạo bảng
create table [sinh viên] (
	[mã số] int,				-- lưu trữ số
	[họ và tên] nvarchar(200),	-- lưu trữ chữ
	[ngày sinh] date			-- lưu trữ thời gian
)


-- so sánh char(n) với varchar(n)
select replace(cast('abc' as char(10)), ' ', '*')
select replace(cast('abc' as varchar(10)), ' ', '*')

-- số ký tự lớn hơn giới hạn
select cast('abcd' as varchar(2))

-- so sánh varchar(n) với nvarchar(n)
select cast(N'こんにち' as varchar(5))
select cast(N'こんにち' as nvarchar(5))

-- so sánh datetime với datetime2
select cast('2024-2-23 0:0:0.005' as datetime)
select cast('2024-2-23 0:0:0.005' as datetime2(3))