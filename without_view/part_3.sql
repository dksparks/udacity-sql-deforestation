/* a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each? */

WITH forest_1990 AS (
  SELECT
    country_code AS code,
    country_name AS country,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm
  FROM forest_area WHERE year = 1990
),
forest_2016 AS (
  SELECT
    country_code AS code,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm
  FROM forest_area WHERE year = 2016
)
SELECT
  f1.country,
  f1.forest_sqkm AS forest_sqkm_1990,
  f2.forest_sqkm AS forest_sqkm_2016,
  f2.forest_sqkm - f1.forest_sqkm AS change
FROM forest_1990 f1
JOIN forest_2016 f2 ON f1.code = f2.code
WHERE f1.country != 'World'
ORDER BY change;

/*
  Brazil, -541510
  Indonesia, -282193.98439999996
  Myanmar, -107234.00390000001
  Nigeria, -106506.00098
  Tanzania, -102320
*/



/* b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each? */


/*
  This is one way to interpret the question.
  Based on the template, however, this interpretation
  does not seem to be what was intended, because
  it does not lead to four of the top five countries
  being in the same region.
*/

WITH forest_1990 AS (
  SELECT
    country_code AS code,
    country_name AS country,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm
  FROM forest_area WHERE year = 1990
),
forest_2016 AS (
  SELECT
    country_code AS code,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm
  FROM forest_area WHERE year = 2016
),
land_1990 AS (
  SELECT
    country_code AS code,
    COALESCE(total_area_sq_mi, 0) * 2.59 AS total_sqkm
  FROM land_area WHERE year = 1990
),
land_2016 AS (
  SELECT
    country_code AS code,
    COALESCE(total_area_sq_mi, 0) * 2.59 AS total_sqkm
  FROM land_area WHERE year = 2016
),
pct AS (
  SELECT
    f1.country,
    CASE
      WHEN l1.total_sqkm = 0 THEN 0
      ELSE 100 * f1.forest_sqkm / l1.total_sqkm
    END AS forest_pct_1990,
    CASE
      WHEN l2.total_sqkm = 0 THEN 0
      ELSE 100 * f2.forest_sqkm / l2.total_sqkm
    END AS forest_pct_2016
  FROM forest_1990 f1
  JOIN forest_2016 f2 ON f2.code = f1.code
  JOIN land_1990 l1 ON l1.code = f1.code
  JOIN land_2016 l2 ON l2.code = f1.code
  WHERE f1.country != 'World'
)
SELECT
  country,
  forest_pct_1990,
  forest_pct_2016,
  forest_pct_2016 - forest_pct_1990 AS change
FROM pct ORDER BY change;

/*
  Honduras -32.75
  Korea, Dem. People’s Rep. -27.38
  Zimbabwe -21.75
  Cambodia -20.48
  Timor-Leste -19.58
*/


/*
  Here is the other way to interpret the question.
  Based on what is already written in the template,
  this interpretation seems to be what was intended,
  as it leads to four of the top five countries being
  in the same region.
*/

WITH forest_1990 AS (
  SELECT
    country_code AS code,
    country_name AS country,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm
  FROM forest_area WHERE year = 1990
),
forest_2016 AS (
  SELECT
    country_code AS code,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm
  FROM forest_area WHERE year = 2016
)
SELECT
  f1.country,
  r.region,
  f1.forest_sqkm AS forest_sqkm_1990,
  f2.forest_sqkm AS forest_sqkm_2016,
  CASE
    WHEN f1.forest_sqkm = 0 THEN 0
    ELSE 100 * (
      f2.forest_sqkm - f1.forest_sqkm 
    ) / f1.forest_sqkm
  END AS change
FROM forest_1990 f1
JOIN forest_2016 f2 ON f2.code = f1.code
JOIN regions r ON r.country_code = f1.code
WHERE f1.country != 'World'
ORDER BY change;

/* St. Martin (French part) -100.00 */
/* Togo -75.45 */
/* Nigeria -61.80 */
/* Uganda -59.13 */
/* Mauritania -46.75 */

/* First: Latin America & Caribbean */
/* Others: Sub-Saharan Africa */



/* c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016? */

/*
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

WITH forest_2016 AS (
  SELECT
    country_code AS code,
    country_name AS country,
    forest_area_sqkm AS forest_sqkm
  FROM forest_area WHERE year = 2016
),
land_2016 AS (
  SELECT
    country_code AS code,
    COALESCE(total_area_sq_mi, 0) * 2.59 AS total_sqkm
  FROM land_area WHERE year = 2016
),
pcts AS (
  SELECT
    f.country,
    CASE
      WHEN f.forest_sqkm IS NULL OR l.total_sqkm = 0 
        THEN NULL
      ELSE 100 * f.forest_sqkm / l.total_sqkm
    END AS forest_pct_2016
  FROM forest_2016 f
  JOIN land_2016 l ON l.code = f.code
  WHERE f.country != 'World'
),
levels AS (
  SELECT
    country,
    forest_pct_2016,
    CASE
      WHEN forest_pct_2016 IS NULL THEN NULL
      WHEN forest_pct_2016 > 75 THEN 4
      WHEN forest_pct_2016 > 50 THEN 3
      WHEN forest_pct_2016 > 25 THEN 2
      ELSE 1
    END AS forestation_level_2016
  FROM pcts ORDER BY forest_pct_2016 DESC
)
SELECT
  forestation_level_2016,
  COUNT(*)
FROM levels
WHERE forestation_level_2016 IS NOT NULL
GROUP BY forestation_level_2016
ORDER BY forestation_level_2016 DESC;

/* 
  group 4:  9
  group 3: 38
  group 2: 72
  group 1: 85
*/
/* bottom quartile, below 25% forestation */



/* d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016. */


WITH forest_2016 AS (
  SELECT
    country_code AS code,
    country_name AS country,
    forest_area_sqkm AS forest_sqkm
  FROM forest_area WHERE year = 2016
),
land_2016 AS (
  SELECT
    country_code AS code,
    COALESCE(total_area_sq_mi, 0) * 2.59 AS total_sqkm
  FROM land_area WHERE year = 2016
),
pcts AS (
  SELECT
    f.country,
    CASE
      WHEN f.forest_sqkm IS NULL OR l.total_sqkm = 0 
        THEN NULL
      ELSE 100 * f.forest_sqkm / l.total_sqkm
    END AS forest_pct_2016
  FROM forest_2016 f
  JOIN land_2016 l ON l.code = f.code
  WHERE f.country != 'World'
),
levels AS (
  SELECT
    country,
    forest_pct_2016,
    CASE
      WHEN forest_pct_2016 IS NULL THEN NULL
      WHEN forest_pct_2016 > 75 THEN 4
      WHEN forest_pct_2016 > 50 THEN 3
      WHEN forest_pct_2016 > 25 THEN 2
      ELSE 1
    END AS forestation_level_2016
  FROM pcts ORDER BY forest_pct_2016 DESC
)
SELECT *
FROM levels
WHERE forestation_level_2016 = 4
ORDER BY forest_pct_2016 DESC;

/*
  Suriname
  Micronesia, Fed. Sts.
  Gabon
  Seychelles
  Palau
  American Samoa
  Guyana
  Lao PDR
  Solomon Islands
*/



/* e. How many countries had a percent forestation higher than the United States in 2016? */

WITH forest_2016 AS (
  SELECT
    country_code AS code,
    country_name AS country,
    forest_area_sqkm AS forest_sqkm
  FROM forest_area WHERE year = 2016
),
land_2016 AS (
  SELECT
    country_code AS code,
    COALESCE(total_area_sq_mi, 0) * 2.59 AS total_sqkm
  FROM land_area WHERE year = 2016
),
pcts AS (
  SELECT
    f.country,
    CASE
      WHEN f.forest_sqkm IS NULL OR l.total_sqkm = 0 
        THEN NULL
      ELSE 100 * f.forest_sqkm / l.total_sqkm
    END AS forest_pct_2016
  FROM forest_2016 f
  JOIN land_2016 l ON l.code = f.code
  WHERE f.country != 'World'
)
SELECT COUNT(*) FROM pcts
WHERE forest_pct_2016 > (
  SELECT forest_pct_2016 FROM pcts
  WHERE country = 'United States'
);

/* 94 */
