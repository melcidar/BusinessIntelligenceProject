
-- =======================================
-- Check row counts
-- =======================================
SET search_path TO dwh_034;

SELECT 'dim_city' AS table_name, COUNT(*) AS row_count FROM dim_city
UNION ALL
SELECT 'dim_sensordevice', COUNT(*) FROM dim_sensordevice
UNION ALL
SELECT 'dim_parameter', COUNT(*) FROM dim_parameter
UNION ALL
SELECT 'dim_timeday', COUNT(*) FROM dim_timeday
UNION ALL
SELECT 'ft_readingevent', COUNT(*) FROM ft_readingevent
UNION ALL
SELECT 'dim_project', COUNT(*) FROM dim_project
UNION ALL
SELECT 'dim_employee', COUNT(*) FROM dim_employee
UNION ALL
SELECT 'dim_servicetype', COUNT(*) FROM dim_servicetype
UNION ALL
SELECT 'ft_serviceevent', COUNT(*) FROM ft_serviceevent


