/* Using the view created in view.sql */



CREATE VIEW regional_forestation_1990_2016 AS
WITH data_1990 AS (
  SELECT
    country_code code,
    region,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm,
    COALESCE(total_area_sqkm, 0) AS total_sqkm
  FROM forestation WHERE year = 1990
),
data_2016 AS (
  SELECT
    country_code code,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm,
    COALESCE(total_area_sqkm, 0) AS total_sqkm
  FROM forestation WHERE year = 2016
)
SELECT
  d1.region,
  SUM(d1.forest_sqkm) AS forest_sqkm_1990,
  SUM(d1.total_sqkm) AS total_sqkm_1990,
  SUM(d2.forest_sqkm) AS forest_sqkm_2016,
  SUM(d2.total_sqkm) AS total_sqkm_2016
FROM data_1990 d1
JOIN data_2016 d2 ON d1.code = d2.code
GROUP BY region ORDER BY region;



/*
   a. What was the percent forest of the entire world 
      in 2016? Which region had the HIGHEST percent 
      forest in 2016, and which had the LOWEST, to 2 
      decimal places?
*/

SELECT
  region,
  100 * forest_sqkm_2016 / total_sqkm_2016
    AS forest_pct_2016
FROM regional_forestation_1990_2016
ORDER BY forest_pct_2016 DESC;

/*
    World: 31.38
  Highest: Latin America & Caribbean, 46.16
   Lowest: Middle East & North Africa, 2.07
*/



/*
   b. What was the percent forest of the entire world 
      in 1990? Which region had the HIGHEST percent 
      forest in 1990, and which had the LOWEST, to 2 
      decimal places?
*/

SELECT
  region,
  100 * forest_sqkm_1990 / total_sqkm_1990
    AS forest_pct_1990
FROM regional_forestation_1990_2016
ORDER BY forest_pct_1990 DESC;

/*
    World: 32.42
  Highest: Latin America & Caribbean, 51.03
   Lowest: Middle East & North Africa, 1.78
*/



/*
   c. Based on the table you created, which regions 
      of the world DECREASED in forest area from 1990 
      to 2016?
*/

SELECT
  region,
  forest_sqkm_1990,
  forest_sqkm_2016
FROM regional_forestation_1990_2016
WHERE forest_sqkm_1990 > forest_sqkm_2016
  AND region != 'World';

/*
  Latin America & Caribbean
  Sub-Saharan Africa
*/
