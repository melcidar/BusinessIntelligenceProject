SELECT 
    dc.city_name,
    dp.param_name,
    AVG(f.data_quality_avg) AS avg_data_quality_2024
FROM dwh2_xxx.ft_param_city_month f
JOIN dwh2_xxx.dim_timemonth dt 
    ON f.month_key = dt.month_key
JOIN dwh2_xxx.dim_city dc 
    ON f.city_key = dc.city_key
JOIN dwh2_xxx.dim_param dp
    ON f.param_key = dp.param_key
WHERE 
    dt.year_num = 2024
GROUP BY 
    dc.city_name,
    dp.param_name
ORDER BY 
    avg_data_quality_2024 DESC
LIMIT 10;