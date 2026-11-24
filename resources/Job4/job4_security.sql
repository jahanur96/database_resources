-- =====================================================================
-- File        : job4_security.sql
-- Job         : Job 4 Part 1 - Secure the production database (DeshiMart)
-- RDBMS       : MySQL 8.0 Community
-- Run as      : root (administrator), AFTER running J:\Job4\job4_start_mysql.sql
-- Features used (MySQL 8.0):
--   * Roles (CREATE ROLE) + SET DEFAULT ROLE
--   * validate_password COMPONENT for length + complexity
--   * PASSWORD EXPIRE INTERVAL 90 DAY  + global default_password_lifetime = 90
--   * FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME UNBOUNDED (MySQL 8.0.19+). MySQL has no
--     server-wide "lock after N failures" setting, so it is set on EVERY account.
--   * ACCOUNT LOCK for the vendor account
--   * MySQL has NO "PUBLIC" role. The nearest thing is "mandatory_roles" (roles given to
--     every user) and anonymous ('' user) accounts. We check and clear both.
-- Change record:
--   v1.0  <date>  Roles, users, grants, vendor lock, password policy, masked view
-- =====================================================================


-- =====================================================================
-- STEP 1 - LOOK AT THE PROBLEM FIRST (evidence "before")
-- =====================================================================

-- WHAT: Show what temp_vendor can do now.
-- WHY : Review finding - "a temporary vendor account still has wide access".
SHOW GRANTS FOR 'temp_vendor'@'%';

-- WHAT: Show every account that has rights on the payments or customers tables.
-- WHY : Find who can read payments / customer phone numbers.
SELECT GRANTEE, TABLE_NAME, PRIVILEGE_TYPE
FROM information_schema.TABLE_PRIVILEGES
WHERE TABLE_SCHEMA = 'deshimart' AND TABLE_NAME IN ('payments', 'customers');

-- WHAT: Show accounts with rights on the WHOLE deshimart database.
-- WHY : Database-level grants also reach payments/customers.
SELECT GRANTEE, PRIVILEGE_TYPE
FROM information_schema.SCHEMA_PRIVILEGES
WHERE TABLE_SCHEMA = 'deshimart';

-- WHAT: Look for anonymous users and roles given to everybody.
-- WHY : This is MySQL's version of "PUBLIC". Both must be empty.
SELECT user, host FROM mysql.user WHERE user = '';
SELECT @@mandatory_roles AS roles_given_to_everyone;


-- =====================================================================
-- STEP 2 - REMOVE EXTRA ACCESS (temp_vendor and "PUBLIC")
-- =====================================================================

-- WHAT: Take away ALL privileges from temp_vendor.
-- WHY : Security policy - least privilege; vendor job is finished.
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'temp_vendor'@'%';

-- WHAT: Lock the temp_vendor account (it can no longer log in).
-- WHY : Policy - "Unused and vendor accounts locked". Lock (not drop) keeps the audit trail.
ALTER USER 'temp_vendor'@'%' ACCOUNT LOCK;

-- WHAT: Make sure no role is given to every user.
-- WHY : Policy - "No PUBLIC access to business tables". PERSIST survives a restart.
SET PERSIST mandatory_roles = '';

-- WHAT: Remove anonymous accounts if any exist (IF EXISTS = no error when none).
-- WHY : An anonymous user lets anyone connect without a name - like PUBLIC access.
DROP USER IF EXISTS ''@'localhost', ''@'%';


-- =====================================================================
-- STEP 3 - PASSWORD POLICY
-- =====================================================================

-- WHAT: Load the password-strength component.
-- WHY : Needed for "at least 10 characters with complexity".
--       If you get Error 3529 "already exists", it is already loaded - skip this line.
INSTALL COMPONENT 'file://component_validate_password';

-- WHAT: Minimum length 10.
-- WHY : Policy - "At least 10 characters".
SET PERSIST validate_password.length = 10;

-- WHAT: MEDIUM policy = length + upper case + lower case + number + special character.
-- WHY : Policy - "with complexity".
SET PERSIST validate_password.policy = 'MEDIUM';

-- WHAT: Need at least 1 of each type (upper/lower, number, special).
-- WHY : Makes the complexity rule clear and explicit.
SET PERSIST validate_password.mixed_case_count   = 1;
SET PERSIST validate_password.number_count       = 1;
SET PERSIST validate_password.special_char_count = 1;

-- WHAT: All passwords expire after 90 days by default.
-- WHY : Policy - "expire after 90 days" (global default for every account).
SET PERSIST default_password_lifetime = 90;

-- WHAT: Show the policy settings.
-- WHY : Evidence for the assessor.
SHOW VARIABLES LIKE 'validate_password%';
SHOW VARIABLES LIKE 'default_password_lifetime';


-- =====================================================================
-- STEP 4 - ROLES WITH LEAST PRIVILEGE
-- =====================================================================

-- WHAT: Create the two roles.
-- WHY : Spec "Roles and users". Rights go to roles; users just get a role (easy to manage).
CREATE ROLE IF NOT EXISTS 'deshimart_cashier', 'deshimart_analyst';

-- WHAT: Cashier may READ products and stock.
-- WHY : Spec - "Read products and stock".
GRANT SELECT ON deshimart.products TO 'deshimart_cashier';
GRANT SELECT ON deshimart.stock    TO 'deshimart_cashier';

-- WHAT: Cashier may INSERT into orders and order_items (no update/delete).
-- WHY : Spec - "insert into orders and order_items".
GRANT INSERT ON deshimart.orders      TO 'deshimart_cashier';
GRANT INSERT ON deshimart.order_items TO 'deshimart_cashier';

-- WHAT: Cashier may UPDATE only ONE column: stock.qty_on_hand.
-- WHY : Spec - "update stock.qty_on_hand". Column-level grant = cannot change product_id etc.
GRANT UPDATE (qty_on_hand) ON deshimart.stock TO 'deshimart_cashier';

-- WHAT: Create the masked customer view (first 3 + last 2 digits, no email).
-- WHY : Policy - "Analysts must not see full phone numbers or emails".
--       01712345678 -> 017 + ****** + 78 = 017******78. Email column is left out.
--       Runs with the creator's rights (SQL SECURITY DEFINER), so analysts need no
--       right on the customers table itself.
CREATE OR REPLACE SQL SECURITY DEFINER VIEW deshimart.v_customers_masked AS
SELECT customer_id,
       full_name,
       CONCAT(LEFT(phone, 3), REPEAT('*', CHAR_LENGTH(phone) - 5), RIGHT(phone, 2)) AS phone_masked,
       area,
       joined_on
FROM deshimart.customers;

-- WHAT: Analyst may READ the masked view, orders, order_items and payments ONLY.
-- WHY : Spec - "Read the masked customer view, orders, order_items and payments only".
--       No grant on deshimart.customers -> the real phone/email stay hidden.
GRANT SELECT ON deshimart.v_customers_masked TO 'deshimart_analyst';
GRANT SELECT ON deshimart.orders             TO 'deshimart_analyst';
GRANT SELECT ON deshimart.order_items        TO 'deshimart_analyst';
GRANT SELECT ON deshimart.payments           TO 'deshimart_analyst';


-- =====================================================================
-- STEP 5 - USERS (each with the password policy) AND ROLE ASSIGNMENT
-- =====================================================================

-- WHAT: Create cashier01 with a strong password, 90-day expiry and lock after 5 bad logins.
-- WHY : Spec user + password policy. PASSWORD_LOCK_TIME UNBOUNDED = stays locked until a DBA unlocks.
CREATE USER IF NOT EXISTS 'cashier01'@'%' IDENTIFIED BY 'Cash#Desk2026'
  PASSWORD EXPIRE INTERVAL 90 DAY
  FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME UNBOUNDED;

-- WHAT: Create analyst01 the same way.
-- WHY : Spec user + password policy.
CREATE USER IF NOT EXISTS 'analyst01'@'%' IDENTIFIED BY 'Report#Data2026'
  PASSWORD EXPIRE INTERVAL 90 DAY
  FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME UNBOUNDED;

-- WHAT: Give each user its role.
-- WHY : Users get rights only through the role (least privilege, easy to audit).
GRANT 'deshimart_cashier' TO 'cashier01'@'%';
GRANT 'deshimart_analyst' TO 'analyst01'@'%';

-- WHAT: Turn the role ON automatically at login.
-- WHY : IMPORTANT in MySQL - without a default role the user logs in with NO rights
--       (Error 1142 "SELECT command denied" even on allowed tables).
SET DEFAULT ROLE ALL TO 'cashier01'@'%', 'analyst01'@'%';

-- WHAT: Apply the failed-login lock and 90-day expiry to the existing owner account too.
-- WHY : Policy covers EVERY account. (Same password as Job 1 already meets length/complexity.)
ALTER USER 'deshimart'@'%'
  PASSWORD EXPIRE INTERVAL 90 DAY
  FAILED_LOGIN_ATTEMPTS 5 PASSWORD_LOCK_TIME UNBOUNDED;

-- WHAT: Prove the password rule works - this weak password must FAIL (Error 1819).
-- WHY : Evidence of the policy. Commented so the script keeps running; run it alone to show.
-- CREATE USER 'weak_test'@'%' IDENTIFIED BY 'abc123';


-- =====================================================================
-- STEP 6 - EVIDENCE ("after")
-- =====================================================================

-- WHAT: Show the final rights of each account (USING shows the role's rights).
-- WHY : Proof of least privilege for the assessor.
SHOW GRANTS FOR 'cashier01'@'%' USING 'deshimart_cashier';
SHOW GRANTS FOR 'analyst01'@'%' USING 'deshimart_analyst';
SHOW GRANTS FOR 'temp_vendor'@'%';

-- WHAT: Show lock status, expiry and failed-login settings for our accounts.
-- WHY : Proof: temp_vendor locked = Y; others N; lifetime 90; User_attributes shows the 5-try lock.
SELECT user, host, account_locked, password_lifetime, User_attributes
FROM mysql.user
WHERE user IN ('temp_vendor', 'cashier01', 'analyst01', 'deshimart');

-- WHAT: Look at the masked view (as root).
-- WHY : Check the mask format: 017******78 style, no email column.
SELECT * FROM deshimart.v_customers_masked LIMIT 5;


-- =====================================================================
-- STEP 7 - TEST AS analyst01 (new connection - NOT root)
-- Workbench: new connection, user analyst01, password Report#Data2026
-- CLI      : mysql -h 192.168.10.25 -P 3306 -u analyst01 -p
-- =====================================================================
-- WHAT: Try the real customers table -> must be REFUSED.
-- WHY : Proof that analysts cannot see full phone/email.
--       Expect: ERROR 1142 (42000): SELECT command denied to user 'analyst01'@'...' for table 'customers'
--   SELECT * FROM deshimart.customers;
--
-- WHAT: Use the masked view -> must WORK.
-- WHY : Proof the analyst gets the safe version (phone like 017******78, no email).
--   SELECT * FROM deshimart.v_customers_masked;
--
-- WHAT: Check which role is active.
-- WHY : Shows `deshimart_analyst`@`%` - the default role is working.
--   SELECT CURRENT_ROLE();
--
-- WHAT: Try temp_vendor login -> must fail.
-- WHY : Proof the vendor account is locked. Expect: ERROR 3118 "Access denied ... Account is locked."
--   mysql -u temp_vendor -p
-- =====================================================================
-- END OF JOB 4 - SECURITY
-- =====================================================================
