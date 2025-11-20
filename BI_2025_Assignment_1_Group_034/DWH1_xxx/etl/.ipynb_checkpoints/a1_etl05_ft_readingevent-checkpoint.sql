-- ===============================================
-- ETL 05: Load ft_readingevent (Student A)
-- ===============================================
SET search_path TO dwh_034, stg_034;

TRUNCATE TABLE ft_readingevent RESTART IDENTITY CASCADE;

INSERT INTO ft_readingevent (
    city_key,
    sk_sensordevice,
    parameter_key,
    sk_project,
    time_key,
    reading_value,
    data_volume,
    data_quality_score,
    etl_load_timestamp
)
SELECT
    dc.city_key,
    ds.sk_sensordevice,
    dp.parameter_key,
    dpj.sk_project,
    dt.id AS time_key,
    r.recordedvalue AS reading_value,
    r.datavolumekb AS data_volume,
    r.dataquality AS data_quality_score,
    CURRENT_TIMESTAMP
FROM stg_034.tb_readingevent r
JOIN stg_034.tb_sensordevice sd ON sd.id = r.sensordevid
JOIN dwh_034.dim_sensordevice ds ON ds.sensor_device_id = sd.id
JOIN dwh_034.dim_city dc ON dc.city_name = (
    SELECT c.cityname FROM stg_034.tb_city c WHERE c.id = sd.cityid
)
JOIN dwh_034.dim_parameter dp ON dp.tb_param_id = r.paramid

JOIN stg_034.tb_serviceevent se ON se.sensordevid = sd.id
JOIN dwh_034.dim_employee de ON de.tb_employee_id = se.employeeid
JOIN stg_034.tb_projectemployee pe ON pe.employee_id = se.employeeid
JOIN dwh_034.dim_project dpj ON dpj.tb_project_id = pe.project_id

JOIN dwh_034.dim_timeday dt ON EXTRACT(DOY FROM r.readat) = dt.id;
