-- =====================================================================
-- File        : job1_commands.sql
-- Job         : Job 1 - Set up the database environment (DeshiMart)
-- RDBMS       : MySQL 8.0 Community Server on Windows (64-bit)
-- Author      : <Candidate ID>          Date: <today>
-- How to use  : STEP 0 and STEP 1 are done in Windows (PowerShell / Notepad).
--               They are written as comments because they are NOT SQL.
--               STEP 2 onwards is real SQL. Run it in MySQL Workbench
--               (or the mysql command line) from top to bottom.
-- Change record:
--   v1.0  <date>  First version for the assessment
-- =====================================================================


-- =====================================================================
-- STEP 0 - PREPARE WINDOWS  (run in PowerShell "Run as Administrator")
-- =====================================================================

-- WHAT: Make the data folder D:\dbdata before installing.
-- WHY : The spec says the data must live in D:\dbdata (not on C:).
--   New-Item -ItemType Directory -Path D:\dbdata

-- WHAT: Open TCP port 3306 ONLY for the lab subnet (change 192.168.10.0/24 to your lab subnet).
-- WHY : Spec: "Open the database port for the lab subnet only. Do not switch the firewall off."
--   New-NetFirewallRule -DisplayName "MySQL 3306 - Lab subnet only" -Direction Inbound `
--     -Protocol TCP -LocalPort 3306 -RemoteAddress 192.168.10.0/24 -Action Allow -Profile Any

-- WHAT: Check the rule exists and the firewall is still ON.
-- WHY : Proof for the assessor that only the port is opened, not the whole firewall.
--   Get-NetFirewallRule -DisplayName "MySQL 3306 - Lab subnet only" | Get-NetFirewallAddressFilter
--   Get-NetFirewallProfile | Select-Object Name, Enabled

-- WHAT: Add the MySQL bin folder to the SYSTEM PATH (permanent, all users).
-- WHY : So "mysql", "mysqldump" and "mysqlbinlog" work from any folder. (Do not use setx - it can cut PATH at 1024 chars.)
--   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\MySQL\MySQL Server 8.0\bin", "Machine")

-- WHAT: Open a NEW PowerShell window and test the PATH.
-- WHY : PATH changes only show in new windows.
--   mysql --version


-- =====================================================================
-- STEP 1 - INSTALL, my.ini AND SERVICE  (Windows)
-- =====================================================================

-- WHAT: Run D:\Installers\mysql-installer-community-8.0.xx.msi -> Custom -> select
--       MySQL Server 8.0 (x64), MySQL Shell/Client, MySQL Workbench.
--       Click "Advanced Options" on MySQL Server and set Data Directory = D:\dbdata.
-- WHY : Puts data on D: from the start (spec) and installs a CLI + GUI client (job step 8).

-- WHAT: In the config wizard: Config type = Server Computer (or Development), TCP/IP port 3306,
--       "Open Windows Firewall port" = UNTICKED (we made our own subnet-only rule),
--       Authentication = Strong (caching_sha2_password), set a strong root password,
--       Windows Service name = MySQL80, "Start at System Startup" = TICKED,
--       Run as "Standard System Account".
-- WHY : Default port (spec), auto start (spec), strong password, our firewall rule stays subnet-only.

-- WHAT: Check / edit my.ini  (file: C:\ProgramData\MySQL\MySQL Server 8.0\my.ini).
--       In the [mysqld] section these lines must be present:
--         [mysqld]
--         port=3306
--         datadir=D:/dbdata
--         bind-address=0.0.0.0
-- WHY : datadir = spec data folder. bind-address 0.0.0.0 = listen on all network cards,
--       so lab PCs can connect (spec: "accept connections from the lab subnet, not only this PC").
--       Use forward slashes "/" in paths. Save the file as ANSI (no BOM) or the service will not start.

-- WHAT: If you moved the data folder AFTER install: stop service, copy old Data, give rights, start.
-- WHY : The service account must be able to read/write D:\dbdata, or the service fails to start.
--   net stop MySQL80
--   robocopy "C:\ProgramData\MySQL\MySQL Server 8.0\Data" D:\dbdata /E
--   icacls D:\dbdata /grant "NT SERVICE\MySQL80:(OI)(CI)F" /T
--   net start MySQL80

-- WHAT: Make sure the service starts automatically and is running.
-- WHY : Spec: "set it to start automatically".
--   sc.exe config MySQL80 start= auto
--   Get-Service MySQL80 | Select-Object Name, Status, StartType

-- WHAT: Check port 3306 is listening on 0.0.0.0.
-- WHY : Proves the "listener" works for the network, not only localhost.
--   netstat -ano | findstr :3306

-- WHAT: Start the CLI client WITH a session log (--tee) and connect over the NETWORK (IP + port).
-- WHY : Job sheet needs job1_session.log and a network connection (host/IP + port), not localhost.
--   mysql -h 192.168.10.25 -P 3306 -u root -p --tee="D:\DBMS_Assessment\<CandidateID>\Job1\job1_session.log"
--   NOTE: root is usually only root@localhost. If "Access denied" over IP, log in with
--         -h localhost first, do STEP 3 (creates deshimart@'%'), then reconnect over IP as deshimart.
--   Inside mysql you can also type:  tee D:/DBMS_Assessment/<CandidateID>/Job1/job1_session.log


-- =====================================================================
-- STEP 2 - VERSION AND CONNECTION CHECK  (SQL - screenshot = job1_version.png)
-- =====================================================================

-- WHAT: Show version, edition, host name, port, data folder, bind address and who I am.
-- WHY : Job step 8 - "run a query that shows the version" + connection details for the record.
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

-- WHAT: Create the deshimart database with full Unicode support.
-- WHY : Spec: for MySQL create "Database deshimart". utf8mb4 stores Bangla names correctly.
CREATE DATABASE IF NOT EXISTS deshimart
  CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- WHAT: Create the login "deshimart" that can connect from any lab PC.
-- WHY : Seed must be run "as the owner of these objects". Strong password (10+ chars,
--       upper, lower, number, symbol) so it already meets the Job 4 password policy.
CREATE USER IF NOT EXISTS 'deshimart'@'%' IDENTIFIED BY 'Deshi@Mart2026';

-- WHAT: Give the owner full rights on the deshimart database only (not the whole server).
-- WHY : Owner needs to create tables, views, routines and triggers (Jobs 1-3), nothing more.
GRANT ALL PRIVILEGES ON deshimart.* TO 'deshimart'@'%';

-- WHAT: Allow non-SUPER users to create functions and triggers while binary logging is ON.
-- WHY : MySQL 8 has binary logging ON by default. Without this, deshimart gets
--       Error 1419 "You do not have the SUPER privilege..." when creating the Job 2
--       function and trigger. PERSIST keeps the setting after a restart.
SET PERSIST log_bin_trust_function_creators = 1;

-- WHAT: Show the grants to prove the owner is limited to deshimart.*.
-- WHY : Evidence of least privilege.
SHOW GRANTS FOR 'deshimart'@'%';


-- =====================================================================
-- STEP 4 - RUN THE SEED SCRIPT AS THE OWNER
-- =====================================================================

-- WHAT: Reconnect as the owner over the network, then load the seed file.
-- WHY : Spec: "Run the seed script as the owner of these objects".
--   CLI       : mysql -h 192.168.10.25 -P 3306 -u deshimart -p deshimart --tee="D:\DBMS_Assessment\<CandidateID>\Job1\job1_session.log"
--               mysql> source J:/Job1/deshimart_seed_mysql.sql
--   Workbench : new connection (host 192.168.10.25, port 3306, user deshimart, default schema deshimart)
--               -> File > Open SQL Script > J:\Job1\deshimart_seed_mysql.sql -> Execute (lightning icon).

-- WHAT: Make deshimart the current database.
-- WHY : The seed file has no "USE" line, so tables would go to the wrong place without it.
USE deshimart;

-- WHAT: Turn autocommit back ON after the seed.
-- WHY : The seed file runs "SET autocommit = 0". If we leave it, later changes stay
--       uncommitted and can be lost or block other users.
SET autocommit = 1;


-- =====================================================================
-- STEP 5 - CHECK EXACT ROW COUNTS  (screenshot = job1_rowcounts.png)
-- =====================================================================

-- WHAT: Count rows in all 10 tables and compare with the spec numbers in one result.
-- WHY : Job step 9 - compare row counts with the specification sheet. "OK" must show in every row.
SELECT t.table_name, t.row_count, t.expected,
       IF(t.row_count = t.expected, 'OK', 'MISMATCH') AS check_result
FROM (
  SELECT 'branches'      AS table_name, (SELECT COUNT(*) FROM branches)      AS row_count, 4      AS expected UNION ALL
  SELECT 'categories',                  (SELECT COUNT(*) FROM categories),                10              UNION ALL
  SELECT 'products',                    (SELECT COUNT(*) FROM products),                  24              UNION ALL
  SELECT 'stock',                       (SELECT COUNT(*) FROM stock),                     96              UNION ALL
  SELECT 'customers',                   (SELECT COUNT(*) FROM customers),                 30              UNION ALL
  SELECT 'staff',                       (SELECT COUNT(*) FROM staff),                     10              UNION ALL
  SELECT 'orders',                      (SELECT COUNT(*) FROM orders),                    90              UNION ALL
  SELECT 'order_items',                 (SELECT COUNT(*) FROM order_items),               232             UNION ALL
  SELECT 'payments',                    (SELECT COUNT(*) FROM payments),                  61              UNION ALL
  SELECT 'order_history',               (SELECT COUNT(*) FROM order_history),             100000
) AS t;

-- WHAT: List the tables that now exist in deshimart.
-- WHY : Quick proof that every table was created in the right database.
SHOW TABLES;

-- =====================================================================
-- END OF JOB 1.  Save: job1_setup_record.txt, job1_version.png,
--                job1_rowcounts.png, job1_session.log  in  D:\DBMS_Assessment\<CandidateID>\Job1
-- =====================================================================

-- =====================================================================
-- ASSESSOR SABOTAGE QUICK-FIX TABLE - JOB 1
-- What they break            | How to spot it                                   | Exact fix
-- ---------------------------+--------------------------------------------------+------------------------------------------------
-- 1 Service stopped / set    | Get-Service MySQL80 -> Stopped or StartType      | sc.exe config MySQL80 start= auto
--   to Manual                |   Manual; client: "Can't connect ... (10061)"    | net start MySQL80
-- 2 my.ini changed (bad      | Service will not start, or remote connect fails: | Fix my.ini [mysqld]: datadir=D:/dbdata,
--   datadir / port /         |   Get-Content D:\dbdata\<HOST>.err -Tail 30     |   port=3306, bind-address=0.0.0.0 (save ANSI)
--   bind-address=127.0.0.1)  |   netstat -ano | findstr :3306 shows 127.0.0.1   | net stop MySQL80 ; net start MySQL80
-- 3 Firewall rule disabled   | Lab PC: Test-NetConnection <IP> -Port 3306 False | Enable-NetFirewallRule -DisplayName "MySQL 3306 - Lab subnet only"
--   or subnet changed        | Get-NetFirewallRule ... Enabled = False          | Set-NetFirewallRule -DisplayName "MySQL 3306 - Lab subnet only" -RemoteAddress 192.168.10.0/24
-- (Extra: row counts show MISMATCH -> DROP DATABASE deshimart; re-run STEP 3 + seed as deshimart.)
-- =====================================================================
