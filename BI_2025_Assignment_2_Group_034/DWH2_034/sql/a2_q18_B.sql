SELECT 
    c.city_name,
    SUM(CASE WHEN t.quarter_num = 1 THEN f.reading_events_count END) AS q1,
    SUM(CASE WHEN t.quarter_num = 2 THEN f.reading_events_count END) AS q2,
    SUM(CASE WHEN t.quarter_num = 3 THEN f.reading_events_count END) AS q3,
    SUM(CASE WHEN t.quarter_num = 4 THEN f.reading_events_count END) AS q4
FROM dwh2_034.ft_param_city_month f
JOIN dwh2_034.dim_city c ON f.city_key = c.city_key
JOIN dwh2_034.dim_timemonth t ON f.month_key = t.month_key
WHERE t.year_num = 2023
  AND c.city_name IN ('Vienna','Berlin','Moscow','London')
GROUP BY c.city_name
ORDER BY c.city_name;
