-- view the table
SELECT * FROM crime;

---------------------------------------------------------

BEGIN TRANSACTION;

-- change column names
ALTER TABLE crime RENAME COLUMN TYPE TO type;
ALTER TABLE crime RENAME COLUMN YEAR TO year;
ALTER TABLE crime RENAME COLUMN MONTH TO month;
ALTER TABLE crime RENAME COLUMN DAY TO day;
ALTER TABLE crime RENAME COLUMN HOUR TO hour;
ALTER TABLE crime RENAME COLUMN HUNDRED_BLOCK TO block;
ALTER TABLE crime RENAME COLUMN NEIGHBOURHOOD TO hood;
ALTER TABLE crime RENAME COLUMN X TO UTM_x;
ALTER TABLE crime RENAME COLUMN Y TO UTM_y;

-- drop column
ALTER TABLE crime DROP COLUMN MINUTE;

END TRANSACTION;

-- view the table
SELECT * FROM crime;

---------------------------------------------------------

-- view distinct values
SELECT DISTINCT type FROM crime;
SELECT DISTINCT year FROM crime ORDER BY year DESC;

---------------------------------------------------------

-- delete rows 
DELETE FROM crime WHERE year < 2011 OR year = 2023;

---------------------------------------------------------

-- view null in UTM_x column
SELECT * FROM crime WHERE UTM_x IS NULL;

-- view '' in UTM_x column
SELECT * FROM crime WHERE UTM_x = '';

-- view 0 in UTM_x column
SELECT * FROM crime WHERE UTM_x = 0;

-- replace '' and 0 with null
BEGIN TRANSACTION;

UPDATE crime SET UTM_x = NULL WHERE UTM_x = '' OR UTM_x = 0;
UPDATE crime SET UTM_y = NULL WHERE UTM_y = '' OR UTM_y = 0;

END TRANSACTION;

---------------------------------------------------------

-- create table
CREATE TABLE population (year, pop);

-- insert rows
INSERT INTO population (year, pop) VALUES 
(2011, 603502),
(2016, 631486),
(2021, 662248);

SELECT * FROM population;

---------------------------------------------------------

BEGIN TRANSACTION;

-- insert rows
INSERT INTO population (year, pop) VALUES
(2012, 609099), (2013, 614696), (2014, 620292), (2015, 625889),
(2017, 637638),(2018, 643791), (2019, 649943), (2020, 656096),
(2022, 668123);

END TRANSACTION;

-- view table as year ascending
SELECT * FROM population ORDER BY year ASC;

---------------------------------------------------------

BEGIN TRANSACTION;

-- create table, rows grouped by year and type, add count value as column
CREATE TABLE crime_rate AS
SELECT type, year, COUNT(*) AS count
FROM crime
GROUP BY type, year;

END TRANSACTION;

SELECT * FROM crime_rate;

---------------------------------------------------------

BEGIN TRANSACTION;

CREATE TABLE crime_rate2 AS

-- join tables 
SELECT crime_rate.*, population.pop AS van_pop
FROM crime_rate
NATURAL JOIN population;

END TRANSACTION;

SELECT * FROM crime_rate2;

---------------------------------------------------------

BEGIN TRANSACTION;

CREATE TABLE crime_rate3 AS

-- calculate per capita
SELECT *,
((count * 1.0) / van_pop) * 100000 AS rate_capita
FROM crime_rate2;

END TRANSACTION;

SELECT * FROM crime_rate3;

---------------------------------------------------------

DROP TABLE crime_rate; 
DROP TABLE crime_rate2;

ALTER TABLE crime_rate3 RENAME TO crime_rate;