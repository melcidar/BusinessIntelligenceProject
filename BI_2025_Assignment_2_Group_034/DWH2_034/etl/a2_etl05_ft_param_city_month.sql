SET search_path TO dwh2_034, stg2_034;

TRUNCATE TABLE ft_param_city_month RESTART IDENTITY CASCADE;

WITH base AS (
    SELECT
        (EXTRACT(YEAR FROM re.readat)::INT * 100 +
         EXTRACT(MONTH FROM re.readat)::INT) AS month_key,

        c.cityname,
        co.countryname,

        re.paramid,
        pa.paramname,

        ap.id AS alertpeak_key,
        re.recordedvalue,
        re.datavolumekb,
        re.dataquality,
        re.readat::date AS d,
        sd.id AS device_id
    FROM tb_readingevent re
    JOIN tb_sensordevice sd ON re.sensordevid = sd.id
    JOIN tb_city c          ON sd.cityid = c.id
    JOIN tb_country co      ON co.id = c.countryid
    JOIN tb_param pa        ON re.paramid = pa.id
    LEFT JOIN tb_paramalert pal ON pal.paramid = pa.id
    LEFT JOIN tb_alert ap       ON pal.alertid = ap.id
    WHERE re.readat BETWEEN '2023-01-01' AND '2024-12-31'
),

agg AS (
    SELECT
        month_key,
        cityname,
        countryname,
        paramid,
        paramname,
        MAX(COALESCE(alertpeak_key, 1000)) AS alertpeak_key,
        COUNT(*) AS reading_events_count,
        COUNT(DISTINCT device_id) AS devices_reporting_count,
        SUM(datavolumekb) AS data_volume_kb_sum,
        AVG(recordedvalue) AS recordedvalue_avg,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY recordedvalue) AS recordedvalue_p95,
        AVG(dataquality) AS data_quality_avg,
        SUM(CASE WHEN recordedvalue > 0 THEN 1 ELSE 0 END) AS exceed_days_any,
        (31 - COUNT(DISTINCT d)) AS missing_days
    FROM base
    GROUP BY month_key, cityname, countryname, paramid, paramname
),

joined AS (
    SELECT
        a.month_key,
        ci.city_key,
        p.param_key,
        a.alertpeak_key,
        a.reading_events_count,
        a.devices_reporting_count,
        a.data_volume_kb_sum,
        a.recordedvalue_avg,
        a.recordedvalue_p95,
        a.exceed_days_any,
        a.data_quality_avg,
        a.missing_days
    FROM agg a
    JOIN dim_city  ci ON ci.city_name = a.cityname AND ci.country_name = a.countryname
    JOIN dim_param p  ON p.param_name = a.paramname
)

INSERT INTO ft_param_city_month (
    ft_pcm_key,
    month_key, city_key, param_key, alertpeak_key,
    reading_events_count, devices_reporting_count, data_volume_kb_sum,
    recordedvalue_avg, recordedvalue_p95, exceed_days_any,
    data_quality_avg, missing_days
)
SELECT
    ROW_NUMBER() OVER (),
    month_key, city_key, param_key, alertpeak_key,
    reading_events_count, devices_reporting_count, data_volume_kb_sum,
    recordedvalue_avg, recordedvalue_p95, exceed_days_any,
    data_quality_avg, missing_days
FROM joined;
