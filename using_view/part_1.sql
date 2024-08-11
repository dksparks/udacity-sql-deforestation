/* Using the view created in view.sql */



/*
   a. What was the total forest area (in sq km) of 
      the world in 1990? Please keep in mind that you 
      can use the country record denoted as “World" 
      in the region table.
*/

SELECT forest_area_sqkm
FROM forestation
WHERE country_name = 'World' AND year = 1990;

/* 41282694.9 */



/*
   b. What was the total forest area (in sq km) of 
      the world in 2016? Please keep in mind that you 
      can use the country record in the table is 
      denoted as “World.”
*/

SELECT forest_area_sqkm
FROM forestation
WHERE country_name = 'World' AND year = 2016;

/* 39958245.9 */



/*
   c. What was the change (in sq km) in the forest 
      area of the world from 1990 to 2016?
*/

WITH two_years AS (
  SELECT year, forest_area_sqkm area
  FROM forestation
  WHERE country_name = 'World'
  AND year IN (1990, 2016)
  ORDER BY year
)
SELECT
  year,
  area,
  area - LAG(area) OVER (ORDER BY year) AS change
FROM two_years;

/* -1324449 */



/*
   d. What was the percent change in forest area of 
      the world between 1990 and 2016?
*/

WITH two_years AS (
  SELECT year, forest_area_sqkm area
  FROM forestation
  WHERE country_name = 'World'
  AND year IN (1990, 2016)
  ORDER BY year
)
SELECT
  year,
  area,
  100 * (
    area - LAG(area) OVER (ORDER BY year)
  ) / LAG(area) OVER (ORDER BY year) AS pct_change
FROM two_years;

/* -3.2082425898024405 */



/*
   e. If you compare the amount of forest area lost 
      between 1990 and 2016, to which country's total 
      area in 2016 is it closest to?
*/

WITH two_years AS (
  SELECT year, forest_area_sqkm area
  FROM forestation
  WHERE country_name = 'World'
  AND year IN (1990, 2016)
  ORDER BY year
),
loss_table AS (
  SELECT
  ABS(area - LAG(area) OVER (ORDER BY year)) AS loss
  FROM two_years
)
SELECT
  country_name,
  total_area_sqkm,
  ABS(total_area_sqkm - (
    SELECT loss FROM loss_table WHERE loss IS NOT NULL
  )) AS diff
FROM forestation WHERE year = 2016 ORDER BY diff;

/* Peru, 1279999.9891 */
