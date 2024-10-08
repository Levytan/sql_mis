--Truy vấn món hàng bán được nhiều nhất (theo số lượng) của từng phân loại.
select CategoryName, ProductName, [Giá trị]
from (
 select *, row_number() over(partition by CategoryName order by [Giá trị] desc) rn
 from (
  select c.CategoryName, p.ProductName, sum(Quantity * od.UnitPrice * (1 - Discount)) [Giá trị]
  from [Order Details] od
  join Products p on p.ProductID = od.ProductID
  join Categories c on c.CategoryID = p.CategoryID
  group by c.CategoryName, p.ProductName
 ) d
) t
where rn = 1
--Truy vấn doanh thu của từng sản phẩm theo từng quý trong năm 1997.
select 
 DATEPART(quarter, o.OrderDate) [Quý],
 ProductName, sum(Quantity * od.UnitPrice * (1 - Discount)) [Giá trị] 
from [Order Details] od
join Products p on p.ProductID = od.ProductID
join Orders o on o.OrderID = od.OrderID
where year(o.OrderDate) = 1997
group by DATEPART(quarter, o.OrderDate), ProductName
--Truy vấn hàng tồn kho theo phân loại và theo vùng địa lý của nhà cung cấp. 
--Quy ước: các quốc gia là 'USA', 'Canada' và 'Brazil' thì sẽ là vùng địa lý 'America'; các quốc gia khác thì là vùng 'Other'.
select
 iif(s.Country in ('USA', 'Canada', 'Brazil'), 'America', 'Other') [Vùng địa lý],
 CategoryName, sum(p.UnitsInStock) [Hàng tồn kho]
from Products p
join Categories c on c.CategoryID = p.CategoryID
join Suppliers s on s.SupplierID = p.SupplierID
group by iif(s.Country in ('USA', 'Canada', 'Brazil'), 'America', 'Other'), CategoryName
order by [Vùng địa lý]
