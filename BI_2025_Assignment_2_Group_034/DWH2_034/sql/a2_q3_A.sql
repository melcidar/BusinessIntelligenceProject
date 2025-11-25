SELECT 
    c.city_name,
    SUM(f.exceed_days_any) AS total_exceed_days_2024
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c 
    ON f.city_key = c.city_key
JOIN dwh2_034.dim_param p 
    ON f.param_key = p.param_key
JOIN dwh2_034.dim_timemonth t 
    ON f.month_key = t.month_key
WHERE p.param_name = 'PM10'
  AND t.year_num = 2024
GROUP BY c.city_name
ORDER BY total_exceed_days_2024 DESC;
