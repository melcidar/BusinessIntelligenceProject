-- =======================================
-- Load dim_timeday
-- =======================================

SET search_path TO dwh_034, stg_034;
TRUNCATE TABLE dwh_034.dim_timeday RESTART IDENTITY CASCADE;
INSERT INTO dwh_034.dim_timeday (id, etl_load_timestamp)
SELECT DISTINCT
    EXTRACT(DOY FROM readat)::INT AS id,
    CURRENT_TIMESTAMP
FROM stg_034.tb_readingevent
WHERE readat IS NOT NULL
ON CONFLICT (id) DO NOTHING;
