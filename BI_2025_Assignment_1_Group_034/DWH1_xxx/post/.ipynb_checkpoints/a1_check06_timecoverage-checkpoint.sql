-- =======================================
-- Check time dimension coverage
-- =======================================
SET search_path TO dwh_034;

SELECT 
  MIN(id) AS first_day,
  MAX(id) AS last_day,
  COUNT(*) AS total_days
FROM dim_timeday;
