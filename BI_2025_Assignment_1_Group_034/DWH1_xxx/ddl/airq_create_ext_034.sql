-- please remember to give a meaningful name to both Table X (instead of tb_x) and TableY (instead of tb_y)

-- Make the A1's stg_xxx schema the default for this session
SET search_path TO stg_034;

-- -------------------------------
-- 2) DROP TABLE before attempting to create OLTP snapshot tables
-- -------------------------------
DROP TABLE IF EXISTS stg_034.tb_projectemployee CASCADE;
DROP TABLE IF EXISTS stg_034.tb_project CASCADE;
DROP TABLE IF EXISTS stg_034.tb_x CASCADE;
DROP TABLE IF EXISTS stg_034.tb_y CASCADE;
DROP TABLE IF EXISTS public.tb_x CASCADE;
DROP TABLE IF EXISTS public.tb_y CASCADE;

-- ===============================================
-- CREATE TABLE_X (tb_project)
-- ===============================================
CREATE TABLE stg_034.tb_project (
    id INT NOT NULL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL,
    budget NUMERIC(12,2),
    goal TEXT,
    sponsor TEXT,
    start_date DATE,
    end_date DATE
);

-- ===============================================
-- CREATE TABLE_Y (tb_projectemployee)
-- ===============================================
CREATE TABLE stg_034.tb_projectemployee (
    id INT NOT NULL PRIMARY key,
    project_id INT REFERENCES stg_034.tb_project(id),
    employee_id INT REFERENCES stg_034.tb_employee(id),
    hoursworked NUMERIC
);



