-- Job 4 starting state (run as root/administrator)
CREATE USER 'temp_vendor'@'%' IDENTIFIED BY 'vendor123';
GRANT ALL PRIVILEGES ON deshimart.customers TO 'temp_vendor'@'%';
GRANT ALL PRIVILEGES ON deshimart.payments TO 'temp_vendor'@'%';
-- MySQL has no PUBLIC grantee; the over-broad access is given to temp_vendor only.
FLUSH PRIVILEGES;
