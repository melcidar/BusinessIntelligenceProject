WITH western_europe AS (
    SELECT 'Austria' AS country UNION ALL
    SELECT 'Germany' UNION ALL
    SELECT 'France' UNION ALL
    SELECT 'Belgium' UNION ALL
    SELECT 'Netherlands' UNION ALL
    SELECT 'Switzerland' UNION ALL
    SELECT 'United Kingdom' UNION ALL
    SELECT 'Ireland' UNION ALL
    SELECT 'Luxembourg'
),
study_params AS (
    SELECT param_key, param_name
    FROM dwh2_034.dim_param
    WHERE purpose = 'Scientific Study'
)
SELECT 
    c.country_name,
    p.param_name,
    ROUND(AVG(f.recordedvalue_avg), 3) AS avg_recorded_value
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c ON f.city_key = c.city_key
JOIN western_europe we ON c.country_name = we.country
JOIN study_params p ON f.param_key = p.param_key
JOIN dwh2_034.dim_timemonth t ON f.month_key = t.month_key
WHERE t.year_num = 2024
GROUP BY c.country_name, p.param_name
ORDER BY c.country_name, p.param_name;
