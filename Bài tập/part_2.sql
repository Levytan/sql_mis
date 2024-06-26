USE [Chinook]
GO
create or alter function [dbo].[get_top_songs_name](@genre_name nvarchar(200))
returns @result table (track_name nvarchar(100))
as begin
	;with track_count as (
		select TrackId, count(*) as Quantity
		from InvoiceLine
		group by TrackId
	)
	insert into @result
	select top(1) with ties Track.[Name]	-- lấy hết những dòng có giá trị giống nhau
	from Track
	join track_count as tc on Track.TrackId = tc.TrackId
	join Genre on Track.GenreId = Genre.GenreId
	where Genre.[Name] = @genre_name
	order by Quantity desc
	return
end
go
create or alter function [dbo].[get_album_details](@album_title nvarchar(200))
returns @result table (
	track_name nvarchar(200),
	track_length float,
	track_genre nvarchar(50)
) as begin
	declare @album_id int
	select @album_id = AlbumId from Album where [Title] = @album_title
	insert into @result
	select t.[Name], t.Milliseconds / 1000, g.[Name]
	from Track as t
	join Genre as g on t.GenreId = g.GenreId
	where t.AlbumId = @album_id
	return
end