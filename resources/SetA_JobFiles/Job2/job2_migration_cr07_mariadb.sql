-- =====================================================================
-- Change Request CR-07 : Supplier SMS confirmation and due date
-- Target DBMS : MariaDB
-- Requested by: Purchasing Manager         Approved by: IT Manager
-- 1. Rename column expected_date to due_date in purchase_orders.
-- 2. Every supplier must have its own phone number, because SMS
--    confirmations are sent to it. Add a unique rule on suppliers.phone.
--    Note from Purchasing: Padma Edible Oils' own number is 01819554310.
-- Run against the purchasing module you built in Job 2.
-- =====================================================================
ALTER TABLE purchase_orders RENAME COLUMN expected_date TO due_date;
ALTER TABLE suppliers ADD CONSTRAINT uq_supplier_phone UNIQUE (phone);
