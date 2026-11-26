-- =====================================================================
--  MySQL Window Functions — Scenario-Based Practice Database
--  Database : window_practice
--  Version  : MySQL 8.0+ (Window Function, CTE, Generated Column লাগবে)
--  Part 1   : Schema (CREATE TABLE) + Sample Data (INSERT INTO) + Verification
--
--  চালানোর নিয়ম:
--    mysql -u root -p < window_functions_practice_db.sql
--  অথবা MySQL Workbench-এ ফাইলটি খুলে পুরোটা Execute (Ctrl+Shift+Enter) করুন।
--  স্ক্রিপ্টটি বারবার চালানো যায়: প্রতিবার database নতুন করে তৈরি হয়।
-- =====================================================================

DROP DATABASE IF EXISTS window_practice;
CREATE DATABASE window_practice
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;
USE window_practice;

-- =====================================================================
-- PART A: SCHEMA
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. departments: কোম্পানির বিভাগ
-- ---------------------------------------------------------------------
CREATE TABLE departments (
    dept_id        INT            NOT NULL,
    dept_name      VARCHAR(60)    NOT NULL,
    location       VARCHAR(40)    NOT NULL,
    annual_budget  DECIMAL(12,2)  NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (dept_id),
    CONSTRAINT uq_departments_name UNIQUE (dept_name)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 2. employees: কর্মী (manager_id দিয়ে self-referencing hierarchy)
-- ---------------------------------------------------------------------
CREATE TABLE employees (
    emp_id          INT            NOT NULL,
    emp_name        VARCHAR(60)    NOT NULL,
    email           VARCHAR(100)   NOT NULL,
    dept_id         INT            NOT NULL,
    manager_id      INT            NULL,            -- Top manager-এর NULL
    job_title       VARCHAR(60)    NOT NULL,
    salary          DECIMAL(10,2)  NOT NULL,
    commission_pct  DECIMAL(4,2)   NULL,            -- শুধু কিছু salesperson-এর, বাকিদের NULL
    hire_date       DATE           NOT NULL,
    status          ENUM('Active','Resigned') NOT NULL DEFAULT 'Active',
    CONSTRAINT pk_employees PRIMARY KEY (emp_id),
    CONSTRAINT uq_employees_email UNIQUE (email),
    CONSTRAINT fk_employees_dept    FOREIGN KEY (dept_id)    REFERENCES departments (dept_id),
    CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id) REFERENCES employees (emp_id),
    CONSTRAINT chk_employees_salary CHECK (salary > 0)
) ENGINE = InnoDB;

-- Department-wise ranking / salary query-র জন্য (PARTITION BY dept_id ORDER BY salary)
CREATE INDEX idx_employees_dept_salary ON employees (dept_id, salary);

-- ---------------------------------------------------------------------
-- 3. customers: ক্রেতা
--    ইচ্ছা করে email-এ UNIQUE দেওয়া হয়নি, যাতে Duplicate Detection অনুশীলন করা যায়।
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id    INT           NOT NULL,
    customer_name  VARCHAR(60)   NOT NULL,
    email          VARCHAR(100)  NOT NULL,
    phone          VARCHAR(20)   NULL,
    city           VARCHAR(40)   NULL,
    segment        ENUM('Retail','Corporate') NOT NULL,
    join_date      DATE          NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id)
) ENGINE = InnoDB;

CREATE INDEX idx_customers_email ON customers (email);

-- ---------------------------------------------------------------------
-- 4. products: পণ্য
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id    INT            NOT NULL,
    product_name  VARCHAR(60)    NOT NULL,
    category      VARCHAR(30)    NOT NULL,
    unit_price    DECIMAL(10,2)  NOT NULL,
    cost_price    DECIMAL(10,2)  NOT NULL,
    launch_date   DATE           NOT NULL,
    is_active     TINYINT(1)     NOT NULL DEFAULT 1,
    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT uq_products_name UNIQUE (product_name),
    CONSTRAINT chk_products_price CHECK (unit_price >= cost_price)
) ENGINE = InnoDB;

CREATE INDEX idx_products_category_price ON products (category, unit_price);

-- ---------------------------------------------------------------------
-- 5. sales: প্রতিটি বিক্রি (transaction-level)
--    total_amount = quantity × unit_price × (1 − discount%), GENERATED column
-- ---------------------------------------------------------------------
CREATE TABLE sales (
    sale_id         INT            NOT NULL,
    sale_date       DATE           NOT NULL,
    customer_id     INT            NOT NULL,
    product_id      INT            NOT NULL,
    emp_id          INT            NOT NULL,          -- যে salesperson বিক্রি করেছেন
    quantity        INT            NOT NULL,
    unit_price      DECIMAL(10,2)  NOT NULL,          -- বিক্রির সময়ের দাম
    discount_pct    DECIMAL(5,2)   NULL,              -- NULL = কোনো ছাড় নেই
    total_amount    DECIMAL(12,2)  GENERATED ALWAYS AS
                    (ROUND(quantity * unit_price * (1 - COALESCE(discount_pct, 0) / 100), 2)) STORED,
    payment_method  ENUM('Cash','Card','bKash','Nagad') NOT NULL,
    CONSTRAINT pk_sales PRIMARY KEY (sale_id),
    CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CONSTRAINT fk_sales_product  FOREIGN KEY (product_id)  REFERENCES products (product_id),
    CONSTRAINT fk_sales_employee FOREIGN KEY (emp_id)      REFERENCES employees (emp_id),
    CONSTRAINT chk_sales_qty CHECK (quantity > 0)
) ENGINE = InnoDB;

-- Window Function-এর সাধারণ PARTITION BY / ORDER BY প্যাটার্ন অনুযায়ী Index
CREATE INDEX idx_sales_date          ON sales (sale_date);
CREATE INDEX idx_sales_customer_date ON sales (customer_id, sale_date);
CREATE INDEX idx_sales_emp_date      ON sales (emp_id, sale_date);
CREATE INDEX idx_sales_product_date  ON sales (product_id, sale_date);

-- ---------------------------------------------------------------------
-- 6. monthly_sales: মাসিক summary (Data Warehouse থেকে আসা pre-aggregated table)
--    MoM, YoY, Moving Average, Target বনাম Actual অনুশীলনের জন্য
-- ---------------------------------------------------------------------
CREATE TABLE monthly_sales (
    id             INT            NOT NULL AUTO_INCREMENT,
    sales_month    DATE           NOT NULL,           -- সবসময় মাসের ১ তারিখ
    category       VARCHAR(30)    NOT NULL,
    revenue        DECIMAL(12,2)  NOT NULL,
    orders_count   INT            NOT NULL,
    target_amount  DECIMAL(12,2)  NULL,               -- 2024 Q1-এ target ঠিক হয়নি → NULL
    CONSTRAINT pk_monthly_sales PRIMARY KEY (id),
    CONSTRAINT uq_monthly_sales UNIQUE (category, sales_month),
    CONSTRAINT chk_monthly_sales_day CHECK (DAY(sales_month) = 1)
) ENGINE = InnoDB;

CREATE INDEX idx_monthly_sales_month ON monthly_sales (sales_month);

-- ---------------------------------------------------------------------
-- 7. employee_attendances: দৈনিক হাজিরা
-- ---------------------------------------------------------------------
CREATE TABLE employee_attendances (
    attendance_id    INT   NOT NULL AUTO_INCREMENT,
    emp_id           INT   NOT NULL,
    attendance_date  DATE  NOT NULL,
    status           ENUM('Present','Late','Absent','Leave') NOT NULL,
    check_in         TIME  NULL,                      -- Absent/Leave হলে NULL
    check_out        TIME  NULL,                      -- punch ভুলে গেলে NULL
    CONSTRAINT pk_employee_attendances PRIMARY KEY (attendance_id),
    CONSTRAINT uq_attendance_emp_date UNIQUE (emp_id, attendance_date),
    CONSTRAINT fk_attendance_employee FOREIGN KEY (emp_id) REFERENCES employees (emp_id)
) ENGINE = InnoDB;

-- ---------------------------------------------------------------------
-- 8. customer_transactions: Customer Wallet-এর লেনদেন (Running Balance-এর জন্য)
--    amount সবসময় ধনাত্মক; চিহ্ন (+/−) txn_type থেকে ঠিক হয়।
-- ---------------------------------------------------------------------
CREATE TABLE customer_transactions (
    txn_id        INT            NOT NULL AUTO_INCREMENT,
    customer_id   INT            NOT NULL,
    txn_datetime  DATETIME       NOT NULL,
    txn_type      ENUM('Deposit','Purchase','Refund','Withdrawal') NOT NULL,
    amount        DECIMAL(12,2)  NOT NULL,
    sale_id       INT            NULL,
    note          VARCHAR(100)   NULL,
    CONSTRAINT pk_customer_transactions PRIMARY KEY (txn_id),
    CONSTRAINT fk_txn_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CONSTRAINT fk_txn_sale     FOREIGN KEY (sale_id)     REFERENCES sales (sale_id),
    CONSTRAINT chk_txn_amount  CHECK (amount > 0)
) ENGINE = InnoDB;

CREATE INDEX idx_txn_customer_time ON customer_transactions (customer_id, txn_datetime);

-- =====================================================================
-- PART B: SAMPLE DATA
-- =====================================================================

-- departments: 6টি (R&D-তে কোনো employee নেই → LEFT JOIN / NULL scenario)
INSERT INTO departments (dept_id, dept_name, location, annual_budget) VALUES
(1, 'Sales', 'Dhaka', 5000000),
(2, 'Marketing', 'Dhaka', 2500000),
(3, 'IT', 'Dhaka', 4000000),
(4, 'HR', 'Chattogram', 1200000),
(5, 'Finance', 'Sylhet', 1800000),
(6, 'Research & Development', 'Khulna', 3000000);

-- employees: 20 জন (Ties: 55000, 48000, 90000, 65000, 50000; commission NULL; self-referencing manager)
INSERT INTO employees (emp_id, emp_name, email, dept_id, manager_id, job_title, salary, commission_pct, hire_date, status) VALUES
(1, 'Rahim Uddin', 'rahim.uddin@company.com.bd', 1, NULL, 'Sales Manager', 95000, NULL, '2018-02-01', 'Active'),
(2, 'Karim Hasan', 'karim.hasan@company.com.bd', 1, 1, 'Sales Executive', 55000, 5.0, '2019-06-15', 'Active'),
(3, 'Fatema Akter', 'fatema.akter@company.com.bd', 1, 1, 'Sales Executive', 55000, 5.0, '2020-03-01', 'Active'),
(4, 'Nusrat Jahan', 'nusrat.jahan@company.com.bd', 1, 1, 'Sales Executive', 48000, 3.0, '2021-07-10', 'Active'),
(5, 'Sabbir Hossain', 'sabbir.hossain@company.com.bd', 1, 1, 'Sales Executive', 48000, 3.0, '2022-01-05', 'Active'),
(6, 'Arif Chowdhury', 'arif.chowdhury@company.com.bd', 1, 1, 'Sales Trainee', 30000, NULL, '2024-02-01', 'Active'),
(7, 'Mitu Rahman', 'mitu.rahman@company.com.bd', 2, NULL, 'Marketing Manager', 88000, NULL, '2018-09-01', 'Active'),
(8, 'Tanvir Ahmed', 'tanvir.ahmed@company.com.bd', 2, 7, 'Digital Marketer', 52000, NULL, '2021-04-12', 'Active'),
(9, 'Sumaiya Islam', 'sumaiya.islam@company.com.bd', 2, 7, 'Content Writer', 40000, NULL, '2022-08-20', 'Active'),
(10, 'Jamal Uddin', 'jamal.uddin@company.com.bd', 3, NULL, 'IT Manager', 120000, NULL, '2017-01-10', 'Active'),
(11, 'Farhana Yasmin', 'farhana.yasmin@company.com.bd', 3, 10, 'Senior Developer', 90000, NULL, '2019-03-01', 'Active'),
(12, 'Imran Kabir', 'imran.kabir@company.com.bd', 3, 10, 'Senior Developer', 90000, NULL, '2020-05-15', 'Active'),
(13, 'Rubina Khatun', 'rubina.khatun@company.com.bd', 3, 10, 'Developer', 65000, NULL, '2022-11-01', 'Active'),
(14, 'Shakil Ahmed', 'shakil.ahmed@company.com.bd', 3, 10, 'Developer', 65000, NULL, '2023-02-01', 'Resigned'),  -- Resigned
(15, 'Nasima Begum', 'nasima.begum@company.com.bd', 4, NULL, 'HR Manager', 75000, NULL, '2016-05-01', 'Active'),
(16, 'Rafiq Islam', 'rafiq.islam@company.com.bd', 4, 15, 'HR Executive', 42000, NULL, '2021-01-20', 'Active'),
(17, 'Kamal Hossain', 'kamal.hossain@company.com.bd', 5, NULL, 'Finance Manager', 98000, NULL, '2017-07-01', 'Active'),
(18, 'Shirin Sultana', 'shirin.sultana@company.com.bd', 5, 17, 'Accountant', 50000, NULL, '2020-10-01', 'Active'),
(19, 'Monir Hossain', 'monir.hossain@company.com.bd', 5, 17, 'Accountant', 50000, NULL, '2021-12-01', 'Active'),
(20, 'Lima Akter', 'lima.akter@company.com.bd', 5, 17, 'Junior Accountant', 35000, NULL, '2024-06-15', 'Active');

-- customers: 15 জন (Duplicate, NULL phone/city, কখনো না কেনা customer)
INSERT INTO customers (customer_id, customer_name, email, phone, city, segment, join_date) VALUES
(1, 'Abdul Karim', 'abdul.karim@mail.com', '01711000001', 'Dhaka', 'Retail', '2023-11-02'),
(2, 'Shirin Akter', 'shirin.akter@mail.com', '01811000002', 'Chattogram', 'Retail', '2023-12-15'),
(3, 'Mahmud Hasan', 'mahmud.hasan@mail.com', '01911000003', 'Dhaka', 'Corporate', '2024-01-08'),
(4, 'Rokeya Begum', 'rokeya.begum@mail.com', NULL, 'Sylhet', 'Retail', '2024-01-20'),  -- phone NULL
(5, 'Selim Reza', 'selim.reza@mail.com', '01611000005', 'Khulna', 'Corporate', '2024-02-01'),
(6, 'Nasrin Sultana', 'nasrin.sultana@mail.com', '01511000006', 'Rajshahi', 'Retail', '2024-02-10'),
(7, 'Habib Rahman', 'habib.rahman@mail.com', NULL, 'Dhaka', 'Retail', '2024-03-18'),  -- phone NULL
(8, 'Jahid Hasan', 'jahid.hasan@mail.com', '01711000008', 'Barishal', 'Retail', '2024-04-05'),
(9, 'Tania Akter', 'tania.akter@mail.com', '01811000009', 'Dhaka', 'Corporate', '2024-05-22'),
(10, 'Mostafa Kamal', 'mostafa.kamal@mail.com', '01911000010', 'Rangpur', 'Retail', '2024-07-01'),
(11, 'Ayesha Siddika', 'ayesha.siddika@mail.com', '01611000011', 'Dhaka', 'Retail', '2024-09-14'),
(12, 'Bashir Ahmed', 'bashir.ahmed@mail.com', '01511000012', NULL, 'Retail', '2025-01-10'),  -- city NULL
(13, 'Shirin Akter', 'shirin.akter@mail.com', '01811000002', 'Chattogram', 'Retail', '2025-03-05'),  -- DUPLICATE of customer 2 (same email)
(14, 'Faruk Hossain', 'faruk.hossain@mail.com', '01711000014', 'Sylhet', 'Corporate', '2025-04-01'),  -- কখনো কিছু কেনেননি
(15, 'Sharmin Nahar', 'sharmin.nahar@mail.com', '01811000015', 'Dhaka', 'Retail', '2025-06-20');  -- নতুন customer (late joiner)

-- products: 16টি, 4 category (দামে Ties, একটি inactive product)
INSERT INTO products (product_id, product_name, category, unit_price, cost_price, launch_date, is_active) VALUES
(1, 'Laptop', 'Electronics', 75000, 62000, '2023-01-01', 1),
(2, 'Smartphone', 'Electronics', 35000, 28000, '2023-01-01', 1),
(3, 'Tablet', 'Electronics', 35000, 27000, '2023-06-01', 1),  -- Smartphone-এর সমান দাম (Tie)
(4, 'Headphones', 'Electronics', 4500, 3000, '2023-01-01', 1),
(5, 'Smartwatch', 'Electronics', 12000, 9000, '2023-09-01', 1),
(6, 'Office Chair', 'Furniture', 15000, 10000, '2023-01-01', 1),
(7, 'Study Table', 'Furniture', 12000, 8000, '2023-01-01', 1),
(8, 'Bookshelf', 'Furniture', 8500, 5500, '2023-01-01', 1),
(9, 'Sofa Set', 'Furniture', 65000, 48000, '2024-06-01', 1),
(10, 'Rice 25kg', 'Grocery', 2200, 1900, '2023-01-01', 1),
(11, 'Soybean Oil 5L', 'Grocery', 950, 820, '2023-01-01', 1),
(12, 'Tea 400g', 'Grocery', 350, 260, '2023-01-01', 1),
(13, 'Panjabi', 'Clothing', 2500, 1500, '2023-01-01', 1),
(14, 'Saree', 'Clothing', 4500, 3000, '2023-01-01', 1),  -- Saree ও Winter Jacket সমান দাম
(15, 'Jeans', 'Clothing', 1800, 1100, '2023-01-01', 1),
(16, 'Winter Jacket', 'Clothing', 4500, 3000, '2024-11-01', 0);  -- Inactive, কখনো বিক্রি হয়নি

-- sales: 132টি (2024-01 থেকে 2025-06; একই দিনে একাধিক sale, Consecutive days, 2টি Duplicate, discount NULL)
-- total_amount একটি GENERATED column, তাই INSERT-এ দেওয়া হয়নি।
INSERT INTO sales (sale_id, sale_date, customer_id, product_id, emp_id, quantity, unit_price, discount_pct, payment_method) VALUES
(1, '2024-01-03', 1, 2, 2, 2, 35000, NULL, 'Cash'),
(2, '2024-01-20', 3, 2, 3, 1, 35000, 10.0, 'Card'),
(3, '2024-01-20', 3, 13, 4, 1, 2500, 10.0, 'Card'),
(4, '2024-01-28', 2, 2, 4, 1, 35000, NULL, 'Nagad'),
(5, '2024-01-31', 1, 6, 5, 1, 15000, NULL, 'bKash'),
(6, '2024-02-02', 2, 14, 2, 2, 4500, 5.0, 'Cash'),
(7, '2024-02-10', 4, 11, 6, 5, 950, NULL, 'Nagad'),
(8, '2024-02-12', 5, 11, 3, 4, 950, NULL, 'Card'),
(9, '2024-02-27', 2, 14, 2, 1, 4500, NULL, 'Card'),
(10, '2024-02-27', 5, 10, 2, 6, 2200, 10.0, 'bKash'),
(11, '2024-02-29', 1, 11, 6, 3, 950, NULL, 'Nagad'),
(12, '2024-03-01', 6, 14, 4, 1, 4500, 10.0, 'bKash'),
(13, '2024-03-07', 1, 1, 3, 1, 75000, 5.0, 'Cash'),
(14, '2024-03-07', 3, 12, 5, 6, 350, NULL, 'bKash'),
(15, '2024-03-11', 3, 2, 5, 2, 35000, NULL, 'Card'),
(16, '2024-03-19', 2, 7, 2, 2, 12000, 10.0, 'Cash'),
(17, '2024-03-22', 3, 8, 2, 1, 8500, 10.0, 'Cash'),
(18, '2024-03-27', 3, 10, 4, 6, 2200, NULL, 'Nagad'),
(19, '2024-03-27', 3, 11, 2, 3, 950, NULL, 'bKash'),
(20, '2024-04-07', 1, 15, 4, 1, 1800, NULL, 'Card'),
(21, '2024-04-19', 4, 10, 5, 1, 2200, NULL, 'Card'),
(22, '2024-04-20', 3, 8, 3, 1, 8500, 5.0, 'Card'),
(23, '2024-04-26', 5, 13, 2, 1, 2500, 10.0, 'Cash'),
(24, '2024-04-30', 3, 14, 4, 1, 4500, 5.0, 'Card'),
(25, '2024-05-01', 7, 4, 6, 2, 4500, 10.0, 'Card'),
(26, '2024-05-06', 5, 14, 3, 4, 4500, 5.0, 'Card'),
(27, '2024-05-15', 6, 8, 5, 1, 8500, NULL, 'Nagad'),
(28, '2024-05-16', 3, 7, 4, 1, 12000, NULL, 'bKash'),
(29, '2024-05-17', 6, 4, 5, 2, 4500, 5.0, 'Cash'),
(30, '2024-05-24', 6, 11, 6, 5, 950, NULL, 'Card'),
(31, '2024-05-25', 2, 8, 2, 2, 8500, NULL, 'Nagad'),
(32, '2024-05-30', 9, 10, 2, 2, 2200, NULL, 'Nagad'),
(33, '2024-06-01', 7, 3, 2, 2, 35000, 10.0, 'bKash'),
(34, '2024-06-03', 7, 2, 3, 2, 35000, 5.0, 'bKash'),
(35, '2024-06-18', 2, 4, 2, 1, 4500, NULL, 'Card'),
(36, '2024-06-20', 2, 10, 5, 1, 2200, 5.0, 'bKash'),
(37, '2024-06-21', 8, 15, 5, 1, 1800, 5.0, 'Nagad'),
(38, '2024-06-24', 5, 8, 6, 1, 8500, 5.0, 'bKash'),
(39, '2024-07-01', 5, 10, 2, 2, 2200, NULL, 'Nagad'),
(40, '2024-07-16', 4, 13, 4, 1, 2500, NULL, 'Cash'),
(41, '2024-07-20', 6, 12, 3, 1, 350, 10.0, 'Card'),
(42, '2024-07-21', 2, 5, 5, 1, 12000, NULL, 'Nagad'),
(43, '2024-07-26', 7, 13, 3, 3, 2500, NULL, 'bKash'),
(44, '2024-07-28', 8, 15, 2, 1, 1800, NULL, 'Card'),
(45, '2024-08-04', 3, 10, 3, 6, 2200, 5.0, 'Card'),
(46, '2024-08-05', 9, 2, 6, 2, 35000, NULL, 'Card'),
(47, '2024-08-15', 7, 8, 4, 2, 8500, 10.0, 'Nagad'),
(48, '2024-08-21', 4, 15, 5, 3, 1800, NULL, 'Cash'),
(49, '2024-08-26', 3, 7, 5, 2, 12000, NULL, 'Nagad'),
(50, '2024-08-29', 8, 4, 5, 1, 4500, NULL, 'Cash'),
(51, '2024-09-01', 10, 14, 4, 1, 4500, NULL, 'bKash'),
(52, '2024-09-02', 1, 13, 5, 4, 2500, NULL, 'Nagad'),
(53, '2024-09-10', 9, 1, 1, 2, 75000, NULL, 'Card'),
(54, '2024-09-11', 4, 11, 3, 2, 950, 10.0, 'bKash'),
(55, '2024-09-24', 6, 5, 6, 1, 12000, NULL, 'Cash'),
(56, '2024-09-27', 10, 14, 4, 3, 4500, NULL, 'Card'),
(57, '2024-10-16', 5, 2, 3, 2, 35000, 5.0, 'Nagad'),
(58, '2024-10-16', 11, 11, 4, 4, 950, 5.0, 'Card'),
(59, '2024-10-18', 7, 3, 2, 2, 35000, NULL, 'Nagad'),
(60, '2024-10-22', 1, 15, 4, 4, 1800, NULL, 'Cash'),
(61, '2024-10-30', 3, 11, 1, 2, 950, 10.0, 'bKash'),
(62, '2024-11-07', 1, 10, 5, 2, 2200, 10.0, 'Nagad'),
(63, '2024-11-09', 2, 15, 3, 1, 1800, 5.0, 'Cash'),
(64, '2024-11-14', 10, 12, 3, 2, 350, NULL, 'Nagad'),
(65, '2024-11-16', 2, 5, 4, 2, 12000, NULL, 'bKash'),
(66, '2024-11-17', 6, 8, 6, 1, 8500, 5.0, 'bKash'),
(67, '2024-11-24', 2, 12, 2, 5, 350, NULL, 'Cash'),
(68, '2024-11-24', 11, 15, 3, 3, 1800, NULL, 'Card'),
(69, '2024-11-30', 10, 6, 2, 1, 15000, NULL, 'Cash'),
(70, '2024-12-06', 2, 4, 2, 2, 4500, 5.0, 'bKash'),
(71, '2024-12-09', 3, 13, 6, 4, 2500, 10.0, 'bKash'),
(72, '2024-12-14', 10, 15, 5, 1, 1800, 10.0, 'Card'),
(73, '2024-12-16', 4, 11, 3, 5, 950, NULL, 'Card'),
(74, '2024-12-17', 4, 2, 6, 2, 35000, 5.0, 'bKash'),
(75, '2024-12-19', 7, 4, 5, 1, 4500, 10.0, 'Card'),
(76, '2024-12-19', 7, 7, 6, 2, 12000, NULL, 'Nagad'),
(77, '2024-12-22', 11, 10, 1, 6, 2200, 10.0, 'bKash'),
(78, '2025-01-07', 3, 7, 3, 2, 12000, NULL, 'Cash'),
(79, '2025-01-08', 3, 7, 5, 2, 12000, 5.0, 'Cash'),
(80, '2025-01-08', 8, 13, 4, 4, 2500, NULL, 'Cash'),
(81, '2025-01-11', 6, 14, 3, 4, 4500, NULL, 'bKash'),
(82, '2025-01-28', 2, 11, 3, 5, 950, NULL, 'Card'),
(83, '2025-01-29', 5, 2, 5, 1, 35000, 10.0, 'Card'),
(84, '2025-01-29', 6, 5, 4, 2, 12000, NULL, 'Cash'),
(85, '2025-01-31', 8, 8, 5, 2, 8500, NULL, 'Card'),
(86, '2025-02-03', 5, 12, 3, 4, 350, NULL, 'bKash'),
(87, '2025-02-05', 12, 5, 5, 1, 12000, NULL, 'bKash'),
(88, '2025-02-08', 10, 13, 4, 3, 2500, NULL, 'Cash'),
(89, '2025-02-13', 1, 3, 2, 2, 35000, NULL, 'Card'),
(90, '2025-02-16', 10, 9, 2, 2, 65000, 10.0, 'Card'),
(91, '2025-02-23', 12, 6, 3, 2, 15000, 10.0, 'Cash'),
(92, '2025-02-26', 5, 2, 4, 1, 35000, NULL, 'bKash'),
(93, '2025-03-03', 8, 11, 4, 4, 950, NULL, 'bKash'),
(94, '2025-03-10', 3, 12, 2, 2, 350, NULL, 'Cash'),
(95, '2025-03-11', 1, 5, 3, 1, 12000, 5.0, 'Card'),
(96, '2025-03-11', 3, 11, 2, 2, 950, NULL, 'bKash'),
(97, '2025-03-12', 1, 15, 4, 2, 1800, NULL, 'Nagad'),
(98, '2025-03-12', 3, 10, 3, 1, 2200, NULL, 'Cash'),
(99, '2025-03-13', 3, 13, 4, 1, 2500, NULL, 'bKash'),
(100, '2025-03-13', 4, 11, 3, 4, 950, 10.0, 'bKash'),
(101, '2025-03-13', 12, 2, 3, 2, 35000, NULL, 'Card'),
(102, '2025-03-16', 3, 4, 2, 1, 4500, NULL, 'Card'),
(103, '2025-03-17', 2, 5, 1, 1, 12000, NULL, 'Nagad'),
(104, '2025-03-17', 3, 12, 5, 3, 350, NULL, 'Cash'),
(105, '2025-03-22', 11, 3, 6, 1, 35000, NULL, 'Cash'),
(106, '2025-03-28', 2, 14, 2, 3, 4500, 10.0, 'bKash'),
(107, '2025-03-28', 6, 13, 3, 2, 2500, NULL, 'Cash'),
(108, '2025-03-28', 13, 14, 2, 2, 4500, NULL, 'bKash'),
(109, '2025-04-02', 4, 7, 4, 2, 12000, NULL, 'Card'),
(110, '2025-04-10', 4, 13, 5, 1, 2500, NULL, 'bKash'),
(111, '2025-04-21', 6, 7, 2, 2, 12000, 10.0, 'Cash'),
(112, '2025-04-28', 10, 1, 6, 2, 75000, NULL, 'Card'),
(113, '2025-04-29', 2, 9, 2, 1, 65000, NULL, 'Card'),
(114, '2025-05-13', 4, 14, 3, 3, 4500, 10.0, 'Card'),
(115, '2025-05-13', 13, 3, 3, 2, 35000, NULL, 'Cash'),
(116, '2025-05-15', 5, 1, 1, 2, 75000, NULL, 'Card'),
(117, '2025-05-19', 12, 2, 6, 2, 35000, NULL, 'Nagad'),
(118, '2025-05-20', 7, 14, 5, 3, 4500, NULL, 'Cash'),
(119, '2025-05-24', 13, 14, 5, 2, 4500, NULL, 'bKash'),
(120, '2025-05-25', 2, 11, 3, 2, 950, 10.0, 'Card'),
(121, '2025-05-25', 5, 13, 2, 3, 2500, NULL, 'bKash'),
(122, '2025-05-27', 13, 2, 3, 1, 35000, NULL, 'Card'),
(123, '2025-06-06', 3, 2, 3, 2, 35000, NULL, 'Nagad'),
(124, '2025-06-06', 5, 2, 4, 2, 35000, NULL, 'Cash'),
(125, '2025-06-12', 3, 10, 1, 1, 2200, NULL, 'bKash'),
(126, '2025-06-16', 4, 14, 6, 4, 4500, NULL, 'Card'),
(127, '2025-06-20', 1, 15, 4, 3, 1800, NULL, 'Card'),
(128, '2025-06-25', 15, 2, 6, 1, 35000, NULL, 'bKash'),
(129, '2025-06-26', 11, 14, 4, 4, 4500, NULL, 'bKash'),
(130, '2025-06-28', 2, 14, 5, 4, 4500, 10.0, 'Cash'),
(131, '2025-05-15', 5, 1, 1, 2, 75000, NULL, 'Card'),  -- DUPLICATE of sale_id 116
(132, '2024-08-04', 3, 10, 3, 6, 2200, 5.0, 'Card');  -- DUPLICATE of sale_id 45

-- monthly_sales: 71টি (2024-01 থেকে 2025-12 × 3 category; একটি Missing month, একটি Tie, target NULL)
INSERT INTO monthly_sales (id, sales_month, category, revenue, orders_count, target_amount) VALUES
(1, '2024-01-01', 'Electronics', 337200.0, 15, NULL),  -- target NULL
(2, '2024-01-01', 'Furniture', 150000.0, 15, NULL),
(3, '2024-01-01', 'Grocery', 79900.0, 52, NULL),
(4, '2024-02-01', 'Electronics', 347100.0, 16, NULL),  -- target NULL
(5, '2024-02-01', 'Furniture', 134300.0, 16, NULL),
(6, '2024-02-01', 'Grocery', 78800.0, 54, NULL),
(7, '2024-03-01', 'Electronics', 435800.0, 23, NULL),  -- target NULL
(8, '2024-03-01', 'Furniture', 188800.0, 19, NULL),
(9, '2024-03-01', 'Grocery', 98000.0, 67, NULL),
(10, '2024-04-01', 'Electronics', 565600.0, 29, 557000.0),
(11, '2024-04-01', 'Furniture', 230500.0, 23, 239000.0),
(12, '2024-04-01', 'Grocery', 126700.0, 86, 126000.0),
(13, '2024-05-01', 'Electronics', 424600.0, 20, 407000.0),
(14, '2024-05-01', 'Furniture', 161200.0, 19, 174000.0),
(15, '2024-05-01', 'Grocery', 87100.0, 57, 92000.0),
(16, '2024-06-01', 'Electronics', 390300.0, 19, 386000.0),
(17, '2024-06-01', 'Furniture', 170400.0, 20, 165000.0),
(18, '2024-06-01', 'Grocery', 80600.0, 49, 87000.0),
(19, '2024-07-01', 'Electronics', 373300.0, 18, 377000.0),
(20, '2024-07-01', 'Grocery', 84000.0, 56, 85000.0),
(21, '2024-08-01', 'Electronics', 399900.0, 18, 394000.0),
(22, '2024-08-01', 'Furniture', 172700.0, 21, 169000.0),  -- Furniture 2024-07 নেই (Missing month)!
(23, '2024-08-01', 'Grocery', 86900.0, 55, 89000.0),
(24, '2024-09-01', 'Electronics', 413800.0, 21, 428000.0),
(25, '2024-09-01', 'Furniture', 169700.0, 19, 184000.0),
(26, '2024-09-01', 'Grocery', 91100.0, 62, 97000.0),
(27, '2024-10-01', 'Electronics', 471600.0, 23, 450000.0),
(28, '2024-10-01', 'Furniture', 192500.0, 22, 193000.0),
(29, '2024-10-01', 'Grocery', 99800.0, 69, 102000.0),
(30, '2024-11-01', 'Electronics', 483000.0, 24, 471000.0),
(31, '2024-11-01', 'Furniture', 189400.0, 21, 202000.0),
(32, '2024-11-01', 'Grocery', 97200.0, 64, 107000.0),
(33, '2024-12-01', 'Electronics', 534100.0, 27, 578000.0),
(34, '2024-12-01', 'Furniture', 257600.0, 31, 248000.0),
(35, '2024-12-01', 'Grocery', 134000.0, 87, 131000.0),
(36, '2025-01-01', 'Electronics', 391800.0, 17, 408000.0),
(37, '2025-01-01', 'Furniture', 166200.0, 20, 169000.0),
(38, '2025-01-01', 'Grocery', 89400.0, 61, 95000.0),
(39, '2025-02-01', 'Electronics', 380000.0, 19, 384000.0),
(40, '2025-02-01', 'Furniture', 152600.0, 18, 159000.0),
(41, '2025-02-01', 'Grocery', 90400.0, 63, 89000.0),
(42, '2025-03-01', 'Electronics', 478100.0, 21, 504000.0),
(43, '2025-03-01', 'Furniture', 197700.0, 24, 208000.0),
(44, '2025-03-01', 'Grocery', 118200.0, 83, 117000.0),
(45, '2025-04-01', 'Electronics', 617100.0, 28, 624000.0),
(46, '2025-04-01', 'Furniture', 266500.0, 32, 258000.0),
(47, '2025-04-01', 'Grocery', 144300.0, 88, 145000.0),
(48, '2025-05-01', 'Electronics', 433000.0, 22, 456000.0),
(49, '2025-05-01', 'Furniture', 193500.0, 23, 188000.0),
(50, '2025-05-01', 'Grocery', 102300.0, 62, 106000.0),
(51, '2025-06-01', 'Electronics', 440100.0, 20, 432000.0),
(52, '2025-06-01', 'Furniture', 168000.0, 19, 178000.0),
(53, '2025-06-01', 'Grocery', 102300.0, 60, 100000.0),  -- 2025-05-এর সমান revenue (Tie)
(54, '2025-07-01', 'Electronics', 402700.0, 18, 422000.0),
(55, '2025-07-01', 'Furniture', 182900.0, 20, 174000.0),
(56, '2025-07-01', 'Grocery', 99700.0, 62, 98000.0),
(57, '2025-08-01', 'Electronics', 450900.0, 19, 441000.0),
(58, '2025-08-01', 'Furniture', 169900.0, 17, 182000.0),
(59, '2025-08-01', 'Grocery', 94500.0, 60, 103000.0),
(60, '2025-09-01', 'Electronics', 487900.0, 22, 480000.0),
(61, '2025-09-01', 'Furniture', 186900.0, 21, 198000.0),
(62, '2025-09-01', 'Grocery', 106100.0, 78, 111000.0),
(63, '2025-10-01', 'Electronics', 478400.0, 22, 504000.0),
(64, '2025-10-01', 'Furniture', 213400.0, 23, 208000.0),
(65, '2025-10-01', 'Grocery', 110800.0, 76, 117000.0),
(66, '2025-11-01', 'Electronics', 485100.0, 24, 528000.0),
(67, '2025-11-01', 'Furniture', 213300.0, 22, 218000.0),
(68, '2025-11-01', 'Grocery', 124000.0, 88, 123000.0),
(69, '2025-12-01', 'Electronics', 675100.0, 35, 648000.0),
(70, '2025-12-01', 'Furniture', 272300.0, 28, 268000.0),
(71, '2025-12-01', 'Grocery', 142300.0, 99, 150000.0);

-- employee_attendances: 86টি (2025-03-01 থেকে 03-15, 6 জন salesperson/marketer)
-- Absent/Leave-এ check_in NULL; কিছু দিনে check_out NULL (punch ভুলে গেছেন); emp 8-এর কিছু দিন row-ই নেই (off day)
INSERT INTO employee_attendances (attendance_id, emp_id, attendance_date, status, check_in, check_out) VALUES
(1, 2, '2025-03-01', 'Present', '09:02:00', '18:27:00'),
(2, 2, '2025-03-02', 'Present', '09:05:00', '17:14:00'),
(3, 2, '2025-03-03', 'Present', '09:13:00', '17:04:00'),
(4, 2, '2025-03-04', 'Present', '09:13:00', '18:24:00'),
(5, 2, '2025-03-05', 'Present', '09:13:00', '17:18:00'),
(6, 2, '2025-03-06', 'Absent', NULL, NULL),
(7, 2, '2025-03-07', 'Present', '09:06:00', '17:35:00'),
(8, 2, '2025-03-08', 'Present', '09:02:00', '18:57:00'),
(9, 2, '2025-03-09', 'Present', '09:00:00', '18:38:00'),
(10, 2, '2025-03-10', 'Present', '09:04:00', '17:19:00'),
(11, 2, '2025-03-11', 'Leave', NULL, NULL),
(12, 2, '2025-03-12', 'Present', '09:03:00', '17:40:00'),
(13, 2, '2025-03-13', 'Present', '09:09:00', '18:58:00'),
(14, 2, '2025-03-14', 'Present', '09:13:00', '18:12:00'),
(15, 2, '2025-03-15', 'Present', '09:12:00', '17:33:00'),
(16, 3, '2025-03-01', 'Present', '09:07:00', '17:38:00'),
(17, 3, '2025-03-02', 'Present', '09:06:00', '17:03:00'),
(18, 3, '2025-03-03', 'Present', '09:14:00', '17:55:00'),
(19, 3, '2025-03-04', 'Present', '09:07:00', '18:13:00'),
(20, 3, '2025-03-05', 'Present', '09:07:00', '18:25:00'),
(21, 3, '2025-03-06', 'Present', '09:10:00', '18:55:00'),
(22, 3, '2025-03-07', 'Present', '09:07:00', '18:42:00'),
(23, 3, '2025-03-08', 'Present', '09:08:00', '17:57:00'),
(24, 3, '2025-03-09', 'Present', '09:09:00', '17:08:00'),
(25, 3, '2025-03-10', 'Present', '09:10:00', '17:25:00'),
(26, 3, '2025-03-11', 'Present', '09:13:00', '17:04:00'),
(27, 3, '2025-03-12', 'Present', '09:12:00', '18:48:00'),
(28, 3, '2025-03-13', 'Present', '09:11:00', '18:56:00'),
(29, 3, '2025-03-14', 'Present', '09:05:00', '17:01:00'),
(30, 3, '2025-03-15', 'Present', '09:10:00', '18:28:00'),
(31, 4, '2025-03-01', 'Present', '09:08:00', '17:06:00'),
(32, 4, '2025-03-02', 'Present', '09:08:00', '17:48:00'),
(33, 4, '2025-03-03', 'Absent', NULL, NULL),
(34, 4, '2025-03-04', 'Absent', NULL, NULL),
(35, 4, '2025-03-05', 'Present', '09:00:00', '18:21:00'),
(36, 4, '2025-03-06', 'Present', '09:02:00', '18:34:00'),
(37, 4, '2025-03-07', 'Present', '09:11:00', '18:21:00'),
(38, 4, '2025-03-08', 'Present', '09:00:00', '18:43:00'),
(39, 4, '2025-03-09', 'Absent', NULL, NULL),
(40, 4, '2025-03-10', 'Present', '09:11:00', '17:05:00'),
(41, 4, '2025-03-11', 'Present', '09:11:00', '18:39:00'),
(42, 4, '2025-03-12', 'Present', '09:01:00', '18:41:00'),
(43, 4, '2025-03-13', 'Late', '09:53:00', '18:34:00'),
(44, 4, '2025-03-14', 'Present', '09:04:00', '17:31:00'),
(45, 4, '2025-03-15', 'Present', '09:09:00', '17:41:00'),
(46, 5, '2025-03-01', 'Late', '09:45:00', '17:18:00'),
(47, 5, '2025-03-02', 'Present', '09:11:00', '17:59:00'),
(48, 5, '2025-03-03', 'Late', '09:40:00', '17:04:00'),
(49, 5, '2025-03-04', 'Present', '09:14:00', '18:48:00'),
(50, 5, '2025-03-05', 'Present', '09:09:00', '18:33:00'),
(51, 5, '2025-03-06', 'Late', '09:42:00', '18:00:00'),
(52, 5, '2025-03-07', 'Present', '09:01:00', '18:15:00'),
(53, 5, '2025-03-08', 'Present', '09:13:00', '17:19:00'),
(54, 5, '2025-03-09', 'Late', '09:35:00', '18:57:00'),
(55, 5, '2025-03-10', 'Present', '09:12:00', '17:07:00'),
(56, 5, '2025-03-11', 'Late', '09:55:00', '17:55:00'),
(57, 5, '2025-03-12', 'Present', '09:11:00', '17:21:00'),
(58, 5, '2025-03-13', 'Present', '09:02:00', '18:43:00'),
(59, 5, '2025-03-14', 'Late', '09:47:00', '17:36:00'),
(60, 5, '2025-03-15', 'Present', '09:14:00', '17:14:00'),
(61, 6, '2025-03-01', 'Absent', NULL, NULL),
(62, 6, '2025-03-02', 'Absent', NULL, NULL),
(63, 6, '2025-03-03', 'Present', '09:07:00', '17:08:00'),
(64, 6, '2025-03-04', 'Present', '09:03:00', '18:46:00'),
(65, 6, '2025-03-05', 'Present', '09:11:00', '17:59:00'),
(66, 6, '2025-03-06', 'Present', '09:00:00', '18:07:00'),
(67, 6, '2025-03-07', 'Present', '09:03:00', NULL),
(68, 6, '2025-03-08', 'Present', '09:00:00', '18:59:00'),
(69, 6, '2025-03-09', 'Present', '09:12:00', '17:19:00'),
(70, 6, '2025-03-10', 'Present', '09:05:00', '17:48:00'),
(71, 6, '2025-03-11', 'Present', '09:10:00', '17:53:00'),
(72, 6, '2025-03-12', 'Present', '09:11:00', '18:23:00'),
(73, 6, '2025-03-13', 'Present', '09:07:00', NULL),
(74, 6, '2025-03-14', 'Present', '09:14:00', '18:20:00'),
(75, 6, '2025-03-15', 'Present', '09:11:00', '18:16:00'),
(76, 8, '2025-03-01', 'Present', '09:05:00', '18:44:00'),
(77, 8, '2025-03-02', 'Present', '09:01:00', '18:36:00'),
(78, 8, '2025-03-03', 'Present', '09:03:00', '17:40:00'),
(79, 8, '2025-03-06', 'Present', '09:13:00', '18:58:00'),
(80, 8, '2025-03-07', 'Present', '09:01:00', '17:31:00'),
(81, 8, '2025-03-08', 'Present', '09:02:00', '18:09:00'),
(82, 8, '2025-03-09', 'Present', '09:11:00', '17:30:00'),
(83, 8, '2025-03-10', 'Present', '09:14:00', '17:33:00'),
(84, 8, '2025-03-13', 'Present', '09:11:00', '17:42:00'),
(85, 8, '2025-03-14', 'Present', '09:13:00', '18:55:00'),
(86, 8, '2025-03-15', 'Present', '09:01:00', '18:58:00');

-- customer_transactions: Wallet লেনদেন (Running Balance; একই timestamp-এ দুটি লেনদেন; overdraft)
INSERT INTO customer_transactions (txn_id, customer_id, txn_datetime, txn_type, amount, sale_id, note) VALUES
(1, 1, '2025-01-02 10:15:00', 'Deposit', 20000, NULL, 'Opening deposit'),
(2, 1, '2025-01-05 12:30:00', 'Purchase', 9500, NULL, 'Online order'),
(3, 1, '2025-01-05 18:45:00', 'Purchase', 2200, NULL, 'Grocery'),
(4, 1, '2025-01-12 09:00:00', 'Deposit', 15000, NULL, 'Top-up'),
(5, 1, '2025-01-20 14:10:00', 'Purchase', 12000, NULL, 'Smartwatch'),
(6, 1, '2025-01-22 11:00:00', 'Refund', 2200, NULL, 'Returned rice'),
(7, 1, '2025-02-03 16:20:00', 'Withdrawal', 5000, NULL, 'Cash out'),
(8, 1, '2025-02-10 10:00:00', 'Purchase', 3600, NULL, 'Jeans'),
(9, 3, '2025-01-03 09:30:00', 'Deposit', 50000, NULL, 'Corporate wallet'),
(10, 3, '2025-01-03 09:30:00', 'Purchase', 35000, NULL, 'Same timestamp as deposit (Tie)'),
(11, 3, '2025-01-15 13:00:00', 'Purchase', 12000, NULL, 'Study table'),
(12, 3, '2025-02-01 10:00:00', 'Deposit', 30000, NULL, 'Top-up'),
(13, 3, '2025-02-14 15:30:00', 'Purchase', 15000, NULL, 'Office chair'),
(14, 3, '2025-02-14 15:45:00', 'Purchase', 4500, NULL, 'Headphones'),
(15, 3, '2025-03-01 11:00:00', 'Refund', 4500, NULL, 'Headphones returned'),
(16, 5, '2025-01-10 10:00:00', 'Deposit', 80000, NULL, 'Corporate wallet'),
(17, 5, '2025-01-18 12:00:00', 'Purchase', 75000, NULL, 'Laptop'),
(18, 5, '2025-02-02 10:30:00', 'Purchase', 12000, NULL, 'Overdraft! balance negative'),
(19, 5, '2025-02-05 09:00:00', 'Deposit', 20000, NULL, 'Top-up'),
(20, 5, '2025-02-25 17:00:00', 'Purchase', 8500, NULL, 'Bookshelf'),
(21, 5, '2025-03-10 10:00:00', 'Withdrawal', 2000, NULL, 'Cash out'),
(22, 9, '2025-02-01 09:00:00', 'Deposit', 10000, NULL, 'First deposit'),
(23, 9, '2025-02-20 13:00:00', 'Purchase', 4500, NULL, 'Saree'),
(24, 9, '2025-03-15 10:00:00', 'Purchase', 5000, NULL, 'Mixed items');


-- =====================================================================
-- PART C: VERIFICATION (Setup ঠিক হয়েছে কিনা যাচাই)
-- প্রত্যাশিত row সংখ্যা Word ফাইলের "Setup ও Testing" অংশে দেওয়া আছে।
-- =====================================================================
SELECT 'departments' AS table_name, COUNT(*) AS total_rows FROM departments
UNION ALL SELECT 'employees',             COUNT(*) FROM employees
UNION ALL SELECT 'customers',             COUNT(*) FROM customers
UNION ALL SELECT 'products',              COUNT(*) FROM products
UNION ALL SELECT 'sales',                 COUNT(*) FROM sales
UNION ALL SELECT 'monthly_sales',         COUNT(*) FROM monthly_sales
UNION ALL SELECT 'employee_attendances',  COUNT(*) FROM employee_attendances
UNION ALL SELECT 'customer_transactions', COUNT(*) FROM customer_transactions;

-- Window Function কাজ করছে কিনা (MySQL 8.0+ না হলে এখানে Error আসবে)
SELECT VERSION() AS mysql_version,
       ROW_NUMBER() OVER () AS window_function_ok;
