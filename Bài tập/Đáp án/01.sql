--Truy vấn tên diễn viên đóng nhiều bộ phim nhất.
select first_name, last_name, fa.[Số lượng phim]
from actor a
join (
 select top(1) actor_id, count(*) [Số lượng phim]
 from film_actor
 group by actor_id
 order by [Số lượng phim] desc
) fa
on a.actor_id = fa.actor_id

--Truy vấn thể loại (category) có nhiều bộ phim nhất.
select c.[name], fc.[Số lượng phim]
from category c
join (
 select top(1) category_id, count(*) [Số lượng phim]
 from film_category
 group by category_id
 order by [Số lượng phim] desc
) fc
on c.category_id = fc.category_id

--Truy vấn tên bộ phim có nhiều diễn viên tham gia nhất.
select title, fa.[Số lượng diễn viên]
from film f
join (
 select top(1) film_id, count(*) [Số lượng diễn viên]
 from film_actor
 group by film_id
 order by [Số lượng diễn viên] desc
) fa
on f.film_id = fa.film_id

--Truy vấn thời gian mượn đĩa trung bình của khách hàng, hiển thị kết quả dưới dạng HH:MM
declare @rent_time int = (select avg(datediff(minute, rental_date, return_date)) from rental)
select cast(@rent_time / 60 as varchar) + ':' + cast(@rent_time % 60 as varchar) [Thời gian mượn trung bình]

--Truy vấn số lượng film theo special_feature.
--Chỉ áp dụng cho phiên bản MSSQL Server 2017 trở đi.
select [value] as [Special Features], count(*) [Số lượng phim]
from film
cross apply string_split(special_features, ',')
group by [value]

--Truy vấn tên bộ phim được thuê nhiều lần nhất.
select top(1) title, [Số lần thuê]
from film
join (
 select film_id, count(*) [Số lần thuê] 
 from rental r
 join inventory i on r.inventory_id = i.inventory_id
 group by film_id
) c on film.film_id = c.film_id
order by [Số lần thuê] desc

--Truy vấn thể loại film có tổng thời gian thuê lâu nhất.
select c.[name], sum(datediff(minute, rental_date, return_date)) [Tổng thời gian thuê]
from rental r
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
join film_category fc on fc.film_id = f.film_id
join category c on c.category_id = fc.category_id
group by c.[name]
order by [Tổng thời gian thuê] desc
