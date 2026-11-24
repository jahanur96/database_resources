# =====================================================================
# File    : job4_nightly_backup.ps1
# Job     : Job 4 - nightly hot backup of DeshiMart (WRITE ONLY - do not run in the exam)
# RDBMS   : MySQL 8.0 on Windows (service MySQL80)
# Does    : 1 hot backup with mysqldump  2 compress with 7-Zip  3 test the archive
#           4 copy to the 2nd location   5 delete backups older than 7 days in BOTH places
#           6 write a log file
# Schedule: every night at 02:00 (outside service hours 08:00-23:00), as SYSTEM:
#   schtasks /Create /TN "DeshiMart Nightly Backup" /SC DAILY /ST 02:00 /RU SYSTEM /RL HIGHEST `
#     /TR "powershell.exe -NoProfile -ExecutionPolicy Bypass -File D:\dbbackup\job4_nightly_backup.ps1"
# Change record:
#   v1.0  <date>  First version
# =====================================================================

# WHAT: Settings in one place.
# WHY : Easy to change paths without touching the logic.
$MysqlBin   = "C:\Program Files\MySQL\MySQL Server 8.0\bin"
$SevenZip   = "C:\Program Files\7-Zip\7z.exe"
$Backup1    = "D:\dbbackup"                                # first backup location (spec)
$Backup2    = "\\LABSERVER\dbbackup2\<CandidateID>"        # second backup location (spec)
$CnfFile    = "D:\dbbackup\backup.cnf"                     # holds backup_user + password (quoted)
$Database   = "deshimart"
$KeepDays   = 7                                            # retention (spec)

# WHAT: Build file names with date and time.
# WHY : Every night gets its own file, so nothing is overwritten.
$Stamp   = Get-Date -Format "yyyyMMdd_HHmm"
$SqlFile = Join-Path $Backup1 "deshimart_$Stamp.sql"
$ZipFile = Join-Path $Backup1 "deshimart_$Stamp.7z"
$LogFile = Join-Path $Backup1 "nightly_backup.log"

# WHAT: Small helper to write a time-stamped line to the log.
# WHY : The DBA can read in the morning what happened at night.
function Write-Log($Text) {
    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  $Text" | Out-File -FilePath $LogFile -Append -Encoding utf8
}

# WHAT: Stop at the first error.
# WHY : A half-done backup must not look like a good one.
$ErrorActionPreference = "Stop"

try {
    Write-Log "START backup of $Database"

    # WHAT: Hot backup with mysqldump (database stays online).
    # WHY : --single-transaction = consistent snapshot without locking users;
    #       --source-data=2 = binlog position for point-in-time recovery;
    #       --flush-logs = new binlog file per backup; --routines/--triggers/--events = all objects;
    #       --result-file = correct file encoding (PowerShell ">" would write UTF-16).
    & "$MysqlBin\mysqldump.exe" --defaults-extra-file="$CnfFile" `
        --single-transaction --source-data=2 --flush-logs `
        --routines --triggers --events --no-tablespaces `
        --result-file="$SqlFile" $Database
    if ($LASTEXITCODE -ne 0) { throw "mysqldump failed with exit code $LASTEXITCODE" }

    # WHAT: Check the dump finished properly.
    # WHY : A complete mysqldump file always ends with "-- Dump completed".
    if (-not (Select-String -Path $SqlFile -Pattern "Dump completed" -Quiet)) {
        throw "Dump file is not complete: $SqlFile"
    }

    # WHAT: Compress with 7-Zip.
    # WHY : Smaller file = less disk and faster copy.
    & $SevenZip a -t7z "$ZipFile" "$SqlFile" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "7-Zip compress failed" }

    # WHAT: Test the archive (CRC check).
    # WHY : Prove the backup file is valid before we trust it.
    & $SevenZip t "$ZipFile" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "7-Zip test failed - archive is damaged" }

    # WHAT: Delete the uncompressed .sql.
    # WHY : The .7z already holds it; keep disk free (health check 80/90% rule).
    Remove-Item $SqlFile

    # WHAT: Copy to the second location and compare the hashes.
    # WHY : Two copies in two places; same SHA256 = identical copy.
    Copy-Item $ZipFile -Destination $Backup2
    $h1 = (Get-FileHash $ZipFile).Hash
    $h2 = (Get-FileHash (Join-Path $Backup2 (Split-Path $ZipFile -Leaf))).Hash
    if ($h1 -ne $h2) { throw "Copy on second location is different from the original" }

    # WHAT: Delete backups older than 7 days in BOTH locations.
    # WHY : Retention rule = 7 days; old files would fill the disk.
    $Limit = (Get-Date).AddDays(-$KeepDays)
    foreach ($Folder in @($Backup1, $Backup2)) {
        Get-ChildItem -Path $Folder -Filter "deshimart_*.7z" |
            Where-Object { $_.LastWriteTime -lt $Limit } |
            ForEach-Object { Write-Log "Deleting old backup $($_.FullName)"; Remove-Item $_.FullName }
    }

    Write-Log "OK   backup $ZipFile copied to $Backup2"
    exit 0
}
catch {
    # WHAT: Log the error and return a failure code.
    # WHY : Task Scheduler shows "last run result" <> 0, so the DBA notices the failure.
    Write-Log "FAIL $($_.Exception.Message)"
    exit 1
}
