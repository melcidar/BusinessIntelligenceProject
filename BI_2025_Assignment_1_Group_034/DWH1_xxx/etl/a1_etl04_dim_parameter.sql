-- ===============================================
-- ETL 04: Load dim_parameter
-- ===============================================

SET search_path TO dwh_034, stg_034;
TRUNCATE TABLE dwh_034.dim_parameter RESTART IDENTITY CASCADE;
INSERT INTO dwh_034.dim_parameter (
    tb_param_id,
    paramname,
    category,
    unit,
    etl_load_timestamp
)
SELECT DISTINCT
    p.id AS tb_param_id,
    p.paramname,
    p.category,
    p.unit,
    CURRENT_TIMESTAMP
FROM stg_034.tb_param p;
