-- Job 4 starting state (run as SYSTEM or another DBA user, in the PDB that holds DESHIMART)
CREATE USER temp_vendor IDENTIFIED BY "vendor123";
GRANT CREATE SESSION TO temp_vendor;
GRANT ALL ON deshimart.customers TO temp_vendor;
GRANT ALL ON deshimart.payments TO temp_vendor;
GRANT SELECT ON deshimart.payments TO PUBLIC;
