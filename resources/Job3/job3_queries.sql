-- =====================================================================
-- File        : job3_queries.sql
-- Job         : Job 3 - Report on and update the order data (DeshiMart)
-- RDBMS       : MySQL 8.0
-- Run as      : deshimart (owner of all tables -> has every privilege needed)
-- Row counts  : "Rows:" under each query = result on the original seed data.
--               If the assessor changed data, your numbers may differ - explain why.
-- Change record:
--   v1.0  <date>  B1-B6 and A1-A5 written and tested
-- MySQL syntax notes (where MySQL differs from other RDBMS):
--   * Row limit  : LIMIT n          (Oracle/Postgres: FETCH FIRST n ROWS ONLY, SQL Server: TOP n)
--   * Rollup     : GROUP BY ... WITH ROLLUP + GROUPING()
--   * Savepoint  : SAVEPOINT x / ROLLBACK TO SAVEPOINT x
--   * NULL check : COALESCE / IFNULL
-- =====================================================================

-- WHAT: Use the deshimart database.
-- WHY : All the tables for Job 3 live there.
USE deshimart;

-- WHAT: Make sure autocommit is ON for the reports.
-- WHY : The seed set it OFF. For B6/A4 we start our own transactions on purpose.
SET autocommit = 1;


-- =====================================================================
-- BEFORE YOU START - tables, keys, indexes, privileges
-- =====================================================================

-- WHAT: Show the foreign keys (how the tables join).
-- WHY : Job step 1 - "look at the tables, keys, relationships and indexes".
SELECT TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'deshimart' AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

-- WHAT: Show the indexes on order_history.
-- WHY : Needed for A5 (ix_order_history_date on ordered_at must exist).
SHOW INDEX FROM order_history;

-- WHAT: Show my privileges.
-- WHY : Job step 1 - "check that your login has the privileges for the requests".
SHOW GRANTS;


-- =====================================================================
-- PART 1 - BASIC SQL
-- =====================================================================

-- ---------------------------------------------------------------------
-- B1. Active products in Rice and Staples or Fresh Produce, 50-300 Taka,
--     with 5% VAT price. Highest price first, then name. First 5 rows.
-- ---------------------------------------------------------------------
-- WHAT: Join products to categories, filter, add VAT, sort, keep 5 rows.
-- WHY : B1 request. BETWEEN includes 50 and 300 (boundary). LIMIT = MySQL row limit.
-- Rows: 5  (Chinigura Rice 290.00/304.50 ... Atta 2 kg 130.00/136.50)
SELECT p.product_name,
       c.category_name,
       p.unit_price,
       ROUND(p.unit_price * 1.05, 2) AS price_with_vat
FROM products p
JOIN categories c ON c.category_id = p.category_id
WHERE c.category_name IN ('Rice and Staples', 'Fresh Produce')
  AND p.is_active = 'Y'
  AND p.unit_price BETWEEN 50 AND 300
ORDER BY p.unit_price DESC, p.product_name
LIMIT 5;

-- ---------------------------------------------------------------------
-- B2. Customers in Dhanmondi or Mirpur: NAME IN CAPITALS, phone, email
--     ("Not provided" if missing), year joined, tier. Oldest member first.
-- ---------------------------------------------------------------------
-- WHAT: Format names, replace NULL email, work out the tier with CASE.
-- WHY : B2 request. Gold < 2025, Silver = 2025, otherwise New. COALESCE handles NULL email.
-- Rows: 10  (4 Gold, 4 Silver, 2 New; 5 show "Not provided")
SELECT UPPER(full_name)                     AS customer_name,
       phone,
       COALESCE(email, 'Not provided')      AS email,
       YEAR(joined_on)                      AS year_joined,
       CASE
         WHEN joined_on <  '2025-01-01' THEN 'Gold'
         WHEN joined_on <  '2026-01-01' THEN 'Silver'
         ELSE 'New'
       END                                  AS tier
FROM customers
WHERE area IN ('Dhanmondi', 'Mirpur')
ORDER BY joined_on;

-- ---------------------------------------------------------------------
-- B3. DELIVERED orders 1 Jan - 31 Mar 2026: each branch's number of orders
--     and total item value (qty x unit price). Only branches with >= 7 orders.
--     Highest value first.
-- ---------------------------------------------------------------------
-- WHAT: Join orders + items, count DISTINCT orders (items repeat the order), sum value.
-- WHY : B3 request. COUNT(DISTINCT) because the join gives one row per ITEM, not per order.
--       HAVING filters groups (>= 7 keeps Dhanmondi with exactly 7 = boundary case).
-- Rows: 3  (Uttara 11 / 16710.00, Dhanmondi 7 / 15537.00, Mirpur 9 / 10903.00; Gulshan has 5 -> removed)
SELECT b.branch_name,
       COUNT(DISTINCT o.order_id)       AS number_of_orders,
       SUM(oi.qty * oi.unit_price)      AS total_item_value
FROM orders o
JOIN branches    b  ON b.branch_id = o.branch_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
  AND o.order_date BETWEEN '2026-01-01' AND '2026-03-31'
GROUP BY b.branch_name
HAVING COUNT(DISTINCT o.order_id) >= 7
ORDER BY total_item_value DESC;

-- WHAT: PROOF 1 - count delivered Q1 orders per branch WITHOUT the item join.
-- WHY : Shows the order counts (11, 7, 9, 5) are right and not inflated by the join.
-- Rows: 4
SELECT b.branch_name, COUNT(*) AS orders_check
FROM orders o
JOIN branches b ON b.branch_id = o.branch_id
WHERE o.status = 'DELIVERED'
  AND o.order_date BETWEEN '2026-01-01' AND '2026-03-31'
GROUP BY b.branch_name;

-- WHAT: PROOF 2 - add up the detail rows of the 3 branches in one total.
-- WHY : Must equal 16710 + 15537 + 10903 = 43150.00 -> report total is right.
-- Rows: 1  (43150.00)
SELECT SUM(oi.qty * oi.unit_price) AS detail_total
FROM orders o
JOIN branches    b  ON b.branch_id = o.branch_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
  AND o.order_date BETWEEN '2026-01-01' AND '2026-03-31'
  AND b.branch_name IN ('Uttara', 'Dhanmondi', 'Mirpur');

-- WHAT: PROOF 3 - list the detail rows for one branch (Dhanmondi) to check by hand.
-- WHY : The line values here add up to 15537.00.
SELECT o.order_id, o.order_date, oi.line_no, oi.qty, oi.unit_price, oi.qty * oi.unit_price AS line_value
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status = 'DELIVERED'
  AND o.order_date BETWEEN '2026-01-01' AND '2026-03-31'
  AND o.branch_id = 1
ORDER BY o.order_id, oi.line_no;

-- ---------------------------------------------------------------------
-- B4. All orders in March 2026: order id, date, customer name ("Walk-in"
--     if no customer), branch, staff name, channel, status.
-- ---------------------------------------------------------------------
-- WHAT: LEFT JOIN customers so orders with NULL customer_id are kept; show "Walk-in".
-- WHY : B4 request. An INNER JOIN would silently drop walk-in (counter) orders - NULL case.
--       Date range uses >= 1st and < 1st of next month (safe even if the type had a time).
-- Rows: 13  (order 1013 shows "Walk-in")
SELECT o.order_id,
       o.order_date,
       COALESCE(c.full_name, 'Walk-in') AS customer_name,
       b.branch_name,
       s.staff_name,
       o.channel,
       o.status
FROM orders o
LEFT JOIN customers c ON c.customer_id = o.customer_id
JOIN branches b       ON b.branch_id   = o.branch_id
JOIN staff s          ON s.staff_id    = o.staff_id
WHERE o.order_date >= '2026-03-01'
  AND o.order_date <  '2026-04-01'
ORDER BY o.order_date, o.order_id;

-- ---------------------------------------------------------------------
-- B5 (a). Active products priced above the average price of active products.
-- ---------------------------------------------------------------------
-- WHAT: Compare each price with a subquery that finds the average ACTIVE price.
-- WHY : B5a request. The average must also use only active products.
-- Rows: 6  (Baby Diapers 1150 ... Black Tea 240)
SELECT product_id, product_name, unit_price
FROM products
WHERE is_active = 'Y'
  AND unit_price > (SELECT AVG(unit_price) FROM products WHERE is_active = 'Y')
ORDER BY unit_price DESC;

-- ---------------------------------------------------------------------
-- B5 (b). Customers who have ordered at least once from the Gulshan branch.
-- ---------------------------------------------------------------------
-- WHAT: EXISTS = "is there at least one Gulshan order for this customer?"
-- WHY : B5b request. EXISTS returns each customer once (no duplicates) and is safe with
--       NULL customer_id in orders (walk-ins).
-- Rows: 11
SELECT c.customer_id, c.full_name, c.area
FROM customers c
WHERE EXISTS (SELECT 1
              FROM orders o
              JOIN branches b ON b.branch_id = o.branch_id
              WHERE o.customer_id = c.customer_id
                AND b.branch_name = 'Gulshan')
ORDER BY c.customer_id;

-- ---------------------------------------------------------------------
-- B6. Counter orders 1091 and 1092 (today, COUNTER, DELIVERED, fee 0,
--     current prices, no payment). One transaction per order.
-- ---------------------------------------------------------------------
-- WHAT: Check the autocommit setting first.
-- WHY : Job step 3. Workbench has autocommit ON (1) by default; START TRANSACTION
--       turns it off until COMMIT/ROLLBACK, so each order is all-or-nothing.
SELECT @@autocommit AS autocommit_now;

-- ===== Order 1091: customer 12, Gulshan (4), staff 8, 2 x product 5 + 3 x product 16 =====

-- WHAT: Start the transaction for order 1091.
-- WHY : Header, items and stock must all succeed together or not at all.
START TRANSACTION;

-- WHAT: Insert the order header.
-- WHY : B6 table. CURDATE() = today; fee 0; COUNTER; DELIVERED. Expect: 1 row affected.
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee)
VALUES (1091, 12, 4, 8, CURDATE(), 'COUNTER', 'DELIVERED', 0);

-- WHAT: Insert the 2 item lines, copying the CURRENT price from products.
-- WHY : "use the current product prices" - never type the price by hand. Expect: 2 rows affected.
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price)
SELECT 1091, 1, product_id, 2, unit_price FROM products WHERE product_id = 5
UNION ALL
SELECT 1091, 2, product_id, 3, unit_price FROM products WHERE product_id = 16;

-- WHAT: Reduce stock row 77 (product 5 at Gulshan) by 2.
-- WHY : Goods left the shop. Expect: 1 row affected (9 -> 7).
UPDATE stock SET qty_on_hand = qty_on_hand - 2 WHERE stock_id = 77;

-- WHAT: Reduce stock row 88 (product 16 at Gulshan) by 3.
-- WHY : Expect: 1 row affected (40 -> 37).
UPDATE stock SET qty_on_hand = qty_on_hand - 3 WHERE stock_id = 88;

-- WHAT: Read the result before deciding.
-- WHY : Job step 3 - "read the result of every statement". 2 items, stock 7 and 37 -> all good.
SELECT (SELECT COUNT(*) FROM order_items WHERE order_id = 1091) AS items_1091,
       (SELECT qty_on_hand FROM stock WHERE stock_id = 77)      AS stock_77,
       (SELECT qty_on_hand FROM stock WHERE stock_id = 88)      AS stock_88;

-- WHAT: Every statement worked -> save it.
-- WHY : Decision for 1091 = COMMIT.
COMMIT;

-- ===== Order 1092: customer 7, Uttara (2), staff 6, 1 x product 12, stock row 36 =====

-- WHAT: Look at the stock first.
-- WHY : Stock row 36 has qty_on_hand = 0 -> we cannot sell 1 egg tray.
SELECT stock_id, product_id, branch_id, qty_on_hand FROM stock WHERE stock_id = 36;

-- WHAT: Start the transaction for order 1092.
-- WHY : So we can undo the header and item if the stock step fails.
START TRANSACTION;

-- WHAT: Insert the order header.
-- WHY : B6 table. Expect: 1 row affected.
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee)
VALUES (1092, 7, 2, 6, CURDATE(), 'COUNTER', 'DELIVERED', 0);

-- WHAT: Insert the item at the current price.
-- WHY : Expect: 1 row affected.
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price)
SELECT 1092, 1, product_id, 1, unit_price FROM products WHERE product_id = 12;

-- WHAT: Try to reduce stock 36 by 1, ONLY if there is enough stock.
-- WHY : Result = "0 row(s) affected" because stock is 0. (Without the "AND qty_on_hand >= 1"
--       you get Error 3819 "Check constraint 'ck_stock_qty' is violated" - same meaning.)
UPDATE stock SET qty_on_hand = qty_on_hand - 1 WHERE stock_id = 36 AND qty_on_hand >= 1;

-- WHAT: Stock update failed (0 rows / constraint error) -> undo the whole order.
-- WHY : Decision for 1092 = ROLLBACK. We must not save a sale with no stock.
ROLLBACK;

-- WHAT: Prove the result: 1091 saved, 1092 not saved.
-- WHY : Evidence for the assessor. Expect: one row, order 1091.
SELECT order_id, order_date, channel, status FROM orders WHERE order_id IN (1091, 1092);


-- =====================================================================
-- PART 2 - ADVANCED SQL
-- =====================================================================

-- ---------------------------------------------------------------------
-- A1. CTE: DELIVERED item value per branch per month, Jan-Jun 2026,
--     with the previous month's value and the change.
-- PLAN (written before the SQL - job step 4):
--   1. CTE "months": make the 6 months Jan-Jun 2026 (recursive CTE, 6 rows).
--   2. CROSS JOIN branches x months, so EVERY branch has EVERY month - a month with
--      no sales shows 0 (example: Gulshan has no DELIVERED sales in March 2026).
--      Without this, LAG() would wrongly compare Gulshan April with February.
--   3. LEFT JOIN DELIVERED orders + items of that month and SUM(qty * unit_price).
--   4. Main query: LAG() over each branch ordered by month = previous month's value.
--   5. change = this month - previous month. January has no previous month -> NULL (boundary).
--   6. Sort by branch, then month.
-- ---------------------------------------------------------------------
-- WHAT: Monthly value per branch with LAG for the previous month.
-- WHY : A1 request - must use a common table expression (WITH) and a window function.
-- Rows: 24  (4 branches x 6 months; Gulshan 2026-03 = 0.00)
WITH RECURSIVE months AS (
  SELECT DATE '2026-01-01' AS month_start
  UNION ALL
  SELECT month_start + INTERVAL 1 MONTH FROM months WHERE month_start < '2026-06-01'
),
monthly AS (
  SELECT b.branch_name,
         DATE_FORMAT(m.month_start, '%Y-%m')      AS order_month,
         COALESCE(SUM(oi.qty * oi.unit_price), 0) AS month_value
  FROM branches b
  CROSS JOIN months m
  LEFT JOIN orders o       ON o.branch_id = b.branch_id
                          AND o.status = 'DELIVERED'
                          AND o.order_date >= m.month_start
                          AND o.order_date <  m.month_start + INTERVAL 1 MONTH
  LEFT JOIN order_items oi ON oi.order_id = o.order_id
  GROUP BY b.branch_name, m.month_start
)
SELECT branch_name,
       order_month,
       month_value,
       LAG(month_value) OVER (PARTITION BY branch_name ORDER BY order_month)               AS previous_month_value,
       month_value - LAG(month_value) OVER (PARTITION BY branch_name ORDER BY order_month) AS change_value
FROM monthly
ORDER BY branch_name, order_month;

-- ---------------------------------------------------------------------
-- A2. DELIVERED item value by branch and top-level category (Grocery /
--     Household = parent of each product's category), branch subtotals and
--     a grand total with ROLLUP. Label the total rows.
-- ---------------------------------------------------------------------
-- WHAT: Inner query finds each line's branch + top-level category; outer query rolls up.
-- WHY : A2 request. COALESCE(parent name, own name) gives the top level. WITH ROLLUP adds
--       subtotal + grand total rows; GROUPING() = 1 marks those rows so we can label them.
-- Rows: 13  (4 branches x [Grocery, Household, Branch subtotal] + 1 GRAND TOTAL)
SELECT CASE WHEN GROUPING(branch_name) = 1 THEN 'ALL BRANCHES'
            ELSE branch_name END                       AS branch,
       CASE WHEN GROUPING(branch_name) = 1 THEN 'GRAND TOTAL'
            WHEN GROUPING(top_category) = 1 THEN 'Branch subtotal'
            ELSE top_category END                      AS top_category,
       SUM(item_value)                                 AS delivered_value
FROM (
  SELECT b.branch_name,
         COALESCE(parent.category_name, c.category_name) AS top_category,
         oi.qty * oi.unit_price                          AS item_value
  FROM orders o
  JOIN branches    b  ON b.branch_id   = o.branch_id
  JOIN order_items oi ON oi.order_id   = o.order_id
  JOIN products    p  ON p.product_id  = oi.product_id
  JOIN categories  c  ON c.category_id = p.category_id
  LEFT JOIN categories parent ON parent.category_id = c.parent_category_id
  WHERE o.status = 'DELIVERED'
) AS d
GROUP BY branch_name, top_category WITH ROLLUP;

-- ---------------------------------------------------------------------
-- A3. DELIVERED orders that have NO payment (NOT EXISTS).
-- ---------------------------------------------------------------------
-- WHAT: Keep a delivered order only if no payment row exists for it.
-- WHY : A3 request. NOT EXISTS is NULL-safe (NOT IN breaks if the list has a NULL).
-- Rows: 6  (1013, 1015, 1036, 1079, 1086 + the new counter order 1091 from B6,
--           because B6 said "no payment is recorded yet")
SELECT o.order_id, o.order_date, o.branch_id, o.channel
FROM orders o
WHERE o.status = 'DELIVERED'
  AND NOT EXISTS (SELECT 1 FROM payments p WHERE p.order_id = o.order_id)
ORDER BY o.order_id;

-- ---------------------------------------------------------------------
-- A4. Online order 2001 with a savepoint.
--     customer 7, Mirpur (3), staff 7, 2026-07-01, ONLINE, PENDING, fee 40,
--     current prices. 1 x product 1 + 1 x product 14; product 7 is inactive.
-- ---------------------------------------------------------------------
-- WHAT: Set the isolation level to READ COMMITTED for this session.
-- WHY : A4 "choose and set a suitable isolation level". Each statement reads the latest
--       COMMITTED data (fresh prices/stock, no dirty reads) and InnoDB takes fewer gap
--       locks than the default REPEATABLE READ, so less blocking for other cashiers.
--       Must be set BEFORE the transaction starts.
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- WHAT: Show the level is set.
-- WHY : Proof for the assessor.
SELECT @@transaction_isolation AS isolation_level;

-- WHAT: Begin one transaction for the whole order.
-- WHY : A4 - "record order 2001 in one transaction".
START TRANSACTION;

-- WHAT: Step 1a - insert the order header.
-- WHY : A4 table, step 1.
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee)
VALUES (2001, 7, 3, 7, '2026-07-01', 'ONLINE', 'PENDING', 40);

-- WHAT: Step 1b - insert 1 x product 1 and 1 x product 14 at current prices.
-- WHY : A4 table, step 1.
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price)
SELECT 2001, 1, product_id, 1, unit_price FROM products WHERE product_id = 1
UNION ALL
SELECT 2001, 2, product_id, 1, unit_price FROM products WHERE product_id = 14;

-- WHAT: Step 1c - set a savepoint after the good part.
-- WHY : A4 table, step 1. We can go back here without losing steps 1a/1b.
SAVEPOINT after_two_items;

-- WHAT: Step 2a - add 1 x product 7.
-- WHY : A4 table, step 2. (No constraint stops it, so WE must check is_active.)
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price)
SELECT 2001, 3, product_id, 1, unit_price FROM products WHERE product_id = 7;

-- WHAT: Step 2b - check if product 7 is active.
-- WHY : Result is 'N' (inactive) -> we must not sell it.
SELECT product_id, product_name, is_active FROM products WHERE product_id = 7;

-- WHAT: Step 2c - undo ONLY line 3.
-- WHY : A4 table, step 2. The header and the 2 good lines stay in the transaction.
ROLLBACK TO SAVEPOINT after_two_items;

-- WHAT: Step 3a - reduce stock row 49 (product 1 at Mirpur) by 1.
-- WHY : A4 table, step 3. Expect 1 row affected (12 -> 11).
--       IF THIS WAITS: the assessor's 2nd session holds a lock - see the BLOCKING notes below.
UPDATE stock SET qty_on_hand = qty_on_hand - 1 WHERE stock_id = 49;

-- WHAT: Step 3b - reduce stock row 62 (product 14 at Mirpur) by 1.
-- WHY : A4 table, step 3. Expect 1 row affected (20 -> 19).
UPDATE stock SET qty_on_hand = qty_on_hand - 1 WHERE stock_id = 62;

-- WHAT: Check before committing: 2 lines, no product 7.
-- WHY : Read the result of every statement before COMMIT.
SELECT order_id, line_no, product_id, qty, unit_price FROM order_items WHERE order_id = 2001;

-- WHAT: Save order 2001.
-- WHY : A4 table, step 3 - "then COMMIT".
COMMIT;

-- WHAT: Put the isolation level back to the MySQL default.
-- WHY : So later work in this session behaves normally.
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- ---- BLOCKING NOTES (A4) - if your UPDATE "hangs" ----------------------
-- WHAT: Open a 2nd tab AS ROOT and find who is blocking whom.
-- WHY : Job step 6 - "find out what is blocking it and resolve it safely".
--   SELECT waiting_pid, waiting_query, blocking_pid, blocking_query,
--          sql_kill_blocking_connection
--   FROM sys.innodb_lock_waits;
--   (or: SELECT * FROM performance_schema.data_lock_waits;  and  SHOW PROCESSLIST;)
-- WHAT: Resolve SAFELY.
-- WHY : Best = ask the other session's owner (assessor) to COMMIT or ROLLBACK.
--       If it is abandoned: KILL <blocking_pid>;  -> MySQL rolls back THEIR open work only.
--       Never kill your own session. If your UPDATE timed out (Error 1205 after 50 s),
--       just run the same UPDATE again - your transaction and savepoint are still open.

-- ---------------------------------------------------------------------
-- A5. Make the slow November 2025 report fast WITHOUT changing its rows.
-- Original (J:\Job3\job3_slow_query_mysql.sql):
--   SELECT DISTINCT * FROM order_history
--   WHERE DATE_FORMAT(ordered_at, '%Y-%m') = '2025-11'
--   ORDER BY ordered_at, history_id;
-- Costly steps and why:
--   1. DATE_FORMAT() is applied to the column -> the index ix_order_history_date cannot be
--      used -> FULL TABLE SCAN of all 100,000 rows (type = ALL).
--   2. DISTINCT * asks MySQL to remove duplicates - but history_id is the PRIMARY KEY,
--      so duplicates are impossible. It is useless and can force a temporary table.
--   3. ORDER BY then needs a filesort of the matching rows.
--   Measured on the seed: BEFORE = type ALL, ~100,000 rows read, "Using where; Using filesort".
--                         AFTER  = type range, 3,076 rows read, no filesort.
-- Fix: compare the plain column with a date range (sargable) and drop DISTINCT.
--      The index on ordered_at (it also holds the PK) returns rows already in
--      (ordered_at, history_id) order -> range scan, no temp table, no filesort.
-- ---------------------------------------------------------------------

-- WHAT: Make sure the date index exists (the assessor may have dropped it).
-- WHY : The fast plan needs it. If SHOW INDEX shows no ix_order_history_date, run:
--       CREATE INDEX ix_order_history_date ON order_history (ordered_at);
SHOW INDEX FROM order_history WHERE Key_name = 'ix_order_history_date';

-- WHAT: BEFORE plan (save to job3_plans.txt).
-- WHY : Shows type=ALL (full scan of ~100,000 rows), "Using where; Using filesort".
EXPLAIN
SELECT DISTINCT * FROM order_history
WHERE DATE_FORMAT(ordered_at, '%Y-%m') = '2025-11'
ORDER BY ordered_at, history_id;

-- WHAT: BEFORE plan with real timings.
-- WHY : EXPLAIN ANALYZE runs the query and shows actual time and rows for each step.
EXPLAIN ANALYZE
SELECT DISTINCT * FROM order_history
WHERE DATE_FORMAT(ordered_at, '%Y-%m') = '2025-11'
ORDER BY ordered_at, history_id;

-- WHAT: AFTER plan.
-- WHY : Shows type=range, key=ix_order_history_date, rows ~3,076, no filesort.
EXPLAIN
SELECT * FROM order_history
WHERE ordered_at >= '2025-11-01' AND ordered_at < '2025-12-01'
ORDER BY ordered_at, history_id;

-- WHAT: AFTER plan with real timings.
-- WHY : Compare the actual time with the BEFORE plan.
EXPLAIN ANALYZE
SELECT * FROM order_history
WHERE ordered_at >= '2025-11-01' AND ordered_at < '2025-12-01'
ORDER BY ordered_at, history_id;

-- WHAT: The improved query (the answer to A5).
-- WHY : Same rows, same order, much cheaper plan.
-- Rows: 3076
SELECT * FROM order_history
WHERE ordered_at >= '2025-11-01' AND ordered_at < '2025-12-01'
ORDER BY ordered_at, history_id;

-- WHAT: Prove both queries return the SAME rows (count + sum of ids + sum of amounts).
-- WHY : Job step 7 - "returns exactly the same rows"; "show both row counts".
-- Rows: 2 lines with identical numbers (3076 rows, id_sum 153856906, amount_sum 1916608.00).
SELECT 'old query' AS version, COUNT(*) AS row_count, SUM(history_id) AS id_sum, SUM(amount) AS amount_sum
FROM (SELECT DISTINCT * FROM order_history
      WHERE DATE_FORMAT(ordered_at, '%Y-%m') = '2025-11') AS old_q
UNION ALL
SELECT 'new query', COUNT(*), SUM(history_id), SUM(amount)
FROM (SELECT * FROM order_history
      WHERE ordered_at >= '2025-11-01' AND ordered_at < '2025-12-01') AS new_q;

-- WHAT: Boundary test - rows on 31 Oct 2025, 1 Nov, 30 Nov and 1 Dec 2025.
-- WHY : Job step 8 "test at least one boundary case": 1 Nov and 30 Nov must be IN,
--       31 Oct and 1 Dec must be OUT. "< '2025-12-01'" is correct for whole days.
--       On the seed only 1 Dec has data: 769 rows -> "NOT in report". A wrong
--       "BETWEEN '2025-11-01' AND '2025-12-01'" would have added these 769 rows.
SELECT ordered_at, COUNT(*) AS rows_that_day,
       IF(ordered_at >= '2025-11-01' AND ordered_at < '2025-12-01', 'IN report', 'NOT in report') AS included
FROM order_history
WHERE ordered_at IN ('2025-10-31', '2025-11-01', '2025-11-30', '2025-12-01')
GROUP BY ordered_at
ORDER BY ordered_at;


-- =====================================================================
-- GIT - commit this file to a local repository named DeshiMart-SQL
-- (Run in PowerShell or Git Bash, NOT in MySQL)
-- =====================================================================
-- WHAT: Go to the Job3 folder and create the repository folder.
-- WHY : Job step 9 - "commit the file to a local Git repository named DeshiMart-SQL".
--   cd D:\DBMS_Assessment\<CandidateID>\Job3
--   mkdir DeshiMart-SQL
--   cd DeshiMart-SQL
--   git init
-- WHAT: Tell Git who you are (only needed once on this PC).
-- WHY : Git refuses to commit without a name and email.
--   git config user.name  "<CandidateID>"
--   git config user.email "<CandidateID>@lab.local"
-- WHAT: Copy the SQL file into the repository, stage it and commit.
-- WHY : Saves a versioned copy with a message.
--   copy ..\job3_queries.sql .
--   git add job3_queries.sql
--   git commit -m "Job 3: B1-B6 and A1-A5 queries with comments and row counts"
-- WHAT: Show the commit as proof.
-- WHY : Evidence for the assessor.
--   git log --oneline
--   git status
-- =====================================================================
-- END OF JOB 3
-- =====================================================================

-- =====================================================================
-- ASSESSOR SABOTAGE QUICK-FIX TABLE - JOB 3
-- What they break            | How to spot it                                   | Exact fix
-- ---------------------------+--------------------------------------------------+------------------------------------------------
-- 1 Autocommit turned off /  | SELECT @@autocommit; -> 0; other session cannot | COMMIT;  (or ROLLBACK;)  then  SET autocommit = 1;
--   open transaction left    |   see your rows; INNODB_TRX shows old trx        |
-- 2 Second session holds a   | Your UPDATE hangs, then Error 1205 "Lock wait    | As root: SELECT blocking_pid FROM sys.innodb_lock_waits;
--   lock (A4)                |   timeout exceeded"                              | ask owner to COMMIT/ROLLBACK, else KILL <blocking_pid>; re-run UPDATE
-- 3 Index on order_history   | AFTER plan still shows type = ALL, key = NULL;   | CREATE INDEX ix_order_history_date ON order_history (ordered_at);
--   dropped (A5)             |   SHOW INDEX FROM order_history; has no ix_...   | then run EXPLAIN again
-- (Extra: product price changed -> fine, we copy the CURRENT price with INSERT ... SELECT.)
-- =====================================================================
