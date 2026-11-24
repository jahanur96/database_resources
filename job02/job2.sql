-- 1. Tell MySQL to output logs to a file (or use 'TABLE' to log to mysql.general_log)
SET GLOBAL log_output = 'FILE';

-- 2. Set your desired log file path (ensure MySQL has write permissions to this folder)
SET GLOBAL general_log_file = 'D:/Database/job02/job2.log';

-- 3. Turn on logging
SET GLOBAL general_log = 'ON';

use dashimart;
SET autocommit = 1;

-- PART 1 - TABLES

CREATE TABLE suppliers (
  supplier_id       INT          NOT NULL,
  supplier_name     VARCHAR(80)  NOT NULL,
  trade_licence_no  VARCHAR(30)  NOT NULL,
  phone             VARCHAR(15)  NOT NULL,
  supplies          VARCHAR(80)  NULL,          -- e.g. "Rice, pulses and flour" (from the paper PO)
  CONSTRAINT pk_suppliers         PRIMARY KEY (supplier_id),
  CONSTRAINT uq_supplier_licence  UNIQUE (trade_licence_no)
) ENGINE=InnoDB;

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

CREATE TABLE po_status_log (
  log_id      INT          NOT NULL AUTO_INCREMENT,
  po_id       INT          NOT NULL,
  old_status  VARCHAR(10)  NULL,
  new_status  VARCHAR(10)  NOT NULL,
  changed_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_po_status_log PRIMARY KEY (log_id),
  CONSTRAINT fk_log_po        FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id)
) ENGINE=InnoDB;

-- PART 2 - VALID TEST ROWS (insert in one transaction and COMMIT)
START TRANSACTION;

INSERT INTO suppliers (supplier_id, supplier_name, trade_licence_no, phone) VALUES
  (1, 'Shapla Agro Traders',   'TRAD/DNCC/04417/2024', '01711302214'),
  (2, 'Padma Edible Oils Ltd', 'TRAD/DSCC/11902/2023', '01711302214');
  
  INSERT INTO purchase_orders (po_id, supplier_id, branch_id, po_date, status, expected_date) VALUES
  (8001, 1, 1, '2026-07-01', 'SENT', '2026-07-08'),
  (8002, 2, 2, '2026-07-02', 'SENT', '2026-07-06'),
  (8003, 1, 3, '2026-07-03', 'SENT', '2026-07-10');
  
  INSERT INTO po_items (po_id, line_no, product_id, qty_ordered, unit_cost) VALUES
  (8001, 1,  1,  40, 365.00),
  (8001, 2,  3,  60, 112.00),
  (8002, 1,  5,  24, 790.00),
  (8003, 1, 10, 100,  42.50);
  
  COMMIT;
  
  SELECT (SELECT COUNT(*) FROM suppliers)       AS suppliers_2,
       (SELECT COUNT(*) FROM purchase_orders) AS pos_3,
       (SELECT COUNT(*) FROM po_items)        AS lines_4;


-- PART 3 - INVALID TEST ROWS
-- Invalid 1 - supplier with a trade licence that already exists.
INSERT INTO suppliers (supplier_id, supplier_name, trade_licence_no, phone)
 VALUES (3, 'Test Traders', 'TRAD/DNCC/04417/2024', '01900000000');
 
 -- Invalid 2 - PO for supplier 999 (does not exist).
 INSERT INTO purchase_orders (po_id, supplier_id, branch_id, po_date) VALUES (8004, 999, 1, '2026-07-04');
 
 -- Invalid 3 - PO with status APPROVED (not an allowed status).
 INSERT INTO purchase_orders (po_id, supplier_id, branch_id, po_date, status) VALUES (8005, 1, 1, '2026-07-04', 'APPROVED');
 
 -- Invalid 4 - PO line with quantity 0
 INSERT INTO po_items (po_id, line_no, product_id, qty_ordered, unit_cost) VALUES (8002, 2, 6, 0, 248.00);
 
 -- Prove nothing from the invalid tests was saved (still 2, 3, 4).
 SELECT (SELECT COUNT(*) FROM suppliers)       AS suppliers_2,
       (SELECT COUNT(*) FROM purchase_orders) AS pos_3,
       (SELECT COUNT(*) FROM po_items)        AS lines_4;
       
       

-- PART 4 - OBJECTS (use the exact names from the spec)

CREATE OR REPLACE VIEW v_open_pos AS
SELECT po.po_id, s.supplier_name, s.phone AS supplier_phone, b.branch_name,
       po.po_date, po.expected_date
FROM purchase_orders po
JOIN suppliers s ON s.supplier_id = po.supplier_id
JOIN branches  b ON b.branch_id   = po.branch_id
WHERE po.status = 'SENT';

-- WHAT: Composite index on (status, expected_date).
CREATE INDEX ix_po_status_expected ON purchase_orders (status, expected_date);

-- WHAT: Procedure that moves a PO's expected date forward by N days.
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
 
 
 CREATE TRIGGER trg_po_status_log
AFTER UPDATE ON purchase_orders
FOR EACH ROW
  INSERT INTO po_status_log (po_id, old_status, new_status, changed_at)
  SELECT NEW.po_id, OLD.status, NEW.status, NOW()
  FROM DUAL
  WHERE NOT (OLD.status <=> NEW.status);
  
  -- WHAT: Test 1 - delay PO 8002 by 5 days.
  CALL sp_delay_po(8002, 5);
  
  SELECT po_id, expected_date FROM purchase_orders WHERE po_id = 8002;
  
  -- WHAT: Test 2 - change status of 8001 to RECEIVED.
UPDATE purchase_orders SET status = 'RECEIVED' WHERE po_id = 8001;

SELECT * FROM po_status_log;

-- WHAT: Test 3 - call the function.
SELECT fn_line_value(24, 790.00) AS line_value;

-- WHAT: Test 4 - query the view.
-- WHY : Expected: 2 rows (8002 and 8003 are still SENT; 8001 is RECEIVED).
SELECT * FROM v_open_pos;

-- =====================================================================
-- PART 6 - CHANGE REQUEST CR-07
--   1) rename purchase_orders.expected_date -> due_date
--   2) unique rule on suppliers.phone (Padma's own number is 01819554310)
-- =====================================================================
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