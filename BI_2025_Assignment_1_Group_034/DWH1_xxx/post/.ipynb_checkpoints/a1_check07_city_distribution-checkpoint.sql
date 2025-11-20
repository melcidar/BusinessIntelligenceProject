-- =======================================
-- Check distribution of readings per city
-- =======================================
SET search_path TO dwh_034;

SELECT 
  c.city_name,
  COUNT(f.readingevent_key) AS num_readings
FROM ft_readingevent f
JOIN dim_city c ON f.city_key = c.city_key
GROUP BY c.city_name
ORDER BY num_readings DESC;
