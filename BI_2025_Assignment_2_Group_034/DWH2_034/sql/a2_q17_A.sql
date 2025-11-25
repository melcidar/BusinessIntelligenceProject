SELECT 
    c.country_name,
    ROUND(AVG(CASE WHEN t.year_num = 2023 THEN f.data_quality_avg END), 3)
        AS avg_quality_2023,
    ROUND(AVG(CASE WHEN t.year_num = 2024 THEN f.data_quality_avg END), 3)
        AS avg_quality_2024
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c 
    ON f.city_key = c.city_key
JOIN dwh2_034.dim_timemonth t 
    ON f.month_key = t.month_key
GROUP BY c.country_name
ORDER BY c.country_name;
