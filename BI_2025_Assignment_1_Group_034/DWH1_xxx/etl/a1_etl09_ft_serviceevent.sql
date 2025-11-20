-- =======================================
-- Load Service Event Fact (Student B)
-- =======================================
SET search_path TO dwh_034, stg_034;

TRUNCATE TABLE ft_serviceevent RESTART IDENTITY CASCADE;

INSERT INTO ft_serviceevent (
    day_id,
    sk_servicetype,
    sk_employee,
    sk_project,
    servicecost,
    durationminutes,
    servicequality
)
SELECT
    td.id AS day_id,
    ds.sk_servicetype,
    de.sk_employee,
    dp.sk_project,
    se.servicecost,
    se.durationminutes,
    se.servicequality
FROM stg_034.tb_serviceevent se
JOIN dwh_034.dim_servicetype ds
  ON ds.tb_servicetype_id = se.servicetypeid
JOIN dwh_034.dim_employee de
  ON de.tb_employee_id = se.employeeid
JOIN stg_034.tb_projectemployee pe
  ON pe.employee_id = se.employeeid

JOIN dwh_034.dim_project dp
  ON dp.tb_project_id = pe.project_id
JOIN dwh_034.dim_timeday td
  ON td.id = EXTRACT(DOY FROM se.servicedat)::INT;  


