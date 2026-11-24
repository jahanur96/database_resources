-- Job 3, request A5: the reporting team says this November 2025 report is slow.
-- Target DBMS: PostgreSQL
-- Do not change what the query returns. Improve how it runs.
SELECT DISTINCT *
FROM   order_history
WHERE  TO_CHAR(ordered_at, 'YYYY-MM') = '2025-11'
ORDER  BY ordered_at, history_id;
