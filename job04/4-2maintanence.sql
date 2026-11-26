-- 1. tell mysql to output logs to a file (or use 'table' to log to mysql.general_log)
set global log_output = 'file';

-- 2. set your desired log file path (ensure mysql has write permissions to this folder)
set global general_log_file = 'd:/log/backup.log';

-- 3. turn on logging
set global general_log = 'on';

use deshimart;
------------------ step 4 ---------------------
--  record the version
select version() as mysql_version,
@@version_comment as edition,
@@version_compile_os as os_name,
@@version_compile_machine as architecture,
@@hostname as host_name,
@@port as port,
@@basedir as base_directory,
@@datadir as data_directory,
@@server_uuid as server_uuid;

-- identify the main memory areas
show variables where variable_name in
('log_bin','server_id','binlog_format','binlog_expire_logs_seconds',
'log_bin_basename','log_error','port','datadir','basedir',
'innodb_buffer_pool_size','innodb_log_buffer_size',
'innodb_redo_log_capacity','max_connections','tmp_table_size',
'thread_cache_size','key_buffer_size','slow_query_log',
'general_log','secure_file_priv');

-- background process 
select thread_id, name, type, processlist_state
from performance_schema.threads
where type = 'background'
order by name;

-- Step q5 -------------------
-- 1. powershell open
-- 2. Folder create: New-Item -ItemType Directory -Force -Path "D:\dbbackup"
-- 3. install mysql version check: Get-Service *mysql*
-- 4. Path setup kora: MySQL path khuje ber korlam: C:\Program Files\MySQL\MySQL Server 8.0\bin
-- Edit environment variable option>system variable >new
-- variable name: path
-- variable value: C:\Program Files\MySQL\MySQL Server 8.0\bin
-- ok
-- open powershell again:
-- 5. execute command: .\where.exe MySQL
-- 6. check mysqldum ace kina?: .\where.exe mysqldump
-- 7. "C:\ProgramData\MySQL\MySQL Server 8.0\my.ini"
-- 8. akta variable a path rakhlam: 
-- $ConfigFile = "C:\ProgramData\MySQL\MySQL Server 8.0\my.ini"
-- 9. test-path $ConfigFile
-- 10. $Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
-- 11. $ColdDir = "D:\dbbackup2\cold_$Stamp"
-- 12. Folder korlam> New-Item -ItemType Directory -Force -Path $ColdDir
-- 13. Copy-Item -LiteralPath $ConfigFile -Destination $ColdDir
-- 14. Stop mysql server> .\net stop MySQL80
-- 15. Get-Service *mysql*
-- 16. .\robocopy "C:\ProgramData\MySQL\MySQL Server 8.0\Data" "$ColdDir\data" /E /COPY:DAT /DCOPY:DAT /R:2 /W:2 /XJ
-- 17. .\net start MySQL80
----- Step 6 ----------------------
select
    @@log_bin as binary_logging;
   --  ,
    -- count(*) as total_customers
-- from deshimart.customers;

-- .\net start MySQL80
-- Run CMD> execute> mysqladmin -u root -p ping (result: mysql is alive)

show variables like 'log_bin';
show variables like 'server_id';
show variables like 'binlog_format';
show variables like 'binlog_expire_logs_seconds';
show binary logs;
show master status;
select 1;
select version(), @@datadir;

-- ------ step 7 ------------------
-- instance check> powershell>  Get-Service *mysql*
-- Listener check>		.\netstat -ano | .\findstr :3306

select
    @@hostname as server_name,
    @@port as listener_port,
    @@skip_networking as network_disabled;

-- check error log 
show variables like 'log_error'; 

-- last 50 error file check korbo log_error value file name copy korte hobe(DESKTOP-FICLC69)
-- Get-Content -LiteralPath "C:\ProgramData\MySQL\MySQL Server 8.0\Data\DESKTOP-FICLC69.err" -Tail 50

-- run powershell below code for: free space against 80% and 90% limits: 
-- Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" |
-- ForEach-Object {
-- $used = [math]::Round((1 - ($_.FreeSpace / $_.Size)) * 100, 1)
-- $state = if ($used -ge 90) { "CRITICAL" }
-- elseif ($used -ge 80) { "WARNING" }
-- else { "OK" }
-- [pscustomobject]@{
-- Drive = $_.DeviceID
-- UsedPercent = $used
-- Status = $state
-- }
-- }

-- check sessions 
show full processlist;

-- check locks
select * from performance_schema.data_lock_waits;

-- step 8: Online (Hot) Backup---------------
-- Online Databse Backup using git bash: 
-- "/c/Program Files/MySQL/MySQL Server 8.0/bin/mysqldump.exe" -u root -p --single-transaction --quick --routines --triggers --events --no-tablespaces --set-gtid-purged=OFF --result-file="D:/dbbackup2/hot/deshimart_hot.sql" deshimart

 

-- step 9 -------------
create database dashimart_restore;
-- or cmd > mysql -u root -p -e "CREATE DATABASE shop_secure_restore CHARACTER SET utf8mb4
-- restore backup databse/import in new database 
-- cmd>
-- mysql -u root -p deshimart_restore < "D:/dbbackup2/hot/deshimart_hot.sql"

-- Restore backup


INSERT INTO test.payments 
SELECT *
FROM deshimart.payments
WHERE payment_id = 60;



-- q9 Take an online (hot) backup, compress it, 
-- open power shell
-- --check version:  mysqldump --version
-- run command:  mysqldump --login-path=job4backup --single-transaction --routines --triggers --events --hex-blob --source-data=2 --result-file="D:\dbbackup\deshimart_backup.sql" deshimart
-- or run: mysqldump --login-path=job4backup --single-transaction --routines --triggers --events --hex-blob --source-data=2 --user root --password --result-file="D:\dbbackup\deshimart_backup.sql" deshimart

-- check file info:   Get-Item "D:\dbbackup\deshimart_backup.sql" | Select-Object Name, Length, LastWriteTime
--  compress file/zip: Compress-Archive -LiteralPath "D:\dbbackup\deshimart_backup.sql" -DestinationPath "D:\dbbackup\deshimart_backup.zip" -Force
-- check compress file: Get-Item "D:\dbbackup\deshimart_backup.zip" | Select-Object Name, Length, LastWriteTime

-- unzip file:  Expand-Archive -LiteralPath "D:\dbbackup\deshimart_backup.zip" -DestinationPath "$env:TEMP\DeshiMartZipTest" -Force

-- check file length : Get-Item "$env:TEMP\DeshiMartZipTest\deshimart_backup.sql" | Select-Object Name, Length
--  create a database deshimart_restore

-- q9
create database deshimart_restore;

-- To restore use the command: .\cmd.exe /c "`"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe`" --login-path=job4backup --user root --password deshimart_restore < `"D:\dbbackup\deshimart_backup.sql`""

SELECT COUNT(*) AS payment_rows,
       COALESCE(SUM(amount), 0.00) AS payments_total
FROM deshimart.payments;

SELECT COUNT(*) AS payment_rows,
       COALESCE(SUM(amount), 0.00) AS payments_total
FROM deshimart_restore.payments;

SELECT *
FROM deshimart_restore.order_items
EXCEPT
SELECT *
FROM deshimart.order_items;

SELECT payment_id, order_id, method, amount, paid_at
FROM deshimart.payments
EXCEPT
SELECT payment_id, order_id, method, amount, paid_at
FROM deshimart_restore.payments;

-- select * from orders where order_id = 1025;
-- delete from order_items where order_id = 1025;
-- delete from orders where order_id = 1025;

