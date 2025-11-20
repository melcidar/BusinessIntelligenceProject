-- ===============================================
-- ETL 02: Load dim_city (idempotent load)
-- ===============================================

SET search_path TO dwh_034, stg_034;
TRUNCATE TABLE dwh_034.dim_city RESTART IDENTITY CASCADE;
INSERT INTO dwh_034.dim_city (city_id, city_name, country_name, population, etl_load_timestamp)
SELECT DISTINCT
    c.id AS city_id,
    c.cityname AS city_name,
    co.countryname AS country_name,
    c.population,
    CURRENT_TIMESTAMP
FROM stg_034.tb_city c
LEFT JOIN stg_034.tb_country co ON co.id = c.countryid
ON CONFLICT (city_id) DO NOTHING;
