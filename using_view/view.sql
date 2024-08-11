CREATE VIEW forestation AS
SELECT
  f.country_code,
  f.country_name,
  f.year,
  f.forest_area_sqkm,
  l.total_area_sq_mi * 2.59 AS total_area_sqkm,
  CASE
    WHEN f.forest_area_sqkm IS NULL
      OR l.total_area_sq_mi IS NULL
      OR l.total_area_sq_mi = 0
      THEN NULL
    ELSE 100 * f.forest_area_sqkm / (
      l.total_area_sq_mi * 2.59
    )
  END AS forest_pct,
  r.region,
  r.income_group
FROM forest_area f
JOIN land_area l
  ON l.country_code = f.country_code
  AND l.year = f.year
JOIN regions r ON r.country_code = f.country_code;
