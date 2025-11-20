-- =======================================
-- Load Service Type Dimension
-- =======================================
SET search_path TO dwh_034, stg_034;

TRUNCATE TABLE dim_servicetype RESTART IDENTITY CASCADE;

INSERT INTO dim_servicetype (
    tb_servicetype_id,
    typename,
    category,
    minlevel,
    servicegroup,
    details
)
SELECT DISTINCT
    st.id AS tb_servicetype_id,
    st.typename,
    st.category,
    st.minlevel,
    st.servicegroup,
    st.details
FROM stg_034.tb_servicetype st
ORDER BY st.id;
