-- 1. Проверьте доступные каталоги и схемы.
SHOW CATALOGS;
SHOW SCHEMAS FROM tpch;

-- 2. Убедитесь, что TPC-H connector доступен.
SHOW TABLES FROM tpch.sf1;

-- 3. Оцените число строк исходных таблиц.
SELECT 'customer' AS table_name, count(*) AS row_count FROM tpch.sf1.customer
UNION ALL
SELECT 'orders', count(*) FROM tpch.sf1.orders
UNION ALL
SELECT 'lineitem', count(*) FROM tpch.sf1.lineitem;

-- Ожидаемые ориентиры для стандартного TPC-H SF1:
-- customer: 150000; orders: 1500000; lineitem: около 6000000.
-- Это ориентиры, не подставляйте их вместо фактического результата.
