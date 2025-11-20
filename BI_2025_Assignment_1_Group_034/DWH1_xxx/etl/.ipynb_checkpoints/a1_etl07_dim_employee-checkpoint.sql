-- =======================================
-- Load Employee Dimension
-- =======================================
SET search_path TO dwh_034, stg_034;

TRUNCATE TABLE dim_employee RESTART IDENTITY CASCADE;

INSERT INTO dim_employee (
    tb_employee_id,
    roleid,
    badgenumber,
    validfrom,
    validto
)
SELECT DISTINCT
    e.id AS tb_employee_id,
    e.roleid,
    e.badgenumber,
    e.validfrom,
    e.validto
FROM stg_034.tb_employee e
JOIN stg_034.tb_role r
  ON e.roleid = r.id
ORDER BY e.id;
