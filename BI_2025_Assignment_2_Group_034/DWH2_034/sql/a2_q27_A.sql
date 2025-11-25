SELECT 
    c.country_name,
    SUM(CASE WHEN t.quarter_num = 1 THEN f.exceed_days_any END) AS q1,
    SUM(CASE WHEN t.quarter_num = 2 THEN f.exceed_days_any END) AS q2,
    SUM(CASE WHEN t.quarter_num = 3 THEN f.exceed_days_any END) AS q3,
    SUM(CASE WHEN t.quarter_num = 4 THEN f.exceed_days_any END) AS q4
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c 
    ON f.city_key = c.city_key
JOIN dwh2_034.dim_timemonth t 
    ON f.month_key = t.month_key
WHERE t.year_num = 2024
  AND c.country_name IN ('Russia','Turkey','Austria','Germany')
GROUP BY c.country_name
ORDER BY c.country_name;
