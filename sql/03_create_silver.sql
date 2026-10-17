-- Silver: типизированные/подготовленные данные для анализа.
-- Здесь сохраняются только необходимые для Q3 поля и приводятся типы/значения.

CREATE TABLE lakehouse.default.silver_customer
WITH (
    format = 'PARQUET',
    compression_codec = 'ZSTD'
) AS
SELECT
    custkey,
    name,
    address,
    nationkey,
    phone,
    acctbal,
    marketsegment AS mktsegment,
    comment
FROM lakehouse.default.bronze_customer;

CREATE TABLE lakehouse.default.silver_orders
WITH (
    format = 'PARQUET',
    compression_codec = 'ZSTD'
) AS
SELECT
    orderkey,
    custkey,
    orderstatus,
    totalprice,
    orderdate,
    orderpriority,
    clerk,
    shippriority,
    comment
FROM lakehouse.default.bronze_orders;

CREATE TABLE lakehouse.default.silver_lineitem
WITH (
    format = 'PARQUET',
    compression_codec = 'ZSTD'
) AS
SELECT
    orderkey,
    partkey,
    suppkey,
    linenumber,
    quantity,
    extendedprice,
    discount,
    tax,
    returnflag,
    linestatus,
    shipdate,
    commitdate,
    receiptdate,
    shipinstruct,
    shipmode,
    comment
FROM lakehouse.default.bronze_lineitem;

SELECT 'silver_customer' AS table_name, count(*) AS row_count FROM lakehouse.default.silver_customer
UNION ALL
SELECT 'silver_orders', count(*) FROM lakehouse.default.silver_orders
UNION ALL
SELECT 'silver_lineitem', count(*) FROM lakehouse.default.silver_lineitem;
