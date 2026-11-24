-- Job 4 starting state (run as root/administrator)
CREATE USER 'temp_vendor'@'%' IDENTIFIED BY 'vendor123';
GRANT ALL PRIVILEGES ON deshimart.customers TO 'temp_vendor'@'%';
GRANT ALL PRIVILEGES ON deshimart.payments TO 'temp_vendor'@'%';
GRANT SELECT ON deshimart.payments TO PUBLIC;
FLUSH PRIVILEGES;
