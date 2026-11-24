-- =====================================================================
-- File        : job4_maintenance.sql
-- Job         : Job 4 Part 2 - Maintain the production database (DeshiMart)
-- RDBMS       : MySQL 8.0 on Windows, service MySQL80, data D:\dbdata
-- Run as      : root
-- Contents    : A. version/config facts  B. config backup + cold backup  C. binary logging
--               D. health check  E. backup user + hot backup  F. point-in-time recovery
-- Windows commands are in comments (run them in PowerShell as Administrator).
-- The nightly backup script is in job4_nightly_backup.ps1.
-- Change record:
--   v1.0  <date>  Maintenance window work (outside 08:00-23:00 service hours)
-- =====================================================================


-- =====================================================================
-- A. FACTS FOR job4_dba_notes.txt
-- =====================================================================

-- WHAT: Version, patch level, edition and OS.
-- WHY : Job step 4 - "record the version, patch level". 8.0.xx -> xx is the patch level.
SELECT VERSION() AS version, @@version_comment AS edition, @@version_compile_os AS os;

-- WHAT: Main configuration settings and file locations.
-- WHY : Job step 4/5 - main settings, where the data, logs and config live.
SELECT @@datadir                         AS data_folder,
       @@port                            AS port,
       @@bind_address                    AS bind_address,
       @@innodb_buffer_pool_size/1024/1024 AS buffer_pool_mb,
       @@innodb_log_buffer_size/1024/1024  AS log_buffer_mb,
       @@max_connections                 AS max_connections,
       @@log_error                       AS error_log,
       @@log_bin                         AS binary_log_on,
       @@log_bin_basename                AS binlog_base,
       @@innodb_undo_directory           AS undo_folder,
       @@innodb_redo_log_capacity/1024/1024 AS redo_capacity_mb;

-- WHAT: List the background threads.
-- WHY : Job step 4 - "background processes". MySQL is ONE process (mysqld.exe) with many threads.
SELECT NAME, TYPE
FROM performance_schema.threads
WHERE TYPE = 'BACKGROUND'
ORDER BY NAME;

-- WHAT: List the InnoDB data, undo and system files.
-- WHY : Job step 5 - "identify what must be backed up".
SELECT FILE_NAME, FILE_TYPE, TABLESPACE_NAME
FROM information_schema.FILES
WHERE FILE_NAME NOT LIKE './mysql/%' AND FILE_NAME NOT LIKE './sys/%'
ORDER BY FILE_TYPE, FILE_NAME;


-- =====================================================================
-- B. CONFIG BACKUP + CLEAN SHUTDOWN + COLD (OFFLINE) BACKUP  (PowerShell)
-- =====================================================================

-- WHAT: Make the two backup folders.
-- WHY : Spec - first location D:\dbbackup, second \\LABSERVER\dbbackup2\<CandidateID>.
--   New-Item -ItemType Directory -Force D:\dbbackup
--   New-Item -ItemType Directory -Force \\LABSERVER\dbbackup2\<CandidateID>

-- WHAT: Back up the configuration file first.
-- WHY : Job step 5 - "Back up the configuration file". my.ini is NOT inside the data folder.
--   Copy-Item "C:\ProgramData\MySQL\MySQL Server 8.0\my.ini" "D:\dbbackup\my.ini.bak_$(Get-Date -f yyyyMMdd_HHmm)"

-- WHAT: Ask InnoDB for a FULL clean shutdown next time it stops (SQL - run it now).
-- WHY : innodb_fast_shutdown = 0 flushes everything to the data files, so the cold copy
--       is fully consistent on its own.
SET GLOBAL innodb_fast_shutdown = 0;

-- WHAT: Stop the service cleanly, check it is stopped.
-- WHY : Job step 5 - "Shut the database down cleanly" before a cold backup.
--   net stop MySQL80
--   Get-Service MySQL80

-- WHAT: Copy the WHOLE data folder (data files, redo, undo, binlogs, mysql.ibd) + my.ini.
-- WHY : Cold backup = our fallback if everything else fails.
--   robocopy D:\dbdata "D:\dbbackup\cold_$(Get-Date -f yyyyMMdd)\dbdata" /E /R:1 /W:1
--   Copy-Item "C:\ProgramData\MySQL\MySQL Server 8.0\my.ini" "D:\dbbackup\cold_$(Get-Date -f yyyyMMdd)\"


-- =====================================================================
-- C. TURN ON BINARY LOGGING (before starting again)
-- =====================================================================

-- WHAT: Edit my.ini [mysqld] (service still STOPPED), add/check these lines:
--         [mysqld]
--         log-bin=deshimart-bin
--         server-id=1
--         binlog_format=ROW
--         binlog_expire_logs_seconds=604800
--       Also make sure there is NO "skip-log-bin" or "disable-log-bin" line.
-- WHY : Job step 6 - binary log is needed for the online backup position and for
--       point-in-time recovery. ROW format keeps the exact changed rows. 604800 s = 7 days
--       (same as backup retention). Files go to D:\dbdata\deshimart-bin.000001 ...

-- WHAT: Start the service and check it is running.
-- WHY : Job step 6 - "Start the database and check that it is open".
--   net start MySQL80
--   Get-Service MySQL80

-- WHAT: Check binary logging is ON and see the current log file and position.
-- WHY : Proof that step C worked.
SHOW VARIABLES LIKE 'log_bin%';
SHOW BINARY LOGS;
SHOW MASTER STATUS;

-- WHAT: Check the database is OPEN for read and write.
-- WHY : "Check that it is open" - read_only = 0 means users can write.
SELECT 'OPEN' AS db_state, @@read_only AS read_only, @@super_read_only AS super_read_only,
       (SELECT COUNT(*) FROM deshimart.orders) AS orders_rows;


-- =====================================================================
-- D. HEALTH CHECK (checklist)  -> screenshot for the assessor
-- =====================================================================

-- [1] INSTANCE + LISTENER --------------------------------------------
-- WHAT: Server up, how long, which port and address it listens on.
-- WHY : Checklist "instance and listener".
SELECT @@hostname AS host, @@port AS port, @@bind_address AS listens_on,
       (SELECT VARIABLE_VALUE FROM performance_schema.global_status
        WHERE VARIABLE_NAME = 'Uptime') AS uptime_seconds;
-- WHAT: Listener check from Windows.
-- WHY : Proves port 3306 really accepts network connections.
--   Get-Service MySQL80
--   netstat -ano | findstr :3306
--   Test-NetConnection -ComputerName 192.168.10.25 -Port 3306

-- [2] ERROR LOG ------------------------------------------------------
-- WHAT: Where the error log is.
-- WHY : Checklist "error log".
SELECT @@log_error AS error_log_file;

-- WHAT: Last 20 errors/warnings, read from inside MySQL (MySQL 8.0.22+).
-- WHY : Find startup problems, crashes, or anything the assessor broke.
SELECT LOGGED, PRIO, ERROR_CODE, DATA
FROM performance_schema.error_log
WHERE PRIO IN ('Error', 'Warning')
ORDER BY LOGGED DESC
LIMIT 20;
--   PowerShell: Get-Content "D:\dbdata\<HOSTNAME>.err" -Tail 30

-- [3] FREE SPACE against 80% (warning) and 90% (critical) ------------
-- WHAT: Size of each database in MB.
-- WHY : Checklist "free space" - know how big the data is and how fast it grows.
SELECT table_schema AS database_name,
       ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS size_mb,
       ROUND(SUM(data_free) / 1024 / 1024, 2)                 AS free_inside_files_mb
FROM information_schema.TABLES
GROUP BY table_schema
ORDER BY size_mb DESC;

-- WHAT: Disk usage of drive D: with the 80% / 90% rule (MySQL cannot see disk free space).
-- WHY : Checklist - OK < 80%, WARNING 80-90%, CRITICAL >= 90%.
--   Get-Volume -DriveLetter D | Select-Object DriveLetter,
--     @{n='SizeGB';e={[math]::Round($_.Size/1GB,1)}},
--     @{n='FreeGB';e={[math]::Round($_.SizeRemaining/1GB,1)}},
--     @{n='UsedPct';e={[math]::Round((1-$_.SizeRemaining/$_.Size)*100,1)}},
--     @{n='Status';e={$u=(1-$_.SizeRemaining/$_.Size)*100; if($u -ge 90){'CRITICAL'}elseif($u -ge 80){'WARNING'}else{'OK'}}}

-- WHAT: Connections used against the maximum, with the same 80% / 90% rule.
-- WHY : Too many connections = new users get "Too many connections".
SELECT c.VARIABLE_VALUE AS threads_connected,
       @@max_connections AS max_connections,
       ROUND(c.VARIABLE_VALUE / @@max_connections * 100, 1) AS used_pct,
       CASE WHEN c.VARIABLE_VALUE / @@max_connections >= 0.9 THEN 'CRITICAL'
            WHEN c.VARIABLE_VALUE / @@max_connections >= 0.8 THEN 'WARNING'
            ELSE 'OK' END AS status
FROM performance_schema.global_status c
WHERE c.VARIABLE_NAME = 'Threads_connected';

-- [4] SESSIONS AND LOCKS ---------------------------------------------
-- WHAT: Who is connected and what they run.
-- WHY : Checklist "sessions".
SELECT ID, USER, HOST, DB, COMMAND, TIME, STATE, LEFT(INFO, 60) AS query_text
FROM information_schema.PROCESSLIST
ORDER BY TIME DESC;

-- WHAT: Open transactions (long ones hold locks).
-- WHY : Checklist "locks" - an old open transaction is a common cause of blocking.
SELECT trx_mysql_thread_id AS session_id, trx_state, trx_started,
       TIMESTAMPDIFF(SECOND, trx_started, NOW()) AS open_seconds, trx_rows_locked
FROM information_schema.INNODB_TRX;

-- WHAT: Who is blocking whom right now.
-- WHY : Checklist "locks". Empty result = no blocking. If not empty, ask the blocker
--       to COMMIT/ROLLBACK, or KILL <blocking_pid> if it is abandoned.
SELECT waiting_pid, waiting_query, blocking_pid, blocking_query, wait_age
FROM sys.innodb_lock_waits;


-- =====================================================================
-- E. ONLINE (HOT) BACKUP - compress, copy to 2nd location, check it
-- =====================================================================

-- WHAT: Make a small backup-only account (read + lock rights, local login only).
-- WHY : Least privilege - the backup script must not use root. PASSWORD EXPIRE NEVER so
--       the nightly job does not break after 90 days (service account - document this).
CREATE USER IF NOT EXISTS 'backup_user'@'localhost' IDENTIFIED BY 'Back#Up2026dm'
  PASSWORD EXPIRE NEVER;

-- WHAT: Give only what mysqldump needs.
-- WHY : SELECT/SHOW VIEW/TRIGGER/EVENT read everything; LOCK TABLES + RELOAD for a
--       consistent snapshot; REPLICATION CLIENT to record the binlog position; PROCESS for tablespace info.
GRANT SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, EVENT, RELOAD, PROCESS, REPLICATION CLIENT
  ON *.* TO 'backup_user'@'localhost';

-- WHAT: Password file so the password is not typed on the command line.
-- WHY : A password on the command line can be seen by other users. QUOTE it - "#" starts a comment!
--   File D:\dbbackup\backup.cnf :
--     [client]
--     user=backup_user
--     password="Back#Up2026dm"
--   icacls D:\dbbackup\backup.cnf /inheritance:r /grant:r "Administrators:F" "SYSTEM:F"

-- WHAT: Take the hot backup while the database stays online.
-- WHY : Job step 8. --single-transaction = consistent InnoDB snapshot without blocking users;
--       --source-data=2 writes the binlog file+position as a comment (start point for PITR);
--       --flush-logs starts a new binlog file; --routines --triggers --events = all objects;
--       --result-file avoids PowerShell's ">" which writes UTF-16 and breaks the file.
--   $ts = Get-Date -f yyyyMMdd_HHmm
--   mysqldump --defaults-extra-file=D:\dbbackup\backup.cnf --single-transaction --source-data=2 `
--     --flush-logs --routines --triggers --events --no-tablespaces `
--     --result-file="D:\dbbackup\deshimart_$ts.sql" deshimart

-- WHAT: Compress it with 7-Zip, then delete the big .sql.
-- WHY : Job step 8 - "compress it". Saves disk space.
--   & "C:\Program Files\7-Zip\7z.exe" a "D:\dbbackup\deshimart_$ts.7z" "D:\dbbackup\deshimart_$ts.sql"
--   Remove-Item "D:\dbbackup\deshimart_$ts.sql"

-- WHAT: Copy to the second backup location.
-- WHY : Job step 8 - two copies in two places (one disk failure cannot lose both).
--   Copy-Item "D:\dbbackup\deshimart_$ts.7z" "\\LABSERVER\dbbackup2\<CandidateID>\"

-- WHAT: Check BOTH copies are valid.
-- WHY : Job step 8 - "check that it is valid". 7z t checks the CRC ("Everything is Ok");
--       same hash = the copy is identical.
--   & "C:\Program Files\7-Zip\7z.exe" t "D:\dbbackup\deshimart_$ts.7z"
--   & "C:\Program Files\7-Zip\7z.exe" t "\\LABSERVER\dbbackup2\<CandidateID>\deshimart_$ts.7z"
--   Get-FileHash "D:\dbbackup\deshimart_$ts.7z", "\\LABSERVER\dbbackup2\<CandidateID>\deshimart_$ts.7z"
--   Get-ChildItem D:\dbbackup, \\LABSERVER\dbbackup2\<CandidateID>      (screenshot = job4_backups.png)

-- WHAT: Write down the payments total NOW (after the backup).
-- WHY : Baseline to compare with after a recovery. Seed = 61 rows, 89459.00.
SELECT COUNT(*) AS payment_rows, SUM(amount) AS payment_total FROM deshimart.payments;


-- =====================================================================
-- F. POINT-IN-TIME RECOVERY - assessor deleted payments rows
-- Method: restore the hot backup into a SIDE database (deshimart_pitr), replay the binlog
-- up to JUST BEFORE the bad DELETE, then copy ONLY the missing rows back into the live
-- deshimart.payments. The live database stays online and NO other work is lost
-- (a full restore over deshimart would wipe everything done after the backup).
-- =====================================================================

-- WHAT: F1 - see how many rows are missing now.
-- WHY : Evidence of the loss (compare with the baseline above).
SELECT COUNT(*) AS payment_rows_now, SUM(amount) AS payment_total_now FROM deshimart.payments;

-- WHAT: F2 - list the binlog files.
-- WHY : The DELETE is in one of these (usually the newest after --flush-logs).
SHOW BINARY LOGS;

-- WHAT: F3 - find the bad DELETE and the position just before it.
-- WHY : We replay up to the END of the last GOOD transaction = "End_log_pos" of the
--       Xid (COMMIT) row just BEFORE the "BEGIN ... Delete_rows (deshimart.payments)" rows.
--       Replace the file name with yours, then run:
--   SHOW BINLOG EVENTS IN 'deshimart-bin.000003';
--   Example result:  Pos 456 Xid End_log_pos 487   <- last good COMMIT  => STOP POSITION = 487
--                    Pos 487 Anonymous_Gtid / 566 BEGIN / 646 Table_map deshimart.payments / 719 Delete_rows
--   Readable rows (optional):
--   mysqlbinlog --base64-output=DECODE-ROWS -v D:\dbdata\deshimart-bin.000003 --result-file=D:\dbbackup\binlog_read.txt
--   findstr /n /c:"DELETE FROM `deshimart`.`payments`" D:\dbbackup\binlog_read.txt

-- WHAT: F4 - find the START position written inside the hot backup.
-- WHY : Replay must start exactly where the backup ended.
--   & "C:\Program Files\7-Zip\7z.exe" e "D:\dbbackup\deshimart_<ts>.7z" -oD:\dbbackup\restore
--   findstr /c:"CHANGE MASTER TO" /c:"CHANGE REPLICATION SOURCE TO" D:\dbbackup\restore\deshimart_<ts>.sql
--   e.g.  -- CHANGE MASTER TO MASTER_LOG_FILE='deshimart-bin.000003', MASTER_LOG_POS=157;

-- WHAT: F5 - make the side database and load the backup into it.
-- WHY : We never overwrite the live database.
--   CREATE DATABASE deshimart_pitr;
--   mysql -u root -p deshimart_pitr -e "source D:/dbbackup/restore/deshimart_<ts>.sql"

-- WHAT: F6 - replay the binlog from the backup position to just before the DELETE,
--       renaming deshimart -> deshimart_pitr on the way.
-- WHY : Brings back rows added AFTER the backup and BEFORE the delete. --database must use
--       the NEW name (rewrite happens first). --result-file avoids PowerShell pipe problems.
--   mysqlbinlog --start-position=157 --stop-position=487 --rewrite-db="deshimart->deshimart_pitr" `
--     --database=deshimart_pitr D:\dbdata\deshimart-bin.000003 --result-file=D:\dbbackup\restore\pitr.sql
--   mysql -u root -p -e "source D:/dbbackup/restore/pitr.sql"
--   (If the backup position and the DELETE are in DIFFERENT files: list both files in order;
--    --start-position applies to the first file, --stop-position to the last.)

-- WHAT: F7 - copy back ONLY the rows that are missing in live payments.
-- WHY : Recovers the lost rows; NOT EXISTS skips rows that are still there -> no duplicates,
--       and every payment added after the delete is kept.
--   INSERT INTO deshimart.payments
--   SELECT r.* FROM deshimart_pitr.payments r
--   WHERE NOT EXISTS (SELECT 1 FROM deshimart.payments p WHERE p.payment_id = r.payment_id);

-- WHAT: F8 - check the payments total again.
-- WHY : Job step 9 - "check the payments total". Count/total must be back to the baseline
--       (plus any payments that were legally added after the delete).
--   SELECT COUNT(*) AS payment_rows, SUM(amount) AS payment_total FROM deshimart.payments;

-- WHAT: F9 - clean up the side database.
-- WHY : Do not leave a second copy of customer/payment data lying around.
--   DROP DATABASE deshimart_pitr;

-- =====================================================================
-- END OF JOB 4 - MAINTENANCE
-- =====================================================================

-- =====================================================================
-- ASSESSOR SABOTAGE QUICK-FIX TABLE - JOB 4
-- What they break            | How to spot it                                   | Exact fix
-- ---------------------------+--------------------------------------------------+------------------------------------------------
-- 1 temp_vendor unlocked /   | SELECT user, account_locked FROM mysql.user      | REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'temp_vendor'@'%';
--   re-granted               |   WHERE user='temp_vendor'; -> N; SHOW GRANTS    | ALTER USER 'temp_vendor'@'%' ACCOUNT LOCK;
-- 2 Binary log switched off  | SHOW VARIABLES LIKE 'log_bin'; -> OFF            | my.ini: delete skip-log-bin, keep log-bin=deshimart-bin + server-id=1
--   (skip-log-bin in my.ini) |                                                  | net stop MySQL80 ; net start MySQL80
-- 3 Payments rows deleted    | SELECT COUNT(*), SUM(amount) FROM payments;      | Section F (side restore + mysqlbinlog --stop-position +
--                            |   lower than the baseline                        |   INSERT ... WHERE NOT EXISTS) - no other work is lost
-- (Extra: analyst01 gets Error 1142 on allowed tables -> SET DEFAULT ROLE ALL TO 'analyst01'@'%';)
-- =====================================================================
