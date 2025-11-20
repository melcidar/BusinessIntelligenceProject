-- =======================================
-- Check referential integrity (facts vs dims)
-- =======================================
SET search_path TO dwh_034;

SELECT 
  'ft_readingevent -> dim_city' AS relation,
  COUNT(*) AS missing_keys
FROM ft_readingevent f
LEFT JOIN dim_city c ON f.city_key = c.city_key
WHERE c.city_key IS NULL

UNION ALL

SELECT 
  'ft_serviceevent -> dim_project' AS relation,
  COUNT(*) AS missing_keys
FROM ft_serviceevent f
LEFT JOIN dim_project p ON f.sk_project = p.sk_project
WHERE p.sk_project IS NULL;
