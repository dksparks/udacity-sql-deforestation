/* Using the view created in view.sql */



CREATE VIEW national_forestation_1990_2016 AS
WITH data_1990 AS (
  SELECT
    country_code code,
    country_name country,
    region,
    forest_area_sqkm,
    total_area_sqkm,
    forest_pct
  FROM forestation WHERE year = 1990
),
data_2016 AS (
  SELECT
    country_code code,
    forest_area_sqkm,
    total_area_sqkm,
    forest_pct
  FROM forestation WHERE year = 2016
)
SELECT
  d1.country,
  d1.region,
  d1.forest_area_sqkm forest_sqkm_1990,
  d1.total_area_sqkm total_sqkm_1990,
  d1.forest_pct forest_pct_1990,
  d2.forest_area_sqkm forest_sqkm_2016,
  d2.total_area_sqkm total_sqkm_2016,
  d2.forest_pct forest_pct_2016
FROM data_1990 d1
JOIN data_2016 d2 ON d1.code = d2.code;



/*
   a. Which 5 countries saw the largest amount 
      decrease in forest area from 1990 to 2016? What 
      was the difference in forest area for each?
*/

SELECT
  country,
  region,
  forest_sqkm_2016 - forest_sqkm_1990
    AS forest_sqkm_change
FROM national_forestation_1990_2016
WHERE country != 'World'
ORDER BY forest_sqkm_change;

/*
  Brazil, -541510
  Indonesia, -282193.98439999996
  Myanmar, -107234.00390000001
  Nigeria, -106506.00098
  Tanzania, -102320
*/



/*
   b. Which 5 countries saw the largest percent 
      decrease in forest area from 1990 to 2016? What 
      was the percent change to 2 decimal places for 
      each?
*/

SELECT
  country,
  region,
  CASE
    WHEN forest_sqkm_1990 IS NULL
      OR forest_sqkm_1990 = 0
      OR forest_sqkm_2016 IS NULL
      THEN NULL
    ELSE 100 * (
      forest_sqkm_2016 - forest_sqkm_1990
    ) / forest_sqkm_1990
  END AS forest_pct_change
FROM national_forestation_1990_2016
WHERE country != 'World'
ORDER BY forest_pct_change;

/*
  Togo -75.45
  Nigeria -61.80
  Uganda -59.13
  Mauritania -46.75
  Honduras -45.03

  first four: Sub-Saharan Africa
  Honduras: Latin America & Caribbean
*/



/*
   c. If countries were grouped by percent 
      forestation in quartiles, which group had the 
      most countries in it in 2016?
*/

/*
  Remark:

  The question as written does not make sense.
  Quartiles, by definition, will always either contain
  the same number of items or differ by at most 1
  if the number of items in the data set is not
  divisible by 4.

  Instead, I am speculating that the question wants me
  to create four groups of countries by percent 
  forestation with break points at 25%, 50%, and 75%.
  These are NOT quartiles, but at least such a
  classification is a sensible thing to do.
*/

WITH levels AS (
  SELECT
    country,
    CASE
      WHEN forest_pct_2016 > 75 THEN 4
      WHEN forest_pct_2016 > 50 THEN 3
      WHEN forest_pct_2016 > 25 THEN 2
      ELSE 1
    END AS forestation_level_2016
  FROM national_forestation_1990_2016
  WHERE forest_pct_2016 IS NOT NULL
  ORDER BY forest_pct_2016 DESC
)
SELECT
  forestation_level_2016,
  COUNT(*)
FROM levels
GROUP BY forestation_level_2016
ORDER BY forestation_level_2016 DESC;

/* 
  group 4:  9
  group 3: 38
  group 2: 72
  group 1: 85

  bottom group, below 25% forestation, has the most
*/



/*
   d. List all of the countries that were in the 4th 
      quartile (percent forest > 75%) in 2016.
*/

SELECT
  country,
  region,
  forest_pct_2016
FROM national_forestation_1990_2016
WHERE forest_pct_2016 > 75
ORDER BY forest_pct_2016 DESC;

/*
  Suriname, 98.26
  Micronesia, Fed. Sts., 91.86
  Gabon, 90.04
  Seychelles, 88.41
  Palau, 87.61
  American Samoa, 87.50
  Guyana, 83.90
  Lao PDR, 82.11
  Solomon Islands, 77.86
*/



/*
   e. How many countries had a percent forestation 
      higher than the United States in 2016?
*/

SELECT COUNT(*)
FROM national_forestation_1990_2016
WHERE forest_pct_2016 > (
  SELECT forest_pct_2016
  FROM national_forestation_1990_2016
  WHERE country = 'United States'
);


/* 94 */



/*
  This is the end of the questions provided with the
  project instructions. However, some additional
  information is needed to fill in the remaining
  blanks in the report template. I have added some 
  more questions and their corresponding SQL queries 
  below.
*/



/*
   f. Which 2 countries saw the largest amount 
      increase in forest area from 1990 to 2016? What 
      was the difference in forest area for each?
*/

SELECT
  country,
  forest_sqkm_2016 - forest_sqkm_1990
    AS forest_sqkm_change
FROM national_forestation_1990_2016
WHERE country != 'World'
AND forest_sqkm_1990 IS NOT NULL
AND forest_sqkm_2016 IS NOT NULL
ORDER BY forest_sqkm_change DESC;

/*
  China, 527229.0619999999
  United States, 79200
*/



/*
   g. Which country saw the largest percent increase 
      in forest area from 1990 to 2016? What was the 
      percent change to 2 decimal places for each?
*/

SELECT
  country,
  region,
  CASE
    WHEN forest_sqkm_1990 IS NULL
      OR forest_sqkm_1990 = 0
      OR forest_sqkm_2016 IS NULL
      THEN NULL
    ELSE 100 * (
      forest_sqkm_2016 - forest_sqkm_1990
    ) / forest_sqkm_1990
  END AS forest_pct_change
FROM national_forestation_1990_2016
WHERE country != 'World'
AND forest_sqkm_1990 IS NOT NULL
AND forest_sqkm_1990 != 0
AND forest_sqkm_2016 IS NOT NULL
ORDER BY forest_pct_change DESC;

/* Iceland, 213.66% */
