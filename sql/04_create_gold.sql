-- Gold: итоговая агрегированная витрина для варианта Q3 — Shipping Priority.
-- Примечание: TPC-H connector использует имена колонок без префикса l_/o_/c_.

CREATE TABLE lakehouse.default.gold_shipping_priority
WITH (
    format = 'PARQUET',
    compression_codec = 'ZSTD'
) AS
SELECT
    l.orderkey,
    sum(l.extendedprice * (1 - l.discount)) AS revenue,
    o.orderdate,
    o.shippriority
FROM lakehouse.default.silver_customer c
JOIN lakehouse.default.silver_orders o ON c.custkey = o.custkey
JOIN lakehouse.default.silver_lineitem l ON l.orderkey = o.orderkey
WHERE c.mktsegment = 'BUILDING'
  AND o.orderdate < DATE '1995-03-15'
  AND l.shipdate > DATE '1995-03-15'
GROUP BY l.orderkey, o.orderdate, o.shippriority;

SELECT *
FROM lakehouse.default.gold_shipping_priority
ORDER BY revenue DESC
LIMIT 10;
