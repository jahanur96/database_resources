-- 1. Tell MySQL to output logs to a file (or use 'TABLE' to log to mysql.general_log)
SET GLOBAL log_output = 'FILE';

-- 2. Set your desired log file path (ensure MySQL has write permissions to this folder)
SET GLOBAL general_log_file = 'D:/Database/job01/script.log';

-- 3. Turn on logging
SET GLOBAL general_log = 'ON';

-- =====================================================================
-- STEP 2 - VERSION AND CONNECTION CHECK  (SQL - screenshot = job1_version.png)
-- =====================================================================

SELECT VERSION()          AS mysql_version,
       @@version_comment  AS edition,
       @@hostname         AS server_host,
       @@port             AS port,
       @@datadir          AS data_folder,
       @@bind_address     AS bind_address,
       CURRENT_USER()     AS logged_in_as;
       
-- =====================================================================
-- STEP 3 - CREATE THE DATABASE AND THE OWNER  (run as root)
-- =====================================================================

CREATE DATABASE if not exists dashimart 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

use dashimart;

SET autocommit = 1;



SELECT 'branches' AS table_name, COUNT(*) AS row_count FROM branches
UNION ALL
SELECT 'categories' AS table_name, COUNT(*) AS row_count FROM categories
UNION ALL
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM products
UNION ALL
SELECT 'stock' AS table_name, COUNT(*) AS row_count FROM stock
UNION ALL
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL
SELECT 'staff' AS table_name, COUNT(*) AS row_count FROM staff
UNION ALL
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders
UNION ALL
SELECT 'order_items' AS table_name, COUNT(*) AS row_count FROM order_items
UNION ALL
SELECT 'payments' AS table_name, COUNT(*) AS row_count FROM payments
UNION ALL
SELECT 'order_history' AS table_name, COUNT(*) AS row_count FROM order_history;

