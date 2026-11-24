-- Job 3, request A5: the reporting team says this November 2025 report is slow.
-- Target DBMS: Microsoft SQL Server
-- Do not change what the query returns. Improve how it runs.
SELECT DISTINCT *
FROM   order_history
WHERE  CONVERT(CHAR(7), ordered_at, 120) = '2025-11'
ORDER  BY ordered_at, history_id;
