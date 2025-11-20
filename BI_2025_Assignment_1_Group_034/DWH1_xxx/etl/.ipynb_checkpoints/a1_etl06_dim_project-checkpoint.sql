-- =======================================
-- Load Project Dimension
-- =======================================
SET search_path TO dwh_034, stg_034;

TRUNCATE TABLE dim_project RESTART IDENTITY CASCADE;

INSERT INTO dim_project (
    tb_project_id,
    project_name,
    budget,
    goal,
    sponsor,
    start_date,
    end_date
)
SELECT DISTINCT
    p.id AS tb_project_id,
    p.project_name,
    p.budget,
    p.goal,
    p.sponsor,
    p.start_date,
    p.end_date
FROM stg_034.tb_project p
ORDER BY p.id;
