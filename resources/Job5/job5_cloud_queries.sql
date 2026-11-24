-- =====================================================================
-- File        : job5_cloud_queries.sql
-- Job         : Job 5 - Shift the order database to a managed cloud service
-- RDBMS       : MySQL 8.0 on a managed service (example: Amazon RDS for MySQL)
-- Run as      : the admin user of the cloud instance, over TLS
-- Order       : 1 connect securely  2 create database  3 run cloud seed
--               4 row counts  5 order 3001  6 DELIVERED value per branch
-- Change record:
--   v1.0  <date>  Cloud build, order 3001, branch report
-- =====================================================================


-- =====================================================================
-- STEP 1 - CONNECT SECURELY (command line, not SQL)
-- =====================================================================
-- WHAT: Connect to the cloud endpoint with TLS REQUIRED and the provider's CA certificate,
--       and keep a session log.
-- WHY : Spec security "TLS for connections". VERIFY_IDENTITY = encrypted AND checks the
--       server's certificate + host name (stops fake servers). --tee = job5_session.log.
--   AWS RDS (download CA bundle "global-bundle.pem" from the AWS RDS docs page):
--   mysql -h deshimart-db.xxxxxxxx.ap-south-1.rds.amazonaws.com -P 3306 -u admin -p `
--     --ssl-mode=VERIFY_IDENTITY --ssl-ca="D:\DBMS_Assessment\<CandidateID>\Job5\global-bundle.pem" `
--     --tee="D:\DBMS_Assessment\<CandidateID>\Job5\job5_session.log"
--   Azure Flexible Server: same command, host <name>.mysql.database.azure.com, its CA file.
--   Workbench: Connection > SSL tab > Use SSL = "Require and Verify Identity", SSL CA File = the .pem.

-- WHAT: Prove the session is encrypted.
-- WHY : Evidence for "how the connection is secured". A cipher name (e.g. TLS_AES_256_GCM_SHA384)
--       means TLS is ON. An EMPTY value means NOT encrypted - reconnect with --ssl-mode.
SHOW SESSION STATUS LIKE 'Ssl_version';
SHOW SESSION STATUS LIKE 'Ssl_cipher';

-- WHAT: Show the cloud server version, host and time zone.
-- WHY : Evidence for the cloud record. Managed MySQL usually runs in UTC (Dhaka = UTC+6).
SELECT VERSION() AS version, @@hostname AS cloud_host, @@port AS port,
       @@system_time_zone AS server_tz, NOW() AS server_time,
       UTC_TIMESTAMP() + INTERVAL 6 HOUR AS dhaka_time;


-- =====================================================================
-- STEP 2 - DATABASE + CLOUD SEED
-- =====================================================================

-- WHAT: Create the deshimart database on the cloud server.
-- WHY : Same name as on-premises (Job 1 spec for MySQL = "Database deshimart").
CREATE DATABASE IF NOT EXISTS deshimart CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- WHAT: Use it.
-- WHY : The cloud seed file has no USE line.
USE deshimart;

-- WHAT: Load the cloud seed.
-- WHY : Job step 1 - "Run the cloud seed J:\Job5\deshimart_cloud_seed_mysql.sql".
--   CLI      : mysql> source J:/Job5/deshimart_cloud_seed_mysql.sql
--   Workbench: File > Open SQL Script > deshimart_cloud_seed_mysql.sql > Execute

-- WHAT: Turn autocommit back ON after the seed.
-- WHY : The seed sets autocommit = 0; we control our own transaction below.
SET autocommit = 1;


-- =====================================================================
-- STEP 3 - ROW COUNTS (must match Job 1, without order_history)
-- =====================================================================

-- WHAT: Count every table and compare with the Job 1 numbers.
-- WHY : Job step 1 - "check the row counts". Every row must say OK.
SELECT t.table_name, t.row_count, t.expected,
       IF(t.row_count = t.expected, 'OK', 'MISMATCH') AS check_result
FROM (
  SELECT 'branches'    AS table_name, (SELECT COUNT(*) FROM branches)    AS row_count, 4   AS expected UNION ALL
  SELECT 'categories',                (SELECT COUNT(*) FROM categories),              10             UNION ALL
  SELECT 'products',                  (SELECT COUNT(*) FROM products),                24             UNION ALL
  SELECT 'stock',                     (SELECT COUNT(*) FROM stock),                   96             UNION ALL
  SELECT 'customers',                 (SELECT COUNT(*) FROM customers),               30             UNION ALL
  SELECT 'staff',                     (SELECT COUNT(*) FROM staff),                   10             UNION ALL
  SELECT 'orders',                    (SELECT COUNT(*) FROM orders),                  90             UNION ALL
  SELECT 'order_items',               (SELECT COUNT(*) FROM order_items),             232            UNION ALL
  SELECT 'payments',                  (SELECT COUNT(*) FROM payments),                61
) AS t;


-- =====================================================================
-- STEP 4 - RECORD ONLINE ORDER 3001
-- 3001, customer 21, Gulshan (4), staff 8, today, ONLINE, PENDING, fee 60,
-- 2 x product 13 + 1 x product 24 at the current prices
-- =====================================================================

-- WHAT: Start one transaction for the order.
-- WHY : Header and both items are saved together or not at all.
START TRANSACTION;

-- WHAT: Insert the order header with TODAY'S DATE IN DHAKA.
-- WHY : Spec "today". The cloud server clock is UTC, so CURDATE() can show yesterday before
--       06:00 Dhaka time. UTC + 6 hours = Dhaka date, always right.
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee)
VALUES (3001, 21, 4, 8, DATE(UTC_TIMESTAMP() + INTERVAL 6 HOUR), 'ONLINE', 'PENDING', 60);

-- WHAT: Insert the two items, taking the price from products.
-- WHY : Spec - "at the current prices" (product 13 = 210.00, product 24 = 220.00 on the seed).
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price)
SELECT 3001, 1, product_id, 2, unit_price FROM products WHERE product_id = 13
UNION ALL
SELECT 3001, 2, product_id, 1, unit_price FROM products WHERE product_id = 24;

-- WHAT: Check the order before saving: 2 lines, total 640.00 + fee 60.
-- WHY : Read the result before COMMIT.
SELECT o.order_id, o.order_date, o.status, o.delivery_fee,
       COUNT(oi.line_no)              AS item_lines,
       SUM(oi.qty * oi.unit_price)    AS items_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_id = 3001
GROUP BY o.order_id, o.order_date, o.status, o.delivery_fee;

-- WHAT: Save the order.
-- WHY : All statements worked.
COMMIT;


-- =====================================================================
-- STEP 5 - DELIVERED ITEM VALUE PER BRANCH
-- =====================================================================

-- WHAT: Total value (qty x unit price) of DELIVERED orders for each branch.
-- WHY : Job step 2 - "show the DELIVERED item value per branch".
--       Order 3001 is PENDING, so it is (correctly) NOT in this total.
-- Rows: 4  (Dhanmondi 27838.00, Uttara 26902.00, Mirpur 22814.00, Gulshan 16538.00 on the cloud seed)
SELECT b.branch_name,
       COUNT(DISTINCT o.order_id)  AS delivered_orders,
       SUM(oi.qty * oi.unit_price) AS delivered_item_value
FROM orders o
JOIN branches    b  ON b.branch_id = o.branch_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
GROUP BY b.branch_name
ORDER BY delivered_item_value DESC;

-- =====================================================================
-- END OF JOB 5.  Delete/stop the cloud instance ONLY when the assessor says so.
-- =====================================================================

-- =====================================================================
-- ASSESSOR SABOTAGE QUICK-FIX TABLE - JOB 5
-- What they break            | How to spot it                                   | Exact fix
-- ---------------------------+--------------------------------------------------+------------------------------------------------
-- 1 Network opened to the    | Console > Security group > Inbound rules shows   | Edit inbound rule: MySQL/Aurora 3306, Source = <lab IP>/32;
--   world (0.0.0.0/0)        |   0.0.0.0/0 (Azure/GCP: 0.0.0.0-255.255.255.255) |   delete the 0.0.0.0/0 rule
-- 2 TLS not used / not       | SHOW SESSION STATUS LIKE 'Ssl_cipher'; -> empty  | Reconnect: mysql ... --ssl-mode=VERIFY_IDENTITY --ssl-ca=global-bundle.pem
--   required                 |   require_secure_transport = OFF                 | Parameter group: require_secure_transport = 1 (apply immediately)
-- 3 Instance stopped /       | Connect times out or "Access denied";            | RDS > Databases > Actions > Start  (wait for "Available")
--   admin password changed   |   console status = Stopped                       | or Modify > New master password > Apply immediately
-- (Extra: backup window changed into service hours -> Modify > Backup window 20:00 UTC (02:00 Dhaka).)
-- =====================================================================
