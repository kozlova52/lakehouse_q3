-- Выполните два CTAS-запроса с одинаковыми данными и разными кодеками.
-- Если тестируете lineitem, учтите, что это крупная таблица.
-- Сначала убедитесь, что имена каталога и схемы верны.

CREATE TABLE lakehouse.default.bench_lineitem_gzip
WITH (
    format = 'PARQUET',
    compression_codec = 'GZIP'
) AS
SELECT orderkey, extendedprice, discount, shipdate
FROM lakehouse.default.bronze_lineitem;

CREATE TABLE lakehouse.default.bench_lineitem_zstd
WITH (
    format = 'PARQUET',
    compression_codec = 'ZSTD'
) AS
SELECT orderkey, extendedprice, discount, shipdate
FROM lakehouse.default.bronze_lineitem;

-- Запустите одинаковый аналитический запрос к обеим таблицам и сравните длительность.
SELECT shipdate, sum(extendedprice * (1 - discount)) AS revenue
FROM lakehouse.default.bench_lineitem_gzip
GROUP BY shipdate
ORDER BY shipdate;

SELECT shipdate, sum(extendedprice * (1 - discount)) AS revenue
FROM lakehouse.default.bench_lineitem_zstd
GROUP BY shipdate
ORDER BY shipdate;
