-- Job 4 starting state (run as root/administrator)
use deshimart;

-- 1. tell mysql to output logs to a file 
set global log_output = 'file';

-- 2. set your desired log file path 
set global general_log_file = 'D:/dbbackup/job4_session.log';  

-- 3. turn on logging
set global general_log = 'on';


-- create temp_vendor user according to instruction
CREATE USER 'temp_vendor'@'%' IDENTIFIED BY 'vendor123';
GRANT ALL PRIVILEGES ON deshimart.customers TO 'temp_vendor'@'%';
GRANT ALL PRIVILEGES ON deshimart.payments TO 'temp_vendor'@'%';
-- MySQL has no PUBLIC grantee; the over-broad access is given to temp_vendor only.
FLUSH PRIVILEGES;



-- check user
select user, host, account_locked
from mysql.user;

-- drop user if exists
-- DROP USER 'cashier01'@'localhost';


-- check user permissions
SHOW GRANTS FOR 'temp_vendor'@'%';
-- SHOW GRANTS FOR 'temp_vendor'@'localhost';

-- revoke all privileges for temp_vendor
REVOKE ALL PRIVILEGES
ON deshimart.customers
FROM 'temp_vendor'@'%';

REVOKE ALL PRIVILEGES
ON deshimart.payments
FROM 'temp_vendor'@'%';

-- check user permissions
SHOW GRANTS FOR 'temp_vendor'@'%';

-- Lock Vendor Account
ALTER USER 'temp_vendor'@'%'
ACCOUNT LOCK;

-- check lock users
select user, account_locked
from mysql.user
where user = 'temp_vendor';

-- create role for deshimart_cashier and analyst
create role if not exists deshimart_cashier, deshimart_analyst;

-- 2. Check role
SHOW GRANTS FOR 'deshimart_cashier';
SHOW GRANTS FOR 'deshimart_analyst';

-- Read products and stock; insert into orders and order_items; update stock.qty_on_hand
-- 3. Cashier Role Permissions 
GRANT SELECT ON deshimart.products
TO 'deshimart_cashier';

GRANT SELECT ON deshimart.stock
TO 'deshimart_cashier';

GRANT INSERT ON deshimart.orders
TO 'deshimart_cashier';

GRANT INSERT ON deshimart.order_items
TO 'deshimart_cashier';

GRANT UPDATE(qty_on_hand) ON deshimart.stock
TO 'deshimart_cashier';

-- 3. Cashier Role Permissions 
GRANT SELECT ON deshimart.products
TO 'deshimart_cashier';

GRANT SELECT ON deshimart.stock
TO 'deshimart_cashier';

GRANT INSERT ON deshimart.orders
TO 'deshimart_cashier';

GRANT INSERT ON deshimart.order_items
TO 'deshimart_cashier';

GRANT UPDATE(qty_on_hand) ON deshimart.stock
TO 'deshimart_cashier';

SHOW GRANTS FOR 'deshimart_cashier';
SHOW GRANTS FOR 'deshimart_analyst';

-- create view for prermission to analyst
-- mask customer mobile number 
Create VIEW v_customers_masked AS
SELECT
    customer_id,
    full_name,
	
    CONCAT(
        LEFT(phone, 3),
        '******',
        RIGHT(phone, 2)
    ) AS masked_phone
FROM customers;

-- check view table
select * from v_customers_masked;
-- 4. Analyst Role Permissions

GRANT SELECT ON deshimart.v_customers_masked
TO 'deshimart_analyst';

GRANT SELECT ON deshimart.orders
TO 'deshimart_analyst';

GRANT SELECT ON deshimart.order_items
TO 'deshimart_analyst';

GRANT SELECT ON deshimart.payments
TO 'deshimart_analyst';

-- check permissions
SHOW GRANTS FOR 'deshimart_analyst';

-- 6. create user
CREATE USER IF NOT EXISTS 'cashier01'@'localhost'
IDENTIFIED BY 'Cashier@2026!';

CREATE USER IF NOT EXISTS 'analyst01'@'localhost'
IDENTIFIED BY 'Analyst@2026!';

-- 20. Assign Roles to Users
GRANT 'deshimart_cashier'@'%'
TO 'cashier01'@'localhost';

GRANT 'deshimart_analyst'@'%'
TO 'analyst01'@'localhost';

-- 21. Activate Roles by Default
SET DEFAULT ROLE 'deshimart_cashier'@'%'
TO 'cashier01'@'localhost';

SET DEFAULT ROLE 'deshimart_analyst'@'%'
TO 'analyst01'@'localhost';

-- 22. Check User Roles
SHOW GRANTS FOR 'cashier01'@'localhost';
SHOW GRANTS FOR 'analyst01'@'localhost';

-- Passwords validation
-- 	At least 10 characters with complexity, 
--  expire after 90 days, account locks after 5 failed attempts.
-- 8. Password validation 
-- check variable available or not 
SHOW VARIABLES LIKE 'validate_password%';

-- Check compenent available or not
SELECT * FROM INFORMATION_SCHEMA.PLUGINS
WHERE PLUGIN_NAME LIKE '%validate%';

-- Install component and check component 
INSTALL COMPONENT 'file://component_validate_password';
SHOW VARIABLES LIKE 'validate_password%';

SELECT VERSION();
SHOW VARIABLES LIKE 'plugin_dir';

SELECT component_urn
FROM mysql.component
WHERE component_urn = 'file://component_validate_password';
SELECT VERSION();

SHOW VARIABLES LIKE 'plugin_dir';
SHOW VARIABLES LIKE 'plugin_dir';

-- 23. Password validation -- Check Password Policy
SHOW VARIABLES LIKE 'validate_password%';
SHOW VARIABLES LIKE 'default_password_lifetime';

-- Check Password Validation Component
SELECT component_urn
FROM mysql.component
WHERE component_urn = 'file://component_validate_password';

-- Install component and check component 
INSTALL COMPONENT 'file://component_validate_password';

-- Modify Passwords according to requirements
-- strong pass
SET PERSIST validate_password.length = 10;
SET PERSIST validate_password.policy = 'MEDIUM';
SET PERSIST validate_password.mixed_case_count = 1;
SET PERSIST validate_password.number_count = 1;
SET PERSIST validate_password.special_char_count = 1;
SET PERSIST default_password_lifetime = 90;
-- weak pass
SET PERSIST validate_password.length = 4;
SET PERSIST validate_password.policy = 'LOW';
SET PERSIST validate_password.mixed_case_count = 0;
SET PERSIST validate_password.number_count = 0;
SET PERSIST validate_password.special_char_count = 0;
SET PERSIST default_password_lifetime = 90;

-- Check again Password Policy
SHOW VARIABLES LIKE 'validate_password%';
SHOW VARIABLES LIKE 'default_password_lifetime';

-- Existing two user expiry and failed login lock 
ALTER USER 'cashier01'@'localhost'
 PASSWORD EXPIRE INTERVAL 90 DAY
 FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME 1;
 
ALTER USER 'analyst01'@'localhost'
 PASSWORD EXPIRE INTERVAL 90 DAY
 FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME 1;
 
 -- Check Password Expiry Settingss
SELECT user, host, password_lifetime
FROM mysql.user
WHERE user IN ('cashier01', 'analyst01');


CREATE USER IF NOT EXISTS 'cashier02'@'localhost'
IDENTIFIED BY 'Cashier02@2026!';








