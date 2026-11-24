-- =====================================================================
-- File        : job2_purchasing.sql
-- Job         : Job 2 - Design and build the purchasing module (DeshiMart)
-- RDBMS       : MySQL 8.0 (InnoDB)
-- Run as      : deshimart (the owner), default schema = deshimart
-- Order       : 1 tables -> 2 valid rows -> 3 invalid-row tests -> 4 objects
--               -> 5 object tests -> 6 CR-07 (dependency check, fix, apply, re-test)
-- Change record:
--   v1.0  <date>  Tables, constraints, test rows, view, index, procedure, function, trigger
--   v1.1  <date>  CR-07 applied: expected_date -> due_date, unique supplier phone,
--                 Padma phone corrected to 01819554310, view + procedure rebuilt
-- =====================================================================

-- WHAT: Work inside the deshimart database.
-- WHY : All purchasing objects must be built "in the deshimart database" (job sheet).
USE deshimart;

-- WHAT: Make sure autocommit is ON.
-- WHY : The seed script turned it OFF; we want each test step to save clearly.
SET autocommit = 1;


-- =====================================================================
-- PART 1 - TABLES (parents first, then children)
-- =====================================================================

-- WHAT: Supplier master table.
-- WHY : Spec: supplier_id key; supplier_name required; trade_licence_no required AND unique
--       (a supplier is "identified by the trade licence number"); phone required.
CREATE TABLE suppliers (
  supplier_id       INT          NOT NULL,
  supplier_name     VARCHAR(80)  NOT NULL,
  trade_licence_no  VARCHAR(30)  NOT NULL,
  phone             VARCHAR(15)  NOT NULL,
  supplies          VARCHAR(80)  NULL,          -- e.g. "Rice, pulses and flour" (from the paper PO)
  CONSTRAINT pk_suppliers         PRIMARY KEY (supplier_id),
  CONSTRAINT uq_supplier_licence  UNIQUE (trade_licence_no)
) ENGINE=InnoDB;

-- WHAT: Purchase order header table (one row per PO).
-- WHY : Spec: po_id key; supplier_id must exist in suppliers; branch_id must exist in branches;
--       po_date required; status only DRAFT/SENT/RECEIVED/CANCELLED with default DRAFT.
--       One supplier per PO (our design assumption - see job2_design.md).
CREATE TABLE purchase_orders (
  po_id          INT          NOT NULL,
  supplier_id    INT          NOT NULL,
  branch_id      INT          NOT NULL,
  po_date        DATE         NOT NULL,
  status         VARCHAR(10)  NOT NULL DEFAULT 'DRAFT',
  expected_date  DATE         NULL,
  raised_by      INT          NULL,             -- staff who raised the PO (3NF: name lives in staff)
  CONSTRAINT pk_purchase_orders PRIMARY KEY (po_id),
  CONSTRAINT fk_po_supplier  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
  CONSTRAINT fk_po_branch    FOREIGN KEY (branch_id)   REFERENCES branches(branch_id),
  CONSTRAINT fk_po_staff     FOREIGN KEY (raised_by)   REFERENCES staff(staff_id),
  CONSTRAINT ck_po_status    CHECK (status IN ('DRAFT','SENT','RECEIVED','CANCELLED'))
) ENGINE=InnoDB;

-- WHAT: PO line table (one row per product line on a PO).
-- WHY : Spec: po_id + line_no together are the key; product_id must exist in products;
--       qty_ordered > 0; unit_cost > 0. Line total is NOT stored (it is calculated = no redundancy).
CREATE TABLE po_items (
  po_id        INT            NOT NULL,
  line_no      INT            NOT NULL,
  product_id   INT            NOT NULL,
  qty_ordered  INT            NOT NULL,
  unit_cost    DECIMAL(10,2)  NOT NULL,
  CONSTRAINT pk_po_items      PRIMARY KEY (po_id, line_no),
  CONSTRAINT fk_poi_po        FOREIGN KEY (po_id)      REFERENCES purchase_orders(po_id),
  CONSTRAINT fk_poi_product   FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT ck_poi_qty       CHECK (qty_ordered > 0),
  CONSTRAINT ck_poi_cost      CHECK (unit_cost > 0)
) ENGINE=InnoDB;

-- WHAT: Status history table, filled by the trigger.
-- WHY : Spec: log_id generated automatically; po_id; old_status; new_status; changed_at.
--       Business need: "keep a history of every status change".
CREATE TABLE po_status_log (
  log_id      INT          NOT NULL AUTO_INCREMENT,
  po_id       INT          NOT NULL,
  old_status  VARCHAR(10)  NULL,
  new_status  VARCHAR(10)  NOT NULL,
  changed_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_po_status_log PRIMARY KEY (log_id),
  CONSTRAINT fk_log_po        FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id)
) ENGINE=InnoDB;


-- =====================================================================
-- PART 2 - VALID TEST ROWS (insert in one transaction and COMMIT)
-- =====================================================================

-- WHAT: Start one transaction for all valid rows.
-- WHY : Job step 6 - "Commit only the valid rows". All-or-nothing.
START TRANSACTION;

-- WHAT: Insert the 2 valid suppliers (same phone is allowed now - it is the sales agent's number).
-- WHY : Spec "Valid test rows" table.
INSERT INTO suppliers (supplier_id, supplier_name, trade_licence_no, phone) VALUES
  (1, 'Shapla Agro Traders',   'TRAD/DNCC/04417/2024', '01711302214'),
  (2, 'Padma Edible Oils Ltd', 'TRAD/DSCC/11902/2023', '01711302214');

-- WHAT: Insert the 3 valid purchase orders.
-- WHY : Spec "Valid test rows" table (status SENT, expected dates given).
INSERT INTO purchase_orders (po_id, supplier_id, branch_id, po_date, status, expected_date) VALUES
  (8001, 1, 1, '2026-07-01', 'SENT', '2026-07-08'),
  (8002, 2, 2, '2026-07-02', 'SENT', '2026-07-06'),
  (8003, 1, 3, '2026-07-03', 'SENT', '2026-07-10');

-- WHAT: Insert the 4 valid PO lines.
-- WHY : Spec "Valid test rows" table.
INSERT INTO po_items (po_id, line_no, product_id, qty_ordered, unit_cost) VALUES
  (8001, 1,  1,  40, 365.00),
  (8001, 2,  3,  60, 112.00),
  (8002, 1,  5,  24, 790.00),
  (8003, 1, 10, 100,  42.50);

-- WHAT: Save the valid rows permanently.
-- WHY : Job step 6 - commit only valid rows.
COMMIT;

-- WHAT: Count the rows we just saved (expect 2, 3, 4).
-- WHY : Proof for job2_tests.png.
SELECT (SELECT COUNT(*) FROM suppliers)       AS suppliers_2,
       (SELECT COUNT(*) FROM purchase_orders) AS pos_3,
       (SELECT COUNT(*) FROM po_items)        AS lines_4;


-- =====================================================================
-- PART 3 - INVALID TEST ROWS (each MUST fail)
-- These lines are commented so the file runs top-to-bottom without stopping.
-- In the exam: remove the "-- " from ONE line, run it alone (Ctrl+Enter),
-- screenshot the error, then put the "-- " back.
-- =====================================================================

-- WHAT: Invalid 1 - supplier with a trade licence that already exists.
-- WHY : Stopped by UNIQUE uq_supplier_licence -> Error 1062 "Duplicate entry 'TRAD/DNCC/04417/2024'".
-- INSERT INTO suppliers (supplier_id, supplier_name, trade_licence_no, phone) VALUES (3, 'Test Traders', 'TRAD/DNCC/04417/2024', '01900000000');

-- WHAT: Invalid 2 - PO for supplier 999 (does not exist).
-- WHY : Stopped by FOREIGN KEY fk_po_supplier -> Error 1452 "Cannot add or update a child row".
-- INSERT INTO purchase_orders (po_id, supplier_id, branch_id, po_date) VALUES (8004, 999, 1, '2026-07-04');

-- WHAT: Invalid 3 - PO with status APPROVED (not an allowed status).
-- WHY : Stopped by CHECK ck_po_status -> Error 3819 "Check constraint 'ck_po_status' is violated".
-- INSERT INTO purchase_orders (po_id, supplier_id, branch_id, po_date, status) VALUES (8005, 1, 1, '2026-07-04', 'APPROVED');

-- WHAT: Invalid 4 - PO line with quantity 0.
-- WHY : Stopped by CHECK ck_poi_qty (qty_ordered > 0) -> Error 3819.
-- INSERT INTO po_items (po_id, line_no, product_id, qty_ordered, unit_cost) VALUES (8002, 2, 6, 0, 248.00);

-- WHAT: Invalid 5 - PO line for product 999 (does not exist).
-- WHY : Stopped by FOREIGN KEY fk_poi_product -> Error 1452.
-- INSERT INTO po_items (po_id, line_no, product_id, qty_ordered, unit_cost) VALUES (8003, 2, 999, 10, 50.00);

-- WHAT: Prove nothing from the invalid tests was saved (still 2, 3, 4).
-- WHY : Shows the database rejected all 5 bad rows.
SELECT (SELECT COUNT(*) FROM suppliers)       AS suppliers_2,
       (SELECT COUNT(*) FROM purchase_orders) AS pos_3,
       (SELECT COUNT(*) FROM po_items)        AS lines_4;


-- =====================================================================
-- PART 4 - OBJECTS (use the exact names from the spec)
-- =====================================================================

-- WHAT: View of POs still waiting for delivery (status SENT).
-- WHY : Business need "see which POs are still waiting for delivery". Spec columns:
--       supplier name, supplier phone, branch name, PO date, expected date.
CREATE OR REPLACE VIEW v_open_pos AS
SELECT po.po_id, s.supplier_name, s.phone AS supplier_phone, b.branch_name,
       po.po_date, po.expected_date
FROM purchase_orders po
JOIN suppliers s ON s.supplier_id = po.supplier_id
JOIN branches  b ON b.branch_id   = po.branch_id
WHERE po.status = 'SENT';

-- WHAT: Composite index on (status, expected_date).
-- WHY : Spec - "to find SENT orders by expected date" fast (status first, then date).
CREATE INDEX ix_po_status_expected ON purchase_orders (status, expected_date);

-- WHAT: Procedure that moves a PO's expected date forward by N days.
-- WHY : Spec sp_delay_po(po_id, days). One statement, so no DELIMITER is needed.
CREATE PROCEDURE sp_delay_po(IN p_po_id INT, IN p_days INT)
  UPDATE purchase_orders
  SET expected_date = DATE_ADD(expected_date, INTERVAL p_days DAY)
  WHERE po_id = p_po_id;

-- WHAT: Function that returns qty x unit cost.
-- WHY : Spec fn_line_value(qty, unit_cost). DETERMINISTIC + NO SQL is needed because
--       binary logging is ON in MySQL 8 (otherwise Error 1418).
CREATE FUNCTION fn_line_value(p_qty INT, p_unit_cost DECIMAL(10,2))
  RETURNS DECIMAL(12,2)
  DETERMINISTIC NO SQL
  RETURN p_qty * p_unit_cost;

-- WHAT: Trigger that writes ONE row to po_status_log when the status really changes.
-- WHY : Spec trg_po_status_log. The WHERE skips updates that do not change status
--       (e.g. sp_delay_po only changes the date -> no log row). One statement = no DELIMITER.
CREATE TRIGGER trg_po_status_log
AFTER UPDATE ON purchase_orders
FOR EACH ROW
  INSERT INTO po_status_log (po_id, old_status, new_status, changed_at)
  SELECT NEW.po_id, OLD.status, NEW.status, NOW()
  FROM DUAL
  WHERE NOT (OLD.status <=> NEW.status);


-- =====================================================================
-- PART 5 - OBJECT TESTS (expected results from the spec)
-- =====================================================================

-- WHAT: Test 1 - delay PO 8002 by 5 days.
-- WHY : Expected: expected date of 8002 becomes 2026-07-11 (was 2026-07-06).
CALL sp_delay_po(8002, 5);

-- WHAT: Show the new date of 8002.
-- WHY : Proof -> 2026-07-11.
SELECT po_id, expected_date FROM purchase_orders WHERE po_id = 8002;

-- WHAT: Test 2 - change status of 8001 to RECEIVED.
-- WHY : Expected: one new row in po_status_log (SENT -> RECEIVED).
UPDATE purchase_orders SET status = 'RECEIVED' WHERE po_id = 8001;

-- WHAT: Show the log.
-- WHY : Proof -> exactly 1 row: 8001, SENT, RECEIVED.
SELECT * FROM po_status_log;

-- WHAT: Test 3 - call the function.
-- WHY : Expected: 18960.00
SELECT fn_line_value(24, 790.00) AS line_value;

-- WHAT: Test 4 - query the view.
-- WHY : Expected: 2 rows (8002 and 8003 are still SENT; 8001 is RECEIVED).
SELECT * FROM v_open_pos;


-- =====================================================================
-- PART 6 - CHANGE REQUEST CR-07
--   1) rename purchase_orders.expected_date -> due_date
--   2) unique rule on suppliers.phone (Padma's own number is 01819554310)
-- =====================================================================

-- WHAT: BEFORE: find views that use the column expected_date.
-- WHY : Job step 9 - "find every object that depends on the column it renames". Expect: v_open_pos.
SELECT TABLE_NAME AS view_name
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = 'deshimart' AND VIEW_DEFINITION LIKE '%expected_date%';

-- WHAT: BEFORE: find procedures/functions that use expected_date.
-- WHY : Expect: sp_delay_po (it updates expected_date).
SELECT ROUTINE_NAME, ROUTINE_TYPE
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'deshimart' AND ROUTINE_DEFINITION LIKE '%expected_date%';

-- WHAT: BEFORE: find triggers that use expected_date.
-- WHY : Expect: none (our trigger only uses status) - still must check.
SELECT TRIGGER_NAME
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'deshimart' AND ACTION_STATEMENT LIKE '%expected_date%';

-- WHAT: BEFORE: find indexes that use expected_date.
-- WHY : Expect: ix_po_status_expected (MySQL renames the index column automatically).
SELECT INDEX_NAME, COLUMN_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'deshimart' AND COLUMN_NAME = 'expected_date';

-- WHAT: BEFORE: find suppliers that share a phone number.
-- WHY : The unique rule will FAIL (Error 1062) if two suppliers have the same phone.
--       Expect: 01711302214 used by 2 suppliers (Padma used its sales agent's number).
SELECT phone, COUNT(*) AS suppliers_using_it
FROM suppliers
GROUP BY phone
HAVING COUNT(*) > 1;

-- WHAT: Fix the data first - give Padma its own number (from the CR-07 note).
-- WHY : Removes the duplicate so the unique rule can be added. Running CR-07 as-is would
--       rename the column and then stop with "Duplicate entry '01711302214' for key 'uq_supplier_phone'".
UPDATE suppliers SET phone = '01819554310' WHERE supplier_id = 2;

-- WHAT: CR-07 part 1 - rename the column.
-- WHY : Change request. (DDL in MySQL commits automatically.)
ALTER TABLE purchase_orders RENAME COLUMN expected_date TO due_date;

-- WHAT: CR-07 part 2 - each supplier must have its own phone.
-- WHY : Change request - SMS confirmations go to the supplier's own phone.
ALTER TABLE suppliers ADD CONSTRAINT uq_supplier_phone UNIQUE (phone);

-- WHAT: Rebuild the view with the new column name.
-- WHY : After the rename, v_open_pos is broken (Error 1356 "references invalid column").
CREATE OR REPLACE VIEW v_open_pos AS
SELECT po.po_id, s.supplier_name, s.phone AS supplier_phone, b.branch_name,
       po.po_date, po.due_date
FROM purchase_orders po
JOIN suppliers s ON s.supplier_id = po.supplier_id
JOIN branches  b ON b.branch_id   = po.branch_id
WHERE po.status = 'SENT';

-- WHAT: Drop the old procedure.
-- WHY : MySQL has no "CREATE OR REPLACE PROCEDURE" - must drop, then create.
DROP PROCEDURE IF EXISTS sp_delay_po;

-- WHAT: Re-create the procedure using due_date.
-- WHY : Old body still said expected_date -> Error 1054 "Unknown column" when called.
CREATE PROCEDURE sp_delay_po(IN p_po_id INT, IN p_days INT)
  UPDATE purchase_orders
  SET due_date = DATE_ADD(due_date, INTERVAL p_days DAY)
  WHERE po_id = p_po_id;

-- WHAT: AFTER: check the index now points to due_date.
-- WHY : Proves the index followed the rename (no rebuild needed).
SELECT INDEX_NAME, SEQ_IN_INDEX, COLUMN_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'deshimart' AND INDEX_NAME = 'ix_po_status_expected';

-- WHAT: AFTER: check the view is valid.
-- WHY : CHECK TABLE on a view reports an error if the view is broken. Expect "OK".
CHECK TABLE v_open_pos;

-- WHAT: AFTER: re-test the view.
-- WHY : Every dependent object must still work - expect 2 rows with due_date.
SELECT * FROM v_open_pos;

-- WHAT: Start a test transaction for the procedure + trigger re-tests.
-- WHY : We test, look, then ROLLBACK - so the final data stays as the spec expects
--       (assessor checks the final state: v_open_pos must still show 2 rows).
START TRANSACTION;

-- WHAT: AFTER: re-test the procedure (move 8003 by 1 day, 2026-07-10 -> 2026-07-11).
-- WHY : Proves sp_delay_po works with due_date.
CALL sp_delay_po(8003, 1);

-- WHAT: Show 8003's new due date.
-- WHY : Proof -> 2026-07-11.
SELECT po_id, due_date FROM purchase_orders WHERE po_id = 8003;

-- WHAT: AFTER: re-test the trigger (8003 SENT -> CANCELLED adds 1 log row).
-- WHY : Proves the trigger still works after CR-07.
UPDATE purchase_orders SET status = 'CANCELLED' WHERE po_id = 8003;

-- WHAT: Show the log (2 rows inside this test transaction).
-- WHY : Proof of the trigger after CR-07.
SELECT * FROM po_status_log ORDER BY log_id;

-- WHAT: Undo the test changes (date, status AND the log row are all undone together).
-- WHY : Keeps the committed data exactly as the spec tests left it.
ROLLBACK;

-- WHAT: Final check of the view.
-- WHY : Still 2 rows (8002, 8003) after the rollback.
SELECT * FROM v_open_pos;

-- WHAT: AFTER: re-test the function.
-- WHY : Still 18960.00.
SELECT fn_line_value(24, 790.00) AS line_value;

-- WHAT: AFTER: prove the new unique phone rule works (should FAIL with Error 1062). Commented to keep the script running.
-- WHY : Evidence that CR-07 rule is active.
-- UPDATE suppliers SET phone = '01711302214' WHERE supplier_id = 2;

-- =====================================================================
-- END OF JOB 2
-- =====================================================================

-- =====================================================================
-- ASSESSOR SABOTAGE QUICK-FIX TABLE - JOB 2
-- What they break            | How to spot it                                   | Exact fix
-- ---------------------------+--------------------------------------------------+------------------------------------------------
-- 1 Trigger dropped          | Status change adds no log row;                   | Re-run the CREATE TRIGGER trg_po_status_log
--                            |   SHOW TRIGGERS LIKE 'purchase_orders'; is empty |   statement from PART 4
-- 2 CHECK switched off       | Invalid row 3 (APPROVED) is ACCEPTED;            | DELETE FROM purchase_orders WHERE po_id = 8005;
--   (NOT ENFORCED)           |   SELECT CONSTRAINT_NAME, ENFORCED FROM          | ALTER TABLE purchase_orders ALTER CHECK ck_po_status ENFORCED;
--                            |   information_schema.TABLE_CONSTRAINTS           |
--                            |   WHERE TABLE_NAME='purchase_orders';  -> NO     |
-- 3 CR-07 / view broken      | Error 1062 Duplicate '01711302214' on            | UPDATE suppliers SET phone='01819554310' WHERE supplier_id=2;
--                            |   uq_supplier_phone, or Error 1356 on v_open_pos | then re-run the ALTER; CREATE OR REPLACE VIEW ... due_date
-- (Extra: Error 1419 creating function/trigger -> as root: SET PERSIST log_bin_trust_function_creators = 1;)
-- =====================================================================
