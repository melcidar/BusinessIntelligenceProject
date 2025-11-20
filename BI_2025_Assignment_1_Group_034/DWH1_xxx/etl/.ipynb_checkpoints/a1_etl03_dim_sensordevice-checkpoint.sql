-- ===============================================
-- ETL 03: Load dim_sensordevice
-- ===============================================

SET search_path TO dwh_034, stg_034;
TRUNCATE TABLE dwh_034.dim_sensordevice RESTART IDENTITY CASCADE;
INSERT INTO dwh_034.dim_sensordevice (
    sensor_device_id,
    city_name,
    location_name,
    location_type,
    altitude,
    install_date,
    etl_load_timestamp
)
SELECT DISTINCT
    sd.id AS sensor_device_id,
    c.cityname AS city_name,
    sd.locationname AS location_name,
    sd.locationtype AS location_type,
    sd.altitude,
    sd.installedat AS install_date,
    CURRENT_TIMESTAMP
FROM stg_034.tb_sensordevice sd
LEFT JOIN stg_034.tb_city c ON c.id = sd.cityid;
