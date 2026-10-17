-- Фиксируем базовую корректность результата и количество строк витрины.
SELECT count(*) AS gold_rows
FROM lakehouse.default.gold_shipping_priority;

SELECT *
FROM lakehouse.default.gold_shipping_priority
ORDER BY revenue DESC
LIMIT 10;

-- Сравнение компрессии:
-- Выполняйте по очереди на одинаковой таблице/объёме, меняя compression_codec
-- на GZIP и ZSTD. Время CTAS фиксируйте в отчёте, размер файлов — в S3-консоли.
-- Не сравнивайте разные объёмы данных или разные запросы.
