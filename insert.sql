-- Количество исполнителей в каждом жанре
SELECT g.NameGenre, COUNT(*) num_artists
FROM ExecutorGenre eg
JOIN Executor e ON e.id = eg.executorid
JOIN Genre g ON g.id = eg.genreid
GROUP BY g.NameGenre;


-- Количество трэков, вошедших в альбомы 2019-2020 годов
SELECT AlbumName, COUNT(*) tr_q
FROM Track t
JOIN Album a ON a.id = t.albumid
WHERE a.year_release BETWEEN '2019-01-01' AND '2020-12-31'
GROUP BY a.AlbumName;


-- Средняя продолжительность трэков по каждому альбому
SELECT AlbumName, AVG(duration_track) tr_q
FROM Track t
JOIN Album a ON a.id = t.id
GROUP BY a.AlbumName


-- Все исполнители которые не выпустили альбом в 2020 году
SELECT ExecutorName exn
FROM Album a
JOIN Executor ex ON ex.id = a.id
WHERE ex.id IN(
	SELECT id FROM Album
WHERE ex.id not in(
	select id from Album
	where extract(year from year_release) = 2020
)
);

	



-- Название сборников в которых присутствует исполнитель Eminem
select c.CollectionName
from track t
join Collectiontrack ct on  t.id = ct.trackid
join Collection c on  ct.collectionid = c.id
join Album a on a.id = t.albumid
join Executoralbum ex on a.id = ex.albumid
join Executor e on ex.executorid = e.id
where e.executorname  = 'EMINEM';


-- Названия альбомов в которых присутствуют исполнители более одного жанра
SELECT Album.albumname 
FROM ExecutorGenre
JOIN Genre  ON ExecutorGenre.genreid = Genre.id
JOIN Executor ON ExecutorGenre.executorid = Executor.id
JOIN ExecutorAlbum ON ExecutorAlbum.executorid = Executor.id
JOIN Album ON ExecutorAlbum.albumid = Album.id
GROUP BY Album.albumname 
HAVING COUNT(DISTINCT Genre.namegenre) > 1;




-- Наименования трэков, которые не входят в сборники
SELECT t.TrackName
FROM Track t
WHERE t.id NOT IN (SELECT trackid FROM CollectionTrack);


-- Исполнитель с самым коротким по продолжительности трэком
SELECT ex.ExecutorName, t.duration_track
FROM Executor ex
JOIN ExecutorAlbum exm ON ex.id = exm.executorid 
JOIN Album a ON a.id = exm.albumid
JOIN Track t ON a.id = t.albumid
WHERE t.duration_track = (SELECT MIN(duration_track) FROM Track);

-- Название альбома с самым наименьшим количеством трэков
SELECT a.AlbumName, COUNT(t.id) t_q
FROM Track t
JOIN Album a ON a.id = t.albumid
GROUP BY a.id
ORDER BY t_q;


SELECT DISTINCT a.AlbumName
FROM Album a
LEFT JOIN track as t ON t.albumid = a.id
WHERE t.albumid IN (
    SELECT albumid
    FROM track
    GROUP BY albumid
    HAVING count(id) = (
        SELECT count(id)
        FROM track
        GROUP BY albumid
        ORDER BY count
        LIMIT 1
    )
)
ORDER BY a.AlbumName;