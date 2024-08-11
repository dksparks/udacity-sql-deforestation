/* preliminary work */

WITH forest_2016 AS (
  SELECT
    country_code AS code,
    country_name AS country,
    COALESCE(forest_area_sqkm, 0) AS forest_sqkm
  FROM forest_area WHERE year = 2016
),
land_2016 AS (
  SELECT
    country_code AS code,
    country_name AS country,
    COALESCE(total_area_sq_mi, 0) * 2.59 AS total_sqkm
  FROM land_area WHERE year = 2016
),
combined_2016 AS (
  SELECT
  f.country,
  f.forest_sqkm,
  l.total_sqkm
  FROM forest_2016 f
  JOIN land_2016 l ON l.code = f.code
)
SELECT
  country,
  100 * forest_sqkm / total_sqkm AS forest_pct
FROM combined_2016
ORDER BY forest_pct DESC;



/* a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places? */

WITH forest_1990 AS (
  SELECT
    country_code AS code,
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
sums AS (
  SELECT
  r.region,
  SUM(f1.forest_sqkm) AS forest_sqkm_1990,
  SUM(f2.forest_sqkm) AS forest_sqkm_2016,
  SUM(l1.total_sqkm) AS total_sqkm_1990,
  SUM(l2.total_sqkm) AS total_sqkm_2016
  FROM regions r
  JOIN forest_1990 f1 ON f1.code = r.country_code
  JOIN forest_2016 f2 ON f2.code = r.country_code
  JOIN land_1990 l1 ON l1.code = r.country_code
  JOIN land_2016 l2 ON l2.code = r.country_code
  GROUP BY region ORDER BY region
)
SELECT
  region,
  100 * forest_sqkm_1990 / total_sqkm_1990
    AS forest_pct_1990,
  100 * forest_sqkm_2016 / total_sqkm_2016
    AS forest_pct_2016
FROM sums ORDER BY forest_pct_2016 DESC;

/* World: 31.38 */
/* Highest: Latin America & Caribbean, 46.16 */
/*  Lowest: Middle East & North Africa, 2.07 */



/* b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places? */

WITH forest_1990 AS (
  SELECT
    country_code AS code,
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
sums AS (
  SELECT
  r.region,
  SUM(f1.forest_sqkm) AS forest_sqkm_1990,
  SUM(f2.forest_sqkm) AS forest_sqkm_2016,
  SUM(l1.total_sqkm) AS total_sqkm_1990,
  SUM(l2.total_sqkm) AS total_sqkm_2016
  FROM regions r
  JOIN forest_1990 f1 ON f1.code = r.country_code
  JOIN forest_2016 f2 ON f2.code = r.country_code
  JOIN land_1990 l1 ON l1.code = r.country_code
  JOIN land_2016 l2 ON l2.code = r.country_code
  GROUP BY region ORDER BY region
)
SELECT
  region,
  100 * forest_sqkm_1990 / total_sqkm_1990
    AS forest_pct_1990,
  100 * forest_sqkm_2016 / total_sqkm_2016
    AS forest_pct_2016
FROM sums ORDER BY forest_pct_1990 DESC;

/* World: 32.42 */
/* Highest: Latin America & Caribbean, 51.03 */
/*  Lowest: Middle East & North Africa, 1.78 */



/* c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016? */

WITH forest_1990 AS (
  SELECT
    country_code AS code,
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
sums AS (
  SELECT
  r.region,
  SUM(f1.forest_sqkm) AS forest_sqkm_1990,
  SUM(f2.forest_sqkm) AS forest_sqkm_2016,
  SUM(l1.total_sqkm) AS total_sqkm_1990,
  SUM(l2.total_sqkm) AS total_sqkm_2016
  FROM regions r
  JOIN forest_1990 f1 ON f1.code = r.country_code
  JOIN forest_2016 f2 ON f2.code = r.country_code
  JOIN land_1990 l1 ON l1.code = r.country_code
  JOIN land_2016 l2 ON l2.code = r.country_code
  GROUP BY region ORDER BY region
)
SELECT
  region,
  100 * forest_sqkm_1990 / total_sqkm_1990
    AS forest_pct_1990,
  100 * forest_sqkm_2016 / total_sqkm_2016
    AS forest_pct_2016
FROM sums WHERE forest_sqkm_1990 > forest_sqkm_2016
ORDER BY region;

/* Latin America & Caribbean, 51.03 to 46.16 */
/* Sub-Saharan Africa, 30.67 to 28.79 */
