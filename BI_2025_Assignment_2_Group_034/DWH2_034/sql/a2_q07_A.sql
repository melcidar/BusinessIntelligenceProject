SELECT 
    c.country_name,
    ROUND(AVG(f.recordedvalue_avg), 3) AS avg_recorded_value_2023,
    ROUND(AVG(f.recordedvalue_p95), 3) AS p95_recorded_value_2023
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c 
    ON f.city_key = c.city_key
JOIN dwh2_034.dim_param p 
    ON f.param_key = p.param_key
JOIN dwh2_034.dim_timemonth t 
    ON f.month_key = t.month_key
WHERE p.param_name = 'PM10'
  AND t.year_num = 2023
GROUP BY c.country_name
ORDER BY avg_recorded_value_2023 DESC;
