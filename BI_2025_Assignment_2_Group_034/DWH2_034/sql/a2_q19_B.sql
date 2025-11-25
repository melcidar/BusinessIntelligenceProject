WITH central_europe AS (
    SELECT 'Germany' AS country UNION ALL
    SELECT 'Austria' UNION ALL
    SELECT 'Switzerland' UNION ALL
    SELECT 'Poland' UNION ALL
    SELECT 'Czechia' UNION ALL
    SELECT 'Slovakia' UNION ALL
    SELECT 'Hungary' UNION ALL
    SELECT 'Slovenia' UNION ALL
    SELECT 'Croatia'
)
SELECT 
    c.city_name,
    SUM(f.missing_days) AS missing_days_2024,
    SUM(f.data_volume_kb_sum) AS data_volume_2024
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c ON f.city_key = c.city_key
JOIN central_europe ce ON c.country_name = ce.country
JOIN dwh2_034.dim_timemonth t ON f.month_key = t.month_key
WHERE t.year_num = 2024
GROUP BY c.city_name
ORDER BY c.city_name;
