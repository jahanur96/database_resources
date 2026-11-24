USE deshimart;

SET autocommit = 1;

SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'deshimart' AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

-- WHAT: Show the indexes on order_history.
SHOW INDEX FROM order_history;

-- WHAT: Show my privileges.
SHOW GRANTS;

-- =====================================================================
-- PART 1 - BASIC SQL
-- =====================================================================

