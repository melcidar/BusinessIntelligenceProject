WITH east_europe AS (
    SELECT 'Poland' AS country UNION ALL
    SELECT 'Czechia' UNION ALL
    SELECT 'Slovakia' UNION ALL
    SELECT 'Hungary' UNION ALL
    SELECT 'Romania' UNION ALL
    SELECT 'Bulgaria' UNION ALL
    SELECT 'Ukraine' UNION ALL
    SELECT 'Belarus' UNION ALL
    SELECT 'Moldova' UNION ALL
    SELECT 'Russia' UNION ALL
    SELECT 'Serbia' UNION ALL
    SELECT 'Bosnia and Herzegovina' UNION ALL
    SELECT 'Croatia' UNION ALL
    SELECT 'Slovenia' UNION ALL
    SELECT 'Montenegro' UNION ALL
    SELECT 'North Macedonia' UNION ALL
    SELECT 'Albania' UNION ALL
    SELECT 'Kosovo'
)
SELECT 
    c.country_name,
    SUM(CASE WHEN t.year_num = 2023 THEN f.exceed_days_any END) AS exceed_2023,
    SUM(CASE WHEN t.year_num = 2024 THEN f.exceed_days_any END) AS exceed_2024
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c ON f.city_key = c.city_key
JOIN east_europe e ON c.country_name = e.country
JOIN dwh2_034.dim_timemonth t ON f.month_key = t.month_key
GROUP BY c.country_name
ORDER BY c.country_name;
