-- =======================================
-- Check quality (Reading vs Service)
-- =======================================
SET search_path TO dwh_034;

SELECT 
  'ft_readingevent' AS table_name,
  MIN(reading_value) AS min_value,
  MAX(reading_value) AS max_value,
  MIN(data_quality_score) AS min_quality,
  MAX(data_quality_score) AS max_quality,
  NULL AS min_cost,
  NULL AS max_cost,
  NULL AS min_duration,
  NULL AS max_duration
FROM ft_readingevent

UNION ALL

SELECT 
  'ft_serviceevent' AS table_name,
  NULL AS min_value,
  NULL AS max_value,
  MIN(servicequality) AS min_quality,
  MAX(servicequality) AS max_quality,
  MIN(servicecost) AS min_cost,
  MAX(servicecost) AS max_cost,
  MIN(durationminutes) AS min_duration,
  MAX(durationminutes) AS max_duration
FROM ft_serviceevent;
