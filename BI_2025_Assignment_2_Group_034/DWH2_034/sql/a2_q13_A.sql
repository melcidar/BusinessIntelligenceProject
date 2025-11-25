SELECT 
    c.city_name,
    SUM(CASE WHEN t.month_num = 1 THEN f.exceed_days_any END) AS jan_2023,
    SUM(CASE WHEN t.month_num = 2 THEN f.exceed_days_any END) AS feb_2023,
    SUM(CASE WHEN t.month_num = 3 THEN f.exceed_days_any END) AS mar_2023
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c 
    ON f.city_key = c.city_key
JOIN dwh2_034.dim_timemonth t 
    ON f.month_key = t.month_key
JOIN dwh2_034.dim_alertpeak a
    ON f.alertpeak_key = a.alertpeak_key
WHERE t.year_num = 2023
  AND t.month_num IN (1,2,3)
  AND a.alert_level_name IN ('None','Yellow')
GROUP BY c.city_name
ORDER BY c.city_name;
