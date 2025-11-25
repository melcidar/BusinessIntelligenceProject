WITH agg AS (
    SELECT 
        c.country_name,
        t.quarter_num,
        SUM(f.reading_events_count) AS re_count
    FROM dwh2_034.ft_param_city_month f
    JOIN dwh2_034.dim_city c ON f.city_key = c.city_key
    JOIN dwh2_034.dim_timemonth t ON f.month_key = t.month_key
    WHERE t.year_num = 2024
    GROUP BY c.country_name, t.quarter_num
),
totals AS (
    SELECT country_name, SUM(re_count) AS total_year
    FROM agg
    GROUP BY country_name
    ORDER BY total_year DESC
    LIMIT 10
)
SELECT 
    a.country_name,
    SUM(CASE WHEN a.quarter_num = 1 THEN a.re_count END) AS q1,
    SUM(CASE WHEN a.quarter_num = 2 THEN a.re_count END) AS q2,
    SUM(CASE WHEN a.quarter_num = 3 THEN a.re_count END) AS q3,
    SUM(CASE WHEN a.quarter_num = 4 THEN a.re_count END) AS q4
FROM agg a
JOIN totals t USING (country_name)
GROUP BY a.country_name
ORDER BY t.total_year DESC;
