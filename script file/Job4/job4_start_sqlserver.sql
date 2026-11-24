-- Job 4 starting state (run as sysadmin)
CREATE LOGIN temp_vendor WITH PASSWORD = 'vendor123', CHECK_POLICY = OFF;
GO
USE deshimart;
GO
CREATE USER temp_vendor FOR LOGIN temp_vendor;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.customers TO temp_vendor;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.payments TO temp_vendor;
GRANT SELECT ON dbo.payments TO public;
GO
