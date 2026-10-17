
-- Bronze: перенос исходных таблиц без бизнес-преобразований.

CREATE SCHEMA IF NOT EXISTS lakehouse.default;

CREATE TABLE lakehouse.default.bronze_customer
WITH (
    format = 'PARQUET'
) AS
SELECT * FROM tpch.sf1.customer;

CREATE TABLE lakehouse.default.bronze_orders
WITH (
    format = 'PARQUET'
) AS
SELECT * FROM tpch.sf1.orders;

CREATE TABLE lakehouse.default.bronze_lineitem
WITH (
    format = 'PARQUET'
) AS
SELECT * FROM tpch.sf1.lineitem;

SELECT 'bronze_customer' AS table_name, count(*) AS row_count
FROM lakehouse.default.bronze_customer
UNION ALL
SELECT 'bronze_orders', count(*)
FROM lakehouse.default.bronze_orders
UNION ALL
SELECT 'bronze_lineitem', count(*)
FROM lakehouse.default.bronze_lineitem;
