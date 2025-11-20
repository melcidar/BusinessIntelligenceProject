-- =======================================
-- Check average measures (data sanity)
-- =======================================
SET search_path TO dwh_034;

SELECT 
  'Average Reading Value' AS metric,
  ROUND(AVG(reading_value), 3) AS avg_value
FROM ft_readingevent

UNION ALL

SELECT 
  'Average Service Cost',
  ROUND(AVG(servicecost), 2)
FROM ft_serviceevent

UNION ALL

SELECT 
  'Average Service Duration',
  ROUND(AVG(durationminutes), 2)
FROM ft_serviceevent;
