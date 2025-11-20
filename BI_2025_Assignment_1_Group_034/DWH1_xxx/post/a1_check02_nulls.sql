-- =======================================
-- Check nulls
-- =======================================
SET search_path TO dwh_034;

SELECT
  SUM(CASE WHEN city_key IS NULL THEN 1 ELSE 0 END) AS null_city,
  SUM(CASE WHEN sk_sensordevice IS NULL THEN 1 ELSE 0 END) AS null_device,
  SUM(CASE WHEN parameter_key IS NULL THEN 1 ELSE 0 END) AS null_param,
  SUM(CASE WHEN time_key IS NULL THEN 1 ELSE 0 END) AS null_time,
  0 AS null_employee,
  0 AS null_project,
  0 AS null_servicetype
FROM ft_readingevent

UNION ALL

SELECT
  0 AS null_city,
  0 AS null_device,
  0 AS null_param,
  0 AS null_time,
  SUM(CASE WHEN sk_employee IS NULL THEN 1 ELSE 0 END) AS null_employee,
  SUM(CASE WHEN sk_project IS NULL THEN 1 ELSE 0 END) AS null_project,
  SUM(CASE WHEN sk_servicetype IS NULL THEN 1 ELSE 0 END) AS null_servicetype
FROM ft_serviceevent;
