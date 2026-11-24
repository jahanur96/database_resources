# DeshiMart – BTEB DBMS Level 5 – MySQL 8.0 Study Guide (Set A)

All SQL files were **tested on MySQL 8.0** with the real Set A job files (seed, CR-07, slow query, Job 4 start script, cloud seed). They ran from top to bottom with no errors, and the results match the spec.

## 1. What is in this ZIP

| Folder | File | What it is |
|---|---|---|
| Job1 | `job1_setup_record.txt` | Completed set-up record (OSH, prerequisites, config choice) |
| Job1 | `job1_commands.sql` | Windows steps (as comments) + SQL: version check, DB, user, row counts |
| Job2 | `job2_design.md` | Conflict, 3-year math, ERD, UNF→3NF, data dictionary |
| Job2 | `job2_purchasing.sql` | Tables, valid/invalid rows, view, index, procedure, function, trigger, CR-07 |
| Job3 | `job3_queries.sql` | B1–B6, A1–A5 with row counts + Git commands |
| Job4 | `job4_security.sql` | Roles, users, grants, vendor lock, password policy, masked view |
| Job4 | `job4_dba_notes.txt` | Version, memory, threads, files, backup checklist |
| Job4 | `job4_maintenance.sql` | Cold backup, binlog, health check, hot backup, point-in-time recovery |
| Job4 | `job4_nightly_backup.ps1` | Nightly backup + 7-day cleanup (tested) |
| Job5 | `job5_cloud_record.txt` | Cloud settings + console checklist |
| Job5 | `job5_cloud_queries.sql` | TLS check, row counts, order 3001, branch report |

Every SQL line has `-- WHAT:` (what it does) and `-- WHY:` (which rule it meets). Read these out loud when the assessor asks.

## 2. Workbench basics (you will need these)

- **Ctrl+Shift+Enter** runs the whole file. **Ctrl+Enter** runs only the statement under the cursor.
- Workbench **stops at the first error**. This is why the "must fail" tests are commented out with `--`. To show one, remove the `--`, press Ctrl+Enter, take a screenshot, then put the `--` back.
- No `DELIMITER` is needed. The procedure, function and trigger are each one statement.
- Windows commands (PowerShell, my.ini) are written as comments inside the .sql files. Run them in **PowerShell (Run as Administrator)**, not in Workbench.
- Session log: use the `mysql` command line with `--tee="...\jobN_session.log"`. Then type `source D:/path/file.sql`.

## 3. The hidden traps in Set A (know these!)

| Job | Trap | What to do |
|---|---|---|
| 1 | The seed runs `SET autocommit = 0` and leaves it OFF | Run `SET autocommit = 1;` after the seed |
| 1 | `root` can only log in from localhost, so a connection over the IP fails | Connect over the network as `deshimart@'%'` |
| 1/2 | Binary log is ON by default, so creating the function/trigger as deshimart fails with **Error 1419** | As root: `SET PERSIST log_bin_trust_function_creators = 1;` (already in Job 1) |
| 2 | The note conflicts: "exactly one supplier" vs "two suppliers on one PO" | Assume 1 supplier per PO and split urgent POs. Ask the manager. |
| 2 | Both suppliers have the same phone, so the CR-07 UNIQUE rule fails with **Error 1062** | First run `UPDATE suppliers SET phone='01819554310' WHERE supplier_id=2` |
| 2 | Renaming the column breaks `v_open_pos` (Error 1356) and `sp_delay_po` (Error 1054) | Rebuild both with `due_date`. The index follows the rename by itself. |
| 3 | B3 join repeats each order once per item line | Use `COUNT(DISTINCT o.order_id)` |
| 3 | B4: walk-in orders have NULL customer | `LEFT JOIN` + `COALESCE(...,'Walk-in')` |
| 3 | B6 order 1092: stock row 36 has **0** | The stock update fails (0 rows / Error 3819), so **ROLLBACK**. 1091 is **COMMIT**. |
| 3 | A1: Gulshan has no sales in March 2026 | Build all 6 months with a recursive CTE, so LAG compares April with March (0) |
| 3 | A4: product 7 is inactive, but no constraint stops the insert | Check `is_active` yourself, then `ROLLBACK TO SAVEPOINT` |
| 3 | A5: `DATE_FORMAT(column)` kills the index; `DISTINCT` is useless (PK) | Use a date range `>= '2025-11-01' AND < '2025-12-01'`. Result: same 3,076 rows. |
| 4 | MySQL has no PUBLIC role | Check `mandatory_roles` and anonymous users, and say so in a comment |
| 4 | A role does nothing until it is active, so analyst01 gets Error 1142 | `SET DEFAULT ROLE ALL TO ...` |
| 4 | MySQL has no global "lock after 5 failed logins" setting | Set `FAILED_LOGIN_ATTEMPTS 5` on **every** account |
| 4 | In `backup.cnf`, `#` starts a comment, so the password gets cut | Put the password in quotes: `password="Back#Up2026dm"` |
| 4 | PowerShell `>` writes UTF-16 and breaks the dump file | Use `mysqldump --result-file=...` |
| 4 | Restoring the whole backup over deshimart would lose newer work | Restore into `deshimart_pitr`, replay the binlog to just before the DELETE, then copy back only the missing rows |
| 5 | The cloud server clock is UTC, so `CURDATE()` can be "yesterday" for Dhaka | `DATE(UTC_TIMESTAMP() + INTERVAL 6 HOUR)` |
| 5 | Backup window must be outside 08:00–23:00 **Dhaka** | Console uses UTC: 20:00 UTC = 02:00 Dhaka |

## 4. Key results on the seed data (to check your screen)

- **Job 1 row counts:** 4 / 10 / 24 / 96 / 30 / 10 / 90 / 232 / 61 / 100000
- **Job 2:** `sp_delay_po(8002,5)` gives 2026-07-11 · status change makes 1 log row · `fn_line_value(24,790)` = 18960.00 · `v_open_pos` = 2 rows
- **B1:** 5 rows (top row: Chinigura Rice 290.00 → 304.50) · **B2:** 10 rows · **B3:** Uttara 11 / 16710, Dhanmondi 7 / 15537, Mirpur 9 / 10903 (detail total 43150) · **B4:** 13 rows · **B5a:** 6 · **B5b:** 11
- **A1:** 24 rows · **A2:** 13 rows, grand total 95872.00 (includes 1091) · **A3:** 6 rows · **A5:** 3,076 rows both ways
- **Job 4 baseline:** payments = 61 rows, total 89459.00
- **Job 5:** order 3001 = 2 lines, 640.00 + fee 60

## 5. Assessor Sabotage Quick-Fix Tables (3 per job)

### Job 1
| What the assessor might break | How to spot it | Exact command to fix it |
|---|---|---|
| Service stopped / set to Manual | `Get-Service MySQL80` shows Stopped or Manual | `sc.exe config MySQL80 start= auto` then `net start MySQL80` |
| my.ini changed (bad datadir, port, bind-address=127.0.0.1) | Service won't start → `Get-Content D:\dbdata\<HOST>.err -Tail 30`; `netstat -ano \| findstr :3306` shows 127.0.0.1 | Fix my.ini (`datadir=D:/dbdata`, `port=3306`, `bind-address=0.0.0.0`, save as ANSI), then `net stop MySQL80; net start MySQL80` |
| Firewall rule disabled / changed | `Test-NetConnection <IP> -Port 3306` = False | `Enable-NetFirewallRule -DisplayName "MySQL 3306 - Lab subnet only"` |

### Job 2
| What the assessor might break | How to spot it | Exact command to fix it |
|---|---|---|
| Trigger dropped | Status change adds no log row; `SHOW TRIGGERS LIKE 'purchase_orders';` is empty | Re-run `CREATE TRIGGER trg_po_status_log ...` |
| CHECK set to NOT ENFORCED | The APPROVED row is accepted; `TABLE_CONSTRAINTS.ENFORCED = NO` | `DELETE FROM purchase_orders WHERE po_id=8005;` then `ALTER TABLE purchase_orders ALTER CHECK ck_po_status ENFORCED;` |
| CR-07 fails / view broken | Error 1062 on uq_supplier_phone, or Error 1356 on v_open_pos | `UPDATE suppliers SET phone='01819554310' WHERE supplier_id=2;` then re-run the ALTER and `CREATE OR REPLACE VIEW ... due_date` |

### Job 3
| What the assessor might break | How to spot it | Exact command to fix it |
|---|---|---|
| Autocommit off / transaction left open | `SELECT @@autocommit;` = 0 | `COMMIT;` (or `ROLLBACK;`) then `SET autocommit = 1;` |
| Second session holds a lock (A4) | UPDATE hangs → Error 1205 | As root: `SELECT blocking_pid FROM sys.innodb_lock_waits;` → ask them to commit, else `KILL <pid>;` → re-run your UPDATE |
| Date index dropped (A5) | New plan still shows `type = ALL` | `CREATE INDEX ix_order_history_date ON order_history (ordered_at);` |

### Job 4
| What the assessor might break | How to spot it | Exact command to fix it |
|---|---|---|
| temp_vendor unlocked / re-granted | `account_locked = 'N'` in mysql.user; `SHOW GRANTS` | `REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'temp_vendor'@'%'; ALTER USER 'temp_vendor'@'%' ACCOUNT LOCK;` |
| Binary log turned off | `SHOW VARIABLES LIKE 'log_bin';` = OFF | Remove `skip-log-bin` from my.ini, keep `log-bin=deshimart-bin` + `server-id=1`, restart the service |
| Payments rows deleted | Count/total lower than 61 / 89459.00 | `job4_maintenance.sql` section F (side restore + `mysqlbinlog --stop-position` + `INSERT ... WHERE NOT EXISTS`) |

### Job 5
| What the assessor might break | How to spot it | Exact command to fix it |
|---|---|---|
| Inbound rule opened to 0.0.0.0/0 | Security group inbound rules | Change the source to `<lab IP>/32`; delete 0.0.0.0/0 |
| TLS not used / not required | `SHOW SESSION STATUS LIKE 'Ssl_cipher';` is empty | Reconnect with `--ssl-mode=VERIFY_IDENTITY --ssl-ca=global-bundle.pem`; set `require_secure_transport = 1` |
| Instance stopped / password changed | Connection times out / Access denied | RDS → Actions → **Start**, or Modify → new master password → Apply immediately |

## 6. Simple answers for the assessor's favourite questions

- **Why InnoDB?** It has transactions (COMMIT/ROLLBACK), row locks, foreign keys and crash recovery.
- **Why DECIMAL for money?** It is exact. FLOAT can give 0.1 + 0.2 = 0.30000000004.
- **Why a role instead of grants on the user?** You give the rights once to the role. Then you just add or remove users from the role. It is easy to check (least privilege).
- **Why READ COMMITTED for A4?** Each statement sees only committed data (no dirty reads), and it takes fewer gap locks than REPEATABLE READ, so other cashiers are blocked less.
- **Cold vs hot backup?** Cold = the server is stopped and you copy the files (simple, always consistent, but downtime). Hot = `mysqldump --single-transaction` while users keep working.
- **Why the binary log?** It records every change. With it you can replay changes after a backup up to any point in time (PITR).
- **Why NOT EXISTS instead of NOT IN?** If the subquery returns a NULL, NOT IN returns no rows at all. NOT EXISTS is safe.
- **What is a sargable condition?** A condition on the plain column (no function around it), so the index can be used.
