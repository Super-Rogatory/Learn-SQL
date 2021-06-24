-- CREATE DATABASE record_company;
-- USE record_company;
-- CREATE TABLE test(
--     test_property INT
-- );
-- ALTER TABLE test
-- ADD another_test_property VARCHAR(255);
-- CREATE TABLE bands (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(255) NOT NULL
-- );
-- CREATE TABLE albums (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(255) NOT NULL,
--     band_id INT NOT NULL,
--     release_year INT,
--     FOREIGN KEY(band_id) REFERENCES bands(id)
-- );
-- INSERT INTO bands (name)
-- VALUES ('Three Days Grace'), ('Breaking Benjamin');
-- INSERT INTO albums(name, release_year, band_id)
-- VALUES ('One-X', 2006, 1),
--        ('Life Starts Now', 2009, 1),
--        ('Dear Agony', 2009, 2),
--        ('Phobia', 2004, 2),
--        ('Test Album', NULL, 2);
-- UPDATE albums
-- SET release_year=2006
-- WHERE id=4;
-- SELECT * FROM bands
-- JOIN albums ON bands.id = albums.band_id;
-- SELECT AVG(release_year) FROM albums;
SELECT b.name AS band_name, COUNT (a.id) AS number_of_albums
FROM bands as b
LEFT JOIN albums AS a ON b.id = a.band_id
GROUP BY b.id;