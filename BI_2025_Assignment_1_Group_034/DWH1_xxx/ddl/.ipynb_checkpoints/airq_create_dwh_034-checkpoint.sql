-- ======================================================
-- Make A1 dwh_xxx schema the default for this session
-- ======================================================
SET search_path TO dwh_034;

-- ======================================================
-- 1) DROP TABLES (fact tables first, then dimensions)
-- ======================================================
-- FACT tables first
DROP TABLE IF EXISTS ft_readingevent;
DROP TABLE IF EXISTS ft_project_activity;
DROP TABLE IF EXISTS ft_serviceevent;

-- DIM tables
DROP TABLE IF EXISTS dim_city;
DROP TABLE IF EXISTS dim_parameter;
DROP TABLE IF EXISTS dim_timeday;
DROP TABLE IF EXISTS dim_servicetype;
DROP TABLE IF EXISTS dim_technician_role_scd2;
DROP TABLE IF EXISTS dim_employee;
DROP TABLE IF EXISTS dim_sensordevice;
DROP TABLE IF EXISTS dim_device;
DROP TABLE IF EXISTS dim_project;
DROP TABLE IF EXISTS dim_employee;
DROP TABLE IF EXISTS dim_serviceType;
-- ======================================================
-- 2) CREATE DIMENSIONS
-- ======================================================

-- Time dimension (shared)
CREATE TABLE dim_timeday (
    id INT NOT NULL PRIMARY KEY,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dim_project (
    sk_project BIGSERIAL PRIMARY KEY,
    tb_project_id INT NOT NULL,
    project_name VARCHAR(100) NOT NULL,
    budget NUMERIC(12,2),
    goal TEXT,
    sponsor TEXT,
    start_date DATE,
    end_date DATE,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dim_project_bk UNIQUE (tb_project_id)
);

CREATE TABLE dim_employee(
    sk_employee BIGSERIAL PRIMARY KEY,
    tb_employee_id INT NOT NULL,
    roleid INT,
    badgenumber VARCHAR(255) NOT NULL,
    validfrom DATE,
    validto DATE,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dim_employee_bl UNIQUE (tb_employee_id)
);

CREATE TABLE dim_servicetype (
    sk_servicetype BIGSERIAL PRIMARY KEY,
    tb_servicetype_id INT NOT NULL,
    typename VARCHAR(200) NOT NULL,
    category VARCHAR(100) NULL,
    minlevel INT NULL CHECK (minlevel IN (1,2,3,4)),
    servicegroup VARCHAR(255) NULL,
    details VARCHAR(255) NULL,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dim_servicetype_bk UNIQUE (tb_servicetype_id)
);

-- City dimension
CREATE TABLE dim_city (
    city_key SERIAL PRIMARY KEY,
    city_id INT NOT NULL,
    city_name VARCHAR(255),
    country_name VARCHAR(255),
    population INT,
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dim_city_bk UNIQUE (city_id)
);

-- Device dimension
CREATE TABLE dim_sensordevice (
  sk_sensordevice BIGSERIAL PRIMARY KEY,
  sensor_device_id INT NOT NULL,
  city_name VARCHAR(200),
  location_name VARCHAR(200),
  location_type VARCHAR(100),
  altitude NUMERIC(8,2),
  install_date DATE,
  etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_dim_sensordevice_bk UNIQUE (sensor_device_id)
);

-- Parameter dimension
CREATE TABLE dim_parameter (
    parameter_key SERIAL PRIMARY KEY,
    tb_param_id INT NOT NULL,
    paramname VARCHAR(255) NOT NULL,
    category VARCHAR(255),
    unit VARCHAR(50),
    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_dim_parameter_bk UNIQUE (tb_param_id)
);


-- ======================================================
-- 3) CREATE FACT TABLE (Student A)
-- ======================================================
CREATE TABLE ft_readingevent (
    readingevent_key SERIAL PRIMARY KEY,
    city_key INT NOT NULL REFERENCES dim_city(city_key),
    sk_sensordevice BIGINT NOT NULL REFERENCES dim_sensordevice(sk_sensordevice),
    parameter_key INT NOT NULL REFERENCES dim_parameter(parameter_key),
    sk_project INT NOT NULL REFERENCES dim_project(sk_project),
    time_key INT NOT NULL REFERENCES dim_timeday(id),

    reading_value NUMERIC(10,3),
    data_volume NUMERIC(10,3),
    data_quality_score INT CHECK (data_quality_score BETWEEN 1 AND 5),

    etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ======================================================
-- 4) INDEXES (optional but recommended)
-- ======================================================
CREATE INDEX ix_ft_reading_city ON ft_readingevent(city_key);
CREATE INDEX ix_ft_reading_sensordevice ON ft_readingevent(sk_sensordevice);
CREATE INDEX ix_ft_reading_param ON ft_readingevent(parameter_key);
CREATE INDEX ix_ft_reading_project ON ft_readingevent(sk_project);
CREATE INDEX ix_ft_reading_time ON ft_readingevent(time_key);


-- FACT 2: linked to TimeDay + Parameter + Technician Role (SCD2)
CREATE TABLE ft_serviceevent (
    id INT NOT NULL PRIMARY KEY                  -- keep a simple surrogate PK for the fact
    , day_id INT NOT NULL                        -- -> dim_timeday.id
    , sk_servicetype BIGINT NOT NULL               -- -> dim_servicetype.sk_servicetype
    , sk_employee BIGINT NOT NULL         -- -> dim_employee.sk_employee
    , sk_project BIGINT NOT NULL -- -> dim_project.sk_project
    , servicecost NUMERIC(10,2) NOT NULL -- measure: cost of service
    , durationminutes INT NOT NULL -- measure: duration of service
    , servicequality INT CHECK (servicequality BETWEEN 1 AND 5) -- measure: service quality
    , etl_load_timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    
    , CONSTRAINT fk_ftserviceevent_day FOREIGN KEY (day_id) REFERENCES dim_timeday(id)
    , CONSTRAINT fk_ftserviceevent_servicetype FOREIGN KEY (sk_servicetype) REFERENCES dim_servicetype(sk_servicetype)
    , CONSTRAINT fk_ftserviceevent_employee FOREIGN KEY (sk_employee) REFERENCES dim_employee(sk_employee)
    , CONSTRAINT fk_ftserviceevent_project FOREIGN KEY (sk_project) REFERENCES dim_project(sk_project)
);

-- helpful indexes for join performance (optional but recommended)
CREATE INDEX ix_ft_serviceevent_day          ON ft_serviceevent(day_id);
CREATE INDEX ix_ft_serviceevent_servicetype  ON ft_serviceevent(sk_servicetype);
CREATE INDEX ix_ft_serviceevent_employee     ON ft_serviceevent(sk_employee);
CREATE INDEX ix_ft_serviceevent_project      ON ft_serviceevent(sk_project);

