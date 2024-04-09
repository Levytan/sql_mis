-- câu 1
-- Truy vấn tên (FirstName, LastName) và Email của những người có mua nhạc Rock.
select 
	distinct c.FirstName, c.LastName, Email
from InvoiceLine as il
join Invoice as i on il.InvoiceId = i.InvoiceId
join Customer as c on i.CustomerId = c.CustomerId
join Track as t on il.TrackId = t.TrackId
join Genre as g on t.GenreId = g.GenreId
where g.[Name] = N'Rock'
-- câu 2
-- Truy vấn tên nghệ sĩ thu được nhiều tiền nhất từ việc bán nhạc.
;with sales as (
	select
		a.ArtistId, sum(il.UnitPrice * il.Quantity) as Sales
	from InvoiceLine as il
	join Track as t on il.TrackId = t.TrackId
	join Album as a on t.AlbumId = a.AlbumId
	group by a.ArtistId
)
select 
	top(1) with ties a.[Name]
from sales 
join Artist as a on sales.ArtistId = a.ArtistId
order by Sales desc
-- câu 3
-- Truy vấn tên khách hàng chi nhiều tiền nhất để mua nhạc.
;with sales as (
	select
		CustomerId, sum(Total) as Total
	from Invoice
	group by CustomerId
)
select
	top(1) Customer.FirstName, Customer.LastName
from Customer
join sales on sales.CustomerId = Customer.CustomerId
order by sales.Total desc
-- câu 4
-- Truy vấn số lượng hóa đơn theo từng tháng.
select
	YEAR(InvoiceDate) as Year,
	MONTH(InvoiceDate) as Month,
	COUNT(*) as Quantity
from Invoice
group by year(InvoiceDate), MONTH(InvoiceDate)
order by Year, Month
-- Câu 5
-- Truy vấn giá trị trung bình mỗi hóa đơn.
select AVG(Total) from Invoice
-- Câu 6
-- Truy vấn thể loại nhạc thu được nhiều tiền nhất.
;with sales as (
	select
		t.GenreId, sum(il.UnitPrice * il.Quantity) as Sales
	from InvoiceLine as il
	join Track as t on il.TrackId = t.TrackId
	group by t.GenreId
)
select 
	top(1) with ties g.[Name]
from sales 
join Genre as g on sales.GenreId = g.GenreId
order by Sales desc