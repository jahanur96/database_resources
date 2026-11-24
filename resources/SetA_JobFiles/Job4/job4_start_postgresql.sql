-- Job 4 starting state (run as the database administrator, connected to database deshimart)
SET search_path TO public;
CREATE ROLE temp_vendor LOGIN PASSWORD 'vendor123';
GRANT ALL ON customers, payments TO temp_vendor;
GRANT SELECT ON payments TO PUBLIC;
