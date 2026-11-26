---
title: "MySQL Window Functions — Basic থেকে Advanced"
subtitle: "হাতে-কলমে বাংলা কোর্স (MySQL 8.0+)"
---

# সূচিপত্র

- **কোর্স পরিচিতি**
- **Learning Roadmap**
- **Practical Database Setup**
- **Module 1: Foundation**
    - Lesson 1.1 — Window Function কী এবং কেন?
    - Lesson 1.2 — GROUP BY বনাম Window Function (Aggregate বনাম Window)
    - Lesson 1.3 — OVER(), PARTITION BY এবং ORDER BY
    - Lesson 1.4 — Basic Syntax পূর্ণাঙ্গ রূপ এবং SELECT Query-তে Window Function-এর অবস্থান
- **Module 2: Ranking Functions**
    - Lesson 2.1 — ROW_NUMBER()
    - Lesson 2.2 — RANK(), DENSE_RANK() এবং Ties
    - Lesson 2.3 — NTILE()
    - Lesson 2.4 — Top N per Department এবং Ties-এর প্রভাব
- **Module 3: Aggregate Window Functions**
    - Lesson 3.1 — SUM, AVG, COUNT, MIN, MAX OVER(): GROUP BY ছাড়াই Aggregate
    - Lesson 3.2 — Running Total এবং Cumulative Average
    - Lesson 3.3 — GROUP BY + Window: মাসিক Running Total ও Share
- **Module 4: Window Frame**
    - Lesson 4.1 — Window Frame কী? (UNBOUNDED, CURRENT ROW, PRECEDING, FOLLOWING)
    - Lesson 4.2 — Moving Average এবং Rolling Sum
    - Lesson 4.3 — ROWS বনাম RANGE: বাস্তব পার্থক্য
- **Module 5: Advanced Window Functions (LAG, LEAD, FIRST_VALUE, LAST_VALUE, NTH_VALUE)**
    - Lesson 5.1 — LAG() এবং LEAD(): আগের ও পরের Row
    - Lesson 5.2 — মাসভিত্তিক Sales Growth: আগের মাসের সঙ্গে তুলনা
    - Lesson 5.3 — FIRST_VALUE(), LAST_VALUE(), NTH_VALUE() এবং LAST_VALUE-এর Frame সমস্যা
- **Module 6: Advanced SQL Problem Solving**
    - Lesson 6.1 — Top 3 Products per Category এবং প্রতিটি Department-এর Highest Paid Employee
    - Lesson 6.2 — Duplicate Record শনাক্তকরণ এবং অপসারণ
    - Lesson 6.3 — Consecutive Days Activity এবং Gaps & Islands
    - Lesson 6.4 — Running Balance Calculation
    - Lesson 6.5 — Month-over-Month ও Year-over-Year Growth (Missing Month সহ) এবং Moving Average
    - Lesson 6.6 — Median Calculation
    - Lesson 6.7 — Customer Purchase Analysis
    - Lesson 6.8 — Advanced Business Intelligence Queries
- **Module 7: Performance এবং Best Practices**
    - Lesson 7.1 — Window Function-এর Performance, Index এবং PARTITION BY / ORDER BY-এর প্রভাব
    - Lesson 7.2 — Subquery, CTE, Derived Table, একাধিক Window Function, Common Mistakes ও Debugging
- **Final Project: Sales Analysis with Window Functions**
    - প্রজেক্ট পরিচিতি
    - ধাপ ০: Data Cleaning, একটি পরিষ্কার VIEW
    - Task 1: Top 3 Products per Category (Revenue অনুযায়ী)
    - Task 2: প্রতিটি Customer-এর Purchase Ranking
    - Task 3–6: Monthly Sales Dashboard (Running Total, Moving Average, Previous Month Comparison, MoM ও YoY Growth)
    - Task 7: Salesperson Performance Ranking (2025)
    - Task 8: Customer Purchase Trend Analysis
    - প্রজেক্ট Extension Challenges (নিজে করুন)
- **কোর্স সমাপ্তি ও পরবর্তী ধাপ**

# কোর্স পরিচিতি

এই কোর্সে MySQL **Window Function** একদম শুরু থেকে Advanced Level পর্যন্ত ধাপে ধাপে শেখানো হয়েছে। প্রতিটি Query **MySQL 8.0.46**-এ চালিয়ে আসল Output এখানে বসানো হয়েছে, তাই আপনি নিজে চালালেও হুবহু একই ফলাফল পাবেন। (যেসব Query-তে ORDER BY নেই, সেখানে row-এর ক্রম আলাদা হতে পারে। Data একই থাকবে।)

**কীভাবে পড়বেন:**

1. প্রথমে নিচের **Practical Database** অংশের SQL চালিয়ে Database তৈরি করুন।
2. প্রতিটি Lesson পড়ুন, Query নিজে টাইপ করে চালান। Copy-paste না করে নিজে টাইপ করলে বেশি মনে থাকবে।
3. প্রতিটি Lesson-এর শেষে **Practice Problems** আর **Quiz** আছে। এদের Solution এই ফাইলে **ইচ্ছা করেই দেওয়া হয়নি**। আপনার Query চ্যাটে পাঠান, আমি যাচাই করব। ভুল হলে কেন ভুল হলো বুঝিয়ে দিয়ে সঠিক Query লিখতে সাহায্য করব।
4. একটা Lesson ভালোভাবে বুঝলে তবেই পরেরটায় যান। চ্যাটে **"Ready"** লিখলে পরের Lesson নিয়ে আলোচনা শুরু করব।

# Learning Roadmap

| Module | বিষয় | Level | কী শিখবেন |
|---|---|---|---|
| 1 | Foundation | Beginner | Window Function কী, GROUP BY-এর সঙ্গে পার্থক্য, OVER(), PARTITION BY, ORDER BY, Syntax, SELECT-এ অবস্থান |
| 2 | Ranking Functions | Beginner → Intermediate | ROW_NUMBER, RANK, DENSE_RANK, NTILE, Ties, Top N per Group |
| 3 | Aggregate Window Functions | Intermediate | SUM/AVG/COUNT/MIN/MAX OVER(), Running Total, Cumulative Average |
| 4 | Window Frame | Intermediate → Advanced | ROWS vs RANGE, UNBOUNDED/CURRENT ROW/PRECEDING/FOLLOWING, Moving Average, Rolling Sum |
| 5 | Advanced (Value) Window Functions | Advanced | LAG, LEAD, FIRST_VALUE, LAST_VALUE, NTH_VALUE, Growth Comparison |
| 6 | Advanced SQL Problem Solving | Advanced | Top N, Duplicates, Gaps & Islands, Running Balance, MoM/YoY, Median, BI Queries |
| 7 | Performance ও Best Practices | Advanced | Index, EXPLAIN, CTE/Derived Table, একাধিক Window, Common Mistakes, Debugging |
| ★ | Final Project | Capstone | পুরো Sales Analysis Project |

**মডিউলগুলোর মধ্যে সম্পর্ক:** Module 1-এর `OVER (PARTITION BY ... ORDER BY ...)` সব জায়গায় লাগবে। Module 2-এর Ranking দিয়ে "কে কত নম্বরে" বের করা যায়। Module 3-এ Aggregate (SUM, AVG) দিয়ে "এ পর্যন্ত মোট কত" হিসাব করা শিখবেন। Module 4-এ শিখবেন সেই "এ পর্যন্ত" ঠিক কতগুলো row নিয়ে (Frame)। Module 5-এ আগের/পরের row-এর মান পড়া শিখবেন। Module 6-এ সব মিলিয়ে বাস্তব সমস্যার সমাধান হবে, আর Module 7-এ সেগুলো দ্রুত ও নির্ভুল রাখার কৌশল।

# Practical Database Setup

আমরা একটি কাল্পনিক বাংলাদেশি Retail কোম্পানির Database বানাব। এতে ৫টি Table থাকবে: `departments`, `employees`, `products`, `customers`, `sales`।

Data ইচ্ছা করে এমনভাবে সাজানো হয়েছে যাতে প্র্যাকটিসের সুবিধা হয়:

- **Ties:** একই Department-এ একই Salary আছে (Sales-এ 62000, IT-তে 72000, Finance-এ 78000)।
- **Duplicate:** `customers`-এ একই email দুবার আছে, আর `sales`-এ একটি sale দুবার entry হয়েছে।
- **একই তারিখে একাধিক sale:** ROWS আর RANGE-এর পার্থক্য দেখার জন্য।
- **Consecutive days:** Customer 3 পরপর কয়েক দিন কেনাকাটা করেছেন (Gaps & Islands-এর জন্য)।
- **দুই বছরের Data:** 2024 ও 2025-এর Jan–Jun (YoY Growth-এর জন্য)। 2024-এর Jul–Dec ইচ্ছা করে নেই, এটা একটা ফাঁদ যা Module 6-এ ধরা হবে।

```sql
-- ধাপ ১: Database তৈরি
CREATE DATABASE IF NOT EXISTS window_lab;
USE window_lab;

-- ধাপ ২: Tables
DROP TABLE IF EXISTS sales, employees, departments, products, customers;

CREATE TABLE departments (
    dept_id    INT PRIMARY KEY,
    dept_name  VARCHAR(50) NOT NULL,
    location   VARCHAR(50)
);

CREATE TABLE employees (
    emp_id     INT PRIMARY KEY,
    emp_name   VARCHAR(50) NOT NULL,
    dept_id    INT,
    salary     INT NOT NULL,
    hire_date  DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE products (
    product_id    INT PRIMARY KEY,
    product_name  VARCHAR(50) NOT NULL,
    category      VARCHAR(30) NOT NULL,
    price         INT NOT NULL
);

CREATE TABLE customers (
    customer_id    INT PRIMARY KEY,
    customer_name  VARCHAR(50) NOT NULL,
    city           VARCHAR(30),
    email          VARCHAR(80),
    join_date      DATE
);

CREATE TABLE sales (
    sale_id      INT PRIMARY KEY,
    sale_date    DATE NOT NULL,
    customer_id  INT,
    product_id   INT,
    emp_id       INT,          -- কোন salesperson বিক্রি করেছেন
    quantity     INT NOT NULL,
    amount       INT NOT NULL, -- quantity * price (টাকা)
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    FOREIGN KEY (emp_id)      REFERENCES employees(emp_id)
);

-- ধাপ ৩: Data
INSERT INTO departments VALUES
(1, 'Sales',   'Dhaka'),
(2, 'IT',      'Dhaka'),
(3, 'HR',      'Chattogram'),
(4, 'Finance', 'Sylhet');

INSERT INTO employees VALUES
(1,  'Rahim Uddin',     1, 55000, '2019-03-15'),
(2,  'Karim Hasan',     1, 62000, '2018-07-01'),
(3,  'Fatema Akter',    1, 62000, '2020-01-10'),
(4,  'Nusrat Jahan',    1, 48000, '2021-05-20'),
(5,  'Tanvir Ahmed',    2, 85000, '2017-09-12'),
(6,  'Sabbir Hossain',  2, 72000, '2019-11-01'),
(7,  'Mitu Rahman',     2, 72000, '2020-06-15'),
(8,  'Arif Chowdhury',  2, 65000, '2022-02-01'),
(9,  'Sumaiya Islam',   3, 45000, '2019-04-01'),
(10, 'Jamal Uddin',     3, 52000, '2016-08-20'),
(11, 'Farhana Yasmin',  4, 78000, '2018-01-15'),
(12, 'Imran Kabir',     4, 78000, '2021-03-01'),
(13, 'Rubina Khatun',   4, 60000, '2023-07-10');

INSERT INTO products VALUES
(1,  'Laptop',          'Electronics', 75000),
(2,  'Smartphone',      'Electronics', 35000),
(3,  'Headphones',      'Electronics',  4500),
(4,  'Smartwatch',      'Electronics', 12000),
(5,  'Office Chair',    'Furniture',   15000),
(6,  'Study Table',     'Furniture',   12000),
(7,  'Bookshelf',       'Furniture',    8500),
(8,  'Rice 25kg',       'Grocery',      2200),
(9,  'Soybean Oil 5L',  'Grocery',       950),
(10, 'Tea 400g',        'Grocery',       350),
(11, 'Panjabi',         'Clothing',     2500),
(12, 'Saree',           'Clothing',     4500),
(13, 'Jeans',           'Clothing',     1800);

INSERT INTO customers VALUES
(1, 'Abdul Karim',    'Dhaka',      'abdul.karim@mail.com',  '2023-11-02'),
(2, 'Shirin Akter',   'Chattogram', 'shirin.akter@mail.com', '2023-12-15'),
(3, 'Mahmud Hasan',   'Dhaka',      'mahmud.hasan@mail.com', '2024-01-08'),
(4, 'Rokeya Begum',   'Sylhet',     'rokeya.begum@mail.com', '2024-01-20'),
(5, 'Selim Reza',     'Khulna',     'selim.reza@mail.com',   '2024-02-01'),
(6, 'Nasrin Sultana', 'Rajshahi',   'nasrin.s@mail.com',     '2024-02-10'),
(7, 'Habib Rahman',   'Dhaka',      'habib.rahman@mail.com', '2024-02-18'),
(8, 'Shirin Akter',   'Chattogram', 'shirin.akter@mail.com', '2025-05-01'); -- Duplicate!

INSERT INTO sales VALUES
(1,  '2024-01-05', 1,  2, 1, 1,  35000),
(2,  '2024-01-12', 2,  8, 2, 3,   6600),
(3,  '2024-01-20', 3,  5, 3, 1,  15000),
(4,  '2024-01-28', 4, 11, 4, 2,   5000),
(5,  '2024-02-03', 5,  1, 1, 1,  75000),
(6,  '2024-02-14', 6, 12, 2, 2,   9000),
(7,  '2024-02-22', 7,  9, 3, 4,   3800),
(8,  '2024-03-02', 1,  4, 2, 1,  12000),
(9,  '2024-03-15', 3, 13, 1, 3,   5400),
(10, '2024-03-25', 2,  6, 4, 1,  12000),
(11, '2024-04-04', 4,  3, 3, 2,   9000),
(12, '2024-04-18', 5, 10, 1, 5,   1750),
(13, '2024-04-27', 6,  7, 2, 1,   8500),
(14, '2024-05-06', 7,  2, 4, 1,  35000),
(15, '2024-05-19', 1,  8, 3, 2,   4400),
(16, '2024-05-30', 3, 11, 1, 3,   7500),
(17, '2024-06-08', 2,  5, 2, 2,  30000),
(18, '2024-06-21', 4, 12, 3, 1,   4500),
(19, '2025-01-05', 1,  1, 1, 1,  75000),
(20, '2025-01-05', 2,  3, 2, 2,   9000),
(21, '2025-01-17', 5,  9, 3, 6,   5700),
(22, '2025-01-29', 6, 13, 4, 2,   3600),
(23, '2025-02-07', 7,  2, 1, 1,  35000),
(24, '2025-02-16', 3,  6, 2, 1,  12000),
(25, '2025-02-25', 4,  8, 3, 3,   6600),
(26, '2025-03-10', 3, 10, 1, 2,    700),
(27, '2025-03-11', 3,  9, 1, 2,   1900),
(28, '2025-03-11', 1,  4, 2, 1,  12000),
(29, '2025-03-12', 3,  8, 2, 1,   2200),
(30, '2025-03-12', 1, 13, 3, 2,   3600),
(31, '2025-03-15', 3, 11, 4, 1,   2500),
(32, '2025-03-16', 3,  3, 1, 1,   4500),
(33, '2025-03-28', 5,  1, 2, 1,  75000),
(34, '2025-04-03', 2,  2, 3, 1,  35000),
(35, '2025-04-14', 6,  5, 4, 2,  30000),
(36, '2025-04-22', 7, 12, 1, 2,   9000),
(37, '2025-04-30', 4,  7, 2, 1,   8500),
(38, '2025-05-09', 1,  2, 1, 1,  35000),
(39, '2025-05-09', 8, 12, 3, 1,   4500),
(40, '2025-05-20', 5,  4, 4, 2,  24000),
(41, '2025-05-31', 6,  8, 2, 4,   8800),
(42, '2025-06-06', 7,  1, 1, 1,  75000),
(43, '2025-06-18', 2,  6, 2, 2,  24000),
(44, '2025-06-18', 2,  6, 2, 2,  24000), -- Duplicate entry!
(45, '2025-06-27', 3, 13, 3, 3,   5400);
```

Database তৈরি হয়ে গেলে প্রতিটি Table একবার দেখে নিন:

```sql
SELECT * FROM departments;
```

**Output:**

| dept_id | dept_name | location |
|---|---|---|
| 1 | Sales | Dhaka |
| 2 | IT | Dhaka |
| 3 | HR | Chattogram |
| 4 | Finance | Sylhet |

_(4 rows)_

```sql
SELECT * FROM employees;
```

**Output:**

| emp_id | emp_name | dept_id | salary | hire_date |
|---|---|---|---|---|
| 1 | Rahim Uddin | 1 | 55000 | 2019-03-15 |
| 2 | Karim Hasan | 1 | 62000 | 2018-07-01 |
| 3 | Fatema Akter | 1 | 62000 | 2020-01-10 |
| 4 | Nusrat Jahan | 1 | 48000 | 2021-05-20 |
| 5 | Tanvir Ahmed | 2 | 85000 | 2017-09-12 |
| 6 | Sabbir Hossain | 2 | 72000 | 2019-11-01 |
| 7 | Mitu Rahman | 2 | 72000 | 2020-06-15 |
| 8 | Arif Chowdhury | 2 | 65000 | 2022-02-01 |
| 9 | Sumaiya Islam | 3 | 45000 | 2019-04-01 |
| 10 | Jamal Uddin | 3 | 52000 | 2016-08-20 |
| 11 | Farhana Yasmin | 4 | 78000 | 2018-01-15 |
| 12 | Imran Kabir | 4 | 78000 | 2021-03-01 |
| 13 | Rubina Khatun | 4 | 60000 | 2023-07-10 |

_(13 rows)_

```sql
SELECT * FROM products;
```

**Output:**

| product_id | product_name | category | price |
|---|---|---|---|
| 1 | Laptop | Electronics | 75000 |
| 2 | Smartphone | Electronics | 35000 |
| 3 | Headphones | Electronics | 4500 |
| 4 | Smartwatch | Electronics | 12000 |
| 5 | Office Chair | Furniture | 15000 |
| 6 | Study Table | Furniture | 12000 |
| 7 | Bookshelf | Furniture | 8500 |
| 8 | Rice 25kg | Grocery | 2200 |
| 9 | Soybean Oil 5L | Grocery | 950 |
| 10 | Tea 400g | Grocery | 350 |
| 11 | Panjabi | Clothing | 2500 |
| 12 | Saree | Clothing | 4500 |
| 13 | Jeans | Clothing | 1800 |

_(13 rows)_

```sql
SELECT * FROM customers;
```

**Output:**

| customer_id | customer_name | city | email | join_date |
|---|---|---|---|---|
| 1 | Abdul Karim | Dhaka | abdul.karim@mail.com | 2023-11-02 |
| 2 | Shirin Akter | Chattogram | shirin.akter@mail.com | 2023-12-15 |
| 3 | Mahmud Hasan | Dhaka | mahmud.hasan@mail.com | 2024-01-08 |
| 4 | Rokeya Begum | Sylhet | rokeya.begum@mail.com | 2024-01-20 |
| 5 | Selim Reza | Khulna | selim.reza@mail.com | 2024-02-01 |
| 6 | Nasrin Sultana | Rajshahi | nasrin.s@mail.com | 2024-02-10 |
| 7 | Habib Rahman | Dhaka | habib.rahman@mail.com | 2024-02-18 |
| 8 | Shirin Akter | Chattogram | shirin.akter@mail.com | 2025-05-01 |

_(8 rows)_

`sales` Table-এ ৪৫টি row আছে (উপরের INSERT দেখুন)। Lesson-গুলোতে প্রয়োজন অনুযায়ী এর অংশবিশেষ ব্যবহার করা হবে।

> **দ্রষ্টব্য:** Window Function চলে শুধু **MySQL 8.0 বা তার পরের** সংস্করণে। আপনার version দেখতে `SELECT VERSION();` চালান।


# Module 1: Foundation

## Lesson 1.1 — Window Function কী এবং কেন?

### ১. Topic Introduction

Window Function এমন এক ধরনের Function যা **প্রতিটি row আলাদা রেখেই** তার আশেপাশের সম্পর্কিত row-গুলোর ওপর হিসাব করে। সেই হিসাবের ফল ওই row-এর পাশে নতুন column হিসেবে বসিয়ে দেয়।

### ২. সহজ বাংলা ব্যাখ্যা

ধরুন একটি ক্লাসে ৩০ জন ছাত্র আছে। শিক্ষক চান প্রতিটি ছাত্রের নম্বরের পাশে **ক্লাসের গড় নম্বর**ও লেখা থাকুক, যাতে বোঝা যায় কে গড়ের ওপরে আর কে নিচে।

- `GROUP BY` দিয়ে গড় বের করলে ৩০টি row ভেঙে **১টি row** হয়ে যায়। ছাত্রদের নাম আর দেখা যায় না।
- **Window Function** দিয়ে গড় বের করলে ৩০টি row-ই থাকে। প্রতিটির পাশে গড়টা বসে যায়।

"Window" মানে জানালা। প্রতিটি row যেন একটা জানালা দিয়ে তার সম্পর্কিত অন্য row-গুলোর দিকে তাকায়, হিসাব করে, আর ফলাফল নিজের পাশে লিখে রাখে। নিজে কিন্তু হারিয়ে যায় না।

**কেন ব্যবহার করি?**

- Row-এর detail আর summary একসঙ্গে দেখাতে (যেমন salary আর department average পাশাপাশি)।
- Ranking বের করতে (১ম, ২য়, ৩য়…)।
- Running Total আর Moving Average হিসাব করতে।
- আগের বা পরের row-এর সঙ্গে তুলনা করতে (গত মাসের তুলনায় এ মাসে বিক্রি কত বাড়ল)।
- জটিল Subquery আর Self-Join ছাড়াই ছোট, পরিষ্কার Query লিখতে।

### ৩. Syntax

```text
function_name(expression) OVER (
    [PARTITION BY column_list]
    [ORDER BY column_list]
    [frame_clause]
)
```

`OVER` শব্দটাই একটা সাধারণ function-কে Window Function বানায়। `OVER`-এর ভেতরের তিনটি অংশই ঐচ্ছিক। এগুলো আমরা ধাপে ধাপে শিখব।

### ৪. Sample Data

এই Lesson-এ `employees` Table ব্যবহার হবে (Setup অংশে দেখুন: ১৩ জন employee, ৪টি department)।

### ৫. SQL Query

প্রতিটি employee-র salary-র পাশে পুরো কোম্পানির গড় salary দেখাই:

```sql
SELECT
    emp_name,
    dept_id,
    salary,
    ROUND(AVG(salary) OVER (), 2) AS company_avg_salary,
    salary - ROUND(AVG(salary) OVER (), 2) AS diff_from_avg
FROM employees
ORDER BY emp_id;
```

### ৬. Expected Output



**Output:**

| emp_name | dept_id | salary | company_avg_salary | diff_from_avg |
|---|---|---|---|---|
| Rahim Uddin | 1 | 55000 | 64153.85 | -9153.85 |
| Karim Hasan | 1 | 62000 | 64153.85 | -2153.85 |
| Fatema Akter | 1 | 62000 | 64153.85 | -2153.85 |
| Nusrat Jahan | 1 | 48000 | 64153.85 | -16153.85 |
| Tanvir Ahmed | 2 | 85000 | 64153.85 | 20846.15 |
| Sabbir Hossain | 2 | 72000 | 64153.85 | 7846.15 |
| Mitu Rahman | 2 | 72000 | 64153.85 | 7846.15 |
| Arif Chowdhury | 2 | 65000 | 64153.85 | 846.15 |
| Sumaiya Islam | 3 | 45000 | 64153.85 | -19153.85 |
| Jamal Uddin | 3 | 52000 | 64153.85 | -12153.85 |
| Farhana Yasmin | 4 | 78000 | 64153.85 | 13846.15 |
| Imran Kabir | 4 | 78000 | 64153.85 | 13846.15 |
| Rubina Khatun | 4 | 60000 | 64153.85 | -4153.85 |

_(13 rows)_

লক্ষ্য করুন, ১৩টি row-ই আছে, আর প্রতিটির পাশে একই গড় (64153.85) বসেছে।

### ৭. Line-by-line Explanation

- `SELECT emp_name, dept_id, salary`: সাধারণ column, প্রতিটি row-এর নিজস্ব মান।
- `AVG(salary)`: Aggregate function, গড় বের করে।
- `OVER ()`: খালি বন্ধনী মানে "পুরো result set-ই একটা window"। তাই ১৩ জনের গড় বের হয়।
- `ROUND(..., 2)`: দশমিকের পর ২ ঘর রাখে।
- `salary - ... AS diff_from_avg`: Window Function-এর ফল দিয়ে সাধারণ গণিতও করা যায়।
- `ORDER BY emp_id`: শেষ ফলাফল সাজানো।

### ৮. Common Mistakes

1. **MySQL 5.7 বা পুরনো version-এ চালানো।** সেখানে `OVER` চেনে না, Syntax Error দেয়।
2. **`OVER` ভুলে যাওয়া।** `AVG(salary)` লিখে `OVER()` না দিলে এটা সাধারণ Aggregate হয়ে যায়। তখন অন্য column-এর সঙ্গে মিশিয়ে লিখলে Error আসে।
3. **ভাবা যে Window Function row কমায়।** কমায় না। যতগুলো row ঢোকে, ততগুলোই বের হয়।

### ৯. Practice Problems

- **Beginner:** প্রতিটি employee-র নাম, salary আর পুরো কোম্পানির **মোট salary** (`SUM`) একসঙ্গে দেখান।
- **Intermediate:** প্রতিটি employee-র পাশে কোম্পানির **সর্বোচ্চ salary** দেখান, আর সর্বোচ্চ salary থেকে সে কত কম পায় সেটাও দেখান।
- **Advanced:** প্রতিটি employee-র salary মোট payroll-এর কত শতাংশ (দশমিকের পর ২ ঘর), সেটা বের করুন।

### ১০. ছোট Quiz

1. Window Function কি result-এর row সংখ্যা কমায়? (হ্যাঁ/না)
2. `OVER ()`-এর খালি বন্ধনী কী বোঝায়?
3. কোন MySQL version থেকে Window Function পাওয়া যায়?

---

## Lesson 1.2 — GROUP BY বনাম Window Function (Aggregate বনাম Window)

### ১. Topic Introduction

আগের Lesson-এ দেখলাম Window Function row কমায় না। এবার `GROUP BY`-এর সঙ্গে পাশাপাশি রেখে দেখব দুটো ঠিক কোথায় আলাদা, আর কখন কোনটা দরকার।

### ২. সহজ বাংলা ব্যাখ্যা

বাজারের উদাহরণ নিন। আপনার কাছে প্রতিটি বিক্রির রসিদ আছে।

- **GROUP BY** হলো রসিদগুলো দোকান অনুযায়ী ভাগ করে প্রতিটি দোকানের জন্য **একটা সারাংশ কাগজ** বানানো। আলাদা রসিদগুলো আর দেখা যায় না।
- **Window Function** হলো প্রতিটি রসিদের কোণায় লিখে দেওয়া "এই দোকানের মোট বিক্রি = X"। সব রসিদ থেকে যায়, সঙ্গে সারাংশও থাকে।

| বিষয় | GROUP BY + Aggregate | Window Function |
|---|---|---|
| Output row | প্রতি group-এ ১টি row | Input-এর সব row থাকে |
| Detail column দেখানো | যায় না (Error বা অর্থহীন মান) | যায় |
| Group নির্ধারণ | `GROUP BY` clause | `OVER (PARTITION BY ...)` |
| একই Query-তে আলাদা আলাদা grouping | কঠিন | সহজ (প্রতিটি column-এ আলাদা OVER) |
| ব্যবহার | Report-এর সারাংশ | Detail + Summary, Ranking, Running Total |

### ৩. Syntax

```text
-- GROUP BY
SELECT group_col, AGG(col) FROM t GROUP BY group_col;

-- Window
SELECT col1, col2, AGG(col) OVER (PARTITION BY group_col) FROM t;
```

### ৪. Sample Data

`employees` Table (১৩ row)।

### ৫. SQL Query

**(ক) GROUP BY দিয়ে department-এর গড় salary:**

```sql
SELECT
    dept_id,
    COUNT(*)              AS total_emp,
    ROUND(AVG(salary), 2) AS dept_avg_salary
FROM employees
GROUP BY dept_id
ORDER BY dept_id;
```

**(খ) GROUP BY-তে employee-র নাম দেখাতে চাইলে কী হয়?**

```sql
SELECT emp_name, dept_id, AVG(salary)
FROM employees
GROUP BY dept_id;
```

**(গ) Window Function দিয়ে একই গড়, কিন্তু প্রতিটি employee-র পাশে:**

```sql
SELECT
    emp_name,
    dept_id,
    salary,
    ROUND(AVG(salary) OVER (PARTITION BY dept_id), 2) AS dept_avg_salary
FROM employees
ORDER BY dept_id, salary DESC;
```

### ৬. Expected Output

**(ক)-এর Output:** মাত্র ৪টি row।



**Output:**

| dept_id | total_emp | dept_avg_salary |
|---|---|---|
| 1 | 4 | 56750.00 |
| 2 | 4 | 73500.00 |
| 3 | 2 | 48500.00 |
| 4 | 3 | 72000.00 |

_(4 rows)_

**(খ)-এর ফলাফল:** Error!



**MySQL Error:**

```text
ERROR 1055 (42000): Expression #1 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'window_lab.employees.emp_name' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by
```

MySQL 8-এ ডিফল্টভাবে `ONLY_FULL_GROUP_BY` চালু থাকে। একটি department-এ ৪ জন থাকলে কোন `emp_name` দেখাবে, MySQL সেটা জানে না। তাই Error দেয়।

**(গ)-এর Output:** ১৩টি row-ই আছে, প্রতিটির পাশে নিজের department-এর গড়।



**Output:**

| emp_name | dept_id | salary | dept_avg_salary |
|---|---|---|---|
| Karim Hasan | 1 | 62000 | 56750.00 |
| Fatema Akter | 1 | 62000 | 56750.00 |
| Rahim Uddin | 1 | 55000 | 56750.00 |
| Nusrat Jahan | 1 | 48000 | 56750.00 |
| Tanvir Ahmed | 2 | 85000 | 73500.00 |
| Sabbir Hossain | 2 | 72000 | 73500.00 |
| Mitu Rahman | 2 | 72000 | 73500.00 |
| Arif Chowdhury | 2 | 65000 | 73500.00 |
| Jamal Uddin | 3 | 52000 | 48500.00 |
| Sumaiya Islam | 3 | 45000 | 48500.00 |
| Farhana Yasmin | 4 | 78000 | 72000.00 |
| Imran Kabir | 4 | 78000 | 72000.00 |
| Rubina Khatun | 4 | 60000 | 72000.00 |

_(13 rows)_

### ৭. Line-by-line Explanation

- (ক) `GROUP BY dept_id`: ১৩টি row-কে ৪টি গ্রুপে ভেঙে প্রতিটি গ্রুপ থেকে ১টি row বানায়।
- (খ) `emp_name` কোনো Aggregate-এর ভেতরে নেই, `GROUP BY`-তেও নেই, তাই Error।
- (গ) `AVG(salary) OVER (PARTITION BY dept_id)`: প্রতিটি row-এর জন্য "আমার department-এর সবার গড়" হিসাব করে। row ভাঙে না।
- (গ) `ORDER BY dept_id, salary DESC`: শুধু দেখানোর সুবিধার জন্য সাজানো।

**Window Function আসার আগে একই কাজ কীভাবে হতো?** Derived table আর JOIN দিয়ে:

```sql
SELECT e.emp_name, e.dept_id, e.salary, d.dept_avg_salary
FROM employees e
JOIN (
    SELECT dept_id, ROUND(AVG(salary), 2) AS dept_avg_salary
    FROM employees
    GROUP BY dept_id
) d ON d.dept_id = e.dept_id
ORDER BY e.dept_id, e.salary DESC;
```

এটাও একই ফল দেয়, কিন্তু Query লম্বা, আর Table দুবার পড়তে হয়। Window Function-এ এক লাইনেই কাজ শেষ।

### ৮. Common Mistakes

1. **GROUP BY আর Window একসঙ্গে মিশিয়ে ভুল বোঝা।** `GROUP BY` থাকলে Window Function চলে **গ্রুপ হয়ে যাওয়া row-এর ওপর** (Lesson 1.4-এ দেখবেন)।
2. **`PARTITION BY` আর `GROUP BY` একই ভাবা।** Partition row ভাঙে না, শুধু হিসাবের সীমা ঠিক করে।
3. **`ONLY_FULL_GROUP_BY` বন্ধ করে Error "ঠিক" করা।** এতে ভুল (random) নাম দেখায়। সঠিক সমাধান হলো Window Function।

### ৯. Practice Problems

- **Beginner:** `GROUP BY` দিয়ে প্রতিটি department-এর মোট salary বের করুন।
- **Intermediate:** Window Function দিয়ে প্রতিটি employee-র নাম, salary আর তার department-এর **মোট salary** দেখান।
- **Advanced:** প্রতিটি employee-র পাশে department-এর গড় salary দেখান, আর `above_avg` নামে একটি column বানান যেখানে salary গড়ের বেশি হলে `'Yes'`, না হলে `'No'` থাকবে।

### ১০. ছোট Quiz

1. ১৩টি row-এর Table-এ `GROUP BY dept_id` (৪টি department) দিলে কতটি row আসবে? আর `AVG(...) OVER (PARTITION BY dept_id)` দিলে কতটি?
2. `ONLY_FULL_GROUP_BY` Error কেন আসে?
3. `PARTITION BY` কি row মুছে ফেলে?

---

## Lesson 1.3 — OVER(), PARTITION BY এবং ORDER BY

### ১. Topic Introduction

`OVER()` clause-এর ভেতরের দুটি প্রধান অংশ হলো `PARTITION BY` আর `ORDER BY`। প্রথমটি ঠিক করে **কোন row-গুলো একসঙ্গে হিসাব হবে**, দ্বিতীয়টি ঠিক করে **সেই গ্রুপের ভেতরে row-গুলোর ক্রম কী হবে**।

### ২. সহজ বাংলা ব্যাখ্যা

একটা স্কুলের বার্ষিক পরীক্ষার ফলাফল ভাবুন:

- **`OVER ()`** = পুরো স্কুল একটা গ্রুপ।
- **`OVER (PARTITION BY class)`** = প্রতিটি ক্লাস আলাদা গ্রুপ। ক্লাস 6-এর হিসাব ক্লাস 7-এর সঙ্গে মিশবে না।
- **`OVER (PARTITION BY class ORDER BY marks DESC)`** = প্রতিটি ক্লাসের ভেতরে নম্বর অনুযায়ী লাইনে দাঁড় করানো। তাহলে রোল (Rank) দেওয়া যায়, বা "এ পর্যন্ত মোট" গোনা যায়।

গুরুত্বপূর্ণ কথা: `OVER`-এর ভেতরের `ORDER BY` আর Query-র শেষের `ORDER BY` **আলাদা জিনিস**।

- `OVER (ORDER BY ...)` ঠিক করে হিসাব কোন ক্রমে হবে।
- Query-র শেষের `ORDER BY` ঠিক করে ফলাফল কোন ক্রমে দেখাবে।

### ৩. Syntax

```text
AGG_OR_RANK_FUNCTION(...) OVER (
    PARTITION BY col_a [, col_b ...]     -- গ্রুপ ভাগ
    ORDER BY col_x [ASC|DESC] [, ...]    -- গ্রুপের ভেতরের ক্রম
)
```

### ৪. Sample Data

`employees` Table।

### ৫. SQL Query

**(ক) খালি OVER() বনাম PARTITION BY:**

```sql
SELECT
    emp_name,
    dept_id,
    COUNT(*) OVER ()                     AS total_employees,
    COUNT(*) OVER (PARTITION BY dept_id) AS employees_in_dept
FROM employees
ORDER BY dept_id, emp_id;
```

**(খ) OVER-এর ভেতরে ORDER BY: হিসাব "ক্রমবর্ধমান" হয়ে যায়:**

```sql
SELECT
    emp_name,
    hire_date,
    salary,
    SUM(salary) OVER (ORDER BY hire_date) AS running_payroll
FROM employees
ORDER BY hire_date;
```

**(গ) PARTITION BY + ORDER BY একসঙ্গে:**

```sql
SELECT
    emp_name,
    dept_id,
    salary,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC, emp_id) AS pos_in_dept
FROM employees
ORDER BY dept_id, pos_in_dept;
```

### ৬. Expected Output

**(ক):**



**Output:**

| emp_name | dept_id | total_employees | employees_in_dept |
|---|---|---|---|
| Rahim Uddin | 1 | 13 | 4 |
| Karim Hasan | 1 | 13 | 4 |
| Fatema Akter | 1 | 13 | 4 |
| Nusrat Jahan | 1 | 13 | 4 |
| Tanvir Ahmed | 2 | 13 | 4 |
| Sabbir Hossain | 2 | 13 | 4 |
| Mitu Rahman | 2 | 13 | 4 |
| Arif Chowdhury | 2 | 13 | 4 |
| Sumaiya Islam | 3 | 13 | 2 |
| Jamal Uddin | 3 | 13 | 2 |
| Farhana Yasmin | 4 | 13 | 3 |
| Imran Kabir | 4 | 13 | 3 |
| Rubina Khatun | 4 | 13 | 3 |

_(13 rows)_

**(খ):** প্রতিটি row-এ "শুরু থেকে এই row পর্যন্ত" salary যোগ হচ্ছে।



**Output:**

| emp_name | hire_date | salary | running_payroll |
|---|---|---|---|
| Jamal Uddin | 2016-08-20 | 52000 | 52000 |
| Tanvir Ahmed | 2017-09-12 | 85000 | 137000 |
| Farhana Yasmin | 2018-01-15 | 78000 | 215000 |
| Karim Hasan | 2018-07-01 | 62000 | 277000 |
| Rahim Uddin | 2019-03-15 | 55000 | 332000 |
| Sumaiya Islam | 2019-04-01 | 45000 | 377000 |
| Sabbir Hossain | 2019-11-01 | 72000 | 449000 |
| Fatema Akter | 2020-01-10 | 62000 | 511000 |
| Mitu Rahman | 2020-06-15 | 72000 | 583000 |
| Imran Kabir | 2021-03-01 | 78000 | 661000 |
| Nusrat Jahan | 2021-05-20 | 48000 | 709000 |
| Arif Chowdhury | 2022-02-01 | 65000 | 774000 |
| Rubina Khatun | 2023-07-10 | 60000 | 834000 |

_(13 rows)_

**(গ):** প্রতিটি department-এ আলাদা করে ১ থেকে গোনা শুরু।



**Output:**

| emp_name | dept_id | salary | pos_in_dept |
|---|---|---|---|
| Karim Hasan | 1 | 62000 | 1 |
| Fatema Akter | 1 | 62000 | 2 |
| Rahim Uddin | 1 | 55000 | 3 |
| Nusrat Jahan | 1 | 48000 | 4 |
| Tanvir Ahmed | 2 | 85000 | 1 |
| Sabbir Hossain | 2 | 72000 | 2 |
| Mitu Rahman | 2 | 72000 | 3 |
| Arif Chowdhury | 2 | 65000 | 4 |
| Jamal Uddin | 3 | 52000 | 1 |
| Sumaiya Islam | 3 | 45000 | 2 |
| Farhana Yasmin | 4 | 78000 | 1 |
| Imran Kabir | 4 | 78000 | 2 |
| Rubina Khatun | 4 | 60000 | 3 |

_(13 rows)_

### ৭. Line-by-line Explanation

- (ক) `COUNT(*) OVER ()`: পুরো Table একটা window, তাই সবার পাশে 13।
- (ক) `COUNT(*) OVER (PARTITION BY dept_id)`: প্রতিটি department আলাদা window। Sales-এ 4, HR-এ 2।
- (খ) `SUM(salary) OVER (ORDER BY hire_date)`: `PARTITION BY` নেই, তাই পুরো Table একটা গ্রুপ। কিন্তু `ORDER BY` থাকায় প্রতিটি row-এ শুধু **প্রথম row থেকে বর্তমান row পর্যন্ত** যোগ হয়। একেই **Running Total** বলে। কেন এমন হয়, তার পেছনের নিয়ম ("Default Frame") Module 4-এ বিস্তারিত দেখবেন।
- (গ) `ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC, emp_id)`: প্রতিটি department-এর ভেতরে বেশি salary আগে রেখে 1, 2, 3… নম্বর দেয়। দুজনের salary সমান হলে `emp_id` দিয়ে ক্রম নিশ্চিত করা হয়েছে।

**মনে রাখুন:**

| OVER-এর ভেতরে | ফলাফল |
|---|---|
| কিছুই নেই | পুরো result একটা window, সব row-এ একই মান |
| শুধু PARTITION BY | প্রতিটি group-এ একই মান |
| শুধু ORDER BY | পুরো result-এ ক্রমবর্ধমান (running) মান |
| PARTITION BY + ORDER BY | প্রতিটি group-এ আলাদা করে ক্রমবর্ধমান মান |

### ৮. Common Mistakes

1. **`OVER`-এর `ORDER BY` দিলেই result সাজানো থাকবে ভাবা।** নিশ্চিত নয়। দেখানোর ক্রম চাইলে Query-র শেষে `ORDER BY` দিন।
2. **Aggregate-এ অজান্তে `ORDER BY` দেওয়া।** `SUM(...) OVER (PARTITION BY dept_id ORDER BY salary)` দিলে department-এর মোট আসে না, running total আসে।
3. **Non-unique ORDER BY।** দুজনের salary সমান হলে `ROW_NUMBER` কাকে আগে দেবে তা নিশ্চিত নয়। একটি unique column (যেমন `emp_id`) যোগ করুন।

### ৯. Practice Problems

- **Beginner:** প্রতিটি employee-র পাশে তার department-এ সর্বোচ্চ salary (`MAX ... OVER (PARTITION BY ...)`) দেখান।
- **Intermediate:** `hire_date` অনুযায়ী প্রতিটি department-এর ভেতরে employee-দের 1, 2, 3… নম্বর দিন (কে আগে যোগ দিয়েছে)।
- **Advanced:** প্রতিটি department-এর ভেতরে `hire_date` অনুযায়ী **running payroll** বের করুন। অর্থাৎ ওই department-এ এ পর্যন্ত যোগ দেওয়া সবার মোট salary।

### ১০. ছোট Quiz

1. `PARTITION BY` আর `ORDER BY`, কোনটি গ্রুপ ভাগ করে?
2. `SUM(salary) OVER ()` আর `SUM(salary) OVER (ORDER BY hire_date)`, এ দুটোর ফল কেন আলাদা?
3. `OVER`-এর `ORDER BY` কি final result সাজানোর নিশ্চয়তা দেয়?

---

## Lesson 1.4 — Basic Syntax পূর্ণাঙ্গ রূপ এবং SELECT Query-তে Window Function-এর অবস্থান

### ১. Topic Introduction

এই Lesson-এ দুটি প্রশ্নের উত্তর দেব: (১) Window Function-এর পূর্ণ Syntax কী, যার মধ্যে Named Window (`WINDOW` clause) আছে? (২) Query execution-এর কোন ধাপে Window Function চলে, আর কেন `WHERE`-এ এটা ব্যবহার করা যায় না?

### ২. সহজ বাংলা ব্যাখ্যা

একটা রান্নাঘরে কাজ ধাপে ধাপে হয়: বাজার থেকে সবজি আনা (FROM), পচাগুলো বাদ দেওয়া (WHERE), ধরন অনুযায়ী ভাগ করা (GROUP BY), কিছু ভাগ বাদ দেওয়া (HAVING), তারপর রান্না (Window Function, SELECT), পরিবেশন (ORDER BY, LIMIT)।

রান্না হওয়ার **আগে** আপনি "রান্না করা তরকারির স্বাদ" দেখে সবজি বাদ দিতে পারবেন না। ঠিক তেমনি, Window Function-এর ফল তৈরি হয় `WHERE`-এর **পরে**। তাই `WHERE`-এ এর ফল দিয়ে filter করা যায় না।

**MySQL-এ Query-র Logical Execution Order:**

| ক্রম | ধাপ | কাজ |
|---|---|---|
| 1 | FROM / JOIN | Table থেকে row আনা |
| 2 | WHERE | Row filter |
| 3 | GROUP BY | Group বানানো |
| 4 | HAVING | Group filter |
| 5 | **Window Functions** | Window হিসাব |
| 6 | SELECT (alias) | Column/alias তৈরি |
| 7 | DISTINCT | Duplicate বাদ |
| 8 | ORDER BY | সাজানো |
| 9 | LIMIT | সংখ্যা সীমিত |

এই কারণে:

- Window Function লেখা যায় **শুধু `SELECT` list আর `ORDER BY`-এ**।
- `WHERE`, `GROUP BY` বা `HAVING`-এ লেখা যায় না।
- Window-এর ফল দিয়ে filter করতে হলে **CTE বা Subquery** লাগে।

### ৩. Syntax

```text
SELECT
    col,
    func(...) OVER w AS alias1,              -- Named window ব্যবহার
    func(...) OVER (w ROWS ...) AS alias2    -- Named window বাড়িয়ে নেওয়া
FROM table
[WHERE ...]
[GROUP BY ...]
[HAVING ...]
WINDOW w AS (PARTITION BY ... ORDER BY ...)  -- HAVING-এর পরে, ORDER BY-এর আগে
[ORDER BY ...]
[LIMIT ...];
```

একই window অনেকবার লাগলে `WINDOW` clause-এ একবার নাম দিয়ে সংজ্ঞা লিখুন, তারপর বারবার ব্যবহার করুন।

### ৪. Sample Data

`employees` Table।

### ৫. SQL Query

**(ক) Named Window: একই window তিনবার ব্যবহার:**

```sql
SELECT
    emp_name,
    dept_id,
    salary,
    MIN(salary) OVER w AS dept_min,
    MAX(salary) OVER w AS dept_max,
    ROUND(AVG(salary) OVER w, 2) AS dept_avg
FROM employees
WINDOW w AS (PARTITION BY dept_id)
ORDER BY dept_id, salary DESC;
```

**(খ) WHERE-এ Window Function: ভুল পদ্ধতি**

```sql
SELECT emp_name, dept_id, salary
FROM employees
WHERE ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC) = 1;
```

**(গ) সঠিক পদ্ধতি: CTE দিয়ে আগে হিসাব, পরে filter**

```sql
WITH ranked AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary DESC, emp_id) AS rn
    FROM employees
)
SELECT emp_name, dept_id, salary
FROM ranked
WHERE rn = 1
ORDER BY dept_id;
```

**(ঘ) WHERE আগে চলে, তাই Window শুধু filter-এর পরের row দেখে:**

```sql
SELECT
    emp_name,
    salary,
    COUNT(*) OVER () AS rows_in_window
FROM employees
WHERE dept_id = 2;
```

**(ঙ) GROUP BY-এর ফলের ওপর Window Function:**

```sql
SELECT
    dept_id,
    SUM(salary)                AS dept_total,
    SUM(SUM(salary)) OVER ()   AS company_total,
    ROUND(100 * SUM(salary) / SUM(SUM(salary)) OVER (), 2) AS pct_of_company
FROM employees
GROUP BY dept_id
ORDER BY dept_id;
```

### ৬. Expected Output

**(ক):**



**Output:**

| emp_name | dept_id | salary | dept_min | dept_max | dept_avg |
|---|---|---|---|---|---|
| Karim Hasan | 1 | 62000 | 48000 | 62000 | 56750.00 |
| Fatema Akter | 1 | 62000 | 48000 | 62000 | 56750.00 |
| Rahim Uddin | 1 | 55000 | 48000 | 62000 | 56750.00 |
| Nusrat Jahan | 1 | 48000 | 48000 | 62000 | 56750.00 |
| Tanvir Ahmed | 2 | 85000 | 65000 | 85000 | 73500.00 |
| Sabbir Hossain | 2 | 72000 | 65000 | 85000 | 73500.00 |
| Mitu Rahman | 2 | 72000 | 65000 | 85000 | 73500.00 |
| Arif Chowdhury | 2 | 65000 | 65000 | 85000 | 73500.00 |
| Jamal Uddin | 3 | 52000 | 45000 | 52000 | 48500.00 |
| Sumaiya Islam | 3 | 45000 | 45000 | 52000 | 48500.00 |
| Farhana Yasmin | 4 | 78000 | 60000 | 78000 | 72000.00 |
| Imran Kabir | 4 | 78000 | 60000 | 78000 | 72000.00 |
| Rubina Khatun | 4 | 60000 | 60000 | 78000 | 72000.00 |

_(13 rows)_

**(খ):** Error



**MySQL Error:**

```text
ERROR 3593 (HY000): You cannot use the window function 'row_number' in this context.'
```

**(গ):**



**Output:**

| emp_name | dept_id | salary |
|---|---|---|
| Karim Hasan | 1 | 62000 |
| Tanvir Ahmed | 2 | 85000 |
| Jamal Uddin | 3 | 52000 |
| Farhana Yasmin | 4 | 78000 |

_(4 rows)_

(Sales আর Finance-এ দুজনের salary সমান, কিন্তু `ROW_NUMBER` শুধু একজনকে দেখাচ্ছে। Ties সামলানো শিখবেন Module 2-এ।)

**(ঘ):** `rows_in_window` = 4, 13 নয়। কারণ `WHERE` আগে চলে।



**Output:**

| emp_name | salary | rows_in_window |
|---|---|---|
| Tanvir Ahmed | 85000 | 4 |
| Sabbir Hossain | 72000 | 4 |
| Mitu Rahman | 72000 | 4 |
| Arif Chowdhury | 65000 | 4 |

_(4 rows)_

**(ঙ):**



**Output:**

| dept_id | dept_total | company_total | pct_of_company |
|---|---|---|---|
| 1 | 227000 | 834000 | 27.22 |
| 2 | 294000 | 834000 | 35.25 |
| 3 | 97000 | 834000 | 11.63 |
| 4 | 216000 | 834000 | 25.90 |

_(4 rows)_

### ৭. Line-by-line Explanation

- (ক) `WINDOW w AS (PARTITION BY dept_id)`: window-এর একটা নাম দেওয়া হলো `w`। এটা `FROM`/`WHERE`-এর পরে আর `ORDER BY`-এর আগে বসে।
- (ক) `MIN(salary) OVER w`: বন্ধনী ছাড়া `OVER w` লিখলে Named Window ব্যবহার হয়।
- (খ) MySQL Error 3593: `WHERE`-এর সময় Window Function-এর মান তৈরিই হয়নি।
- (গ) `WITH ranked AS (...)`: প্রথমে একটা অস্থায়ী result (CTE) বানানো হলো, যেখানে `rn` column আছে। বাইরের Query-তে `WHERE rn = 1` এখন সাধারণ column-এর মতো কাজ করে।
- (ঘ) `WHERE dept_id = 2` আগে চলে ৪টি row রাখে। তারপর `COUNT(*) OVER ()` সেই ৪টি row-ই দেখে।
- (ঙ) `SUM(SUM(salary)) OVER ()`: ভেতরের `SUM(salary)` হলো GROUP BY-এর Aggregate (প্রতি department-এর মোট)। বাইরের `SUM(...) OVER ()` হলো Window, যা ৪টি গ্রুপ-row-এর মোট বের করে। দুই স্তরের হিসাব একটি Query-তেই হয়ে গেল।

### ৮. Common Mistakes

1. **`WHERE` বা `HAVING`-এ Window Function লেখা।** Error 3593 আসবে। সমাধান: CTE বা Derived Table।
2. **একই Query-র `WHERE`-এ Window column-এর alias ব্যবহার।** `WHERE rn = 1` একই স্তরে কাজ করে না। বাইরের Query-তে নিতে হবে।
3. **`WINDOW` clause ভুল জায়গায় লেখা।** এটা `HAVING`-এর পরে আর `ORDER BY`-এর আগে বসে।
4. **`SUM(SUM(x)) OVER ()` দেখে ভয় পাওয়া।** এটা বৈধ, আর GROUP BY-এর পরে খুব কাজের।

### ৯. Practice Problems

- **Beginner:** একটি Named Window (`WINDOW w AS (PARTITION BY dept_id)`) ব্যবহার করে প্রতিটি employee-র পাশে department-এর মোট salary আর employee সংখ্যা দেখান।
- **Intermediate:** CTE ব্যবহার করে প্রতিটি department-এ সবচেয়ে **আগে যোগ দেওয়া** employee-কে বের করুন (`hire_date` অনুযায়ী)।
- **Advanced:** `GROUP BY dept_id` করে প্রতিটি department-এর employee সংখ্যা বের করুন, আর একই Query-তে Window Function দিয়ে মোট employee-র কত শতাংশ ওই department-এ আছে সেটা দেখান।

### ১০. ছোট Quiz

1. Window Function কোন কোন clause-এ লেখা যায়?
2. `WHERE` আর Window Function-এর মধ্যে কোনটা আগে চলে?
3. `SUM(SUM(salary)) OVER ()`-এ ভেতরের আর বাইরের `SUM` আলাদাভাবে কী করে?

> **Module 1 শেষ।** এখন আপনি জানেন Window Function কী, `OVER`-এর তিনটি অংশ কী, আর Query-তে এটা কোথায় বসে। Module 2-এ এই জ্ঞান দিয়েই Ranking শিখব। আপনার Practice-এর উত্তর পাঠান, তারপর **"Ready"** লিখুন।


# Module 2: Ranking Functions

**আগের Module-এর সঙ্গে সম্পর্ক:** Lesson 1.3-এ `ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...)` এক ঝলক দেখেছিলেন। Ranking Function-এ `ORDER BY` **বাধ্যতামূলক**, কারণ ক্রম ছাড়া "প্রথম" বা "দ্বিতীয়" বলার কোনো মানে হয় না। আর `PARTITION BY` দিলে প্রতিটি গ্রুপে আলাদা করে ranking শুরু হয়।

## Lesson 2.1 — ROW_NUMBER()

### ১. Topic Introduction

`ROW_NUMBER()` প্রতিটি row-কে 1, 2, 3… এভাবে একটি **অনন্য (unique)** ক্রমিক নম্বর দেয়। দুটি row-এর মান সমান হলেও নম্বর আলাদা হবে।

### ২. সহজ বাংলা ব্যাখ্যা

ব্যাংকের লাইনে টোকেন নম্বরের কথা ভাবুন। দুজন একই সময়ে এলেও একজন 7 পাবে, অন্যজন 8। একই নম্বর কখনো দুজনকে দেওয়া হয় না। `ROW_NUMBER()` ঠিক এভাবে কাজ করে।

**ব্যবহার:** Pagination (প্রতি পাতায় ১০টি row), প্রতি গ্রুপ থেকে ঠিক ১টি row নেওয়া, Duplicate খোঁজা (Module 6)।

### ৩. Syntax

```text
ROW_NUMBER() OVER (
    [PARTITION BY partition_cols]
    ORDER BY sort_cols
)
```

### ৪. Sample Data

`employees` Table। মনে রাখুন: Karim ও Fatema (Sales) দুজনেরই salary 62000, Sabbir ও Mitu (IT) দুজনেরই 72000।

### ৫. SQL Query

**(ক) পুরো কোম্পানিতে salary অনুযায়ী ক্রমিক নম্বর:**

```sql
SELECT
    ROW_NUMBER() OVER (ORDER BY salary DESC, emp_id) AS row_num,
    emp_name,
    dept_id,
    salary
FROM employees
ORDER BY row_num;
```

**(খ) প্রতিটি department-এ আলাদা ক্রমিক নম্বর, সবচেয়ে নতুন employee আগে:**

```sql
SELECT
    dept_id,
    emp_name,
    hire_date,
    ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY hire_date DESC) AS newest_rank
FROM employees
ORDER BY dept_id, newest_rank;
```

**(গ) Pagination: salary অনুযায়ী সাজানো তালিকার "দ্বিতীয় পাতা" (প্রতি পাতায় ৫ জন):**

```sql
WITH numbered AS (
    SELECT emp_name, salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC, emp_id) AS rn
    FROM employees
)
SELECT rn, emp_name, salary
FROM numbered
WHERE rn BETWEEN 6 AND 10;
```

### ৬. Expected Output

**(ক):**

**Output:**

| row_num | emp_name | dept_id | salary |
|---|---|---|---|
| 1 | Tanvir Ahmed | 2 | 85000 |
| 2 | Farhana Yasmin | 4 | 78000 |
| 3 | Imran Kabir | 4 | 78000 |
| 4 | Sabbir Hossain | 2 | 72000 |
| 5 | Mitu Rahman | 2 | 72000 |
| 6 | Arif Chowdhury | 2 | 65000 |
| 7 | Karim Hasan | 1 | 62000 |
| 8 | Fatema Akter | 1 | 62000 |
| 9 | Rubina Khatun | 4 | 60000 |
| 10 | Rahim Uddin | 1 | 55000 |
| 11 | Jamal Uddin | 3 | 52000 |
| 12 | Nusrat Jahan | 1 | 48000 |
| 13 | Sumaiya Islam | 3 | 45000 |

_(13 rows)_

**(খ):**

**Output:**

| dept_id | emp_name | hire_date | newest_rank |
|---|---|---|---|
| 1 | Nusrat Jahan | 2021-05-20 | 1 |
| 1 | Fatema Akter | 2020-01-10 | 2 |
| 1 | Rahim Uddin | 2019-03-15 | 3 |
| 1 | Karim Hasan | 2018-07-01 | 4 |
| 2 | Arif Chowdhury | 2022-02-01 | 1 |
| 2 | Mitu Rahman | 2020-06-15 | 2 |
| 2 | Sabbir Hossain | 2019-11-01 | 3 |
| 2 | Tanvir Ahmed | 2017-09-12 | 4 |
| 3 | Sumaiya Islam | 2019-04-01 | 1 |
| 3 | Jamal Uddin | 2016-08-20 | 2 |
| 4 | Rubina Khatun | 2023-07-10 | 1 |
| 4 | Imran Kabir | 2021-03-01 | 2 |
| 4 | Farhana Yasmin | 2018-01-15 | 3 |

_(13 rows)_

**(গ):**

**Output:**

| rn | emp_name | salary |
|---|---|---|
| 6 | Arif Chowdhury | 65000 |
| 7 | Karim Hasan | 62000 |
| 8 | Fatema Akter | 62000 |
| 9 | Rubina Khatun | 60000 |
| 10 | Rahim Uddin | 55000 |

_(5 rows)_

### ৭. Line-by-line Explanation

- `ROW_NUMBER()`: বন্ধনীর ভেতরে কোনো argument নেই।
- (ক) `ORDER BY salary DESC, emp_id`: বেশি salary আগে। salary সমান হলে ছোট `emp_id` আগে। দ্বিতীয় column-টাকে বলে **tie-breaker**। এটা না দিলে Karim আর Fatema-র মধ্যে কে 3 আর কে 4 পাবে, তা প্রতিবার একই হবে এমন নিশ্চয়তা নেই।
- (খ) `PARTITION BY dept_id`: প্রতিটি department-এ গোনা আবার 1 থেকে শুরু।
- (খ) `ORDER BY hire_date DESC`: যে সবচেয়ে পরে যোগ দিয়েছে সে 1।
- (গ) CTE-তে আগে নম্বর দেওয়া হলো, তারপর বাইরের Query-তে `WHERE rn BETWEEN 6 AND 10` দিয়ে দ্বিতীয় পাতা নেওয়া হলো।

### ৮. Common Mistakes

1. **Tie-breaker না দেওয়া।** ফলে একই Query বারবার চালালে আলাদা ফল আসতে পারে (non-deterministic)।
2. **`ROW_NUMBER()`-এ `ORDER BY` না দেওয়া।** MySQL Error দেয় না, কিন্তু নম্বরগুলো অর্থহীন (random) হয়।
3. **Ties-এ সবাইকে চাইলে ROW_NUMBER ব্যবহার করা।** ROW_NUMBER ties-এর একজনকে বাদ দিয়ে দেয়। সেখানে `RANK`/`DENSE_RANK` লাগবে (পরের Lesson)।

### ৯. Practice Problems

- **Beginner:** `products` Table-এ দামের ক্রমে (সবচেয়ে দামি আগে) প্রতিটি product-কে ক্রমিক নম্বর দিন।
- **Intermediate:** প্রতিটি `category`-তে সবচেয়ে **সস্তা** product-টি বের করুন (ROW_NUMBER + CTE)।
- **Advanced:** `sales` Table থেকে প্রতিটি customer-এর **সর্বশেষ (latest)** কেনাকাটার row বের করুন। একই দিনে দুটি কেনাকাটা থাকলে বড় `sale_id`-টি নিন।

### ১০. ছোট Quiz

1. ROW_NUMBER কি দুটি row-কে একই নম্বর দিতে পারে?
2. Tie-breaker কী এবং কেন দরকার?
3. `PARTITION BY` দিলে ROW_NUMBER-এর গোনা কখন আবার 1 থেকে শুরু হয়?

---

## Lesson 2.2 — RANK(), DENSE_RANK() এবং Ties

### ১. Topic Introduction

মান সমান হলে (Ties) ROW_NUMBER জোর করে আলাদা নম্বর দেয়। কিন্তু বাস্তবে সমান নম্বর পাওয়া দুজনকে একই অবস্থান দেওয়াই ন্যায্য। এজন্য আছে `RANK()` আর `DENSE_RANK()`।

### ২. সহজ বাংলা ব্যাখ্যা

দৌড় প্রতিযোগিতায় দুজন একসঙ্গে প্রথম হলো।

- **RANK():** দুজনেই ১ম। পরের জন **৩য়**, কারণ তার আগে দুজন আছে। ২ নম্বর বাদ পড়ল (**gap** থাকে)। অলিম্পিকে এই পদ্ধতি চলে।
- **DENSE_RANK():** দুজনেই ১ম। পরের জন **২য়**। কোনো নম্বর বাদ পড়ে না (**gap** নেই)।
- **ROW_NUMBER():** একজন ১, অন্যজন ২, পরের জন ৩। Ties উপেক্ষা করে।

| salary | ROW_NUMBER | RANK | DENSE_RANK |
|---|---|---|---|
| 62000 | 1 | 1 | 1 |
| 62000 | 2 | 1 | 1 |
| 55000 | 3 | **3** | **2** |
| 48000 | 4 | 4 | 3 |

### ৩. Syntax

```text
RANK()       OVER ([PARTITION BY ...] ORDER BY ...)
DENSE_RANK() OVER ([PARTITION BY ...] ORDER BY ...)
```

### ৪. Sample Data

`employees` Table।

### ৫. SQL Query

**(ক) তিনটি Ranking পাশাপাশি, পুরো কোম্পানিতে:**

```sql
SELECT
    emp_name,
    salary,
    ROW_NUMBER() OVER w AS row_num,
    RANK()       OVER w AS rnk,
    DENSE_RANK() OVER w AS dense_rnk
FROM employees
WINDOW w AS (ORDER BY salary DESC)
ORDER BY salary DESC, emp_id;
```

**(খ) Department অনুযায়ী Employee Ranking:**

```sql
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    RANK()       OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS dept_rank,
    DENSE_RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS dept_dense_rank
FROM employees e
JOIN departments d ON d.dept_id = e.dept_id
ORDER BY d.dept_id, e.salary DESC, e.emp_id;
```

### ৬. Expected Output

**(ক):**

**Output:**

| emp_name | salary | row_num | rnk | dense_rnk |
|---|---|---|---|---|
| Tanvir Ahmed | 85000 | 1 | 1 | 1 |
| Farhana Yasmin | 78000 | 2 | 2 | 2 |
| Imran Kabir | 78000 | 3 | 2 | 2 |
| Sabbir Hossain | 72000 | 4 | 4 | 3 |
| Mitu Rahman | 72000 | 5 | 4 | 3 |
| Arif Chowdhury | 65000 | 6 | 6 | 4 |
| Karim Hasan | 62000 | 7 | 7 | 5 |
| Fatema Akter | 62000 | 8 | 7 | 5 |
| Rubina Khatun | 60000 | 9 | 9 | 6 |
| Rahim Uddin | 55000 | 10 | 10 | 7 |
| Jamal Uddin | 52000 | 11 | 11 | 8 |
| Nusrat Jahan | 48000 | 12 | 12 | 9 |
| Sumaiya Islam | 45000 | 13 | 13 | 10 |

_(13 rows)_

লক্ষ্য করুন: 78000-এ দুজন। তাদের RANK 2, 2, আর পরের জন (72000) পায় RANK **4**, কিন্তু DENSE_RANK **3**। আবার 72000-এ দুজন, তাই 65000-এর RANK 6 আর DENSE_RANK 4।

**(খ):**

**Output:**

| dept_name | emp_name | salary | dept_rank | dept_dense_rank |
|---|---|---|---|---|
| Sales | Karim Hasan | 62000 | 1 | 1 |
| Sales | Fatema Akter | 62000 | 1 | 1 |
| Sales | Rahim Uddin | 55000 | 3 | 2 |
| Sales | Nusrat Jahan | 48000 | 4 | 3 |
| IT | Tanvir Ahmed | 85000 | 1 | 1 |
| IT | Sabbir Hossain | 72000 | 2 | 2 |
| IT | Mitu Rahman | 72000 | 2 | 2 |
| IT | Arif Chowdhury | 65000 | 4 | 3 |
| HR | Jamal Uddin | 52000 | 1 | 1 |
| HR | Sumaiya Islam | 45000 | 2 | 2 |
| Finance | Farhana Yasmin | 78000 | 1 | 1 |
| Finance | Imran Kabir | 78000 | 1 | 1 |
| Finance | Rubina Khatun | 60000 | 3 | 2 |

_(13 rows)_

### ৭. Line-by-line Explanation

- (ক) `WINDOW w AS (ORDER BY salary DESC)`: তিনটি function একই window ব্যবহার করছে।
- (ক) `RANK() OVER w`: সমান salary-তে একই rank। পরের rank = (আগের row-এর সংখ্যা + 1)।
- (ক) `DENSE_RANK() OVER w`: সমান salary-তে একই rank। পরের rank শুধু 1 বাড়ে।
- (খ) `JOIN departments`: department-এর নাম আনার জন্য। Window Function JOIN-এর পরের row-এর ওপর চলে।
- (খ) `PARTITION BY e.dept_id`: প্রতিটি department-এ ranking আলাদা।

**কখন কোনটা?**

| প্রয়োজন | Function |
|---|---|
| প্রতিটি row-এর unique নম্বর, ঠিক ১টি row বাছাই | ROW_NUMBER |
| প্রতিযোগিতার মতো অবস্থান (ties-এর পরে gap থাকে) | RANK |
| "কয়টি আলাদা মানের স্তর", যেমন 2nd highest salary | DENSE_RANK |

### ৮. Common Mistakes

1. **"দ্বিতীয় সর্বোচ্চ salary" খুঁজতে RANK ব্যবহার।** উপরের (ক)-তে RANK = 2 আছে, কিন্তু RANK = 3 কেউ নেই। "Nth highest" প্রশ্নে DENSE_RANK নিরাপদ।
2. **RANK/DENSE_RANK-এ tie-breaker যোগ করা।** যেমন `ORDER BY salary DESC, emp_id`। এতে আর ties থাকে না, সবাই আলাদা rank পায়। Ties রাখতে চাইলে শুধু তুলনার column দিন।
3. **DESC ভুলে যাওয়া।** তখন সবচেয়ে কম salary-ই rank 1 হয়ে যায়।

### ৯. Practice Problems

- **Beginner:** `products` Table-এ দাম অনুযায়ী (বেশি দাম আগে) RANK আর DENSE_RANK পাশাপাশি দেখান। কোথায় ties আছে খুঁজে বের করুন।
- **Intermediate:** পুরো কোম্পানির **তৃতীয় সর্বোচ্চ salary** কত এবং কে কে পায়, বের করুন।
- **Advanced:** প্রতিটি salesperson-এর (`sales.emp_id`) মোট বিক্রি (`SUM(amount)`) বের করে RANK দিন। (ইঙ্গিত: `GROUP BY` আর তার ওপর Window, Lesson 1.4 দেখুন।)

### ১০. ছোট Quiz

1. সংখ্যাগুলো 90, 90, 80, 70। RANK আর DENSE_RANK কী কী হবে?
2. কোন Ranking function-এ gap থাকে?
3. "২য় সর্বোচ্চ মান" খুঁজতে কোনটা ব্যবহার করবেন, কেন?

---

## Lesson 2.3 — NTILE()

### ১. Topic Introduction

`NTILE(n)` সাজানো row-গুলোকে **n টি প্রায় সমান ভাগে (bucket)** ভাগ করে, আর প্রতিটি row কোন ভাগে পড়ল সেই নম্বর (1…n) দেয়।

### ২. সহজ বাংলা ব্যাখ্যা

ক্লাসের ছাত্রদের নম্বর অনুযায়ী সাজিয়ে ৪টি দলে ভাগ করা: Top 25% (দল 1), পরের 25% (দল 2) ইত্যাদি। একে **Quartile** বলে। ১০ ভাগ করলে **Decile**।

ভাগ সমান না হলে **প্রথম দিকের দলগুলো ১ জন করে বেশি** পায়। ১৩ জনকে ৪ দলে ভাগ করলে দলের আকার হবে 4, 3, 3, 3।

**ব্যবহার:** Customer segmentation (Top 20% customer), salary band, price tier (Premium/Mid/Budget)।

### ৩. Syntax

```text
NTILE(n) OVER ([PARTITION BY ...] ORDER BY ...)
```

### ৪. Sample Data

`employees` আর `products` Table।

### ৫. SQL Query

**(ক) ১৩ জন employee-কে salary অনুযায়ী ৪টি band-এ ভাগ:**

```sql
SELECT
    emp_name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC, emp_id) AS salary_quartile
FROM employees
ORDER BY salary DESC, emp_id;
```

**(খ) প্রতিটি category-তে product-কে দাম অনুযায়ী Premium/Budget-এ ভাগ:**

```sql
SELECT
    category,
    product_name,
    price,
    NTILE(2) OVER (PARTITION BY category ORDER BY price DESC) AS tier_no,
    CASE NTILE(2) OVER (PARTITION BY category ORDER BY price DESC)
        WHEN 1 THEN 'Premium'
        ELSE 'Budget'
    END AS tier
FROM products
ORDER BY category, price DESC;
```

### ৬. Expected Output

**(ক):** প্রথম দলে ৪ জন, বাকি দলে ৩ জন করে।

**Output:**

| emp_name | salary | salary_quartile |
|---|---|---|
| Tanvir Ahmed | 85000 | 1 |
| Farhana Yasmin | 78000 | 1 |
| Imran Kabir | 78000 | 1 |
| Sabbir Hossain | 72000 | 1 |
| Mitu Rahman | 72000 | 2 |
| Arif Chowdhury | 65000 | 2 |
| Karim Hasan | 62000 | 2 |
| Fatema Akter | 62000 | 3 |
| Rubina Khatun | 60000 | 3 |
| Rahim Uddin | 55000 | 3 |
| Jamal Uddin | 52000 | 4 |
| Nusrat Jahan | 48000 | 4 |
| Sumaiya Islam | 45000 | 4 |

_(13 rows)_

**(খ):**

**Output:**

| category | product_name | price | tier_no | tier |
|---|---|---|---|---|
| Clothing | Saree | 4500 | 1 | Premium |
| Clothing | Panjabi | 2500 | 1 | Premium |
| Clothing | Jeans | 1800 | 2 | Budget |
| Electronics | Laptop | 75000 | 1 | Premium |
| Electronics | Smartphone | 35000 | 1 | Premium |
| Electronics | Smartwatch | 12000 | 2 | Budget |
| Electronics | Headphones | 4500 | 2 | Budget |
| Furniture | Office Chair | 15000 | 1 | Premium |
| Furniture | Study Table | 12000 | 1 | Premium |
| Furniture | Bookshelf | 8500 | 2 | Budget |
| Grocery | Rice 25kg | 2200 | 1 | Premium |
| Grocery | Soybean Oil 5L | 950 | 1 | Premium |
| Grocery | Tea 400g | 350 | 2 | Budget |

_(13 rows)_

Electronics-এ ৪টি product, তাই 2+2। Clothing, Furniture আর Grocery-তে ৩টি করে, তাই 2+1 (প্রথম দল বেশি পায়)।

### ৭. Line-by-line Explanation

- `NTILE(4)`: ৪টি bucket।
- `ORDER BY salary DESC, emp_id`: বেশি salary প্রথম bucket-এ। tie-breaker দেওয়ায় ফল নিশ্চিত থাকে।
- (খ) `CASE NTILE(2) OVER (...) WHEN 1 THEN 'Premium'`: Window Function-এর ফলকে `CASE`-এর ভেতরে ব্যবহার করে লেবেল বানানো হয়েছে।

**লক্ষ্য করুন:** (ক)-তে Sabbir আর Mitu দুজনেরই salary 72000, তবু Sabbir পড়েছেন bucket 1-এ আর Mitu bucket 2-এ। কারণ NTILE শুধু row গোনে, মান দেখে না। এটাই NTILE-এর বড় সীমাবদ্ধতা।

### ৮. Common Mistakes

1. **NTILE-কে percentile ভাবা।** NTILE row সংখ্যা ভাগ করে, মানের পরিসর নয়। Ties আলাদা bucket-এ পড়তে পারে।
2. **row-এর চেয়ে বেশি bucket দেওয়া।** ৩টি row-এ `NTILE(5)` দিলে শুধু 1, 2, 3 পাবেন। 4 আর 5 খালি থাকবে।
3. **ORDER BY না দেওয়া।** তখন ভাগ অর্থহীন হয়।

### ৯. Practice Problems

- **Beginner:** `products` Table-কে দাম অনুযায়ী ৩টি ভাগে (`NTILE(3)`) ভাগ করুন।
- **Intermediate:** ভাগ 1 = 'High', 2 = 'Medium', 3 = 'Low' লেবেল দিন।
- **Advanced:** প্রতিটি customer-এর মোট কেনাকাটা বের করে (`sales`) customer-দের ৩টি segment-এ ভাগ করুন: 'Gold', 'Silver', 'Bronze'। Duplicate customer (ID 8) আলাদা ধরেই হিসাব করুন।

### ১০. ছোট Quiz

1. ১০টি row-কে `NTILE(3)` দিলে প্রতিটি bucket-এ কতটি row থাকবে?
2. NTILE কি সমান মানকে সবসময় একই bucket-এ রাখে?
3. `NTILE(4)` দিয়ে কোন পরিসংখ্যান-ধারণা পাওয়া যায়?

---

## Lesson 2.4 — Top N per Department এবং Ties-এর প্রভাব

### ১. Topic Introduction

বাস্তবে সবচেয়ে বেশি ব্যবহৃত Window Function প্যাটার্ন হলো **"প্রতিটি গ্রুপের Top N"**। যেমন প্রতিটি department-এর সর্বোচ্চ বেতনের ২ জন, বা প্রতিটি category-র সেরা ৩টি product। এখানে আগের তিনটি Lesson একসঙ্গে কাজে লাগে।

### ২. সহজ বাংলা ব্যাখ্যা

তিন ধাপে কাজ:

1. **Rank দিন:** প্রতিটি গ্রুপে (`PARTITION BY`) ক্রম অনুযায়ী (`ORDER BY`)।
2. **CTE/Subquery-তে মুড়ে দিন:** কারণ `WHERE`-এ সরাসরি Window Function চলে না (Lesson 1.4)।
3. **Filter করুন:** `WHERE rnk <= N`।

কোন Ranking function নেবেন, তার ওপর ফল বদলায়:

- **ROW_NUMBER:** ঠিক N জন, ties-এর কেউ বাদ পড়তে পারে।
- **RANK:** N-এর বেশি আসতে পারে (ties), কিন্তু rank-এ gap থাকে।
- **DENSE_RANK:** "শীর্ষ N টি আলাদা salary-স্তরের" সবাই আসে।

### ৩. Syntax

```text
WITH ranked AS (
    SELECT ..., RANK_FUNC() OVER (PARTITION BY grp ORDER BY metric DESC) AS rnk
    FROM t
)
SELECT ... FROM ranked WHERE rnk <= N;
```

### ৪. Sample Data

`employees` + `departments`।

### ৫. SQL Query

**প্রতিটি department-এর Top 2 salary পাওয়া employee, তিন পদ্ধতিতে একসঙ্গে তুলনা:**

```sql
WITH ranked AS (
    SELECT
        d.dept_name,
        e.emp_name,
        e.salary,
        ROW_NUMBER() OVER w AS rn,
        RANK()       OVER w AS rnk,
        DENSE_RANK() OVER w AS drnk
    FROM employees e
    JOIN departments d ON d.dept_id = e.dept_id
    WINDOW w AS (PARTITION BY e.dept_id ORDER BY e.salary DESC)
)
SELECT *
FROM ranked
WHERE drnk <= 2
ORDER BY dept_name, salary DESC, emp_name;
```

### ৬. Expected Output

**Output:**

| dept_name | emp_name | salary | rn | rnk | drnk |
|---|---|---|---|---|---|
| Finance | Farhana Yasmin | 78000 | 1 | 1 | 1 |
| Finance | Imran Kabir | 78000 | 2 | 1 | 1 |
| Finance | Rubina Khatun | 60000 | 3 | 3 | 2 |
| HR | Jamal Uddin | 52000 | 1 | 1 | 1 |
| HR | Sumaiya Islam | 45000 | 2 | 2 | 2 |
| IT | Tanvir Ahmed | 85000 | 1 | 1 | 1 |
| IT | Mitu Rahman | 72000 | 3 | 2 | 2 |
| IT | Sabbir Hossain | 72000 | 2 | 2 | 2 |
| Sales | Fatema Akter | 62000 | 2 | 1 | 1 |
| Sales | Karim Hasan | 62000 | 1 | 1 | 1 |
| Sales | Rahim Uddin | 55000 | 3 | 3 | 2 |

_(11 rows)_

এই ফলাফল থেকে তিন পদ্ধতির পার্থক্য পড়ুন:

- `WHERE rn <= 2` দিলে Sales-এ শুধু Karim/Fatema আসত, Rahim (55000) আসত না।
- `WHERE rnk <= 2` দিলে IT-তে Tanvir (1) আর Sabbir/Mitu (2, 2) আসত। Sales-এ শুধু Karim ও Fatema, কারণ Rahim-এর rank 3।
- `WHERE drnk <= 2` (উপরের Query) দিলে প্রতিটি department-এ শীর্ষ **২টি আলাদা salary-স্তরের** সবাই আসে।

### ৭. Line-by-line Explanation

- `WITH ranked AS (...)`: তিনটি ranking একসঙ্গে হিসাব করে রাখা হলো।
- `WINDOW w AS (PARTITION BY e.dept_id ORDER BY e.salary DESC)`: department অনুযায়ী ভাগ, বেশি salary আগে।
- `SELECT * FROM ranked WHERE drnk <= 2`: বাইরের Query-তে ranking column সাধারণ column-এর মতো filter হয়।
- `ORDER BY dept_name, salary DESC, emp_name`: সুন্দর করে দেখানো।

**Business সিদ্ধান্ত:** "Top 2 বোনাস পাবে" নিয়মে ties থাকলে কী হবে, সেটা আগে ঠিক করে তারপর function বাছুন। SQL শুধু নিয়ম অনুসরণ করে।

### ৮. Common Mistakes

1. **`WHERE` বা `HAVING`-এ সরাসরি rank লেখা।** Error 3593।
2. **Ties-এর নিয়ম না ভেবে ROW_NUMBER ব্যবহার।** কেউ অন্যায্যভাবে বাদ পড়তে পারে।
3. **`LIMIT 2` দিয়ে Top N per group করার চেষ্টা।** `LIMIT` পুরো result-এ কাজ করে, প্রতি গ্রুপে নয়।

### ৯. Practice Problems

- **Beginner:** প্রতিটি department-এর সর্বোচ্চ salary-র employee (ties সহ) বের করুন।
- **Intermediate:** প্রতিটি department-এ **সবচেয়ে কম** salary-র ২ জন (ঠিক ২ জন, ties হলে ছোট `emp_id`) বের করুন।
- **Advanced:** প্রতিটি category-তে **বিক্রির মোট পরিমাণ (`SUM(quantity)`)** অনুযায়ী Top 2 product বের করুন (`sales` + `products`)। Ties থাকলে সবাইকে দেখাবেন।

### ১০. ছোট Quiz

1. Top N per group-এ CTE কেন দরকার?
2. প্রতিটি গ্রুপ থেকে "ঠিক N টি" row চাইলে কোন function?
3. `LIMIT` কেন Top-N-per-group সমাধান করতে পারে না?

> **Module 2 শেষ।** এখন আপনি "কে কত নম্বরে" বের করতে পারেন। Module 3-এ শিখব "এ পর্যন্ত মোট কত": Aggregate Window Functions। Practice-এর উত্তর পাঠান, তারপর **"Ready"** লিখুন।


# Module 3: Aggregate Window Functions

**আগের Module-এর সঙ্গে সম্পর্ক:** Module 2-এর Ranking function-গুলো শুধু Window Function হিসেবেই চলে। কিন্তু `SUM`, `AVG`, `COUNT`, `MIN`, `MAX` আপনি আগে থেকেই `GROUP BY`-এর সঙ্গে চেনেন। এগুলোর পাশে `OVER` লাগালেই Window Function হয়ে যায় (Module 1)। এই Module-এ এদের পুরো শক্তি দেখব।

## Lesson 3.1 — SUM, AVG, COUNT, MIN, MAX OVER(): GROUP BY ছাড়াই Aggregate

### ১. Topic Introduction

`OVER (PARTITION BY ...)` দিয়ে Aggregate function ব্যবহার করলে প্রতিটি row-এর পাশে তার গ্রুপের মোট, গড়, সংখ্যা, সর্বনিম্ন আর সর্বোচ্চ মান বসে। `GROUP BY` লাগে না, row-ও হারায় না।

### ২. সহজ বাংলা ব্যাখ্যা

অফিসের HR রিপোর্টে প্রতিটি employee-র পাশে লেখা থাকে: "তোমার department-এ মোট কতজন, গড় বেতন কত, সর্বোচ্চ কত, আর তুমি department-এর মোট বেতনের কত শতাংশ পাও।" এটাই Aggregate Window।

**ব্যবহার:** Contribution % (কে কত অবদান রাখছে), গড়ের সঙ্গে তুলনা, সর্বোচ্চ মান থেকে দূরত্ব, data quality check।

### ৩. Syntax

```text
SUM(col)   OVER ([PARTITION BY ...])
AVG(col)   OVER ([PARTITION BY ...])
COUNT(*)   OVER ([PARTITION BY ...])   -- বা COUNT(col): NULL বাদ দিয়ে গোনে
MIN(col)   OVER ([PARTITION BY ...])
MAX(col)   OVER ([PARTITION BY ...])
```

**সাবধান:** এখানে `ORDER BY` **দেবেন না**, যদি পুরো গ্রুপের মান চান। `ORDER BY` দিলে Running হিসাব হয়ে যায় (পরের Lesson)।

### ৪. Sample Data

`employees` + `departments`।

### ৫. SQL Query

**Department-wise Total, Average, Count, Min, Max আর Contribution %:**

```sql
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    COUNT(*)              OVER w AS dept_emp_count,
    SUM(e.salary)         OVER w AS dept_total,
    ROUND(AVG(e.salary) OVER w, 0) AS dept_avg,
    MIN(e.salary)         OVER w AS dept_min,
    MAX(e.salary)         OVER w AS dept_max,
    ROUND(100 * e.salary / SUM(e.salary) OVER w, 1) AS pct_of_dept,
    MAX(e.salary) OVER w - e.salary AS gap_to_top
FROM employees e
JOIN departments d ON d.dept_id = e.dept_id
WINDOW w AS (PARTITION BY e.dept_id)
ORDER BY d.dept_id, e.salary DESC, e.emp_id;
```

**Product-এর দাম, category-র গড় দাম আর পুরো দোকানের গড় দাম, একসঙ্গে:**

```sql
SELECT
    category,
    product_name,
    price,
    ROUND(AVG(price) OVER (PARTITION BY category), 0) AS category_avg,
    ROUND(AVG(price) OVER (), 0)                      AS overall_avg,
    CASE WHEN price > AVG(price) OVER (PARTITION BY category)
         THEN 'Above avg' ELSE 'At/Below avg' END    AS position
FROM products
ORDER BY category, price DESC;
```

### ৬. Expected Output

**Department রিপোর্ট:**

**Output:**

| dept_name | emp_name | salary | dept_emp_count | dept_total | dept_avg | dept_min | dept_max | pct_of_dept | gap_to_top |
|---|---|---|---|---|---|---|---|---|---|
| Sales | Karim Hasan | 62000 | 4 | 227000 | 56750 | 48000 | 62000 | 27.3 | 0 |
| Sales | Fatema Akter | 62000 | 4 | 227000 | 56750 | 48000 | 62000 | 27.3 | 0 |
| Sales | Rahim Uddin | 55000 | 4 | 227000 | 56750 | 48000 | 62000 | 24.2 | 7000 |
| Sales | Nusrat Jahan | 48000 | 4 | 227000 | 56750 | 48000 | 62000 | 21.1 | 14000 |
| IT | Tanvir Ahmed | 85000 | 4 | 294000 | 73500 | 65000 | 85000 | 28.9 | 0 |
| IT | Sabbir Hossain | 72000 | 4 | 294000 | 73500 | 65000 | 85000 | 24.5 | 13000 |
| IT | Mitu Rahman | 72000 | 4 | 294000 | 73500 | 65000 | 85000 | 24.5 | 13000 |
| IT | Arif Chowdhury | 65000 | 4 | 294000 | 73500 | 65000 | 85000 | 22.1 | 20000 |
| HR | Jamal Uddin | 52000 | 2 | 97000 | 48500 | 45000 | 52000 | 53.6 | 0 |
| HR | Sumaiya Islam | 45000 | 2 | 97000 | 48500 | 45000 | 52000 | 46.4 | 7000 |
| Finance | Farhana Yasmin | 78000 | 3 | 216000 | 72000 | 60000 | 78000 | 36.1 | 0 |
| Finance | Imran Kabir | 78000 | 3 | 216000 | 72000 | 60000 | 78000 | 36.1 | 0 |
| Finance | Rubina Khatun | 60000 | 3 | 216000 | 72000 | 60000 | 78000 | 27.8 | 18000 |

_(13 rows)_

**Product রিপোর্ট:**

**Output:**

| category | product_name | price | category_avg | overall_avg | position |
|---|---|---|---|---|---|
| Clothing | Saree | 4500 | 2933 | 13408 | Above avg |
| Clothing | Panjabi | 2500 | 2933 | 13408 | At/Below avg |
| Clothing | Jeans | 1800 | 2933 | 13408 | At/Below avg |
| Electronics | Laptop | 75000 | 31625 | 13408 | Above avg |
| Electronics | Smartphone | 35000 | 31625 | 13408 | Above avg |
| Electronics | Smartwatch | 12000 | 31625 | 13408 | At/Below avg |
| Electronics | Headphones | 4500 | 31625 | 13408 | At/Below avg |
| Furniture | Office Chair | 15000 | 11833 | 13408 | Above avg |
| Furniture | Study Table | 12000 | 11833 | 13408 | Above avg |
| Furniture | Bookshelf | 8500 | 11833 | 13408 | At/Below avg |
| Grocery | Rice 25kg | 2200 | 1167 | 13408 | Above avg |
| Grocery | Soybean Oil 5L | 950 | 1167 | 13408 | At/Below avg |
| Grocery | Tea 400g | 350 | 1167 | 13408 | At/Below avg |

_(13 rows)_

### ৭. Line-by-line Explanation

- `WINDOW w AS (PARTITION BY e.dept_id)`: সব aggregate একই department-window ব্যবহার করছে।
- `COUNT(*) OVER w`: department-এ কতজন।
- `SUM(e.salary) OVER w`: department-এর মোট salary। একই department-এর সব row-এ একই মান।
- `ROUND(100 * e.salary / SUM(e.salary) OVER w, 1)`: এই employee department-এর মোট salary-র কত শতাংশ পান।
- `MAX(e.salary) OVER w - e.salary`: department-এর শীর্ষ বেতনের চেয়ে কত কম।
- Product Query-তে একই Query-তে দুটি আলাদা window: `PARTITION BY category` আর খালি `OVER ()`। GROUP BY দিয়ে এটা এক Query-তে করা খুব কঠিন।
- `CASE WHEN price > AVG(price) OVER (...)`: Window-এর ফল `CASE`-এর শর্তে ব্যবহার করা যায়।

### ৮. Common Mistakes

1. **Integer ভাগে দশমিক হারানোর ভয়।** MySQL-এ `/` সবসময় দশমিক ফল দেয় (`DIV` হলো integer ভাগ), তাই এখানে সমস্যা নেই। অন্য DB-তে (যেমন PostgreSQL, SQL Server) `100.0 *` লিখতে হয়।
2. **শূন্য দিয়ে ভাগ।** মোট 0 হলে NULL পেতে `NULLIF(SUM(x) OVER w, 0)` ব্যবহার করুন।
3. **`COUNT(col)` আর `COUNT(*)` গুলিয়ে ফেলা।** `COUNT(col)` NULL মান গোনে না।
4. **অজান্তে `ORDER BY` দেওয়া।** তখন মোটের বদলে running total আসে।

### ৯. Practice Problems

- **Beginner:** `sales` Table থেকে প্রতিটি sale-এর পাশে ওই salesperson-এর (`emp_id`) মোট বিক্রি দেখান।
- **Intermediate:** প্রতিটি sale-এর amount ওই customer-এর মোট কেনাকাটার কত শতাংশ, বের করুন।
- **Advanced:** প্রতিটি product-এর জন্য দেখান: দাম, category-র সর্বোচ্চ দাম, category-র সর্বনিম্ন দাম, আর `price_position` = (price − min) / (max − min) × 100। একটি category-তে max = min হলে NULL দেখাবেন।

### ১০. ছোট Quiz

1. `SUM(salary) OVER (PARTITION BY dept_id)` আর `SUM(salary) OVER (PARTITION BY dept_id ORDER BY salary)`-এর পার্থক্য কী?
2. একই Query-তে দুটি ভিন্ন PARTITION BY ব্যবহার করা যায় কি?
3. `COUNT(*)` আর `COUNT(email)`-এর পার্থক্য কী?

---

## Lesson 3.2 — Running Total এবং Cumulative Average

### ১. Topic Introduction

**Running Total (Cumulative Sum)** মানে শুরু থেকে বর্তমান row পর্যন্ত সব মানের যোগফল। **Cumulative Average** মানে শুরু থেকে বর্তমান row পর্যন্ত গড়। দুটোই পাওয়া যায় `OVER`-এ `ORDER BY` দিলে।

### ২. সহজ বাংলা ব্যাখ্যা

দোকানের ক্যাশবাক্সের কথা ভাবুন। প্রতিটি বিক্রির পর দোকানদার খাতায় লেখেন "আজ এ পর্যন্ত মোট বিক্রি কত"। প্রথম বিক্রি 500, দ্বিতীয় 300, তাই এ পর্যন্ত 800। তৃতীয় 200, তাই 1000। এটাই Running Total।

**একটা গুরুত্বপূর্ণ ফাঁদ:** একই তারিখে দুটি বিক্রি হলে আর আপনি শুধু তারিখ দিয়ে `ORDER BY` দিলে, MySQL ওই দুটিকে "সমান" ধরে **দুটিকেই একসঙ্গে যোগ করে** দেখায়। কারণ ডিফল্ট Frame হলো `RANGE`। পুরো কারণটা Module 4-এ শিখবেন। আপাতত সমাধান হলো একটি unique tie-breaker (`sale_id`) যোগ করা।

### ৩. Syntax

```text
SUM(col) OVER ([PARTITION BY ...] ORDER BY sort_col [, tie_breaker])  -- Running Total
AVG(col) OVER ([PARTITION BY ...] ORDER BY sort_col [, tie_breaker])  -- Cumulative Avg
```

### ৪. Sample Data

`sales` Table-এর 2025 সালের জানুয়ারি থেকে মার্চের অংশ (১৫টি row)। লক্ষ্য করুন, 2025-01-05, 2025-03-11 আর 2025-03-12 তারিখে দুটি করে বিক্রি আছে।

### ৫. SQL Query

**(ক) পুরো কোম্পানির Running Total আর Cumulative Average:**

```sql
SELECT
    sale_id,
    sale_date,
    amount,
    SUM(amount) OVER (ORDER BY sale_date)          AS running_by_date_only,
    SUM(amount) OVER (ORDER BY sale_date, sale_id) AS running_total,
    ROUND(AVG(amount) OVER (ORDER BY sale_date, sale_id), 2) AS cumulative_avg,
    COUNT(*)    OVER (ORDER BY sale_date, sale_id) AS sales_so_far
FROM sales
WHERE sale_date BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY sale_date, sale_id;
```

**(খ) প্রতিটি Salesperson-এর আলাদা Running Total:**

```sql
SELECT
    e.emp_name AS salesperson,
    s.sale_date,
    s.amount,
    SUM(s.amount) OVER (PARTITION BY s.emp_id ORDER BY s.sale_date, s.sale_id) AS running_total
FROM sales s
JOIN employees e ON e.emp_id = s.emp_id
WHERE s.sale_date BETWEEN '2025-01-01' AND '2025-03-31'
ORDER BY salesperson, s.sale_date, s.sale_id;
```

### ৬. Expected Output

**(ক):**

**Output:**

| sale_id | sale_date | amount | running_by_date_only | running_total | cumulative_avg | sales_so_far |
|---|---|---|---|---|---|---|
| 19 | 2025-01-05 | 75000 | 84000 | 75000 | 75000.00 | 1 |
| 20 | 2025-01-05 | 9000 | 84000 | 84000 | 42000.00 | 2 |
| 21 | 2025-01-17 | 5700 | 89700 | 89700 | 29900.00 | 3 |
| 22 | 2025-01-29 | 3600 | 93300 | 93300 | 23325.00 | 4 |
| 23 | 2025-02-07 | 35000 | 128300 | 128300 | 25660.00 | 5 |
| 24 | 2025-02-16 | 12000 | 140300 | 140300 | 23383.33 | 6 |
| 25 | 2025-02-25 | 6600 | 146900 | 146900 | 20985.71 | 7 |
| 26 | 2025-03-10 | 700 | 147600 | 147600 | 18450.00 | 8 |
| 27 | 2025-03-11 | 1900 | 161500 | 149500 | 16611.11 | 9 |
| 28 | 2025-03-11 | 12000 | 161500 | 161500 | 16150.00 | 10 |
| 29 | 2025-03-12 | 2200 | 167300 | 163700 | 14881.82 | 11 |
| 30 | 2025-03-12 | 3600 | 167300 | 167300 | 13941.67 | 12 |
| 31 | 2025-03-15 | 2500 | 169800 | 169800 | 13061.54 | 13 |
| 32 | 2025-03-16 | 4500 | 174300 | 174300 | 12450.00 | 14 |
| 33 | 2025-03-28 | 75000 | 249300 | 249300 | 16620.00 | 15 |

_(15 rows)_

`running_by_date_only` column-টা দেখুন। sale 19 আর 20 দুটোই 2025-01-05 তারিখের, আর দুটোরই মান 84000। অর্থাৎ sale 19-এর row-এ sale 20-এর টাকাও যোগ হয়ে গেছে! `running_total` column-এ `sale_id` tie-breaker থাকায় এটা ঠিক আছে (75000, তারপর 84000)।

**(খ):**

**Output:**

| salesperson | sale_date | amount | running_total |
|---|---|---|---|
| Fatema Akter | 2025-01-17 | 5700 | 5700 |
| Fatema Akter | 2025-02-25 | 6600 | 12300 |
| Fatema Akter | 2025-03-12 | 3600 | 15900 |
| Karim Hasan | 2025-01-05 | 9000 | 9000 |
| Karim Hasan | 2025-02-16 | 12000 | 21000 |
| Karim Hasan | 2025-03-11 | 12000 | 33000 |
| Karim Hasan | 2025-03-12 | 2200 | 35200 |
| Karim Hasan | 2025-03-28 | 75000 | 110200 |
| Nusrat Jahan | 2025-01-29 | 3600 | 3600 |
| Nusrat Jahan | 2025-03-15 | 2500 | 6100 |
| Rahim Uddin | 2025-01-05 | 75000 | 75000 |
| Rahim Uddin | 2025-02-07 | 35000 | 110000 |
| Rahim Uddin | 2025-03-10 | 700 | 110700 |
| Rahim Uddin | 2025-03-11 | 1900 | 112600 |
| Rahim Uddin | 2025-03-16 | 4500 | 117100 |

_(15 rows)_

### ৭. Line-by-line Explanation

- `SUM(amount) OVER (ORDER BY sale_date)`: শুধু তারিখে ক্রম। একই তারিখের row "peer" (সমকক্ষ) হিসেবে একসঙ্গে যোগ হয়।
- `SUM(amount) OVER (ORDER BY sale_date, sale_id)`: প্রতিটি row আলাদা। তাই সত্যিকারের row-by-row running total পাওয়া যায়।
- `AVG(amount) OVER (ORDER BY ...)`: এ পর্যন্ত গড়। এটাই Cumulative Average।
- `COUNT(*) OVER (ORDER BY ...)`: এ পর্যন্ত কয়টি বিক্রি।
- (খ) `PARTITION BY s.emp_id`: প্রতিটি salesperson-এর হিসাব আলাদা, প্রতিজনের জন্য 0 থেকে শুরু।

### ৮. Common Mistakes

1. **Non-unique ORDER BY দিয়ে Running Total।** একই মানের row-এ "লাফ" দেখা যায়। tie-breaker দিন, অথবা Module 4-এর `ROWS` frame ব্যবহার করুন।
2. **`WHERE` দিয়ে কিছু row বাদ দেওয়ার পর ভাবা যে Running Total সব data থেকে হচ্ছে।** Window শুধু filter-এর পরের row দেখে।
3. **Final `ORDER BY` না দেওয়া।** Running Total পড়তে হলে result অবশ্যই একই ক্রমে সাজাতে হবে।

### ৯. Practice Problems

- **Beginner:** 2024 সালের সব sale-এর জন্য তারিখ অনুযায়ী Running Total বের করুন (tie-breaker সহ)।
- **Intermediate:** প্রতিটি customer-এর কেনাকাটার Running Total আর এ পর্যন্ত কয়টি order হলো (`COUNT`), বের করুন।
- **Advanced:** প্রতিটি salesperson-এর Cumulative Average sale amount বের করুন, আর দেখান কোন sale-এর পর cumulative average প্রথমবার 20000-এর নিচে নেমেছে।

### ১০. ছোট Quiz

1. Running Total পেতে `OVER`-এ কোন clause বাধ্যতামূলক?
2. একই তারিখের দুটি row-এ Running Total কেন একই মান দেখাল?
3. প্রতিটি customer-এর আলাদা Running Total-এর জন্য কী যোগ করবেন?

---

## Lesson 3.3 — GROUP BY + Window: মাসিক Running Total ও Share

### ১. Topic Introduction

বাস্তব রিপোর্টে আমরা প্রায়ই আগে data **summarize** করি (যেমন মাসভিত্তিক মোট), তারপর সেই summary-র ওপর Window Function চালাই (যেমন মাসিক running total)। Lesson 1.4-এ শেখা `SUM(SUM(x)) OVER (...)` এখানে মূল অস্ত্র।

### ২. সহজ বাংলা ব্যাখ্যা

প্রথমে প্রতিদিনের রসিদগুলো মাস অনুযায়ী যোগ করে "মাসিক খাতা" বানাই (`GROUP BY`)। তারপর সেই মাসিক খাতায় লিখি "বছরের শুরু থেকে এ পর্যন্ত" (Year-to-Date, YTD) আর "বছরের মোটের কত শতাংশ এই মাসে এসেছে"।

### ৩. Syntax

```text
SELECT
    group_col,
    SUM(x) AS group_total,
    SUM(SUM(x)) OVER ([PARTITION BY ...] ORDER BY group_col) AS running_total
FROM t
GROUP BY group_col;
```

অথবা আরও পরিষ্কারভাবে, CTE-তে আগে GROUP BY, তারপর বাইরে Window।

### ৪. Sample Data

`sales` Table-এর সব data (2024 ও 2025)।

### ৫. SQL Query

```sql
WITH monthly AS (
    SELECT
        YEAR(sale_date)                    AS yr,
        DATE_FORMAT(sale_date, '%Y-%m')    AS month,
        SUM(amount)                        AS monthly_sales,
        COUNT(*)                           AS orders
    FROM sales
    GROUP BY YEAR(sale_date), DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT
    month,
    monthly_sales,
    orders,
    SUM(monthly_sales) OVER (PARTITION BY yr ORDER BY month) AS ytd_sales,
    SUM(monthly_sales) OVER (PARTITION BY yr)                 AS year_total,
    ROUND(100 * monthly_sales / SUM(monthly_sales) OVER (PARTITION BY yr), 1) AS pct_of_year
FROM monthly
ORDER BY month;
```

### ৬. Expected Output

**Output:**

| month | monthly_sales | orders | ytd_sales | year_total | pct_of_year |
|---|---|---|---|---|---|
| 2024-01 | 61600 | 4 | 61600 | 279450 | 22.0 |
| 2024-02 | 87800 | 3 | 149400 | 279450 | 31.4 |
| 2024-03 | 29400 | 3 | 178800 | 279450 | 10.5 |
| 2024-04 | 19250 | 3 | 198050 | 279450 | 6.9 |
| 2024-05 | 46900 | 3 | 244950 | 279450 | 16.8 |
| 2024-06 | 34500 | 2 | 279450 | 279450 | 12.3 |
| 2025-01 | 93300 | 4 | 93300 | 532500 | 17.5 |
| 2025-02 | 53600 | 3 | 146900 | 532500 | 10.1 |
| 2025-03 | 102400 | 8 | 249300 | 532500 | 19.2 |
| 2025-04 | 82500 | 4 | 331800 | 532500 | 15.5 |
| 2025-05 | 72300 | 4 | 404100 | 532500 | 13.6 |
| 2025-06 | 128400 | 4 | 532500 | 532500 | 24.1 |

_(12 rows)_

### ৭. Line-by-line Explanation

- `WITH monthly AS (...)`: ৪৫টি sale থেকে ১২টি মাসিক row বানানো হলো।
- `DATE_FORMAT(sale_date, '%Y-%m')`: তারিখকে '2025-03' আকারে রূপান্তর, যাতে মাস অনুযায়ী group করা যায়। এই string ঠিকভাবে sort-ও হয়।
- `SUM(monthly_sales) OVER (PARTITION BY yr ORDER BY month)`: প্রতি বছর আলাদা করে (`PARTITION BY yr`) মাসের ক্রমে Running Total। নতুন বছরে আবার 0 থেকে শুরু। একেই **YTD** বলে।
- `SUM(monthly_sales) OVER (PARTITION BY yr)`: `ORDER BY` নেই, তাই পুরো বছরের মোট।
- `pct_of_year`: মাসের বিক্রি ÷ বছরের মোট × 100।

একই কাজ CTE ছাড়া `SUM(SUM(amount)) OVER (PARTITION BY YEAR(sale_date) ORDER BY ...)` দিয়েও করা যায়। কিন্তু CTE-তে পড়তে আর debug করতে সহজ।

### ৮. Common Mistakes

1. **Window-এর ORDER BY-তে এমন expression দেওয়া যা GROUP BY-তে নেই।** GROUP BY-এর পরে শুধু grouped column বা aggregate ব্যবহার করা যায়।
2. **মাসকে `MONTHNAME()` দিয়ে sort করা।** 'April' বর্ণানুক্রমে 'February'-র আগে চলে আসে। `'%Y-%m'` বা মাসের প্রথম দিনের DATE ব্যবহার করুন।
3. **বছর পার হলেও Running Total চলতে থাকা।** YTD চাইলে `PARTITION BY yr` দিন।

### ৯. Practice Problems

- **Beginner:** প্রতিটি category-র মোট বিক্রি বের করুন, আর প্রতিটির পাশে সব category মিলিয়ে মোট বিক্রি দেখান।
- **Intermediate:** উপরের ফলে প্রতিটি category-র share (%) যোগ করুন, আর বড় থেকে ছোট সাজিয়ে **Cumulative Share %** দেখান।
- **Advanced:** প্রতিটি salesperson-এর **মাসিক** বিক্রি বের করুন, আর প্রতিজনের আলাদা YTD Running Total দেখান (salesperson + বছর অনুযায়ী partition)।

### ১০. ছোট Quiz

1. `SUM(SUM(amount)) OVER (...)`-এ কোন SUM আগে চলে?
2. YTD হিসাবে `PARTITION BY yr` না দিলে কী হবে?
3. মাসের নাম ('January') দিয়ে sort করলে সমস্যা কী?

> **Module 3 শেষ।** Lesson 3.2-এ দেখেছেন, একই তারিখের row-এ Running Total অদ্ভুত আচরণ করে। এর মূল কারণ **Window Frame**, যা Module 4-এর বিষয়। Practice শেষ করে **"Ready"** লিখুন।


# Module 4: Window Frame

**আগের Module-এর সঙ্গে সম্পর্ক:** Lesson 3.2-এ দেখেছেন, `ORDER BY` দিলে `SUM` "এ পর্যন্ত মোট" দেয়, আর একই তারিখের row একসঙ্গে যোগ হয়ে যায়। কেন? কারণ প্রতিটি Window Function আসলে partition-এর **একটা নির্দিষ্ট অংশের (Frame)** ওপর কাজ করে। `ORDER BY` দিলে MySQL নিজে থেকেই একটা ডিফল্ট Frame বসিয়ে দেয়। এই Module-এ সেই Frame নিজের হাতে নিয়ন্ত্রণ করা শিখব।

## Lesson 4.1 — Window Frame কী? (UNBOUNDED, CURRENT ROW, PRECEDING, FOLLOWING)

### ১. Topic Introduction

**Window Frame** হলো partition-এর ভেতরে, বর্তমান row-এর সাপেক্ষে, ঠিক কোন কোন row হিসাবে নেওয়া হবে তার সীমানা। এটা চলমান: প্রতিটি row-এর জন্য Frame আলাদা হতে পারে।

### ২. সহজ বাংলা ব্যাখ্যা

ট্রেনের জানালা দিয়ে বাইরে তাকানোর কথা ভাবুন। ট্রেন চলছে (বর্তমান row বদলাচ্ছে), আর জানালা দিয়ে আপনি একসঙ্গে কয়েকটি গাছ দেখছেন। Frame ঠিক করে জানালা কত বড়, আর তা কোন দিকে খোলা:

- **`UNBOUNDED PRECEDING`**: partition-এর একদম প্রথম row থেকে।
- **`n PRECEDING`**: বর্তমান row-এর n টি row আগে থেকে।
- **`CURRENT ROW`**: বর্তমান row।
- **`n FOLLOWING`**: বর্তমান row-এর n টি row পর পর্যন্ত।
- **`UNBOUNDED FOLLOWING`**: partition-এর একদম শেষ row পর্যন্ত।

```text
Partition:  [ Jan | Feb | Mar | Apr | May | Jun ]
বর্তমান row = Apr

ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW   → Jan Feb Mar Apr
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING           → Mar Apr May
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING   → Apr May Jun
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING → Jan … Jun (সব)
```

**ডিফল্ট Frame (খুব গুরুত্বপূর্ণ):**

| OVER-এর ভেতরে | MySQL যে Frame ধরে নেয় |
|---|---|
| `ORDER BY` নেই | পুরো partition (`UNBOUNDED PRECEDING` থেকে `UNBOUNDED FOLLOWING`) |
| `ORDER BY` আছে, Frame লেখা নেই | `RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` |

এজন্যই `ORDER BY` দিলে Running Total হয়। আর ডিফল্টটা `RANGE` হওয়ায় একই মানের row-গুলো একসঙ্গে ঢুকে পড়ে (Lesson 4.3)।

**নোট:** Frame শুধু Aggregate আর `FIRST_VALUE`/`LAST_VALUE`/`NTH_VALUE`-এ কাজ করে। `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `NTILE`, `LAG`, `LEAD` Frame মানে না। এদের Frame লিখলেও MySQL উপেক্ষা করে।

### ৩. Syntax

```text
func(...) OVER (
    [PARTITION BY ...]
    ORDER BY ...
    {ROWS | RANGE} BETWEEN frame_start AND frame_end
)

frame_start / frame_end:
    UNBOUNDED PRECEDING | n PRECEDING | CURRENT ROW | n FOLLOWING | UNBOUNDED FOLLOWING

সংক্ষিপ্ত রূপ:  ROWS UNBOUNDED PRECEDING
               = ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
```

### ৪. Sample Data

2025 সালের মাসিক বিক্রি (৬টি row), `sales` থেকে CTE দিয়ে বানানো।

### ৫. SQL Query

```sql
WITH monthly AS (
    SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month,
           SUM(amount) AS total
    FROM sales
    WHERE YEAR(sale_date) = 2025
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT
    month,
    total,
    SUM(total) OVER (ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)         AS running_total,
    SUM(total) OVER (ORDER BY month
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)         AS remaining_total,
    SUM(total) OVER (ORDER BY month
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)                 AS prev_cur_next,
    SUM(total) OVER (ORDER BY month
        ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING)                 AS prev_two_months,
    SUM(total) OVER (ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS grand_total
FROM monthly
ORDER BY month;
```

### ৬. Expected Output

**Output:**

| month | total | running_total | remaining_total | prev_cur_next | prev_two_months | grand_total |
|---|---|---|---|---|---|---|
| 2025-01 | 93300 | 93300 | 532500 | 146900 | NULL | 532500 |
| 2025-02 | 53600 | 146900 | 439200 | 249300 | 93300 | 532500 |
| 2025-03 | 102400 | 249300 | 385600 | 238500 | 146900 | 532500 |
| 2025-04 | 82500 | 331800 | 283200 | 257200 | 156000 | 532500 |
| 2025-05 | 72300 | 404100 | 200700 | 283200 | 184900 | 532500 |
| 2025-06 | 128400 | 532500 | 128400 | 200700 | 154800 | 532500 |

_(6 rows)_

### ৭. Line-by-line Explanation

- `running_total`: শুরু থেকে বর্তমান মাস পর্যন্ত। Jan = 93300, Feb = 93300 + 53600 = 146900।
- `remaining_total`: বর্তমান মাস থেকে শেষ পর্যন্ত। Jun-এ শুধু নিজের মান।
- `prev_cur_next`: আগের মাস + বর্তমান + পরের মাস। Jan-এর আগে কিছু নেই, তাই শুধু Jan + Feb।
- `prev_two_months`: বর্তমান row বাদ দিয়ে আগের দুই মাস। Jan-এর আগে কিছু নেই, তাই Frame খালি, ফল **NULL**।
- `grand_total`: পুরো partition। `OVER ()`-এর সমান।

### ৮. Common Mistakes

1. **Frame-এর শুরু শেষের পরে লেখা।** যেমন `BETWEEN CURRENT ROW AND 1 PRECEDING`, এতে Error আসে।
2. **ভাবা যে Frame ছাড়া `ORDER BY` দিলে পুরো partition আসবে।** আসে না। ডিফল্ট হলো "শুরু থেকে বর্তমান row (ও তার peers) পর্যন্ত"।
3. **খালি Frame-এ NULL পাওয়াকে bug ভাবা।** এটা স্বাভাবিক। দরকার হলে `COALESCE(..., 0)` দিন।
4. **`ROW_NUMBER`/`LAG`-এ Frame দিয়ে কিছু পরিবর্তনের আশা করা।** এদের ওপর Frame কাজ করে না।

### ৯. Practice Problems

- **Beginner:** 2024 সালের মাসিক বিক্রিতে `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` দিয়ে Running Total বের করুন।
- **Intermediate:** প্রতিটি মাসের পাশে "পরের দুই মাসের মোট বিক্রি" (বর্তমান মাস বাদে) দেখান।
- **Advanced:** প্রতিটি employee-র (salary অনুযায়ী সাজানো, বেশি আগে) পাশে দেখান: তার ঠিক ওপরের আর ঠিক নিচের employee-র salary-র **গড়**। একটি Aggregate + Frame দিয়ে করবেন, `LAG`/`LEAD` ছাড়া।

### ১০. ছোট Quiz

1. `ORDER BY` আছে কিন্তু Frame নেই, তখন ডিফল্ট Frame কী?
2. `ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING` প্রথম row-এর জন্য কী দেবে?
3. `ROWS UNBOUNDED PRECEDING`-এর পূর্ণ রূপ কী?

---

## Lesson 4.2 — Moving Average এবং Rolling Sum

### ১. Topic Introduction

**Moving Average (চলমান গড়)** মানে শেষ N টি সময়ের গড়, আর **Rolling Sum** মানে শেষ N টি সময়ের যোগফল। প্রতি ধাপে জানালা এক ঘর সরে যায়: একটা নতুন মান ঢোকে, সবচেয়ে পুরনো মানটা বেরিয়ে যায়।

### ২. সহজ বাংলা ব্যাখ্যা

আপনার মাসিক বিক্রি একেক মাসে খুব ওঠানামা করে: 93 হাজার, 53 হাজার, 102 হাজার… এই ওঠানামা দেখে আসল প্রবণতা (trend) বোঝা কঠিন। "শেষ ৩ মাসের গড়" নিলে লাইনটা মসৃণ হয়ে যায়, আর বোঝা যায় ব্যবসা আসলে বাড়ছে না কমছে। শেয়ারবাজারের "50-day moving average" এই একই ধারণা।

**প্রথম দিকের মাসের সমস্যা:** জানুয়ারিতে "শেষ ৩ মাস" বলতে শুধু ১টি মাস পাওয়া যায়, ফেব্রুয়ারিতে ২টি। এগুলো পূর্ণ ৩ মাসের গড় নয়। রিপোর্টে এদের আলাদা করে চিহ্নিত করা বা NULL দেখানো ভালো।

### ৩. Syntax

```text
AVG(col) OVER (ORDER BY time_col ROWS BETWEEN (N-1) PRECEDING AND CURRENT ROW)  -- N-period Moving Avg
SUM(col) OVER (ORDER BY time_col ROWS BETWEEN (N-1) PRECEDING AND CURRENT ROW)  -- N-period Rolling Sum
```

### ৪. Sample Data

2025-এর মাসিক বিক্রি (Lesson 4.1-এর CTE)।

### ৫. SQL Query

```sql
WITH monthly AS (
    SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month,
           SUM(amount) AS total
    FROM sales
    WHERE YEAR(sale_date) = 2025
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT
    month,
    total,
    SUM(total) OVER w3                          AS rolling_3m_sum,
    ROUND(AVG(total) OVER w3, 0)                AS moving_avg_3m,
    COUNT(*)   OVER w3                          AS months_in_window,
    CASE WHEN COUNT(*) OVER w3 = 3
         THEN ROUND(AVG(total) OVER w3, 0)
    END                                         AS moving_avg_3m_strict,
    ROUND(AVG(total) OVER (ORDER BY month
          ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), 0) AS centered_avg
FROM monthly
WINDOW w3 AS (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
ORDER BY month;
```

### ৬. Expected Output

**Output:**

| month | total | rolling_3m_sum | moving_avg_3m | months_in_window | moving_avg_3m_strict | centered_avg |
|---|---|---|---|---|---|---|
| 2025-01 | 93300 | 93300 | 93300 | 1 | NULL | 73450 |
| 2025-02 | 53600 | 146900 | 73450 | 2 | NULL | 83100 |
| 2025-03 | 102400 | 249300 | 83100 | 3 | 83100 | 79500 |
| 2025-04 | 82500 | 238500 | 79500 | 3 | 79500 | 85733 |
| 2025-05 | 72300 | 257200 | 85733 | 3 | 85733 | 94400 |
| 2025-06 | 128400 | 283200 | 94400 | 3 | 94400 | 100350 |

_(6 rows)_

### ৭. Line-by-line Explanation

- `WINDOW w3 AS (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)`: আগের ২ মাস + বর্তমান মাস = ৩ মাসের জানালা।
- `SUM(total) OVER w3`: ৩ মাসের Rolling Sum। Mar = Jan + Feb + Mar = 93300 + 53600 + 102400 = 249300।
- `AVG(total) OVER w3`: ৩ মাসের Moving Average। Mar = 249300 ÷ 3 = 83100।
- `COUNT(*) OVER w3`: জানালায় আসলে কয়টি মাস আছে। Jan-এ 1, Feb-এ 2।
- `CASE WHEN COUNT(*) OVER w3 = 3 THEN ... END`: পূর্ণ ৩ মাস না থাকলে NULL। এটা সৎ রিপোর্টিং।
- `centered_avg`: আগের, বর্তমান আর পরের মাসের গড়। Trend বিশ্লেষণে কাজে লাগে, কিন্তু ভবিষ্যতের data লাগে বলে চলতি মাসের রিপোর্টে ব্যবহার করা যায় না।

### ৮. Common Mistakes

1. **`ROWS` ছাড়া শুধু `ORDER BY` দিয়ে Moving Average বানানোর চেষ্টা।** তখন Cumulative Average পাবেন, Moving নয়।
2. **মাস বাদ পড়লে (missing month) `ROWS` ভুল ফল দেয়।** "আগের ২টি row" মানে "আগের ২ মাস" না-ও হতে পারে। সমাধান: সব মাসের একটা calendar বানিয়ে LEFT JOIN করুন, অথবা `RANGE` + INTERVAL (Lesson 4.3)।
3. **অসম্পূর্ণ জানালার গড়কে পূর্ণ গড় হিসেবে দেখানো।**

### ৯. Practice Problems

- **Beginner:** 2025-এর মাসিক বিক্রির ২-মাসের Moving Average বের করুন।
- **Intermediate:** প্রতিটি salesperson-এর **শেষ ৩টি sale-এর** Rolling Sum বের করুন (salesperson অনুযায়ী partition, `sale_date, sale_id` অনুযায়ী ক্রম)।
- **Advanced:** 2025-এর মাসিক বিক্রিতে ৩-মাসের Moving Average বের করে দেখান কোন মাসে বিক্রি Moving Average-এর চেয়ে ১০%-এর বেশি ওপরে ছিল (`'Spike'` লেবেল দিন)।

### ১০. ছোট Quiz

1. ৩-মাসের Moving Average-এর Frame কী হবে?
2. Rolling Sum আর Running Total-এর পার্থক্য কী?
3. প্রথম দুই মাসের Moving Average কেন "অসম্পূর্ণ"?

---

## Lesson 4.3 — ROWS বনাম RANGE: বাস্তব পার্থক্য

### ১. Topic Introduction

`ROWS` Frame গোনে **শারীরিক row** দিয়ে ("আগের ২টি row")। `RANGE` Frame গোনে **ORDER BY column-এর মান** দিয়ে ("যাদের তারিখ আজ থেকে ২ দিনের মধ্যে")। একই `ORDER BY` মানের row-গুলোকে `RANGE` **peer** হিসেবে একসঙ্গে ধরে।

### ২. সহজ বাংলা ব্যাখ্যা

একটা লাইনে মানুষ দাঁড়িয়ে আছে, প্রত্যেকের হাতে তারিখ লেখা টিকিট।

- **ROWS 2 PRECEDING** = "আমার ঠিক সামনের ২ জন", তাদের টিকিটে যে তারিখই থাকুক।
- **RANGE INTERVAL 2 DAY PRECEDING** = "যাদের টিকিটের তারিখ আমার তারিখের ২ দিনের মধ্যে", তারা ১ জন হোক বা ১০ জন।

আর `RANGE ... CURRENT ROW` মানে "আমি আর **আমার মতো একই তারিখের সবাই**"। Lesson 3.2-এর রহস্যের সমাধান এটাই: ডিফল্ট Frame `RANGE`, তাই একই তারিখের দুটি sale একসঙ্গে যোগ হয়েছিল।

| বিষয় | ROWS | RANGE |
|---|---|---|
| একক | row সংখ্যা | ORDER BY-এর মান |
| Ties/duplicate মান | আলাদা আলাদা row | সবাই একসঙ্গে (peers) |
| `n PRECEDING` | n টি row আগে | মান − n পর্যন্ত |
| তারিখে INTERVAL | না | হ্যাঁ (`INTERVAL 7 DAY PRECEDING`) |
| ORDER BY column | যতগুলো খুশি | মান-ভিত্তিক offset দিলে ঠিক ১টি numeric/date column |
| ডিফল্ট (ORDER BY থাকলে) | না | হ্যাঁ |

**Running Total-এর Frame নির্ধারণের নিয়ম:**

- প্রতিটি row-এর আলাদা running total চাইলে → `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` (সঙ্গে tie-breaker)।
- "এই তারিখের শেষে মোট কত" চাইলে (একই তারিখের সবাই একই মান) → `RANGE` (ডিফল্ট)।

### ৩. Syntax

```text
SUM(x) OVER (ORDER BY d ROWS  BETWEEN 2 PRECEDING AND CURRENT ROW)
SUM(x) OVER (ORDER BY d RANGE BETWEEN INTERVAL 2 DAY PRECEDING AND CURRENT ROW)
SUM(x) OVER (ORDER BY n RANGE BETWEEN 5000 PRECEDING AND 5000 FOLLOWING)
```

### ৪. Sample Data

`sales` Table-এর মার্চ 2025 অংশ (৮টি row, ১১ আর ১২ তারিখে দুটি করে sale)।

### ৫. SQL Query

**(ক) একই data-তে ROWS আর RANGE:**

```sql
SELECT
    sale_id,
    sale_date,
    amount,
    SUM(amount) OVER (ORDER BY sale_date, sale_id
                      ROWS  BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS rows_running,
    SUM(amount) OVER (ORDER BY sale_date
                      RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS range_running,
    SUM(amount) OVER (ORDER BY sale_date, sale_id
                      ROWS  BETWEEN 2 PRECEDING AND CURRENT ROW)         AS last_3_rows,
    SUM(amount) OVER (ORDER BY sale_date
                      RANGE BETWEEN INTERVAL 2 DAY PRECEDING AND CURRENT ROW) AS last_3_days
FROM sales
WHERE sale_date BETWEEN '2025-03-01' AND '2025-03-31'
ORDER BY sale_date, sale_id;
```

**(খ) সংখ্যার ওপর RANGE: নিজের salary-র ±5000-এর মধ্যে কতজন সহকর্মী আছে?**

```sql
SELECT
    emp_name,
    salary,
    COUNT(*) OVER (ORDER BY salary
                   RANGE BETWEEN 5000 PRECEDING AND 5000 FOLLOWING) - 1 AS peers_within_5000
FROM employees
ORDER BY salary DESC, emp_id;
```

### ৬. Expected Output

**(ক):**

**Output:**

| sale_id | sale_date | amount | rows_running | range_running | last_3_rows | last_3_days |
|---|---|---|---|---|---|---|
| 26 | 2025-03-10 | 700 | 700 | 700 | 700 | 700 |
| 27 | 2025-03-11 | 1900 | 2600 | 14600 | 2600 | 14600 |
| 28 | 2025-03-11 | 12000 | 14600 | 14600 | 14600 | 14600 |
| 29 | 2025-03-12 | 2200 | 16800 | 20400 | 16100 | 20400 |
| 30 | 2025-03-12 | 3600 | 20400 | 20400 | 17800 | 20400 |
| 31 | 2025-03-15 | 2500 | 22900 | 22900 | 8300 | 2500 |
| 32 | 2025-03-16 | 4500 | 27400 | 27400 | 10600 | 7000 |
| 33 | 2025-03-28 | 75000 | 102400 | 102400 | 82000 | 75000 |

_(8 rows)_

পড়ার কৌশল:

- **rows_running বনাম range_running:** sale 27-এ rows = 2600, কিন্তু range = 14600, কারণ RANGE একই তারিখের sale 28-কেও নিয়ে নিয়েছে।
- **last_3_rows বনাম last_3_days:** sale 31 (১৫ তারিখ)-এ `last_3_rows` নিয়েছে sale 29, 30, 31 (১২ ও ১৫ তারিখ)। কিন্তু `last_3_days` (১৩–১৫ তারিখ) নিয়েছে শুধু sale 31, কারণ ১৩ বা ১৪ তারিখে কোনো sale নেই। ব্যবসায়িক প্রশ্নটা যদি হয় "শেষ ৩ দিনে কত বিক্রি", তাহলে সঠিক উত্তর RANGE দেয়।

**(খ):**

**Output:**

| emp_name | salary | peers_within_5000 |
|---|---|---|
| Tanvir Ahmed | 85000 | 0 |
| Farhana Yasmin | 78000 | 1 |
| Imran Kabir | 78000 | 1 |
| Sabbir Hossain | 72000 | 1 |
| Mitu Rahman | 72000 | 1 |
| Arif Chowdhury | 65000 | 3 |
| Karim Hasan | 62000 | 3 |
| Fatema Akter | 62000 | 3 |
| Rubina Khatun | 60000 | 4 |
| Rahim Uddin | 55000 | 2 |
| Jamal Uddin | 52000 | 2 |
| Nusrat Jahan | 48000 | 2 |
| Sumaiya Islam | 45000 | 1 |

_(13 rows)_

### ৭. Line-by-line Explanation

- (ক) `ROWS ... ORDER BY sale_date, sale_id`: ROWS-এ tie-breaker দেওয়া ভালো, তাহলে ফল নির্দিষ্ট থাকে।
- (ক) `RANGE ... ORDER BY sale_date`: RANGE-এ `INTERVAL` offset দিলে ORDER BY-তে **ঠিক একটি** column থাকতে হবে।
- (ক) `INTERVAL 2 DAY PRECEDING AND CURRENT ROW`: বর্তমান তারিখ আর তার আগের ২ দিন, মোট ৩ দিনের ক্যালেন্ডার-জানালা।
- (খ) `RANGE BETWEEN 5000 PRECEDING AND 5000 FOLLOWING`: salary − 5000 থেকে salary + 5000 পর্যন্ত যাদের salary, তারা সবাই।
- (খ) `- 1`: নিজেকে বাদ দেওয়া।

### ৮. Common Mistakes

1. **RANGE + INTERVAL-এ একাধিক ORDER BY column দেওয়া।** Error আসে।
2. **ROWS-এ tie-breaker না দেওয়া।** একই তারিখের row-এর ক্রম অনির্দিষ্ট থাকে, তাই ফলও অনির্দিষ্ট।
3. **"শেষ ৭ দিন" বোঝাতে `ROWS 6 PRECEDING` লেখা।** কিছু দিনে sale না থাকলে বা একদিনে একাধিক sale থাকলে ভুল হয়। `RANGE INTERVAL 6 DAY PRECEDING` দিন।
4. **ডিফল্ট RANGE-কে উপেক্ষা করা।** Duplicate ORDER BY মানে Running Total লাফ দেয়।

### ৯. Practice Problems

- **Beginner:** পুরো `sales` Table-এ `ROWS` আর `RANGE` দিয়ে দুটি Running Total পাশাপাশি দেখান, তারপর কোন কোন row-এ দুটো আলাদা তা খুঁজে বের করুন।
- **Intermediate:** প্রতিটি sale-এর পাশে "শেষ ৭ দিনের মোট বিক্রি" (বর্তমান দিনসহ) দেখান।
- **Advanced:** প্রতিটি product-এর পাশে দেখান, তার দামের ±20%-এর মধ্যে আর কয়টি product আছে। (ইঙ্গিত: RANGE-এ offset একটা স্থির সংখ্যা হতে হয়, তাই এই Problem-এ Self-Join বা Subquery লাগবে। কেন RANGE এখানে সরাসরি কাজ করে না, সেটাও ব্যাখ্যা করুন।)

### ১০. ছোট Quiz

1. একই তারিখের দুটি row-এ `RANGE ... CURRENT ROW` কী করে?
2. "শেষ ৩০ দিনের বিক্রি" বের করতে ROWS না RANGE?
3. `ORDER BY` আছে কিন্তু Frame নেই, তখন ROWS না RANGE ধরা হয়?

> **Module 4 শেষ।** এখন আপনি জানেন Window Function ঠিক কোন row-গুলো দেখে। Module 5-এর `LAST_VALUE`-এ এই জ্ঞান সরাসরি লাগবে। **"Ready"** লিখুন।


# Module 5: Advanced Window Functions (LAG, LEAD, FIRST_VALUE, LAST_VALUE, NTH_VALUE)

**আগের Module-এর সঙ্গে সম্পর্ক:** এ পর্যন্ত আমরা Window-এর row-গুলো **একত্র করে** (যোগ, গড়, গণনা) একটা মান বানিয়েছি। এই Module-এর function-গুলো একত্র করে না। এরা Window-এর **একটি নির্দিষ্ট row-এর মান তুলে আনে**: আগের row, পরের row, প্রথম row, শেষ row বা N-তম row। `LAG`/`LEAD` Frame মানে না। কিন্তু `FIRST_VALUE`/`LAST_VALUE`/`NTH_VALUE` Frame মানে, তাই Module 4-এর জ্ঞান এখানে সরাসরি লাগবে।

## Lesson 5.1 — LAG() এবং LEAD(): আগের ও পরের Row

### ১. Topic Introduction

- `LAG(col, n, default)` বর্তমান row-এর **n টি row আগের** মান এনে দেয়।
- `LEAD(col, n, default)` বর্তমান row-এর **n টি row পরের** মান এনে দেয়।

Self-Join ছাড়াই আগের বা পরের row-এর সঙ্গে তুলনা করার সবচেয়ে সহজ উপায় এগুলো।

### ২. সহজ বাংলা ব্যাখ্যা

ডায়েরিতে প্রতিদিনের ওজন লিখছেন। আজকের পাতায় শুধু আজকের ওজন নয়, **গতকালের ওজনও** পাশে লিখে রাখলে এক নজরে বোঝা যায় কতটা বাড়ল বা কমল। `LAG` হলো "গতকালের পাতা দেখা", আর `LEAD` হলো "আগামীকালের পাতা দেখা"।

- প্রথম row-এর আগে কিছু নেই, তাই `LAG` দেয় NULL (অথবা আপনার দেওয়া default)।
- শেষ row-এর পরে কিছু নেই, তাই `LEAD` দেয় NULL।

### ৩. Syntax

```text
LAG(expr  [, offset [, default]]) OVER ([PARTITION BY ...] ORDER BY ...)
LEAD(expr [, offset [, default]]) OVER ([PARTITION BY ...] ORDER BY ...)
-- offset ডিফল্ট 1, default ডিফল্ট NULL
```

### ৪. Sample Data

`employees` আর `sales` Table।

### ৫. SQL Query

**(ক) Employee Salary Comparison: department-এ ঠিক ওপরের আর নিচের জনের সঙ্গে তুলনা:**

```sql
SELECT
    dept_id,
    emp_name,
    salary,
    LAG(salary)  OVER w          AS next_higher_salary,
    salary - LAG(salary) OVER w  AS diff_from_higher,
    LEAD(salary) OVER w          AS next_lower_salary,
    LEAD(emp_name) OVER w        AS next_lower_emp
FROM employees
WINDOW w AS (PARTITION BY dept_id ORDER BY salary DESC, emp_id)
ORDER BY dept_id, salary DESC, emp_id;
```

**(খ) Customer-এর প্রতিটি কেনাকাটার আগের কেনাকাটার তারিখ আর ব্যবধান (দিন):**

```sql
SELECT
    customer_id,
    sale_id,
    sale_date,
    amount,
    LAG(sale_date) OVER w                          AS prev_purchase_date,
    DATEDIFF(sale_date, LAG(sale_date) OVER w)     AS days_since_prev,
    LAG(amount, 1, 0) OVER w                       AS prev_amount_or_0
FROM sales
WHERE customer_id IN (1, 4)
WINDOW w AS (PARTITION BY customer_id ORDER BY sale_date, sale_id)
ORDER BY customer_id, sale_date, sale_id;
```

### ৬. Expected Output

**(ক):**

**Output:**

| dept_id | emp_name | salary | next_higher_salary | diff_from_higher | next_lower_salary | next_lower_emp |
|---|---|---|---|---|---|---|
| 1 | Karim Hasan | 62000 | NULL | NULL | 62000 | Fatema Akter |
| 1 | Fatema Akter | 62000 | 62000 | 0 | 55000 | Rahim Uddin |
| 1 | Rahim Uddin | 55000 | 62000 | -7000 | 48000 | Nusrat Jahan |
| 1 | Nusrat Jahan | 48000 | 55000 | -7000 | NULL | NULL |
| 2 | Tanvir Ahmed | 85000 | NULL | NULL | 72000 | Sabbir Hossain |
| 2 | Sabbir Hossain | 72000 | 85000 | -13000 | 72000 | Mitu Rahman |
| 2 | Mitu Rahman | 72000 | 72000 | 0 | 65000 | Arif Chowdhury |
| 2 | Arif Chowdhury | 65000 | 72000 | -7000 | NULL | NULL |
| 3 | Jamal Uddin | 52000 | NULL | NULL | 45000 | Sumaiya Islam |
| 3 | Sumaiya Islam | 45000 | 52000 | -7000 | NULL | NULL |
| 4 | Farhana Yasmin | 78000 | NULL | NULL | 78000 | Imran Kabir |
| 4 | Imran Kabir | 78000 | 78000 | 0 | 60000 | Rubina Khatun |
| 4 | Rubina Khatun | 60000 | 78000 | -18000 | NULL | NULL |

_(13 rows)_

**(খ):**

**Output:**

| customer_id | sale_id | sale_date | amount | prev_purchase_date | days_since_prev | prev_amount_or_0 |
|---|---|---|---|---|---|---|
| 1 | 1 | 2024-01-05 | 35000 | NULL | NULL | 0 |
| 1 | 8 | 2024-03-02 | 12000 | 2024-01-05 | 57 | 35000 |
| 1 | 15 | 2024-05-19 | 4400 | 2024-03-02 | 78 | 12000 |
| 1 | 19 | 2025-01-05 | 75000 | 2024-05-19 | 231 | 4400 |
| 1 | 28 | 2025-03-11 | 12000 | 2025-01-05 | 65 | 75000 |
| 1 | 30 | 2025-03-12 | 3600 | 2025-03-11 | 1 | 12000 |
| 1 | 38 | 2025-05-09 | 35000 | 2025-03-12 | 58 | 3600 |
| 4 | 4 | 2024-01-28 | 5000 | NULL | NULL | 0 |
| 4 | 11 | 2024-04-04 | 9000 | 2024-01-28 | 67 | 5000 |
| 4 | 18 | 2024-06-21 | 4500 | 2024-04-04 | 78 | 9000 |
| 4 | 25 | 2025-02-25 | 6600 | 2024-06-21 | 249 | 4500 |
| 4 | 37 | 2025-04-30 | 8500 | 2025-02-25 | 64 | 6600 |

_(12 rows)_

### ৭. Line-by-line Explanation

- (ক) `WINDOW w AS (PARTITION BY dept_id ORDER BY salary DESC, emp_id)`: department-এর ভেতরে বেশি salary আগে। "আগের row" মানে ঠিক ওপরের বেশি বেতনের জন।
- (ক) `LAG(salary) OVER w`: ওপরের জনের salary। department-এর প্রথম জনের জন্য NULL।
- (ক) `salary - LAG(salary) OVER w`: ওপরের জনের চেয়ে কত কম (ঋণাত্মক মান)। সমান হলে 0।
- (ক) `LEAD(emp_name) OVER w`: নিচের জনের **নাম**। শুধু সংখ্যা নয়, যেকোনো column আনা যায়।
- (খ) `PARTITION BY customer_id`: প্রতিটি customer-এর ইতিহাস আলাদা।
- (খ) `DATEDIFF(sale_date, LAG(sale_date) OVER w)`: দুই কেনাকাটার মাঝে কত দিন।
- (খ) `LAG(amount, 1, 0)`: প্রথম কেনাকাটায় NULL-এর বদলে 0।

### ৮. Common Mistakes

1. **`PARTITION BY` ভুলে যাওয়া।** তখন এক customer-এর "আগের কেনাকাটা" হিসেবে অন্য customer-এর row চলে আসে।
2. **Non-unique ORDER BY।** একই তারিখে দুটি row থাকলে কোনটা "আগের", তা অনিশ্চিত। tie-breaker দিন।
3. **LAG/LEAD-এ Frame দেওয়া।** কোনো প্রভাব পড়ে না।
4. **`LAG` মানে "আগের মাস" ভাবা।** `LAG` মানে "আগের row"। মাস বাদ পড়লে ভুল তুলনা হয় (Module 6-এ সমাধান)।

### ৯. Practice Problems

- **Beginner:** `employees`-এ `hire_date` অনুযায়ী সাজিয়ে প্রতিটি employee-র পাশে তার **আগে যোগ দেওয়া** employee-র নাম দেখান।
- **Intermediate:** প্রতিটি salesperson-এর প্রতিটি sale-এর পাশে তার **পরের** sale-এর তারিখ আর amount দেখান।
- **Advanced:** প্রতিটি customer-এর জন্য বের করুন দুই কেনাকাটার মাঝে **সবচেয়ে বড় বিরতি (দিন)** কত ছিল (LAG + CTE + MAX)।

### ১০. ছোট Quiz

1. `LAG(amount, 2)` কী দেয়?
2. `LEAD` শেষ row-এ কী দেয়, আর NULL-এর বদলে 0 পেতে কী লিখবেন?
3. LAG/LEAD-এ `PARTITION BY` কেন গুরুত্বপূর্ণ?

---

## Lesson 5.2 — মাসভিত্তিক Sales Growth: আগের মাসের সঙ্গে তুলনা

### ১. Topic Introduction

`LAG` দিয়ে আগের মাসের বিক্রি পাশে আনলে Growth হিসাব সহজ হয়ে যায়:

**Growth % = (এই মাস − আগের মাস) ÷ আগের মাস × 100**

### ২. সহজ বাংলা ব্যাখ্যা

দোকানের মালিক প্রতি মাসের শেষে জানতে চান: "গত মাসের চেয়ে কত বেশি বা কম বিক্রি হলো, শতাংশে?" Module 3-এ মাসিক মোট বানানো শিখেছেন। এখন সেই মোটের পাশে `LAG` দিয়ে গত মাসের মোট আনব, তারপর শতাংশ হিসাব করব।

### ৩. Syntax

```text
WITH monthly AS (SELECT month, SUM(amount) AS total FROM ... GROUP BY month)
SELECT month, total,
       LAG(total) OVER (ORDER BY month) AS prev_total,
       ROUND(100 * (total - LAG(total) OVER (ORDER BY month))
                 / NULLIF(LAG(total) OVER (ORDER BY month), 0), 2) AS growth_pct
FROM monthly;
```

### ৪. Sample Data

2025-এর মাসিক বিক্রি।

### ৫. SQL Query

```sql
WITH monthly AS (
    SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month,
           SUM(amount) AS total
    FROM sales
    WHERE YEAR(sale_date) = 2025
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT
    month,
    total                                           AS current_month,
    LAG(total) OVER w                               AS previous_month,
    total - LAG(total) OVER w                       AS change_amount,
    ROUND(100 * (total - LAG(total) OVER w)
              / NULLIF(LAG(total) OVER w, 0), 2)    AS growth_pct,
    CASE
        WHEN LAG(total) OVER w IS NULL THEN 'N/A'
        WHEN total > LAG(total) OVER w THEN 'Up'
        WHEN total < LAG(total) OVER w THEN 'Down'
        ELSE 'Flat'
    END                                             AS trend,
    LEAD(total) OVER w                              AS next_month
FROM monthly
WINDOW w AS (ORDER BY month)
ORDER BY month;
```

### ৬. Expected Output

**Output:**

| month | current_month | previous_month | change_amount | growth_pct | trend | next_month |
|---|---|---|---|---|---|---|
| 2025-01 | 93300 | NULL | NULL | NULL | N/A | 53600 |
| 2025-02 | 53600 | 93300 | -39700 | -42.55 | Down | 102400 |
| 2025-03 | 102400 | 53600 | 48800 | 91.04 | Up | 82500 |
| 2025-04 | 82500 | 102400 | -19900 | -19.43 | Down | 72300 |
| 2025-05 | 72300 | 82500 | -10200 | -12.36 | Down | 128400 |
| 2025-06 | 128400 | 72300 | 56100 | 77.59 | Up | NULL |

_(6 rows)_

### ৭. Line-by-line Explanation

- `WITH monthly`: ৬টি মাসিক row।
- `LAG(total) OVER w`: আগের মাসের মোট। জানুয়ারির আগের মাস (2024-12) এই data-তে নেই, তাই NULL।
- `total - LAG(total) OVER w`: পরিবর্তন, টাকায়।
- `NULLIF(LAG(total) OVER w, 0)`: আগের মাস 0 হলে শূন্য দিয়ে ভাগ এড়াতে NULL বানানো। MySQL-এ শূন্য দিয়ে ভাগ করলে NULL আসে, তবে strict mode-এ INSERT/UPDATE-এর সময় Error দিতে পারে, তাই অভ্যাসটা রাখুন।
- `CASE ... END AS trend`: সংখ্যাকে সহজ ভাষায় রূপান্তর।
- `LEAD(total) OVER w`: পরের মাস। Forecast-এর সঙ্গে মেলাতে কাজে লাগে।

### ৮. Common Mistakes

1. **শতাংশে ১০০ দিয়ে গুণ করতে ভুলে যাওয়া।** তখন 0.4 মানে 40%, এমন বিভ্রান্তি হয়।
2. **ভাগের হর (denominator) ভুল নেওয়া।** Growth-এর হর হবে **আগের মাস**, বর্তমান মাস নয়।
3. **শূন্য দিয়ে ভাগ।** `NULLIF` ব্যবহার করুন।
4. **মাস বাদ পড়ে গেলে ভুল তুলনা।** Module 6-এ দেখবেন 2024-06-এর পরের row 2025-01, আর `LAG` সেটাকে "আগের মাস" ভেবে নেয়।

### ৯. Practice Problems

- **Beginner:** 2024-এর মাসিক বিক্রির জন্য আগের মাসের বিক্রি আর পরিবর্তন (টাকায়) দেখান।
- **Intermediate:** 2025-এর মাসিক **order সংখ্যার** Growth % বের করুন।
- **Advanced:** প্রতিটি salesperson-এর 2025-এর মাসিক বিক্রি বের করে আগের মাসের সঙ্গে Growth % দেখান (salesperson অনুযায়ী partition)। কোনো মাসে কারও বিক্রি না থাকলে কী সমস্যা হয়, লিখুন।

### ১০. ছোট Quiz

1. Growth %-এর সূত্রে হর কোনটি?
2. `NULLIF(x, 0)` কী করে?
3. জানুয়ারির `previous_month` কেন NULL?

---

## Lesson 5.3 — FIRST_VALUE(), LAST_VALUE(), NTH_VALUE() এবং LAST_VALUE-এর Frame সমস্যা

### ১. Topic Introduction

- `FIRST_VALUE(col)`: Frame-এর **প্রথম** row-এর মান।
- `LAST_VALUE(col)`: Frame-এর **শেষ** row-এর মান।
- `NTH_VALUE(col, n)`: Frame-এর **n-তম** row-এর মান।

তিনটিই Frame মানে। এটাই সবচেয়ে বড় ফাঁদ।

### ২. সহজ বাংলা ব্যাখ্যা

ক্লাসে নম্বর অনুযায়ী লাইনে দাঁড়ানো ছাত্রদের প্রত্যেককে জিজ্ঞেস করা হলো: "লাইনের প্রথম জন কে? শেষ জন কে? দ্বিতীয় জন কে?"

- **প্রথম জন:** সবাই সামনে তাকিয়ে একই উত্তর দেয়। `FIRST_VALUE` ঠিকঠাক কাজ করে।
- **শেষ জন:** সমস্যা! ডিফল্ট Frame হলো "শুরু থেকে **আমি পর্যন্ত**" (Module 4)। তাই প্রত্যেকে পেছনে না তাকিয়ে নিজেকেই "শেষ জন" বলে! `LAST_VALUE`-এর ভুল উত্তর এখান থেকেই আসে।
- **সমাধান:** Frame-কে পুরো লাইন বানিয়ে দিন: `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`।

### ৩. Syntax

```text
FIRST_VALUE(expr) OVER (... ORDER BY ... [frame])
LAST_VALUE(expr)  OVER (... ORDER BY ...
                        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
NTH_VALUE(expr, n) [FROM FIRST] OVER (... ORDER BY ... [frame])
```

### ৪. Sample Data

`employees` Table।

### ৫. SQL Query

**(ক) LAST_VALUE-এর সমস্যা আর সমাধান পাশাপাশি:**

```sql
SELECT
    dept_id,
    emp_name,
    salary,
    FIRST_VALUE(emp_name) OVER (PARTITION BY dept_id ORDER BY salary DESC, emp_id)
        AS top_earner,
    LAST_VALUE(emp_name)  OVER (PARTITION BY dept_id ORDER BY salary DESC, emp_id)
        AS lowest_WRONG,
    LAST_VALUE(emp_name)  OVER (PARTITION BY dept_id ORDER BY salary DESC, emp_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
        AS lowest_CORRECT
FROM employees
ORDER BY dept_id, salary DESC, emp_id;
```

**(খ) NTH_VALUE: প্রতিটি department-এর দ্বিতীয় সর্বোচ্চ salary, ডিফল্ট Frame বনাম পূর্ণ Frame:**

```sql
SELECT
    dept_id,
    emp_name,
    salary,
    NTH_VALUE(salary, 2) OVER (PARTITION BY dept_id ORDER BY salary DESC, emp_id)
        AS second_default_frame,
    NTH_VALUE(salary, 2) OVER (PARTITION BY dept_id ORDER BY salary DESC, emp_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
        AS second_full_frame,
    salary - FIRST_VALUE(salary) OVER (PARTITION BY dept_id ORDER BY salary DESC)
        AS diff_from_top
FROM employees
ORDER BY dept_id, salary DESC, emp_id;
```

### ৬. Expected Output

**(ক):** `lowest_WRONG` column-এ প্রতিটি row নিজের নামই দেখাচ্ছে।

**Output:**

| dept_id | emp_name | salary | top_earner | lowest_WRONG | lowest_CORRECT |
|---|---|---|---|---|---|
| 1 | Karim Hasan | 62000 | Karim Hasan | Karim Hasan | Nusrat Jahan |
| 1 | Fatema Akter | 62000 | Karim Hasan | Fatema Akter | Nusrat Jahan |
| 1 | Rahim Uddin | 55000 | Karim Hasan | Rahim Uddin | Nusrat Jahan |
| 1 | Nusrat Jahan | 48000 | Karim Hasan | Nusrat Jahan | Nusrat Jahan |
| 2 | Tanvir Ahmed | 85000 | Tanvir Ahmed | Tanvir Ahmed | Arif Chowdhury |
| 2 | Sabbir Hossain | 72000 | Tanvir Ahmed | Sabbir Hossain | Arif Chowdhury |
| 2 | Mitu Rahman | 72000 | Tanvir Ahmed | Mitu Rahman | Arif Chowdhury |
| 2 | Arif Chowdhury | 65000 | Tanvir Ahmed | Arif Chowdhury | Arif Chowdhury |
| 3 | Jamal Uddin | 52000 | Jamal Uddin | Jamal Uddin | Sumaiya Islam |
| 3 | Sumaiya Islam | 45000 | Jamal Uddin | Sumaiya Islam | Sumaiya Islam |
| 4 | Farhana Yasmin | 78000 | Farhana Yasmin | Farhana Yasmin | Rubina Khatun |
| 4 | Imran Kabir | 78000 | Farhana Yasmin | Imran Kabir | Rubina Khatun |
| 4 | Rubina Khatun | 60000 | Farhana Yasmin | Rubina Khatun | Rubina Khatun |

_(13 rows)_

**(খ):** `second_default_frame` প্রথম row-এ NULL, কারণ তখন Frame-এ মাত্র ১টি row আছে।

**Output:**

| dept_id | emp_name | salary | second_default_frame | second_full_frame | diff_from_top |
|---|---|---|---|---|---|
| 1 | Karim Hasan | 62000 | NULL | 62000 | 0 |
| 1 | Fatema Akter | 62000 | 62000 | 62000 | 0 |
| 1 | Rahim Uddin | 55000 | 62000 | 62000 | -7000 |
| 1 | Nusrat Jahan | 48000 | 62000 | 62000 | -14000 |
| 2 | Tanvir Ahmed | 85000 | NULL | 72000 | 0 |
| 2 | Sabbir Hossain | 72000 | 72000 | 72000 | -13000 |
| 2 | Mitu Rahman | 72000 | 72000 | 72000 | -13000 |
| 2 | Arif Chowdhury | 65000 | 72000 | 72000 | -20000 |
| 3 | Jamal Uddin | 52000 | NULL | 45000 | 0 |
| 3 | Sumaiya Islam | 45000 | 45000 | 45000 | -7000 |
| 4 | Farhana Yasmin | 78000 | NULL | 78000 | 0 |
| 4 | Imran Kabir | 78000 | 78000 | 78000 | 0 |
| 4 | Rubina Khatun | 60000 | 78000 | 78000 | -18000 |

_(13 rows)_

### ৭. Line-by-line Explanation

- (ক) `FIRST_VALUE(emp_name) OVER (... ORDER BY salary DESC, emp_id)`: ডিফল্ট Frame "শুরু থেকে বর্তমান row", আর প্রথম row সবসময় Frame-এ থাকে। তাই উত্তর সঠিক।
- (ক) `lowest_WRONG`: ডিফল্ট Frame বর্তমান row-এ শেষ হয়, তাই "শেষ row" = বর্তমান row।
- (ক) `lowest_CORRECT`: `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` দিয়ে পুরো department-কে Frame বানানো হলো।
- (খ) `NTH_VALUE(salary, 2)`: Frame-এর দ্বিতীয় row-এর salary। পূর্ণ Frame দিলে department-এর সবার row-এ একই মান আসে।
- (খ) Sales-এ দ্বিতীয় row-এর salary 62000, যা প্রথম row-এর সমান। NTH_VALUE **অবস্থান** দেখে, আলাদা মান দেখে না। "দ্বিতীয় সর্বোচ্চ আলাদা salary" চাইলে DENSE_RANK = 2 ব্যবহার করুন (Module 2)।
- (খ) `salary - FIRST_VALUE(salary) OVER (...)`: শীর্ষ বেতন থেকে দূরত্ব।

**সহজ বিকল্প:** শুধু department-এর সর্বনিম্ন **মান** দরকার হলে `MIN(salary) OVER (PARTITION BY dept_id)` লিখুন, Frame-এর ঝামেলা নেই। কিন্তু সর্বনিম্ন বেতনের **মানুষের নাম** দরকার হলে `LAST_VALUE`/`FIRST_VALUE` লাগবে। একটা কৌশল: `FIRST_VALUE(emp_name) OVER (PARTITION BY dept_id ORDER BY salary ASC)` লিখলে Frame-এর ঝামেলা ছাড়াই সর্বনিম্ন বেতনের জনকে পাওয়া যায়।

### ৮. Common Mistakes

1. **LAST_VALUE-এ পূর্ণ Frame না দেওয়া।** এটাই সবচেয়ে প্রচলিত ভুল।
2. **`RANGE` দিয়ে পূর্ণ Frame।** `RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING`-ও কাজ করে, কিন্তু `ROWS` বেশি স্পষ্ট।
3. **Ties-এ FIRST_VALUE অনিশ্চিত।** Karim আর Fatema-র salary সমান। tie-breaker না দিলে "top earner" কে, তা প্রতিবার একই হবে এমন নিশ্চয়তা নেই।
4. **NTH_VALUE-কে "n-তম বড় আলাদা মান" ভাবা।**

### ৯. Practice Problems

- **Beginner:** প্রতিটি product-এর পাশে তার category-র **সবচেয়ে দামি product-এর নাম** দেখান।
- **Intermediate:** প্রতিটি product-এর পাশে category-র **সবচেয়ে সস্তা product-এর নাম** দেখান, `LAST_VALUE` ব্যবহার করে (সঠিক Frame সহ)।
- **Advanced:** প্রতিটি customer-এর প্রতিটি কেনাকাটার পাশে দেখান: তার **প্রথম** কেনাকাটার তারিখ, **সর্বশেষ** কেনাকাটার তারিখ, আর **দ্বিতীয়** কেনাকাটার amount (NTH_VALUE)।

### ১০. ছোট Quiz

1. ডিফল্ট Frame-এ LAST_VALUE কেন বর্তমান row দেয়?
2. LAST_VALUE ঠিক করতে কোন Frame লিখবেন?
3. Sales department-এ `NTH_VALUE(salary, 2)` কেন 62000 দিল, 55000 নয়?

> **Module 5 শেষ।** Window Function-এর সব মূল টুল এখন আপনার হাতে। Module 6-এ এগুলো মিলিয়ে বাস্তব Interview আর Business সমস্যা সমাধান করব। **"Ready"** লিখুন।


# Module 6: Advanced SQL Problem Solving

**আগের Module-গুলোর সঙ্গে সম্পর্ক:** এই Module-এ নতুন function নেই। এখানে Module 1–5-এর টুলগুলো জোড়া লাগিয়ে বাস্তব সমস্যা সমাধান করব। প্রায় প্রতিটি সমাধান একই ছাঁচে চলে:

1. **CTE-তে data প্রস্তুত করুন** (GROUP BY, JOIN)।
2. **Window Function দিয়ে নতুন column বানান** (rank, lag, running sum)।
3. **বাইরের Query-তে filter বা summarize করুন।**

Interview-তে এই ধরনের প্রশ্নই সবচেয়ে বেশি আসে।

## Lesson 6.1 — Top 3 Products per Category এবং প্রতিটি Department-এর Highest Paid Employee

### ১. Topic Introduction

"প্রতিটি গ্রুপের সেরা N" (Lesson 2.4) এখানে দুটি বাস্তব রূপে আসছে: বিক্রির পরিমাণ অনুযায়ী প্রতিটি category-র Top 3 product, আর প্রতিটি department-এর সর্বোচ্চ বেতনের employee (ties সহ)।

### ২. সহজ বাংলা ব্যাখ্যা

দোকানের ম্যানেজার জানতে চান প্রতিটি তাকে (category) কোন ৩টি পণ্য সবচেয়ে বেশি বিক্রি হয়, যাতে সেগুলোর stock আগে থেকে রাখা যায়। HR জানতে চায় প্রতিটি বিভাগে সবচেয়ে বেশি বেতন কে পায়। দুজন সমান বেতন পেলে দুজনকেই দেখাতে হবে।

### ৩. Syntax

```text
WITH agg AS (SELECT grp, item, SUM(metric) AS m FROM ... GROUP BY grp, item),
     ranked AS (SELECT *, DENSE_RANK() OVER (PARTITION BY grp ORDER BY m DESC) AS rnk FROM agg)
SELECT * FROM ranked WHERE rnk <= 3;
```

### ৪. Sample Data

`products` + `sales` (১৩টি product, ৪টি category), `employees` + `departments`।

### ৫. SQL Query

**(ক) Category অনুযায়ী বিক্রির পরিমাণে (quantity) Top 3 Products:**

```sql
WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        COALESCE(SUM(s.quantity), 0) AS units_sold,
        COALESCE(SUM(s.amount), 0)   AS revenue
    FROM products p
    LEFT JOIN sales s ON s.product_id = p.product_id
    GROUP BY p.product_id, p.category, p.product_name
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY category ORDER BY units_sold DESC) AS rnk
    FROM product_sales
)
SELECT category, rnk, product_name, units_sold, revenue
FROM ranked
WHERE rnk <= 3
ORDER BY category, rnk, product_name;
```

**(খ) প্রতিটি Department-এর Highest Paid Employee (ties সহ), দুই পদ্ধতিতে:**

```sql
-- পদ্ধতি ১: RANK
WITH r AS (
    SELECT d.dept_name, e.emp_name, e.salary,
           RANK() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC) AS rnk
    FROM employees e
    JOIN departments d ON d.dept_id = e.dept_id
)
SELECT dept_name, emp_name, salary
FROM r
WHERE rnk = 1
ORDER BY dept_name, emp_name;
```

```sql
-- পদ্ধতি ২: MAX() OVER
WITH m AS (
    SELECT d.dept_name, e.emp_name, e.salary,
           MAX(e.salary) OVER (PARTITION BY e.dept_id) AS dept_max
    FROM employees e
    JOIN departments d ON d.dept_id = e.dept_id
)
SELECT dept_name, emp_name, salary
FROM m
WHERE salary = dept_max
ORDER BY dept_name, emp_name;
```

### ৬. Expected Output

**(ক):**

**Output:**

| category | rnk | product_name | units_sold | revenue |
|---|---|---|---|---|
| Clothing | 1 | Jeans | 10 | 18000 |
| Clothing | 2 | Panjabi | 6 | 15000 |
| Clothing | 2 | Saree | 6 | 27000 |
| Electronics | 1 | Headphones | 5 | 22500 |
| Electronics | 1 | Smartphone | 5 | 175000 |
| Electronics | 2 | Laptop | 4 | 300000 |
| Electronics | 2 | Smartwatch | 4 | 48000 |
| Furniture | 1 | Study Table | 6 | 72000 |
| Furniture | 2 | Office Chair | 5 | 75000 |
| Furniture | 3 | Bookshelf | 2 | 17000 |
| Grocery | 1 | Rice 25kg | 13 | 28600 |
| Grocery | 2 | Soybean Oil 5L | 12 | 11400 |
| Grocery | 3 | Tea 400g | 7 | 2450 |

_(13 rows)_

লক্ষ্য করুন, Electronics-এ ৪টি product-ই এসেছে। Headphones আর Smartphone দুটোই 5 unit (rank 1), Laptop আর Smartwatch দুটোই 4 unit (rank 2)। DENSE_RANK "শীর্ষ ৩টি **স্তর**" দেয়, তাই ties থাকলে ৩টির বেশি product আসতে পারে। ঠিক ৩টি চাইলে ROW_NUMBER + tie-breaker দিন। Clothing-এ Panjabi আর Saree-ও সমান (6)।

আরেকটি সতর্কতা: Study Table-এর একটি sale duplicate (Lesson 6.2), তাই সেটা ২ unit বেশি দেখাচ্ছে। Duplicate বাদ দিলে Study Table হবে 4 unit, আর Office Chair (5) Furniture-এ প্রথম হবে। **নোংরা data, ভুল Ranking।**

**(খ) পদ্ধতি ১:**

**Output:**

| dept_name | emp_name | salary |
|---|---|---|
| Finance | Farhana Yasmin | 78000 |
| Finance | Imran Kabir | 78000 |
| HR | Jamal Uddin | 52000 |
| IT | Tanvir Ahmed | 85000 |
| Sales | Fatema Akter | 62000 |
| Sales | Karim Hasan | 62000 |

_(6 rows)_

**(খ) পদ্ধতি ২:** একই ফল।

**Output:**

| dept_name | emp_name | salary |
|---|---|---|
| Finance | Farhana Yasmin | 78000 |
| Finance | Imran Kabir | 78000 |
| HR | Jamal Uddin | 52000 |
| IT | Tanvir Ahmed | 85000 |
| Sales | Fatema Akter | 62000 |
| Sales | Karim Hasan | 62000 |

_(6 rows)_

### ৭. Line-by-line Explanation

- (ক) `LEFT JOIN sales`: যে product একবারও বিক্রি হয়নি, সেটাও তালিকায় থাকে (0 হিসেবে)।
- (ক) `GROUP BY p.product_id, ...`: product অনুযায়ী মোট।
- (ক) `DENSE_RANK() ... ORDER BY units_sold DESC`: সমান বিক্রি হলে সমান rank, কেউ বাদ পড়ে না।
- (খ) পদ্ধতি ১-এ `RANK() = 1`: সর্বোচ্চ salary-র সবাই।
- (খ) পদ্ধতি ২-এ `salary = MAX(salary) OVER (...)`: Ranking ছাড়াই একই কাজ। "সর্বোচ্চ/সর্বনিম্ন" প্রশ্নে এটা প্রায়ই বেশি পরিষ্কার।

### ৮. Common Mistakes

1. **INNER JOIN দিয়ে অবিক্রিত product হারিয়ে ফেলা।**
2. **ROW_NUMBER দিয়ে highest paid খোঁজা।** ties-এর একজন বাদ পড়ে।
3. **Revenue আর Quantity গুলিয়ে ফেলা।** "Top" কোন মাপকাঠিতে, আগে ঠিক করুন।

### ৯. Practice Problems

- **Beginner:** প্রতিটি category-তে **revenue** অনুযায়ী Top 2 product বের করুন।
- **Intermediate:** প্রতিটি department-এর **সর্বনিম্ন** বেতনের employee (ties সহ) বের করুন।
- **Advanced:** প্রতিটি **শহরের** (customers.city) customer-দের মধ্যে কে সবচেয়ে বেশি টাকার কেনাকাটা করেছেন, বের করুন (ties সহ)।

### ১০. ছোট Quiz

1. Top N-এ অবিক্রিত item রাখতে কোন JOIN?
2. Highest paid খুঁজতে RANK আর MAX OVER-এর মধ্যে মূল পার্থক্য কী?
3. ties-এ সবাইকে রাখতে কোন function এড়াবেন?

---

## Lesson 6.2 — Duplicate Record শনাক্তকরণ এবং অপসারণ

### ১. Topic Introduction

Duplicate data খুব সাধারণ সমস্যা: একই customer দুবার রেজিস্ট্রেশন করেছেন, বা একই বিক্রি দুবার entry হয়েছে। `ROW_NUMBER() OVER (PARTITION BY <যে column-গুলো মিললে duplicate> ORDER BY <কোনটা রাখব>)` দিয়ে এক Query-তেই এদের খুঁজে বের করা যায়।

### ২. সহজ বাংলা ব্যাখ্যা

একই রকম রসিদগুলো একটা স্তূপে রাখুন (`PARTITION BY`)। প্রতিটি স্তূপে রসিদগুলোকে 1, 2, 3 নম্বর দিন (`ROW_NUMBER`)। 1 নম্বরটি আসল, বাকিগুলো (2, 3…) duplicate।

### ৩. Syntax

```text
ROW_NUMBER() OVER (PARTITION BY dup_col1, dup_col2, ... ORDER BY keep_priority) AS rn
-- rn = 1 → রাখুন, rn > 1 → duplicate
COUNT(*) OVER (PARTITION BY dup_cols) AS copies   -- কতবার আছে
```

### ৪. Sample Data

`customers` (ID 2 আর 8-এর email একই) আর `sales` (sale 43 আর 44 হুবহু এক)।

### ৫. SQL Query

**(ক) একই email-এর customer:**

```sql
WITH c AS (
    SELECT
        customer_id, customer_name, email, join_date,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY join_date, customer_id) AS rn,
        COUNT(*)     OVER (PARTITION BY email) AS copies
    FROM customers
)
SELECT customer_id, customer_name, email, join_date, rn, copies,
       CASE WHEN rn = 1 THEN 'Keep' ELSE 'Duplicate' END AS action
FROM c
WHERE copies > 1
ORDER BY email, rn;
```

**(খ) হুবহু একই sale entry:**

```sql
WITH s AS (
    SELECT
        sale_id, sale_date, customer_id, product_id, emp_id, quantity, amount,
        ROW_NUMBER() OVER (
            PARTITION BY sale_date, customer_id, product_id, emp_id, quantity, amount
            ORDER BY sale_id
        ) AS rn
    FROM sales
)
SELECT *
FROM s
WHERE rn > 1;
```

**(গ) Duplicate মুছে ফেলা (শুধু প্রথমটি রেখে):**

এই Course-এ পরের Lesson-গুলোর জন্য data অপরিবর্তিত রাখা হয়েছে, তাই নিচের DELETE চালানো হয়নি। নিজে চালাতে চাইলে **আগে backup নিন** (`CREATE TABLE sales_backup AS SELECT * FROM sales;`)।

```sql
DELETE s
FROM sales s
JOIN (
    SELECT sale_id,
           ROW_NUMBER() OVER (
               PARTITION BY sale_date, customer_id, product_id, emp_id, quantity, amount
               ORDER BY sale_id
           ) AS rn
    FROM sales
) d ON d.sale_id = s.sale_id
WHERE d.rn > 1;
```

(একটি কপি Table-এ পরীক্ষা করে দেখা গেছে: এটি ঠিক ১টি row, sale 44, মুছে ৪৫ থেকে ৪৪ row করে।)

### ৬. Expected Output

**(ক):**

**Output:**

| customer_id | customer_name | email | join_date | rn | copies | action |
|---|---|---|---|---|---|---|
| 2 | Shirin Akter | shirin.akter@mail.com | 2023-12-15 | 1 | 2 | Keep |
| 8 | Shirin Akter | shirin.akter@mail.com | 2025-05-01 | 2 | 2 | Duplicate |

_(2 rows)_

**(খ):**

**Output:**

| sale_id | sale_date | customer_id | product_id | emp_id | quantity | amount | rn |
|---|---|---|---|---|---|---|---|
| 44 | 2025-06-18 | 2 | 6 | 2 | 2 | 24000 | 2 |

_(1 rows)_

### ৭. Line-by-line Explanation

- (ক) `PARTITION BY email`: একই email-এর সবাই এক গ্রুপে।
- (ক) `ORDER BY join_date, customer_id`: যিনি আগে রেজিস্টার করেছেন তিনি rn = 1 (আসল)।
- (ক) `COUNT(*) OVER (PARTITION BY email)`: কতবার আছে। `WHERE copies > 1` দিলে শুধু সমস্যাযুক্ত গ্রুপ দেখায়।
- (খ) `PARTITION BY` সব ব্যবসায়িক column (sale_id বাদে): যেগুলো মিললে "একই বিক্রি" ধরা হবে।
- (গ) MySQL-এ CTE থেকে সরাসরি DELETE করা যায় না। তাই Derived Table-এর সঙ্গে JOIN করে `DELETE s FROM ...` লেখা হয়েছে।

### ৮. Common Mistakes

1. **Primary key (`sale_id`) PARTITION BY-তে রাখা।** প্রতিটি row আলাদা হয়ে যায়, কোনো duplicate ধরা পড়ে না।
2. **`GROUP BY` + `HAVING COUNT(*) > 1` দিয়ে থেমে যাওয়া।** এতে duplicate গ্রুপ দেখা যায়, কিন্তু কোন row রাখবেন আর কোনটা মুছবেন, তা বোঝা যায় না।
3. **Backup ছাড়া DELETE চালানো।**

### ৯. Practice Problems

- **Beginner:** `GROUP BY` + `HAVING` দিয়ে duplicate email-গুলোর তালিকা দেখান।
- **Intermediate:** একই `customer_name` আর `city`-র customer খুঁজুন, আর **নতুনতম** রেকর্ডটি রাখার নিয়মে `action` column বানান।
- **Advanced:** Duplicate sale বাদ দিয়ে (CTE-তে `rn = 1` রেখে) প্রতিটি category-র সঠিক মোট revenue বের করুন। Duplicate থাকা অবস্থার revenue-এর সঙ্গে পার্থক্য দেখান।

### ১০. ছোট Quiz

1. Duplicate খোঁজার সময় PARTITION BY-তে কোন column রাখবেন না?
2. `rn = 1` মানে কী?
3. MySQL-এ CTE দিয়ে সরাসরি DELETE করা না গেলে কী করবেন?

---

## Lesson 6.3 — Consecutive Days Activity এবং Gaps & Islands

### ১. Topic Introduction

**Island** হলো পরপর (consecutive) মানের একটা টানা অংশ, আর **Gap** হলো দুই Island-এর মাঝের ফাঁকা অংশ। উদাহরণ: কোন customer টানা কত দিন কেনাকাটা করেছেন (streak), কোন সার্ভার কখন টানা down ছিল, কোন invoice নম্বর হারিয়ে গেছে।

### ২. সহজ বাংলা ব্যাখ্যা

**মূল কৌশল (তারিখ − row number):** পরপর দিনগুলো থেকে তাদের ক্রমিক নম্বর বিয়োগ করলে **একই ফল** আসে।

| তারিখ | ROW_NUMBER | তারিখ − ROW_NUMBER দিন |
|---|---|---|
| Mar 10 | 1 | Mar 09 |
| Mar 11 | 2 | Mar 09 |
| Mar 12 | 3 | Mar 09 |
| Mar 15 | 4 | Mar 11 |
| Mar 16 | 5 | Mar 11 |

যতক্ষণ দিন আর নম্বর দুটোই ১ করে বাড়ে, বিয়োগফল একই থাকে। একদিন বাদ পড়লে তারিখ ২ বাড়ে কিন্তু নম্বর ১, তাই বিয়োগফল বদলে যায়। একই বিয়োগফলের row-গুলোই এক Island।

### ৩. Syntax

```text
DATE_SUB(d, INTERVAL ROW_NUMBER() OVER (PARTITION BY id ORDER BY d) DAY) AS grp
-- তারপর GROUP BY id, grp → MIN(d) = শুরু, MAX(d) = শেষ, COUNT(*) = দৈর্ঘ্য
```

### ৪. Sample Data

`sales` Table। Customer 3 মার্চ 2025-এ 10, 11, 12, 15, 16 তারিখে কেনাকাটা করেছেন। Customer 1 করেছেন 11 আর 12 তারিখে।

### ৫. SQL Query

**(ক) ধাপ ১, group key তৈরি (Customer 3):**

```sql
WITH d AS (
    SELECT DISTINCT customer_id, sale_date
    FROM sales
    WHERE customer_id = 3
)
SELECT
    customer_id,
    sale_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date) AS rn,
    DATE_SUB(sale_date,
             INTERVAL ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date) DAY) AS grp
FROM d
ORDER BY sale_date;
```

**(খ) ধাপ ২, সব customer-এর Consecutive Purchase Streak (Islands, কমপক্ষে ২ দিন):**

```sql
WITH d AS (
    SELECT DISTINCT customer_id, sale_date FROM sales
),
g AS (
    SELECT customer_id, sale_date,
           DATE_SUB(sale_date,
                    INTERVAL ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date) DAY) AS grp
    FROM d
)
SELECT
    customer_id,
    MIN(sale_date) AS streak_start,
    MAX(sale_date) AS streak_end,
    COUNT(*)       AS consecutive_days
FROM g
GROUP BY customer_id, grp
HAVING COUNT(*) >= 2
ORDER BY consecutive_days DESC, customer_id, streak_start;
```

**(গ) Gaps: Customer 3-এর দুই কেনাকাটার মাঝের ফাঁকা সময় (১ দিনের বেশি):**

```sql
WITH d AS (
    SELECT DISTINCT sale_date FROM sales WHERE customer_id = 3
),
n AS (
    SELECT sale_date,
           LEAD(sale_date) OVER (ORDER BY sale_date) AS next_date
    FROM d
)
SELECT
    DATE_ADD(sale_date, INTERVAL 1 DAY) AS gap_start,
    DATE_SUB(next_date, INTERVAL 1 DAY) AS gap_end,
    DATEDIFF(next_date, sale_date) - 1  AS gap_days
FROM n
WHERE DATEDIFF(next_date, sale_date) > 1
ORDER BY gap_start;
```

### ৬. Expected Output

**(ক):** একই `grp` = একই Island।

**Output:**

| customer_id | sale_date | rn | grp |
|---|---|---|---|
| 3 | 2024-01-20 | 1 | 2024-01-19 |
| 3 | 2024-03-15 | 2 | 2024-03-13 |
| 3 | 2024-05-30 | 3 | 2024-05-27 |
| 3 | 2025-02-16 | 4 | 2025-02-12 |
| 3 | 2025-03-10 | 5 | 2025-03-05 |
| 3 | 2025-03-11 | 6 | 2025-03-05 |
| 3 | 2025-03-12 | 7 | 2025-03-05 |
| 3 | 2025-03-15 | 8 | 2025-03-07 |
| 3 | 2025-03-16 | 9 | 2025-03-07 |
| 3 | 2025-06-27 | 10 | 2025-06-17 |

_(10 rows)_

**(খ):**

**Output:**

| customer_id | streak_start | streak_end | consecutive_days |
|---|---|---|---|
| 3 | 2025-03-10 | 2025-03-12 | 3 |
| 1 | 2025-03-11 | 2025-03-12 | 2 |
| 3 | 2025-03-15 | 2025-03-16 | 2 |

_(3 rows)_

**(গ):**

**Output:**

| gap_start | gap_end | gap_days |
|---|---|---|
| 2024-01-21 | 2024-03-14 | 54 |
| 2024-03-16 | 2024-05-29 | 75 |
| 2024-05-31 | 2025-02-15 | 261 |
| 2025-02-17 | 2025-03-09 | 21 |
| 2025-03-13 | 2025-03-14 | 2 |
| 2025-03-17 | 2025-06-26 | 102 |

_(6 rows)_

### ৭. Line-by-line Explanation

- `SELECT DISTINCT customer_id, sale_date`: একদিনে একাধিক কেনাকাটা থাকলে দিনটা একবারই গোনা হবে। এটা না করলে কৌশলটা ভেঙে যায়।
- `ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date)`: প্রতিটি customer-এর দিনগুলোর ক্রমিক নম্বর।
- `DATE_SUB(sale_date, INTERVAL rn DAY)`: Island-এর পরিচয় (group key)।
- `GROUP BY customer_id, grp`: প্রতিটি Island একটি row। `MIN`/`MAX`/`COUNT` দিয়ে শুরু, শেষ আর দৈর্ঘ্য।
- `HAVING COUNT(*) >= 2`: শুধু টানা ২+ দিনের streak।
- (গ) `LEAD(sale_date)`: পরের কেনাকাটার দিন। পার্থক্য > 1 হলে মাঝে Gap।

### ৮. Common Mistakes

1. **DISTINCT না করা।** একই দিনে দুটি row থাকলে rn বাড়ে কিন্তু তারিখ বাড়ে না, ফলে Island ভেঙে যায়।
2. **`sale_date - rn` লেখা।** MySQL-এ DATE থেকে সংখ্যা বিয়োগ করলে সংখ্যায় রূপান্তর হয়ে ভুল ফল আসে। `DATE_SUB(..., INTERVAL n DAY)` ব্যবহার করুন।
3. **PARTITION BY customer_id ভুলে যাওয়া।** তখন সব customer-এর দিন মিশে যায়।

### ৯. Practice Problems

- **Beginner:** Lesson-এর (ক) Query Customer 1-এর জন্য চালান, তার Island-গুলো দেখুন।
- **Intermediate:** কোম্পানির পর্যায়ে (customer নির্বিশেষে) মার্চ 2025-এ টানা কত দিন অন্তত একটি বিক্রি হয়েছে, সব Island বের করুন।
- **Advanced:** `sales.sale_id`-তে কোনো নম্বর হারিয়ে গেছে কিনা (gap) তা বের করার Query লিখুন (`LEAD(sale_id)` দিয়ে)। পরীক্ষার জন্য একটি কপি Table-এ কয়েকটি row মুছে দেখুন।

### ১০. ছোট Quiz

1. Gaps & Islands-এর "তারিখ − row number" কৌশল কেন কাজ করে?
2. DISTINCT কেন দরকার?
3. Gap খুঁজতে কোন function সবচেয়ে সহজ?

---

## Lesson 6.4 — Running Balance Calculation

### ১. Topic Introduction

ব্যাংক বা মোবাইল ওয়ালেটের statement-এ প্রতিটি লেনদেনের পর ব্যালেন্স দেখানো হয়। এটা Running Total-এরই রূপ, যেখানে জমা (+) আর উত্তোলন (−) চিহ্ন অনুযায়ী যোগ হয়।

### ২. সহজ বাংলা ব্যাখ্যা

বিকাশের statement ভাবুন: 50000 জমা, তারপর 12000 উত্তোলন, তাই ব্যালেন্স 38000। লেনদেন আসে ক্রমে, আর প্রতিটির পর হিসাব আপডেট হয়। এখানে `ROWS` frame আর tie-breaker খুব জরুরি, কারণ একই দিনে একাধিক লেনদেন হতে পারে (Module 4)।

### ৩. Syntax

```text
SUM(CASE WHEN type = 'Deposit' THEN amount ELSE -amount END)
    OVER (PARTITION BY account ORDER BY txn_date, txn_id
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS balance
```

### ৪. Sample Data

এই Lesson-এর জন্য একটি নতুন Table:

```sql
DROP TABLE IF EXISTS bank_transactions;
CREATE TABLE bank_transactions (
    txn_id      INT PRIMARY KEY,
    account_no  VARCHAR(10) NOT NULL,
    txn_date    DATE NOT NULL,
    txn_type    ENUM('Deposit', 'Withdraw') NOT NULL,
    amount      INT NOT NULL
);

INSERT INTO bank_transactions VALUES
(1,  'A-101', '2025-01-01', 'Deposit',  50000),
(2,  'B-202', '2025-01-02', 'Deposit',  30000),
(3,  'A-101', '2025-01-05', 'Withdraw', 12000),
(4,  'B-202', '2025-01-05', 'Withdraw',  5000),
(5,  'B-202', '2025-01-05', 'Withdraw',  2000),
(6,  'A-101', '2025-01-10', 'Withdraw',  8000),
(7,  'A-101', '2025-01-15', 'Deposit',  20000),
(8,  'B-202', '2025-01-18', 'Deposit',  15000),
(9,  'A-101', '2025-01-20', 'Withdraw', 55000),
(10, 'A-101', '2025-01-25', 'Deposit',  10000),
(11, 'B-202', '2025-01-28', 'Withdraw', 10000);
```

### ৫. SQL Query

```sql
WITH t AS (
    SELECT
        account_no, txn_id, txn_date, txn_type, amount,
        CASE WHEN txn_type = 'Deposit' THEN amount ELSE -amount END AS signed_amount
    FROM bank_transactions
),
b AS (
    SELECT *,
        SUM(signed_amount) OVER (
            PARTITION BY account_no
            ORDER BY txn_date, txn_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_balance
    FROM t
)
SELECT
    account_no, txn_id, txn_date, txn_type, amount, signed_amount,
    running_balance,
    MIN(running_balance) OVER (PARTITION BY account_no) AS lowest_balance,
    CASE WHEN running_balance < 0 THEN 'OVERDRAWN' ELSE 'OK' END AS status
FROM b
ORDER BY account_no, txn_date, txn_id;
```

### ৬. Expected Output

**Output:**

| account_no | txn_id | txn_date | txn_type | amount | signed_amount | running_balance | lowest_balance | status |
|---|---|---|---|---|---|---|---|---|
| A-101 | 1 | 2025-01-01 | Deposit | 50000 | 50000 | 50000 | -5000 | OK |
| A-101 | 3 | 2025-01-05 | Withdraw | 12000 | -12000 | 38000 | -5000 | OK |
| A-101 | 6 | 2025-01-10 | Withdraw | 8000 | -8000 | 30000 | -5000 | OK |
| A-101 | 7 | 2025-01-15 | Deposit | 20000 | 20000 | 50000 | -5000 | OK |
| A-101 | 9 | 2025-01-20 | Withdraw | 55000 | -55000 | -5000 | -5000 | OVERDRAWN |
| A-101 | 10 | 2025-01-25 | Deposit | 10000 | 10000 | 5000 | -5000 | OK |
| B-202 | 2 | 2025-01-02 | Deposit | 30000 | 30000 | 30000 | 23000 | OK |
| B-202 | 4 | 2025-01-05 | Withdraw | 5000 | -5000 | 25000 | 23000 | OK |
| B-202 | 5 | 2025-01-05 | Withdraw | 2000 | -2000 | 23000 | 23000 | OK |
| B-202 | 8 | 2025-01-18 | Deposit | 15000 | 15000 | 38000 | 23000 | OK |
| B-202 | 11 | 2025-01-28 | Withdraw | 10000 | -10000 | 28000 | 23000 | OK |

_(11 rows)_

### ৭. Line-by-line Explanation

- `CASE WHEN txn_type = 'Deposit' THEN amount ELSE -amount END`: জমা হলে ধনাত্মক, উত্তোলন হলে ঋণাত্মক।
- `PARTITION BY account_no`: প্রতিটি account-এর ব্যালেন্স আলাদা।
- `ORDER BY txn_date, txn_id` + `ROWS ...`: একই দিনের দুটি লেনদেনও (B-202, 5 জানুয়ারি) আলাদা ধাপে হিসাব হয়।
- `MIN(running_balance) OVER (PARTITION BY account_no)`: Window-এর ফলের ওপর আবার Window চালাতে CTE `b` লেগেছে। Window Function-এর ভেতরে আরেকটা Window Function লেখা যায় না।
- `status`: A-101-এ 20 জানুয়ারি ব্যালেন্স ঋণাত্মক হয়েছে।

### ৮. Common Mistakes

1. **ডিফল্ট RANGE frame-এ ব্যালেন্স।** একই দিনের সব লেনদেন একসঙ্গে যোগ হয়ে যায়, মাঝের ব্যালেন্স দেখা যায় না।
2. **Window-এর ভেতরে Window লেখা**, যেমন `MIN(SUM(x) OVER ...) OVER ...`। এতে Error আসে, CTE-তে ভাগ করুন।
3. **Opening balance ভুলে যাওয়া।** বাস্তবে আগের মাসের closing balance যোগ করতে হয়।

### ৯. Practice Problems

- **Beginner:** শুধু A-101-এর running balance দেখান।
- **Intermediate:** প্রতিটি account-এর **closing balance** (শেষ লেনদেনের পরের ব্যালেন্স) বের করুন। (ইঙ্গিত: ROW_NUMBER DESC বা LAST_VALUE)
- **Advanced:** প্রতিটি account-এর জন্য বের করুন কোন লেনদেনে ব্যালেন্স **প্রথমবার** ঋণাত্মক হয়েছে (যদি হয়ে থাকে)।

### ১০. ছোট Quiz

1. Running Balance-এ ROWS কেন RANGE-এর চেয়ে নিরাপদ?
2. Window-এর ফলের ওপর আরেকটি Window চালাতে কী লাগে?
3. উত্তোলনকে ঋণাত্মক করার জন্য কী লিখেছি?

---

## Lesson 6.5 — Month-over-Month ও Year-over-Year Growth (Missing Month সহ) এবং Moving Average

### ১. Topic Introduction

Lesson 5.2-এ MoM Growth বানিয়েছিলাম। কিন্তু সেখানে একটা লুকানো ফাঁদ ছিল: `LAG` "আগের row" দেয়, "আগের মাস" নয়। আমাদের data-তে 2024-এর Jul–Dec নেই। এই Lesson-এ ফাঁদটা ধরব, তারপর তিনভাবে সমাধান করব। শেষে YoY Growth আর Calendar-ভিত্তিক Moving Average দেখব।

### ২. সহজ বাংলা ব্যাখ্যা

মনে করুন একজন ছাত্রের প্রতি মাসের পরীক্ষার খাতা আছে, কিন্তু মাঝের ছয় মাসের খাতা হারিয়ে গেছে। কেউ যদি শুধু "আগের খাতা"র সঙ্গে তুলনা করে, তাহলে জানুয়ারি 2025-কে জুন 2024-এর সঙ্গে তুলনা করে বলবে "গত মাসের চেয়ে ভালো"। অথচ এটা গত মাস নয়!

**সমাধান:**

1. আগের row-এর মাস সত্যিই "এক মাস আগে" কিনা যাচাই করুন।
2. অথবা একটা পূর্ণ **Calendar** বানিয়ে বাদ পড়া মাসগুলোতে 0 বসান (Recursive CTE)।
3. **YoY**-এর জন্য `PARTITION BY` মাস-নম্বর, `ORDER BY` বছর, তারপর `LAG`। তাহলে "গত বছরের একই মাস" পাওয়া যায়।

### ৩. Syntax

```text
-- যাচাইসহ MoM
CASE WHEN LAG(month_start) OVER w = month_start - INTERVAL 1 MONTH
     THEN (total - LAG(total) OVER w) / LAG(total) OVER w * 100 END

-- YoY
LAG(total) OVER (PARTITION BY MONTH(month_start) ORDER BY YEAR(month_start))
```

### ৪. Sample Data

`sales`, মাসভিত্তিক (2024 Jan–Jun এবং 2025 Jan–Jun)।

### ৫. SQL Query

**(ক) ফাঁদ: সরাসরি LAG:**

```sql
WITH monthly AS (
    SELECT CAST(DATE_FORMAT(sale_date, '%Y-%m-01') AS DATE) AS month_start,
           SUM(amount) AS total
    FROM sales
    GROUP BY month_start
)
SELECT
    month_start,
    total,
    LAG(month_start) OVER (ORDER BY month_start) AS compared_with,
    ROUND(100 * (total - LAG(total) OVER (ORDER BY month_start))
              / LAG(total) OVER (ORDER BY month_start), 2) AS naive_mom_pct
FROM monthly
ORDER BY month_start;
```

**(খ) সমাধান ১: আগের row সত্যিই আগের মাস কিনা যাচাই:**

```sql
WITH monthly AS (
    SELECT CAST(DATE_FORMAT(sale_date, '%Y-%m-01') AS DATE) AS month_start,
           SUM(amount) AS total
    FROM sales
    GROUP BY month_start
)
SELECT
    month_start,
    total,
    CASE WHEN LAG(month_start) OVER w = month_start - INTERVAL 1 MONTH
         THEN LAG(total) OVER w END                       AS prev_month_total,
    CASE WHEN LAG(month_start) OVER w = month_start - INTERVAL 1 MONTH
         THEN ROUND(100 * (total - LAG(total) OVER w) / LAG(total) OVER w, 2)
    END                                                   AS mom_pct
FROM monthly
WINDOW w AS (ORDER BY month_start)
ORDER BY month_start;
```

**(গ) সমাধান ২: Recursive CTE দিয়ে পূর্ণ Calendar, তারপর MoM আর ৩-মাসের Moving Average:**

```sql
WITH RECURSIVE calendar AS (
    SELECT DATE '2024-01-01' AS month_start
    UNION ALL
    SELECT month_start + INTERVAL 1 MONTH
    FROM calendar
    WHERE month_start < DATE '2025-06-01'
),
monthly AS (
    SELECT CAST(DATE_FORMAT(sale_date, '%Y-%m-01') AS DATE) AS month_start,
           SUM(amount) AS total
    FROM sales
    GROUP BY month_start
),
filled AS (
    SELECT c.month_start, COALESCE(m.total, 0) AS total
    FROM calendar c
    LEFT JOIN monthly m ON m.month_start = c.month_start
)
SELECT
    month_start,
    total,
    LAG(total) OVER w AS prev_month,
    ROUND(100 * (total - LAG(total) OVER w) / NULLIF(LAG(total) OVER w, 0), 2) AS mom_pct,
    ROUND(AVG(total) OVER (ORDER BY month_start
          ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 0) AS moving_avg_3m
FROM filled
WINDOW w AS (ORDER BY month_start)
ORDER BY month_start;
```

**(ঘ) Year-over-Year Growth:**

```sql
WITH monthly AS (
    SELECT YEAR(sale_date)  AS yr,
           MONTH(sale_date) AS mon,
           SUM(amount)      AS total
    FROM sales
    GROUP BY yr, mon
)
SELECT
    yr,
    mon,
    total,
    LAG(total) OVER (PARTITION BY mon ORDER BY yr) AS same_month_last_year,
    ROUND(100 * (total - LAG(total) OVER (PARTITION BY mon ORDER BY yr))
              / LAG(total) OVER (PARTITION BY mon ORDER BY yr), 2) AS yoy_pct
FROM monthly
ORDER BY yr, mon;
```

### ৬. Expected Output

**(ক) ফাঁদ:** 2025-01-কে 2024-06-এর সঙ্গে তুলনা করা হয়েছে, যা ভুল!

**Output:**

| month_start | total | compared_with | naive_mom_pct |
|---|---|---|---|
| 2024-01-01 | 61600 | NULL | NULL |
| 2024-02-01 | 87800 | 2024-01-01 | 42.53 |
| 2024-03-01 | 29400 | 2024-02-01 | -66.51 |
| 2024-04-01 | 19250 | 2024-03-01 | -34.52 |
| 2024-05-01 | 46900 | 2024-04-01 | 143.64 |
| 2024-06-01 | 34500 | 2024-05-01 | -26.44 |
| 2025-01-01 | 93300 | 2024-06-01 | 170.43 |
| 2025-02-01 | 53600 | 2025-01-01 | -42.55 |
| 2025-03-01 | 102400 | 2025-02-01 | 91.04 |
| 2025-04-01 | 82500 | 2025-03-01 | -19.43 |
| 2025-05-01 | 72300 | 2025-04-01 | -12.36 |
| 2025-06-01 | 128400 | 2025-05-01 | 77.59 |

_(12 rows)_

**(খ):** 2025-01-এর MoM এখন সঠিকভাবে NULL (আগের মাসের data নেই)।

**Output:**

| month_start | total | prev_month_total | mom_pct |
|---|---|---|---|
| 2024-01-01 | 61600 | NULL | NULL |
| 2024-02-01 | 87800 | 61600 | 42.53 |
| 2024-03-01 | 29400 | 87800 | -66.51 |
| 2024-04-01 | 19250 | 29400 | -34.52 |
| 2024-05-01 | 46900 | 19250 | 143.64 |
| 2024-06-01 | 34500 | 46900 | -26.44 |
| 2025-01-01 | 93300 | NULL | NULL |
| 2025-02-01 | 53600 | 93300 | -42.55 |
| 2025-03-01 | 102400 | 53600 | 91.04 |
| 2025-04-01 | 82500 | 102400 | -19.43 |
| 2025-05-01 | 72300 | 82500 | -12.36 |
| 2025-06-01 | 128400 | 72300 | 77.59 |

_(12 rows)_

**(গ):** বাদ পড়া মাসগুলো 0। 0 থেকে growth অসংজ্ঞায়িত, তাই NULL।

**Output:**

| month_start | total | prev_month | mom_pct | moving_avg_3m |
|---|---|---|---|---|
| 2024-01-01 | 61600 | NULL | NULL | 61600 |
| 2024-02-01 | 87800 | 61600 | 42.53 | 74700 |
| 2024-03-01 | 29400 | 87800 | -66.51 | 59600 |
| 2024-04-01 | 19250 | 29400 | -34.52 | 45483 |
| 2024-05-01 | 46900 | 19250 | 143.64 | 31850 |
| 2024-06-01 | 34500 | 46900 | -26.44 | 33550 |
| 2024-07-01 | 0 | 34500 | -100.00 | 27133 |
| 2024-08-01 | 0 | 0 | NULL | 11500 |
| 2024-09-01 | 0 | 0 | NULL | 0 |
| 2024-10-01 | 0 | 0 | NULL | 0 |
| 2024-11-01 | 0 | 0 | NULL | 0 |
| 2024-12-01 | 0 | 0 | NULL | 0 |
| 2025-01-01 | 93300 | 0 | NULL | 31100 |
| 2025-02-01 | 53600 | 93300 | -42.55 | 48967 |
| 2025-03-01 | 102400 | 53600 | 91.04 | 83100 |
| 2025-04-01 | 82500 | 102400 | -19.43 | 79500 |
| 2025-05-01 | 72300 | 82500 | -12.36 | 85733 |
| 2025-06-01 | 128400 | 72300 | 77.59 | 94400 |

_(18 rows)_

**(ঘ):**

**Output:**

| yr | mon | total | same_month_last_year | yoy_pct |
|---|---|---|---|---|
| 2024 | 1 | 61600 | NULL | NULL |
| 2024 | 2 | 87800 | NULL | NULL |
| 2024 | 3 | 29400 | NULL | NULL |
| 2024 | 4 | 19250 | NULL | NULL |
| 2024 | 5 | 46900 | NULL | NULL |
| 2024 | 6 | 34500 | NULL | NULL |
| 2025 | 1 | 93300 | 61600 | 51.46 |
| 2025 | 2 | 53600 | 87800 | -38.95 |
| 2025 | 3 | 102400 | 29400 | 248.30 |
| 2025 | 4 | 82500 | 19250 | 328.57 |
| 2025 | 5 | 72300 | 46900 | 54.16 |
| 2025 | 6 | 128400 | 34500 | 272.17 |

_(12 rows)_

### ৭. Line-by-line Explanation

- `CAST(DATE_FORMAT(sale_date, '%Y-%m-01') AS DATE)`: যেকোনো তারিখকে মাসের প্রথম দিনে নিয়ে যাওয়া। DATE হওয়ায় `- INTERVAL 1 MONTH` চালানো যায়।
- (খ) `LAG(month_start) OVER w = month_start - INTERVAL 1 MONTH`: আগের row ঠিক এক মাস আগের কিনা।
- (গ) `WITH RECURSIVE calendar`: 2024-01 থেকে 2025-06 পর্যন্ত প্রতিটি মাসের row বানায়। প্রথম SELECT শুরুর মান, দ্বিতীয় SELECT প্রতিবার ১ মাস যোগ করে, যতক্ষণ শর্ত সত্য।
- (গ) `LEFT JOIN ... COALESCE(m.total, 0)`: বিক্রি না থাকা মাসে 0।
- (গ) `moving_avg_3m`: এখন "আগের ২টি row" মানে সত্যিই "আগের ২ মাস", কারণ কোনো মাস বাদ নেই।
- (ঘ) `PARTITION BY mon ORDER BY yr`: প্রতিটি মাস-নম্বরের (1–12) আলাদা গ্রুপ, বছরের ক্রমে। তাই `LAG` = গত বছরের একই মাস।

### ৮. Common Mistakes

1. **`LAG` মানে "আগের মাস" ধরে নেওয়া।**
2. **YoY-তে `LAG(total, 12)` লেখা।** এটা কাজ করে শুধু যদি ১২টি মাসই data-তে থাকে। আমাদের data-তে এটা ভুল ফল দিত।
3. **Calendar না বানিয়ে Moving Average।** বাদ পড়া মাস থাকলে গড়ের জানালা ভুল হয়।
4. **Recursive CTE-তে থামার শর্ত না দেওয়া।** তখন অসীম লুপ হয় (MySQL `cte_max_recursion_depth` = 1000-এ থামিয়ে Error দেয়)।

### ৯. Practice Problems

- **Beginner:** (ঘ)-এর মতো করে YoY-তে order সংখ্যার পরিবর্তন বের করুন।
- **Intermediate:** প্রতিটি category-র মাসিক বিক্রিতে সঠিক MoM Growth বের করুন (যাচাই পদ্ধতিতে, `PARTITION BY category`)।
- **Advanced:** Calendar পদ্ধতিতে প্রতিটি category × প্রতিটি মাস (2025 Jan–Jun) টেবিল বানান (CROSS JOIN), বিক্রি না থাকলে 0। তারপর ৩-মাসের Moving Average বের করুন।

### ১০. ছোট Quiz

1. আমাদের data-তে সরাসরি `LAG` দিয়ে MoM করলে কোন মাসটা ভুল হয়?
2. YoY-এর জন্য PARTITION BY কী?
3. Recursive CTE-এর দুটি অংশ কী কী?

---

## Lesson 6.6 — Median Calculation

### ১. Topic Introduction

**Median** হলো সাজানো তালিকার ঠিক মাঝের মান। গড় (Average) বড় outlier দ্বারা প্রভাবিত হয়, কিন্তু Median হয় না। MySQL-এ `MEDIAN()` function নেই, তাই Window Function দিয়ে বানাতে হয়।

### ২. সহজ বাংলা ব্যাখ্যা

৫ জনের বেতন: 20, 22, 25, 27, **200** হাজার। গড় = 58.8 হাজার, যা কারও বেতনের কাছাকাছিও না! Median = 25 হাজার (মাঝের জন), যা বাস্তব চিত্রের কাছাকাছি।

- **বিজোড় সংখ্যক** (n = 5): মাঝের জন, অবস্থান (5+1)/2 = 3।
- **জোড় সংখ্যক** (n = 4): মাঝের দুজনের গড়, অবস্থান 2 ও 3।

একটা সূত্রে দুটোই সামলানো যায়: অবস্থান `FLOOR((n+1)/2)` আর `CEIL((n+1)/2)`। বিজোড় হলে দুটো একই অবস্থান, জোড় হলে পাশাপাশি দুটি।

### ৩. Syntax

```text
WITH r AS (
  SELECT grp, val,
         ROW_NUMBER() OVER (PARTITION BY grp ORDER BY val) AS rn,
         COUNT(*)     OVER (PARTITION BY grp)              AS cnt
  FROM t)
SELECT grp, AVG(val) AS median
FROM r
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2))
GROUP BY grp;
```

### ৪. Sample Data

`employees` (department-এ 4, 4, 2, 3 জন: জোড় ও বিজোড় দুটোই আছে) আর `sales`।

### ৫. SQL Query

**(ক) Department অনুযায়ী Median Salary, গড়ের সঙ্গে তুলনা:**

```sql
WITH r AS (
    SELECT
        dept_id, salary,
        ROW_NUMBER() OVER (PARTITION BY dept_id ORDER BY salary) AS rn,
        COUNT(*)     OVER (PARTITION BY dept_id)                AS cnt,
        AVG(salary)  OVER (PARTITION BY dept_id)                AS avg_salary
    FROM employees
)
SELECT
    dept_id,
    MAX(cnt)                 AS employees,
    ROUND(MAX(avg_salary),2) AS avg_salary,
    AVG(salary)              AS median_salary
FROM r
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2))
GROUP BY dept_id
ORDER BY dept_id;
```

**(খ) সব sale-এর Median amount বনাম গড়:**

```sql
WITH r AS (
    SELECT amount,
           ROW_NUMBER() OVER (ORDER BY amount) AS rn,
           COUNT(*)     OVER ()                AS cnt,
           AVG(amount)  OVER ()                AS avg_amount
    FROM sales
)
SELECT
    MAX(cnt)                   AS total_sales,
    ROUND(MAX(avg_amount), 2)  AS average_amount,
    AVG(amount)                AS median_amount
FROM r
WHERE rn IN (FLOOR((cnt + 1) / 2), CEIL((cnt + 1) / 2));
```

**(গ) বোনাস: PERCENT_RANK() আর CUME_DIST(), বিতরণে অবস্থান:**

```sql
SELECT
    emp_name,
    salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary), 3) AS pct_rank,
    ROUND(CUME_DIST()    OVER (ORDER BY salary), 3) AS cume_dist
FROM employees
ORDER BY salary, emp_id;
```

### ৬. Expected Output

**(ক):**

**Output:**

| dept_id | employees | avg_salary | median_salary |
|---|---|---|---|
| 1 | 4 | 56750.00 | 58500.0000 |
| 2 | 4 | 73500.00 | 72000.0000 |
| 3 | 2 | 48500.00 | 48500.0000 |
| 4 | 3 | 72000.00 | 78000.0000 |

_(4 rows)_

**(খ):** গড় (বড় Laptop বিক্রির কারণে) Median-এর চেয়ে অনেক বেশি।

**Output:**

| total_sales | average_amount | median_amount |
|---|---|---|
| 45 | 18043.33 | 9000.0000 |

_(1 rows)_

**(গ):**

**MySQL Error:**

```text
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'cume_dist
FROM employees
ORDER BY salary, emp_id'
```

### ৭. Line-by-line Explanation

- `ROW_NUMBER() ... ORDER BY salary`: ছোট থেকে বড় ক্রমিক নম্বর।
- `COUNT(*) OVER (PARTITION BY dept_id)`: গ্রুপে মোট কতজন।
- `WHERE rn IN (FLOOR((cnt+1)/2), CEIL((cnt+1)/2))`: HR-এ cnt = 2, তাই অবস্থান 1 ও 2 (দুজনের গড়)। Finance-এ cnt = 3, তাই অবস্থান 2 (একজন)।
- `AVG(salary)`: এক বা দুটি মাঝের মানের গড় = Median।
- `MAX(cnt)`, `MAX(avg_salary)`: গ্রুপের সব row-এ একই মান, GROUP BY-তে দেখানোর জন্য MAX নেওয়া।
- (গ) `PERCENT_RANK()` = (rank − 1) / (n − 1), 0 থেকে 1। `CUME_DIST()` = (এই মান বা তার কম কতজন) / n।

### ৮. Common Mistakes

1. **`ROW_NUMBER`-এর বদলে `RANK` ব্যবহার।** ties-এ অবস্থান লাফ দেয়, তখন মাঝের অবস্থান খুঁজে পাওয়া না-ও যেতে পারে।
2. **জোড় সংখ্যার ক্ষেত্রে শুধু একটি মান নেওয়া।**
3. **Integer ভাগে বিভ্রান্তি।** `(cnt+1)/2` MySQL-এ দশমিক দেয়, তাই FLOOR/CEIL দিয়ে পূর্ণসংখ্যা বানানো দরকার।

### ৯. Practice Problems

- **Beginner:** পুরো কোম্পানির Median salary বের করুন।
- **Intermediate:** প্রতিটি category-র product দামের Median বের করুন।
- **Advanced:** প্রতিটি salesperson-এর sale amount-এর Median বের করুন, আর গড়ের সঙ্গে পার্থক্য দেখান। কার বিক্রিতে outlier-এর প্রভাব সবচেয়ে বেশি?

### ১০. ছোট Quiz

1. ৪টি মানের Median কোন অবস্থানের মান থেকে আসে?
2. Median কেন outlier-এ কম প্রভাবিত হয়?
3. `CUME_DIST()` কী মাপে?

---

## Lesson 6.7 — Customer Purchase Analysis

### ১. Topic Introduction

একটি Query-তে প্রতিটি customer-এর পূর্ণ প্রোফাইল বানাব: প্রথম ও শেষ কেনাকাটা, মোট order, মোট খরচ, গড় order, কেনাকাটার গড় বিরতি, মোট বিক্রিতে অংশ, rank আর segment। এখানে LAG, GROUP BY, SUM OVER, RANK, NTILE সব একসঙ্গে লাগবে।

### ২. সহজ বাংলা ব্যাখ্যা

Marketing টিম জানতে চায়: কোন customer সবচেয়ে মূল্যবান, কে নিয়মিত কেনেন, কে অনেক দিন আসেননি। এই রিপোর্ট দিয়ে "Gold" customer-দের বিশেষ অফার, আর অনেক দিন না আসা customer-দের "আবার আসুন" মেসেজ পাঠানো যায়।

### ৩. Syntax

```text
CTE ১: row-level Window (LAG দিয়ে বিরতি)
CTE ২: customer-level GROUP BY
শেষ SELECT: customer-level Window (RANK, NTILE, SUM OVER)
```

### ৪. Sample Data

`customers` + `sales`। (রিপোর্টের "আজ" ধরা হয়েছে 2025-06-30।)

### ৫. SQL Query

```sql
WITH purchase AS (
    SELECT
        s.customer_id,
        s.sale_date,
        s.amount,
        DATEDIFF(s.sale_date,
                 LAG(s.sale_date) OVER (PARTITION BY s.customer_id
                                        ORDER BY s.sale_date, s.sale_id)) AS gap_days
    FROM sales s
),
profile AS (
    SELECT
        customer_id,
        MIN(sale_date)        AS first_purchase,
        MAX(sale_date)        AS last_purchase,
        COUNT(*)              AS orders,
        SUM(amount)           AS total_spent,
        ROUND(AVG(amount), 0) AS avg_order,
        ROUND(AVG(gap_days), 0) AS avg_gap_days
    FROM purchase
    GROUP BY customer_id
)
SELECT
    c.customer_name,
    p.first_purchase,
    p.last_purchase,
    DATEDIFF('2025-06-30', p.last_purchase)            AS days_inactive,
    p.orders,
    p.total_spent,
    p.avg_order,
    p.avg_gap_days,
    RANK() OVER (ORDER BY p.total_spent DESC)          AS spend_rank,
    ROUND(100 * p.total_spent / SUM(p.total_spent) OVER (), 1) AS share_pct,
    CASE NTILE(3) OVER (ORDER BY p.total_spent DESC)
        WHEN 1 THEN 'Gold' WHEN 2 THEN 'Silver' ELSE 'Bronze'
    END                                                AS segment
FROM profile p
JOIN customers c ON c.customer_id = p.customer_id
ORDER BY spend_rank;
```

### ৬. Expected Output

**Output:**

| customer_name | first_purchase | last_purchase | days_inactive | orders | total_spent | avg_order | avg_gap_days | spend_rank | share_pct | segment |
|---|---|---|---|---|---|---|---|---|---|---|
| Selim Reza | 2024-02-03 | 2025-05-20 | 41 | 5 | 181450 | 36290 | 118 | 1 | 22.3 | Gold |
| Abdul Karim | 2024-01-05 | 2025-05-09 | 52 | 7 | 177000 | 25286 | 82 | 2 | 21.8 | Gold |
| Habib Rahman | 2024-02-22 | 2025-06-06 | 24 | 5 | 157800 | 31560 | 118 | 3 | 19.4 | Gold |
| Shirin Akter | 2024-01-12 | 2025-06-18 | 12 | 7 | 140600 | 20086 | 87 | 4 | 17.3 | Silver |
| Nasrin Sultana | 2024-02-14 | 2025-05-31 | 30 | 5 | 59900 | 11980 | 118 | 5 | 7.4 | Silver |
| Mahmud Hasan | 2024-01-20 | 2025-06-27 | 3 | 10 | 57100 | 5710 | 58 | 6 | 7.0 | Silver |
| Rokeya Begum | 2024-01-28 | 2025-04-30 | 61 | 5 | 33600 | 6720 | 115 | 7 | 4.1 | Bronze |
| Shirin Akter | 2025-05-09 | 2025-05-09 | 52 | 1 | 4500 | 4500 | NULL | 8 | 0.6 | Bronze |

_(8 rows)_

### ৭. Line-by-line Explanation

- `purchase` CTE: প্রতিটি কেনাকাটার আগের কেনাকাটা থেকে কত দিন পরে (LAG + DATEDIFF)। প্রথম কেনাকাটায় NULL।
- `profile` CTE: customer অনুযায়ী GROUP BY। `AVG(gap_days)` NULL উপেক্ষা করে, তাই প্রথম কেনাকাটা গড়ে ঢোকে না।
- `DATEDIFF('2025-06-30', p.last_purchase)`: কত দিন কেনেননি (Recency)।
- `RANK() OVER (ORDER BY p.total_spent DESC)`: খরচ অনুযায়ী অবস্থান।
- `SUM(p.total_spent) OVER ()`: সব customer-এর মোট। তা দিয়ে share %।
- `NTILE(3)`: ৮ জনকে ৩ ভাগে (3, 3, 2) ভাগ করে Gold, Silver, Bronze।

লক্ষ্য করুন: Shirin Akter দুবার আছেন (ID 2 ও 8)। Lesson 6.2-এর duplicate সমস্যা এখানে রিপোর্টকে বিকৃত করছে। বাস্তবে আগে customer data পরিষ্কার করতে হয়।

### ৮. Common Mistakes

1. **একই স্তরে row-level আর customer-level Window মেশানো।** স্তর আলাদা রাখতে CTE ব্যবহার করুন।
2. **`AVG(gap_days)`-তে NULL-কে 0 বানিয়ে ফেলা।** তখন গড় ভুলভাবে কমে যায়।
3. **Duplicate customer পরিষ্কার না করে রিপোর্ট।**

### ৯. Practice Problems

- **Beginner:** প্রতিটি customer-এর order সংখ্যা আর মোট খরচ, সঙ্গে খরচ অনুযায়ী DENSE_RANK দেখান।
- **Intermediate:** ৯০ দিনের বেশি কেনাকাটা না করা customer-দের "At Risk" লেবেল দিন।
- **Advanced:** Duplicate customer (একই email) একত্র করে (আসল customer_id-তে ম্যাপ করে) উপরের পুরো প্রোফাইল আবার বানান।

### ১০. ছোট Quiz

1. এই Query-তে কয়টি স্তরে (level) Window Function চলেছে?
2. `AVG()` NULL-এর সঙ্গে কী করে?
3. ৮ জনকে `NTILE(3)` দিলে ভাগগুলোর আকার কী?

---

## Lesson 6.8 — Advanced Business Intelligence Queries

### ১. Topic Introduction

তিনটি জনপ্রিয় BI বিশ্লেষণ:

1. **Pareto / ABC Analysis:** কোন অল্প কয়েকটি product থেকে বেশিরভাগ আয় আসে।
2. **মাসের সেরা Salesperson:** প্রতি মাসে কে Top।
3. **New vs Returning Customers:** প্রতি মাসে কতজন নতুন customer এলেন, আর কতজন পুরনো ফিরে এলেন।

### ২. সহজ বাংলা ব্যাখ্যা

**Pareto (80/20) নিয়ম:** প্রায়ই ২০% product থেকে ৮০% আয় আসে। Product-গুলোকে আয় অনুযায়ী সাজিয়ে **Cumulative %** বের করলে দেখা যায় কোনগুলো "A" (প্রথম ৮০% আয়), কোনগুলো "B" (পরের ১৫%), আর কোনগুলো "C" (শেষ ৫%)। Stock আর মার্কেটিং-এর সিদ্ধান্তে এটা খুব কাজের।

### ৩. Syntax

```text
SUM(revenue) OVER (ORDER BY revenue DESC ROWS UNBOUNDED PRECEDING) / SUM(revenue) OVER () → cumulative share
RANK() OVER (PARTITION BY month ORDER BY sales DESC) = 1 → মাসের সেরা
ROW_NUMBER() OVER (PARTITION BY customer ORDER BY date) = 1 → প্রথম কেনাকাটা (নতুন customer)
```

### ৪. Sample Data

`products`, `sales`, `employees`, `customers`।

### ৫. SQL Query

**(ক) Pareto / ABC Analysis:**

```sql
WITH rev AS (
    SELECT p.product_name, p.category, SUM(s.amount) AS revenue
    FROM sales s
    JOIN products p ON p.product_id = s.product_id
    GROUP BY p.product_id, p.product_name, p.category
),
cum AS (
    SELECT *,
        ROUND(100 * revenue / SUM(revenue) OVER (), 2) AS share_pct,
        ROUND(100 * SUM(revenue) OVER (ORDER BY revenue DESC, product_name
                                       ROWS UNBOUNDED PRECEDING)
                  / SUM(revenue) OVER (), 2)           AS cumulative_pct
    FROM rev
)
SELECT *,
    CASE WHEN cumulative_pct <= 80 THEN 'A'
         WHEN cumulative_pct <= 95 THEN 'B'
         ELSE 'C' END AS abc_class
FROM cum
ORDER BY revenue DESC, product_name;
```

**(খ) প্রতি মাসের সেরা Salesperson (2025):**

```sql
WITH m AS (
    SELECT DATE_FORMAT(s.sale_date, '%Y-%m') AS month,
           e.emp_name,
           SUM(s.amount) AS sales_amt
    FROM sales s
    JOIN employees e ON e.emp_id = s.emp_id
    WHERE YEAR(s.sale_date) = 2025
    GROUP BY month, e.emp_id, e.emp_name
),
r AS (
    SELECT *,
        RANK() OVER (PARTITION BY month ORDER BY sales_amt DESC) AS rnk,
        ROUND(100 * sales_amt / SUM(sales_amt) OVER (PARTITION BY month), 1) AS month_share_pct
    FROM m
)
SELECT month, emp_name AS top_salesperson, sales_amt, month_share_pct
FROM r
WHERE rnk = 1
ORDER BY month;
```

**(গ) মাসভিত্তিক New vs Returning Customers:**

```sql
WITH firsts AS (
    SELECT customer_id,
           DATE_FORMAT(sale_date, '%Y-%m') AS month,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date, sale_id) AS purchase_no
    FROM sales
)
SELECT
    month,
    COUNT(DISTINCT customer_id)                                   AS active_customers,
    COUNT(DISTINCT CASE WHEN purchase_no = 1 THEN customer_id END) AS new_customers,
    COUNT(DISTINCT CASE WHEN purchase_no > 1 THEN customer_id END) AS returning_customers,
    SUM(SUM(purchase_no = 1)) OVER (ORDER BY month)               AS cumulative_customers
FROM firsts
GROUP BY month
ORDER BY month;
```

### ৬. Expected Output

**(ক):**

**Output:**

| product_name | category | revenue | share_pct | cumulative_pct | abc_class |
|---|---|---|---|---|---|
| Laptop | Electronics | 300000 | 36.95 | 36.95 | A |
| Smartphone | Electronics | 175000 | 21.55 | 58.50 | A |
| Office Chair | Furniture | 75000 | 9.24 | 67.74 | A |
| Study Table | Furniture | 72000 | 8.87 | 76.61 | A |
| Smartwatch | Electronics | 48000 | 5.91 | 82.52 | B |
| Rice 25kg | Grocery | 28600 | 3.52 | 86.04 | B |
| Saree | Clothing | 27000 | 3.33 | 89.37 | B |
| Headphones | Electronics | 22500 | 2.77 | 92.14 | B |
| Jeans | Clothing | 18000 | 2.22 | 94.35 | B |
| Bookshelf | Furniture | 17000 | 2.09 | 96.45 | C |
| Panjabi | Clothing | 15000 | 1.85 | 98.29 | C |
| Soybean Oil 5L | Grocery | 11400 | 1.40 | 99.70 | C |
| Tea 400g | Grocery | 2450 | 0.30 | 100.00 | C |

_(13 rows)_

**(খ):**

**Output:**

| month | top_salesperson | sales_amt | month_share_pct |
|---|---|---|---|
| 2025-01 | Rahim Uddin | 75000 | 80.4 |
| 2025-02 | Rahim Uddin | 35000 | 65.3 |
| 2025-03 | Karim Hasan | 89200 | 87.1 |
| 2025-04 | Fatema Akter | 35000 | 42.4 |
| 2025-05 | Rahim Uddin | 35000 | 48.4 |
| 2025-06 | Rahim Uddin | 75000 | 58.4 |

_(6 rows)_

**(গ):**

**Output:**

| month | active_customers | new_customers | returning_customers | cumulative_customers |
|---|---|---|---|---|
| 2024-01 | 4 | 4 | 0 | 4 |
| 2024-02 | 3 | 3 | 0 | 7 |
| 2024-03 | 3 | 0 | 3 | 7 |
| 2024-04 | 3 | 0 | 3 | 7 |
| 2024-05 | 3 | 0 | 3 | 7 |
| 2024-06 | 2 | 0 | 2 | 7 |
| 2025-01 | 4 | 0 | 4 | 7 |
| 2025-02 | 3 | 0 | 3 | 7 |
| 2025-03 | 3 | 0 | 3 | 7 |
| 2025-04 | 4 | 0 | 4 | 7 |
| 2025-05 | 4 | 1 | 3 | 8 |
| 2025-06 | 3 | 0 | 3 | 8 |

_(12 rows)_

### ৭. Line-by-line Explanation

- (ক) `SUM(revenue) OVER (ORDER BY revenue DESC, product_name ROWS UNBOUNDED PRECEDING)`: বড় থেকে ছোট আয়ের running total। ÷ মোট আয় = cumulative %।
- (ক) `CASE ... abc_class`: 80% পর্যন্ত A, 95% পর্যন্ত B, বাকি C।
- (খ) `RANK() OVER (PARTITION BY month ...) = 1`: প্রতি মাসে সর্বোচ্চ বিক্রেতা (সমান হলে দুজনই)।
- (খ) `SUM(sales_amt) OVER (PARTITION BY month)`: ওই মাসের মোট, যা দিয়ে Top salesperson-এর share।
- (গ) `ROW_NUMBER() ... = 1`: প্রতিটি customer-এর প্রথম কেনাকাটা।
- (গ) `COUNT(DISTINCT CASE WHEN purchase_no = 1 ...)`: সেই মাসে নতুন customer।
- (গ) `SUM(SUM(purchase_no = 1)) OVER (ORDER BY month)`: MySQL-এ `purchase_no = 1` শর্তটা 1/0 দেয়। ভেতরের SUM মাসের নতুন customer সংখ্যা, বাইরের SUM OVER তার running total। অর্থাৎ এ পর্যন্ত মোট কতজন customer।

### ৮. Common Mistakes

1. **Pareto-তে ডিফল্ট RANGE frame ব্যবহার।** দুটি product-এর আয় সমান হলে cumulative % লাফ দেয়। ROWS + tie-breaker দিন।
2. **New customer গুনতে `MIN(sale_date)` না বুঝে ব্যবহার।** ROW_NUMBER পদ্ধতি বেশি নমনীয়, যেমন "দ্বিতীয় কেনাকাটা কবে" খুঁজতেও কাজে লাগে।
3. **Share % হিসাবে ভুল partition।** মাসের share চাইলে `PARTITION BY month`।

### ৯. Practice Problems

- **Beginner:** Pareto Query-তে কয়টি product "A" class-এ পড়েছে, গুনে বের করুন।
- **Intermediate:** প্রতি মাসের **সবচেয়ে কম** বিক্রি করা salesperson বের করুন (যিনি সেই মাসে অন্তত একটি বিক্রি করেছেন)।
- **Advanced:** প্রতিটি customer-এর **প্রথম** আর **দ্বিতীয়** কেনাকাটার মাঝে কত দিন লেগেছে, বের করুন। যাঁর দ্বিতীয় কেনাকাটা নেই, তাঁকে `'One-time'` দেখান।

### ১০. ছোট Quiz

1. Cumulative % হিসাবে কোন দুটি Window লাগে?
2. "মাসের সেরা" খুঁজতে PARTITION BY কী হবে?
3. New customer চেনার জন্য কোন Ranking function সবচেয়ে উপযুক্ত?

> **Module 6 শেষ।** আপনি এখন Interview-লেভেলের প্রায় সব Window Function সমস্যা সমাধান করতে পারেন। Module 7-এ শিখব এগুলো কীভাবে দ্রুত চালানো যায় আর ভুল কীভাবে ধরা যায়। **"Ready"** লিখুন।


# Module 7: Performance এবং Best Practices

**আগের Module-গুলোর সঙ্গে সম্পর্ক:** এ পর্যন্ত আমরা সঠিক ফল পাওয়ায় মন দিয়েছি। কিন্তু বাস্তবে Table-এ লক্ষ লক্ষ row থাকে। এই Module-এ দেখব MySQL ভেতরে ভেতরে Window Function কীভাবে চালায়, কোথায় সময় যায়, আর কীভাবে Query দ্রুত, পরিষ্কার ও নির্ভুল রাখা যায়।

## Lesson 7.1 — Window Function-এর Performance, Index এবং PARTITION BY / ORDER BY-এর প্রভাব

### ১. Topic Introduction

MySQL প্রতিটি **আলাদা Window সংজ্ঞার** (PARTITION BY + ORDER BY) জন্য সাধারণত:

1. Data-কে ওই ক্রমে **Sort** করে।
2. Partition ধরে ধরে row পড়ে, Frame অনুযায়ী হিসাব করে।
3. একাধিক আলাদা Window থাকলে মাঝের ফল একটা **Temporary Table**-এ রাখে, তারপর পরের Window-এর জন্য আবার Sort করে।

তাই Performance-এর মূল কথা: **কম row, কম Sort, কম আলাদা Window।**

### ২. সহজ বাংলা ব্যাখ্যা

লাইব্রেরিতে বই সাজানোর কথা ভাবুন। একবার লেখকের নাম অনুযায়ী সাজিয়ে তিনটা আলাদা প্রশ্নের উত্তর দিলে পরিশ্রম কম। কিন্তু প্রতিটি প্রশ্নের জন্য আলাদা ক্রমে (লেখক, তারপর সাল, তারপর পৃষ্ঠা) পুরো লাইব্রেরি নতুন করে সাজালে তিনগুণ পরিশ্রম। আর যদি আগে শুধু দরকারি তাকের বইগুলো আলাদা করে নেন (`WHERE`), তাহলে সাজাতে হয় অনেক কম বই।

**Practical নিয়ম:**

| কৌশল | কেন |
|---|---|
| `WHERE` দিয়ে আগে row কমান | Sort-এ কম row ঢোকে |
| `WHERE`/`JOIN`-এর column-এ Index দিন | কম row পড়তে হয় (Index range scan) |
| একই PARTITION BY + ORDER BY বারবার ব্যবহার করুন (Named Window) | একটাই Sort |
| অপ্রয়োজনীয় আলাদা Window এড়িয়ে চলুন | প্রতিটি নতুন Window = নতুন Sort + Temp Table |
| শুধু দরকারি column SELECT করুন | Sort buffer আর Temp Table ছোট থাকে |
| আগে GROUP BY করে row কমান, তারপর Window | ১০ লাখ sale-এর বদলে ১২টি মাসিক row-এ Window |
| বড় Sort হলে `sort_buffer_size` দেখুন | Disk-এ sort হলে ধীর হয় |

**Index নিয়ে সৎ কথা:** MySQL 8.0-এ (PARTITION BY, ORDER BY)-এর সঙ্গে মিলে যাওয়া Index থাকলেও Window-এর জন্য **Sort ধাপ প্রায়ই থেকে যায়**। নিচের EXPLAIN-এ নিজেই দেখবেন। Index-এর আসল লাভ আসে `WHERE` আর `JOIN`-এ, কারণ Sort-এ ঢোকার আগেই row অনেক কমে যায়।

### ৩. Syntax

```text
EXPLAIN FORMAT=TREE  <query>;   -- Plan দেখায় (চালায় না)
EXPLAIN ANALYZE      <query>;   -- আসলে চালিয়ে প্রতিটি ধাপের সময় দেখায়
CREATE INDEX idx_name ON table(col1, col2, ...);
```

### ৪. Sample Data

`sales` Table।

### ৫. SQL Query

**(ক) দুটি আলাদা Window: দুটি Sort + Temporary Table:**

```sql
EXPLAIN FORMAT=TREE
SELECT
    sale_id,
    SUM(amount) OVER (PARTITION BY emp_id ORDER BY sale_date, sale_id) AS running_by_emp,
    LAG(amount) OVER (ORDER BY sale_date, sale_id)                     AS prev_sale_amount
FROM sales;
```

**(খ) একই Named Window-এ তিনটি function: একটাই Sort:**

```sql
EXPLAIN FORMAT=TREE
SELECT
    sale_id,
    SUM(amount)  OVER w AS running_total,
    AVG(amount)  OVER w AS running_avg,
    ROW_NUMBER() OVER w AS rn
FROM sales
WINDOW w AS (PARTITION BY emp_id ORDER BY sale_date, sale_id);
```

**(গ) WHERE-এর column-এ Index: Sort-এ কম row ঢোকে:**

```sql
CREATE INDEX idx_sales_date ON sales(sale_date);
```

```sql
EXPLAIN FORMAT=TREE
SELECT sale_id, sale_date, amount,
       SUM(amount) OVER (ORDER BY sale_date, sale_id) AS running_total
FROM sales
WHERE sale_date BETWEEN '2025-03-01' AND '2025-03-31';
```

### ৬. Expected Output

**(ক):** নিচ থেকে ওপরে পড়ুন। Table scan, তারপর Sort, Window, Temporary table, আবার Sort, আবার Window।



**Output:**

```text
-> Window aggregate with buffering: lag(sales.amount) OVER (ORDER BY sales.sale_date,sales.sale_id ) 
    -> Sort: sales.sale_date, sales.sale_id
        -> Table scan on <temporary>  (cost=2.5..2.5 rows=0)
            -> Temporary table  (cost=0..0 rows=0)
                -> Window aggregate with buffering: sum(sales.amount) OVER (PARTITION BY sales.emp_id ORDER BY sales.sale_date,sales.sale_id ) 
                    -> Sort: sales.emp_id, sales.sale_date, sales.sale_id  (cost=4.75 rows=45)
                        -> Table scan on sales  (cost=4.75 rows=45)
```

**(খ):** একটাই "Sort", আর তিনটি function একই "Window aggregate" ধাপে হিসাব হয়েছে।



**Output:**

```text
-> Window aggregate with buffering: sum(sales.amount) OVER w, avg(sales.amount) OVER w, row_number() OVER w
    -> Sort: sales.emp_id, sales.sale_date, sales.sale_id  (cost=4.75 rows=45)
        -> Table scan on sales  (cost=4.75 rows=45)
```

**(গ):** "Index range scan" মানে ৪৫টির বদলে শুধু মার্চের ৮টি row পড়া হয়েছে। Sort ধাপ এখনো আছে, কিন্তু মাত্র ৮টি row নিয়ে।



**Output:**

```text
-> Window aggregate with buffering: sum(sales.amount) OVER (ORDER BY sales.sale_date,sales.sale_id ) 
    -> Sort: sales.sale_date, sales.sale_id  (cost=3.86 rows=8)
        -> Index range scan on sales using idx_sales_date over ('2025-03-01' <= sale_date <= '2025-03-31'), with index condition: (sales.sale_date between '2025-03-01' and '2025-03-31')  (cost=3.86 rows=8)
```

### ৭. Line-by-line Explanation

- `EXPLAIN FORMAT=TREE`: Query চালায় না, শুধু Plan দেখায়। গাছের মতো সাজানো থাকে, আর সবচেয়ে ভেতরের (নিচের) ধাপ আগে চলে।
- `Table scan on sales`: পুরো Table পড়া হচ্ছে।
- `Sort: sales.emp_id, sales.sale_date, sales.sale_id`: PARTITION BY + ORDER BY অনুযায়ী Sort।
- `Window aggregate with buffering`: Frame-এর জন্য row buffer-এ রেখে হিসাব।
- `Temporary table`: প্রথম Window-এর ফল রেখে দ্বিতীয় Window-এর জন্য আবার Sort। (ক)-তে PARTITION BY আলাদা হওয়ায় এটা লেগেছে।
- (খ) একই `w`, তাই একটাই Sort।
- (গ) `Index range scan on sales using idx_sales_date`: Index দিয়ে শুধু দরকারি row পড়া হয়েছে।

**বাস্তব পরামর্শ:**

1. **বড় Table-এ আগে aggregate:** দৈনিক বা মাসিক মোট CTE-তে বানিয়ে তারপর LAG/Moving Average চালান।
2. **Partition-এর আকার:** খুব বড় partition (বা `OVER ()` পুরো Table-এ) মানে সব row একসঙ্গে buffer-এ রাখা। `RANGE`/`ROWS UNBOUNDED FOLLOWING` থাকলে memory বেশি লাগে।
3. **Pagination-এ সাবধান:** `ROW_NUMBER()` দিয়ে Page 1000 চাইলেও আগে সব row-এর নম্বর দিতে হয়। খুব বড় data-তে "keyset pagination" (`WHERE id > last_seen_id ORDER BY id LIMIT 10`) দ্রুততর।
4. **`EXPLAIN ANALYZE` দিয়ে মাপুন:** অনুমানে নয়, আসল সময় দেখে Optimize করুন।

### ৮. Common Mistakes

1. **প্রতিটি column-এ আলাদা ORDER BY**, যেমন একটায় `ORDER BY sale_date`, আরেকটায় `ORDER BY sale_date, sale_id`। প্রতিটির জন্য নতুন Sort হয়। সম্ভব হলে সব জায়গায় একই ক্রম দিন।
2. **Filter পরে করা।** বাইরের Query-তে `WHERE` দিলে ভেতরের Window পুরো Table-এ চলে। কিন্তু সাবধান: Window-এর হিসাবে বাদ পড়া row-গুলো দরকার হলে (যেমন LAG-এর আগের মাস) Filter ভেতরে নেওয়া যাবে না।
3. **ভাবা যে Index দিলেই Window Sort উধাও হবে।**

### ৯. Practice Problems

- **Beginner:** Lesson 3.2-এর Running Total Query-তে `EXPLAIN FORMAT=TREE` চালিয়ে কয়টি Sort হচ্ছে গুনুন।
- **Intermediate:** একটি Query লিখুন যাতে ৩টি Window Function আছে কিন্তু মাত্র একটি Sort হয়। EXPLAIN দিয়ে প্রমাণ করুন।
- **Advanced:** `sales(customer_id, sale_date)` Index বানিয়ে `WHERE customer_id = 3` সহ একটি Running Total Query-র Plan আগে ও পরে তুলনা করুন। `EXPLAIN ANALYZE`-এর সময়ও লিখুন।

### ১০. ছোট Quiz

1. দুটি আলাদা PARTITION BY থাকলে Plan-এ কী অতিরিক্ত ধাপ দেখা যায়?
2. Index Window-এর Performance-এ মূলত কোন ধাপে সাহায্য করে?
3. Named Window কীভাবে Performance বাড়াতে পারে?

---

## Lesson 7.2 — Subquery, CTE, Derived Table, একাধিক Window Function, Common Mistakes ও Debugging

### ১. Topic Introduction

Window Function-এর ফল দিয়ে filter, আবার হিসাব বা join করতে হলে একটা "বাইরের স্তর" লাগে। MySQL-এ তিনভাবে এটা করা যায়: **Derived Table** (FROM-এ Subquery), **CTE** (`WITH`), আর কিছু ক্ষেত্রে **Subquery**। এই Lesson-এ তিনটি তুলনা করব, একাধিক Window পরিষ্কারভাবে লেখা শিখব, আর ভুল ধরার কৌশল দেখব।

### ২. সহজ বাংলা ব্যাখ্যা

- **Derived Table** = Query-র ভেতরে একটা অস্থায়ী Table, যার একটা নাম (alias) থাকতে হয়।
- **CTE** = একই জিনিস, কিন্তু Query-র শুরুতে নাম দিয়ে লেখা। ধাপে ধাপে পড়া যায়, যেমন রেসিপির ধাপ ১, ধাপ ২, ধাপ ৩।
- **Correlated Subquery** = প্রতিটি row-এর জন্য আলাদা ছোট Query চলে। Window Function আসার আগে এটাই ভরসা ছিল, কিন্তু প্রায়ই ধীর।

সাধারণ পরামর্শ: **পড়ার সুবিধার জন্য CTE।** MySQL 8.0 প্রায়ই CTE আর Derived Table-কে একইভাবে optimize করে।

### ৩. Syntax

```text
-- Derived Table
SELECT ... FROM (SELECT ..., WIN() OVER (...) AS x FROM t) AS d WHERE d.x ...;

-- CTE
WITH d AS (SELECT ..., WIN() OVER (...) AS x FROM t)
SELECT ... FROM d WHERE x ...;

-- Named Window inheritance
WINDOW w1 AS (PARTITION BY a),
       w2 AS (w1 ORDER BY b)     -- w1-এর ওপর ORDER BY যোগ
```

### ৪. Sample Data

`employees`, `sales`।

### ৫. SQL Query

**(ক) একই প্রশ্ন, তিন পদ্ধতি: "কারা নিজের department-এর গড়ের চেয়ে বেশি বেতন পান?"**

```sql
-- পদ্ধতি ১: Correlated Subquery (পুরনো পদ্ধতি)
SELECT e.emp_name, e.dept_id, e.salary
FROM employees e
WHERE e.salary > (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.dept_id = e.dept_id)
ORDER BY e.dept_id, e.salary DESC;
```

```sql
-- পদ্ধতি ২: Derived Table + Window
SELECT emp_name, dept_id, salary, dept_avg
FROM (
    SELECT emp_name, dept_id, salary,
           ROUND(AVG(salary) OVER (PARTITION BY dept_id), 0) AS dept_avg
    FROM employees
) AS d
WHERE salary > dept_avg
ORDER BY dept_id, salary DESC;
```

```sql
-- পদ্ধতি ৩: CTE + Window (সবচেয়ে পড়তে সহজ)
WITH d AS (
    SELECT emp_name, dept_id, salary,
           ROUND(AVG(salary) OVER (PARTITION BY dept_id), 0) AS dept_avg
    FROM employees
)
SELECT emp_name, dept_id, salary, dept_avg
FROM d
WHERE salary > dept_avg
ORDER BY dept_id, salary DESC;
```

**(খ) একই Query-তে একাধিক Window Function, Named Window inheritance সহ:**

```sql
SELECT
    e.emp_name                    AS salesperson,
    s.sale_date,
    s.amount,
    ROW_NUMBER()  OVER w_ord      AS sale_no,
    SUM(s.amount) OVER w_ord      AS running_total,
    LAG(s.amount) OVER w_ord      AS prev_amount,
    SUM(s.amount) OVER w_emp      AS emp_total,
    ROUND(100 * s.amount / SUM(s.amount) OVER w_emp, 1) AS pct_of_emp_total,
    RANK() OVER (ORDER BY s.amount DESC) AS company_rank
FROM sales s
JOIN employees e ON e.emp_id = s.emp_id
WHERE s.sale_date BETWEEN '2025-04-01' AND '2025-06-30'
WINDOW w_emp AS (PARTITION BY s.emp_id),
       w_ord AS (w_emp ORDER BY s.sale_date, s.sale_id)
ORDER BY salesperson, s.sale_date, s.sale_id;
```

**(গ) Debugging কৌশল: Frame-এর সীমানা চোখে দেখা:**

```sql
SELECT
    sale_id, sale_date, amount,
    FIRST_VALUE(sale_id) OVER f_rows AS rows_frame_from,
    LAST_VALUE(sale_id)  OVER f_rows AS rows_frame_to,
    COUNT(*)             OVER f_rows AS rows_frame_size,
    FIRST_VALUE(sale_id) OVER f_rng  AS range_frame_from,
    LAST_VALUE(sale_id)  OVER f_rng  AS range_frame_to,
    COUNT(*)             OVER f_rng  AS range_frame_size
FROM sales
WHERE sale_date BETWEEN '2025-03-01' AND '2025-03-31'
WINDOW f_rows AS (ORDER BY sale_date, sale_id ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
       f_rng  AS (ORDER BY sale_date RANGE BETWEEN INTERVAL 2 DAY PRECEDING AND CURRENT ROW)
ORDER BY sale_date, sale_id;
```

### ৬. Expected Output

**(ক):** তিন পদ্ধতিই একই employee দেয় (পদ্ধতি ১-এ `dept_avg` column নেই)। পদ্ধতি ৩-এর Output:

**Output:**

| emp_name | dept_id | salary | dept_avg |
|---|---|---|---|
| Karim Hasan | 1 | 62000 | 56750 |
| Fatema Akter | 1 | 62000 | 56750 |
| Tanvir Ahmed | 2 | 85000 | 73500 |
| Jamal Uddin | 3 | 52000 | 48500 |
| Farhana Yasmin | 4 | 78000 | 72000 |
| Imran Kabir | 4 | 78000 | 72000 |

_(6 rows)_

**(খ):**

**Output:**

| salesperson | sale_date | amount | sale_no | running_total | prev_amount | emp_total | pct_of_emp_total | company_rank |
|---|---|---|---|---|---|---|---|---|
| Fatema Akter | 2025-04-03 | 35000 | 1 | 35000 | NULL | 44900 | 78.0 | 2 |
| Fatema Akter | 2025-05-09 | 4500 | 2 | 39500 | 35000 | 44900 | 10.0 | 12 |
| Fatema Akter | 2025-06-27 | 5400 | 3 | 44900 | 4500 | 44900 | 12.0 | 11 |
| Karim Hasan | 2025-04-30 | 8500 | 1 | 8500 | NULL | 65300 | 13.0 | 10 |
| Karim Hasan | 2025-05-31 | 8800 | 2 | 17300 | 8500 | 65300 | 13.5 | 9 |
| Karim Hasan | 2025-06-18 | 24000 | 3 | 41300 | 8800 | 65300 | 36.8 | 5 |
| Karim Hasan | 2025-06-18 | 24000 | 4 | 65300 | 24000 | 65300 | 36.8 | 5 |
| Nusrat Jahan | 2025-04-14 | 30000 | 1 | 30000 | NULL | 54000 | 55.6 | 4 |
| Nusrat Jahan | 2025-05-20 | 24000 | 2 | 54000 | 30000 | 54000 | 44.4 | 5 |
| Rahim Uddin | 2025-04-22 | 9000 | 1 | 9000 | NULL | 119000 | 7.6 | 8 |
| Rahim Uddin | 2025-05-09 | 35000 | 2 | 44000 | 9000 | 119000 | 29.4 | 2 |
| Rahim Uddin | 2025-06-06 | 75000 | 3 | 119000 | 35000 | 119000 | 63.0 | 1 |

_(12 rows)_

**(গ):** প্রতিটি row-এর Frame কোন sale থেকে কোন sale পর্যন্ত, সরাসরি দেখা যাচ্ছে।

**Output:**

| sale_id | sale_date | amount | rows_frame_from | rows_frame_to | rows_frame_size | range_frame_from | range_frame_to | range_frame_size |
|---|---|---|---|---|---|---|---|---|
| 26 | 2025-03-10 | 700 | 26 | 26 | 1 | 26 | 26 | 1 |
| 27 | 2025-03-11 | 1900 | 26 | 27 | 2 | 26 | 28 | 3 |
| 28 | 2025-03-11 | 12000 | 26 | 28 | 3 | 26 | 28 | 3 |
| 29 | 2025-03-12 | 2200 | 27 | 29 | 3 | 26 | 30 | 5 |
| 30 | 2025-03-12 | 3600 | 28 | 30 | 3 | 26 | 30 | 5 |
| 31 | 2025-03-15 | 2500 | 29 | 31 | 3 | 31 | 31 | 1 |
| 32 | 2025-03-16 | 4500 | 30 | 32 | 3 | 31 | 32 | 2 |
| 33 | 2025-03-28 | 75000 | 31 | 33 | 3 | 33 | 33 | 1 |

_(8 rows)_

### ৭. Line-by-line Explanation

- (ক) পদ্ধতি ১: প্রতিটি employee-র জন্য ভেতরের `SELECT AVG(...)` আবার চলে (correlated)। বড় Table-এ ধীর হতে পারে।
- (ক) পদ্ধতি ২: `FROM (...) AS d`। MySQL-এ Derived Table-এর alias বাধ্যতামূলক।
- (ক) পদ্ধতি ৩: একই যুক্তি, কিন্তু উপরে নাম দিয়ে লেখা, তাই পড়তে সহজ। একাধিক CTE কমা দিয়ে পরপর লেখা যায়, আর পরেরটা আগেরটাকে ব্যবহার করতে পারে।
- (খ) `WINDOW w_emp AS (PARTITION BY s.emp_id)`: মূল window।
- (খ) `w_ord AS (w_emp ORDER BY ...)`: `w_emp`-এর partition নিয়ে তার ওপর ORDER BY যোগ। একে Window inheritance বলে।
- (খ) `RANK() OVER (ORDER BY s.amount DESC)`: সম্পূর্ণ আলাদা একটা window, পুরো (filtered) result-এ rank।
- (গ) `FIRST_VALUE(sale_id)`/`LAST_VALUE(sale_id)` আর `COUNT(*)` একই Frame-এ: Frame-এ ঠিক কোন row-গুলো ঢুকছে তা বোঝার সবচেয়ে কার্যকর debugging কৌশল। যেকোনো Moving Average বা Running Total ভুল মনে হলে এভাবে Frame "প্রিন্ট" করুন।

### ৮. Common Mistakes এবং Debugging

**MySQL-এর আসল Error message-গুলো দেখুন:**

**(i) Window Function-এর ভেতরে Window Function:**

```sql
SELECT MAX(SUM(amount) OVER (ORDER BY sale_id)) OVER () FROM sales;
```

**MySQL Error:**

```text
ERROR 3593 (HY000): You cannot use the window function 'sum' in this context.'
```

সমাধান: ভেতরের Window CTE-তে হিসাব করুন, বাইরের Query-তে দ্বিতীয় Window।

**(ii) Window Aggregate-এ DISTINCT:**

```sql
SELECT emp_id, COUNT(DISTINCT customer_id) OVER (PARTITION BY emp_id) FROM sales;
```

**MySQL Error:**

```text
ERROR 1235 (42000): This version of MySQL doesn't yet support '<window function>(DISTINCT ..)'
```

সমাধান: আগে `GROUP BY emp_id` দিয়ে `COUNT(DISTINCT ...)` বের করে JOIN করুন, অথবা DENSE_RANK-এর কৌশল ব্যবহার করুন: `MAX(dr) OVER (PARTITION BY emp_id)`, যেখানে `dr = DENSE_RANK() OVER (PARTITION BY emp_id ORDER BY customer_id)`।

**(iii) RANGE + INTERVAL-এ একাধিক ORDER BY:**

```sql
SELECT SUM(amount) OVER (ORDER BY sale_date, sale_id
       RANGE BETWEEN INTERVAL 2 DAY PRECEDING AND CURRENT ROW) FROM sales;
```

**MySQL Error:**

```text
ERROR 3587 (HY000): Window '<unnamed window>' with RANGE N PRECEDING/FOLLOWING frame requires exactly one ORDER BY expression, of numeric or temporal type
```

সমাধান: RANGE-এ শুধু `ORDER BY sale_date`।

**সম্পূর্ণ Checklist: ভুল ফল পেলে এই ক্রমে যাচাই করুন:**

| # | প্রশ্ন | সাধারণ লক্ষণ | সমাধান |
|---|---|---|---|
| 1 | PARTITION BY ঠিক আছে? | অন্য গ্রুপের data মিশে যাচ্ছে | সঠিক partition column |
| 2 | OVER-এর ORDER BY unique? | একই Query বারবার চালালে ফল বদলায় | tie-breaker (id) যোগ |
| 3 | Frame কী? | Running Total লাফ দেয়, LAST_VALUE ভুল | ROWS/পূর্ণ Frame লিখে দিন |
| 4 | WHERE আগে চলে মনে আছে? | গণনা কম দেখাচ্ছে | Filter-এর স্থান বদলান (CTE-র ভেতরে/বাইরে) |
| 5 | Window-এর ফলে filter? | Error 3593 | CTE/Derived Table |
| 6 | GROUP BY-এর পরে Window? | Error 1055 বা অদ্ভুত মান | `SUM(SUM(x)) OVER` বা CTE |
| 7 | NULL কীভাবে সামলানো হচ্ছে? | LAG/LEAD-এ NULL, শূন্য দিয়ে ভাগ | `COALESCE`, `NULLIF`, LAG-এর default |
| 8 | ROW_NUMBER, RANK না DENSE_RANK? | Ties-এ কেউ বাদ পড়ছে | ব্যবসায়িক নিয়ম অনুযায়ী function |
| 9 | "আগের row" = "আগের সময়কাল"? | MoM ভুল | Calendar বা মাস যাচাই |
| 10 | Duplicate data? | Total/Rank বিকৃত | আগে ROW_NUMBER দিয়ে de-dup |

**Debugging-এর ৩টি অভ্যাস:**

1. **মাঝের column দেখান:** rn, cnt, frame_size, prev_value। চূড়ান্ত হিসাবের আগে প্রতিটি ধাপ চোখে দেখুন।
2. **ছোট data-তে পরীক্ষা:** `WHERE customer_id = 3` বা একটা মাস দিয়ে হাতে মিলিয়ে দেখুন।
3. **CTE ধাপে ধাপে চালান:** প্রথম CTE-টা একা `SELECT * FROM cte1` দিয়ে দেখুন, তারপর পরেরটা যোগ করুন।

### ৯. Practice Problems

- **Beginner:** (ক)-এর প্রশ্নটি নিজে Derived Table দিয়ে লিখুন, কিন্তু এবার "গড়ের **চেয়ে কম**" বেতনের জনদের খুঁজুন।
- **Intermediate:** Named Window inheritance ব্যবহার করে প্রতিটি customer-এর প্রতিটি কেনাকাটায় দেখান: ক্রমিক নম্বর, Running Total, আগের amount, আর customer-এর মোট খরচ।
- **Advanced:** প্রতিটি salesperson কতজন **আলাদা customer**-এর কাছে বিক্রি করেছেন, তা প্রতিটি sale row-এর পাশে দেখান। `COUNT(DISTINCT) OVER` চলে না, তাই উপরের DENSE_RANK কৌশল ব্যবহার করুন।

### ১০. ছোট Quiz

1. MySQL-এ Derived Table-এর ক্ষেত্রে কোন জিনিসটা বাধ্যতামূলক?
2. `WINDOW w2 AS (w1 ORDER BY x)` কী বোঝায়?
3. Frame debug করতে কোন তিনটি function একসঙ্গে ব্যবহার করা যায়?

> **Module 7 শেষ।** এখন পুরো জ্ঞান একসঙ্গে প্রয়োগ করার সময়: **Final Project**।


# Final Project: Sales Analysis with Window Functions

## প্রজেক্ট পরিচিতি

আপনি এই কোম্পানির নতুন **Data Analyst**। ম্যানেজমেন্ট 2025 সালের প্রথম ছয় মাসের (Jan–Jun) একটি পূর্ণ Sales Analysis রিপোর্ট চায়। তুলনার জন্য 2024-এর Jan–Jun data-ও আছে। রিপোর্টে ৮টি প্রশ্নের উত্তর থাকবে:

| # | কাজ | মূল Window Function | যে Module থেকে |
|---|---|---|---|
| 1 | Top 3 Products per Category | RANK, SUM OVER | 2, 3, 6 |
| 2 | প্রতিটি Customer-এর Purchase Ranking | DENSE_RANK, ROW_NUMBER | 2 |
| 3 | Monthly Sales Running Total | SUM OVER + ROWS | 3, 4 |
| 4 | Moving Average | AVG OVER + ROWS frame | 4 |
| 5 | Previous Month Sales Comparison | LAG | 5 |
| 6 | Month-over-Month Growth % (+ YoY) | LAG, PARTITION BY | 5, 6 |
| 7 | Salesperson Performance Ranking | RANK, NTILE, LEAD | 2, 5, 6 |
| 8 | Customer Purchase Trend Analysis | LAG, FIRST/LAST_VALUE | 5, 6 |

**প্রজেক্টের নিয়ম:** বাস্তব Analyst-এর মতো, আগে **data পরিষ্কার** করব (Module 6.2-এর শিক্ষা), তারপর বিশ্লেষণ।

## ধাপ ০: Data Cleaning, একটি পরিষ্কার VIEW

আমাদের data-তে দুটি সমস্যা আছে: একটি sale দুবার entry (sale 44), আর একই customer দুবার রেজিস্টার্ড (ID 2 ও 8)। দুটোই Window Function দিয়ে ঠিক করে একটি VIEW বানাব। পরের সব Query এই VIEW ব্যবহার করবে।

```sql
CREATE OR REPLACE VIEW sales_clean AS
WITH dedup_sales AS (
    SELECT s.*,
           ROW_NUMBER() OVER (
               PARTITION BY sale_date, customer_id, product_id, emp_id, quantity, amount
               ORDER BY sale_id
           ) AS rn
    FROM sales s
),
customer_master AS (
    SELECT customer_id,
           FIRST_VALUE(customer_id) OVER (
               PARTITION BY email ORDER BY join_date, customer_id
           ) AS master_id
    FROM customers
)
SELECT
    d.sale_id,
    d.sale_date,
    CAST(DATE_FORMAT(d.sale_date, '%Y-%m-01') AS DATE) AS month_start,
    cm.master_id      AS customer_id,
    c.customer_name,
    d.product_id,
    p.product_name,
    p.category,
    d.emp_id,
    e.emp_name        AS salesperson,
    d.quantity,
    d.amount
FROM dedup_sales d
JOIN customer_master cm ON cm.customer_id = d.customer_id
JOIN customers c        ON c.customer_id  = cm.master_id
JOIN products  p        ON p.product_id   = d.product_id
JOIN employees e        ON e.emp_id       = d.emp_id
WHERE d.rn = 1;
```

**যাচাই (Validation):**

```sql
SELECT 'raw sales'   AS source, COUNT(*) AS row_count, SUM(amount) AS total_amount,
       COUNT(DISTINCT customer_id) AS customers FROM sales
UNION ALL
SELECT 'sales_clean', COUNT(*), SUM(amount), COUNT(DISTINCT customer_id) FROM sales_clean;
```

**Output:**

| source | row_count | total_amount | customers |
|---|---|---|---|
| raw sales | 45 | 811950 | 8 |
| sales_clean | 44 | 787950 | 7 |

_(2 rows)_

একটি duplicate sale (24000 টাকা) বাদ পড়েছে, আর ৮ জন customer এখন ৭ জন।

**ব্যাখ্যা:**

- `dedup_sales`: Lesson 6.2-এর ROW_NUMBER কৌশল। `rn = 1` রাখা হয়েছে।
- `customer_master`: একই email-এর সবার জন্য **প্রথম রেজিস্টার্ড** customer_id (FIRST_VALUE)। তাই customer 8-এর sale এখন customer 2-এর নামে যাবে।
- MySQL 8.0-এ VIEW-এর ভেতরে CTE আর Window Function দুটোই চলে।

---

## Task 1: Top 3 Products per Category (Revenue অনুযায়ী)

**প্রশ্ন:** প্রতিটি category-তে কোন ৩টি product সবচেয়ে বেশি আয় এনেছে, আর category-র মোট আয়ে তাদের অংশ কত?

```sql
WITH product_rev AS (
    SELECT category, product_name,
           SUM(quantity) AS units,
           SUM(amount)   AS revenue
    FROM sales_clean
    GROUP BY category, product_id, product_name
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rnk,
        ROUND(100 * revenue / SUM(revenue) OVER (PARTITION BY category), 1) AS pct_of_category
    FROM product_rev
)
SELECT category, rnk, product_name, units, revenue, pct_of_category
FROM ranked
WHERE rnk <= 3
ORDER BY category, rnk;
```

**Output:**

| category | rnk | product_name | units | revenue | pct_of_category |
|---|---|---|---|---|---|
| Clothing | 1 | Saree | 6 | 27000 | 45.0 |
| Clothing | 2 | Jeans | 10 | 18000 | 30.0 |
| Clothing | 3 | Panjabi | 6 | 15000 | 25.0 |
| Electronics | 1 | Laptop | 4 | 300000 | 55.0 |
| Electronics | 2 | Smartphone | 5 | 175000 | 32.1 |
| Electronics | 3 | Smartwatch | 4 | 48000 | 8.8 |
| Furniture | 1 | Office Chair | 5 | 75000 | 53.6 |
| Furniture | 2 | Study Table | 4 | 48000 | 34.3 |
| Furniture | 3 | Bookshelf | 2 | 17000 | 12.1 |
| Grocery | 1 | Rice 25kg | 13 | 28600 | 67.4 |
| Grocery | 2 | Soybean Oil 5L | 12 | 11400 | 26.9 |
| Grocery | 3 | Tea 400g | 7 | 2450 | 5.8 |

_(12 rows)_

**ব্যাখ্যা:**

- `product_rev`: product অনুযায়ী মোট unit আর revenue।
- `RANK() OVER (PARTITION BY category ORDER BY revenue DESC)`: category-র ভেতরে আয়ের ক্রম।
- `SUM(revenue) OVER (PARTITION BY category)`: category-র মোট আয়, যা দিয়ে শতাংশ।
- `WHERE rnk <= 3`: CTE-র বাইরে filter (Lesson 1.4)।
- **Insight:** Electronics-এ Laptop একাই category-র অর্ধেকের বেশি আয় এনেছে। Clean data-তে Furniture-এ Office Chair (75000) Study Table-কে (48000) পেছনে ফেলেছে। Duplicate থাকলে Study Table 72000 দেখাত।

---

## Task 2: প্রতিটি Customer-এর Purchase Ranking

**প্রশ্ন:** প্রতিটি customer-এর সবচেয়ে বড় ২টি কেনাকাটা কী কী, সেগুলো তাঁর কততম কেনাকাটা ছিল, আর মোট খরচে customer-দের অবস্থান কী?

```sql
WITH r AS (
    SELECT
        customer_id,
        customer_name,
        sale_date,
        product_name,
        amount,
        DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC)         AS purchase_rank,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date, sale_id)  AS purchase_no,
        COUNT(*)     OVER (PARTITION BY customer_id)                              AS total_purchases,
        SUM(amount)  OVER (PARTITION BY customer_id)                              AS customer_total
    FROM sales_clean
)
SELECT
    DENSE_RANK() OVER (ORDER BY customer_total DESC) AS customer_rank,
    customer_name,
    customer_total,
    purchase_rank,
    CONCAT(purchase_no, ' of ', total_purchases)     AS which_purchase,
    sale_date,
    product_name,
    amount
FROM r
WHERE purchase_rank <= 2
ORDER BY customer_rank, purchase_rank, sale_date;
```

**Output:**

| customer_rank | customer_name | customer_total | purchase_rank | which_purchase | sale_date | product_name | amount |
|---|---|---|---|---|---|---|---|
| 1 | Selim Reza | 181450 | 1 | 1 of 5 | 2024-02-03 | Laptop | 75000 |
| 1 | Selim Reza | 181450 | 1 | 4 of 5 | 2025-03-28 | Laptop | 75000 |
| 1 | Selim Reza | 181450 | 2 | 5 of 5 | 2025-05-20 | Smartwatch | 24000 |
| 2 | Abdul Karim | 177000 | 1 | 4 of 7 | 2025-01-05 | Laptop | 75000 |
| 2 | Abdul Karim | 177000 | 2 | 1 of 7 | 2024-01-05 | Smartphone | 35000 |
| 2 | Abdul Karim | 177000 | 2 | 7 of 7 | 2025-05-09 | Smartphone | 35000 |
| 3 | Habib Rahman | 157800 | 1 | 5 of 5 | 2025-06-06 | Laptop | 75000 |
| 3 | Habib Rahman | 157800 | 2 | 2 of 5 | 2024-05-06 | Smartphone | 35000 |
| 3 | Habib Rahman | 157800 | 2 | 3 of 5 | 2025-02-07 | Smartphone | 35000 |
| 4 | Shirin Akter | 121100 | 1 | 5 of 7 | 2025-04-03 | Smartphone | 35000 |
| 4 | Shirin Akter | 121100 | 2 | 3 of 7 | 2024-06-08 | Office Chair | 30000 |
| 5 | Nasrin Sultana | 59900 | 1 | 4 of 5 | 2025-04-14 | Office Chair | 30000 |
| 5 | Nasrin Sultana | 59900 | 2 | 1 of 5 | 2024-02-14 | Saree | 9000 |
| 6 | Mahmud Hasan | 57100 | 1 | 1 of 10 | 2024-01-20 | Office Chair | 15000 |
| 6 | Mahmud Hasan | 57100 | 2 | 4 of 10 | 2025-02-16 | Study Table | 12000 |
| 7 | Rokeya Begum | 33600 | 1 | 2 of 5 | 2024-04-04 | Headphones | 9000 |
| 7 | Rokeya Begum | 33600 | 2 | 5 of 5 | 2025-04-30 | Bookshelf | 8500 |

_(17 rows)_

**ব্যাখ্যা:**

- `DENSE_RANK() ... ORDER BY amount DESC`: customer-এর নিজের কেনাকাটাগুলোর মধ্যে বড় থেকে ছোট। সমান amount হলে একই rank (যেমন একাধিক কেনাকাটা একই দামের হলে)।
- `ROW_NUMBER() ... ORDER BY sale_date, sale_id`: কততম কেনাকাটা (সময়ের ক্রমে)।
- `SUM(amount) OVER (PARTITION BY customer_id)`: customer-এর মোট খরচ।
- বাইরের `DENSE_RANK() OVER (ORDER BY customer_total DESC)`: **দ্বিতীয় স্তরের Window**, customer-দের মধ্যে অবস্থান। ভেতরের CTE-তে এটা সম্ভব ছিল না, কারণ `customer_total` নিজেই একটা Window-এর ফল (Lesson 6.4: Window-এর ভেতরে Window চলে না)।
- **Insight:** Shirin Akter-এর দুটি account একত্র হওয়ায় তিনি এখন একজন customer, আর তাঁর মোট খরচ সঠিকভাবে দেখাচ্ছে।

---

## Task 3–6: Monthly Sales Dashboard (Running Total, Moving Average, Previous Month Comparison, MoM ও YoY Growth)

**প্রশ্ন:** 2025-এর প্রতিটি মাসে কত বিক্রি হলো? বছরের শুরু থেকে এ পর্যন্ত মোট কত (Task 3)? ৩-মাসের চলমান গড় কত (Task 4)? আগের মাসের তুলনায় কত বাড়ল বা কমল (Task 5), শতাংশে কত (Task 6)? আর গত বছরের একই মাসের তুলনায় কত?

**অনুমান (Assumption):** 2024-এর Jul–Dec data নেই। তাই MoM আর Moving Average প্রতিটি বছরের ভেতরে হিসাব হবে (`PARTITION BY yr`), যাতে 2025-01-কে ভুল করে 2024-06-এর সঙ্গে তুলনা না করা হয় (Lesson 6.5)। YoY তুলনা হবে 2024-এর একই মাসের সঙ্গে।

```sql
WITH monthly AS (
    SELECT
        YEAR(month_start)  AS yr,
        MONTH(month_start) AS mon,
        month_start,
        COUNT(*)           AS orders,
        SUM(amount)        AS total
    FROM sales_clean
    GROUP BY month_start
),
dashboard AS (
    SELECT
        yr,
        DATE_FORMAT(month_start, '%Y-%m')                            AS month,
        orders,
        total,
        -- Task 3: Running Total (YTD)
        SUM(total) OVER (PARTITION BY yr ORDER BY month_start
                         ROWS UNBOUNDED PRECEDING)                   AS ytd_total,
        -- Task 4: 3-month Moving Average (পূর্ণ ৩ মাস হলেই)
        CASE WHEN COUNT(*) OVER w3 = 3
             THEN ROUND(AVG(total) OVER w3, 0) END                   AS moving_avg_3m,
        -- Task 5: Previous Month Comparison
        LAG(total) OVER (PARTITION BY yr ORDER BY month_start)       AS prev_month,
        total - LAG(total) OVER (PARTITION BY yr ORDER BY month_start) AS change_amt,
        -- Task 6: MoM Growth %
        ROUND(100 * (total - LAG(total) OVER (PARTITION BY yr ORDER BY month_start))
                  / NULLIF(LAG(total) OVER (PARTITION BY yr ORDER BY month_start), 0), 2)
                                                                     AS mom_pct,
        -- বোনাস: YoY Growth %
        ROUND(100 * (total - LAG(total) OVER (PARTITION BY mon ORDER BY yr))
                  / NULLIF(LAG(total) OVER (PARTITION BY mon ORDER BY yr), 0), 2)
                                                                     AS yoy_pct
    FROM monthly
    WINDOW w3 AS (PARTITION BY yr ORDER BY month_start
                  ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
)
SELECT month, orders, total, ytd_total, moving_avg_3m,
       prev_month, change_amt, mom_pct, yoy_pct
FROM dashboard
WHERE yr = 2025
ORDER BY month;
```

**Output:**

| month | orders | total | ytd_total | moving_avg_3m | prev_month | change_amt | mom_pct | yoy_pct |
|---|---|---|---|---|---|---|---|---|
| 2025-01 | 4 | 93300 | 93300 | NULL | NULL | NULL | NULL | 51.46 |
| 2025-02 | 3 | 53600 | 146900 | NULL | 93300 | -39700 | -42.55 | -38.95 |
| 2025-03 | 8 | 102400 | 249300 | 83100 | 53600 | 48800 | 91.04 | 248.30 |
| 2025-04 | 4 | 82500 | 331800 | 79500 | 102400 | -19900 | -19.43 | 328.57 |
| 2025-05 | 4 | 72300 | 404100 | 85733 | 82500 | -10200 | -12.36 | 54.16 |
| 2025-06 | 3 | 104400 | 508500 | 86400 | 72300 | 32100 | 44.40 | 202.61 |

_(6 rows)_

**ব্যাখ্যা:**

- `monthly`: clean data থেকে ১২টি মাসিক row (2024 ও 2025)।
- **Task 3:** `SUM(total) OVER (PARTITION BY yr ORDER BY month_start ROWS UNBOUNDED PRECEDING)` বছরের শুরু থেকে running total দেয়। ROWS দেওয়া হয়েছে স্পষ্টতার জন্য (Module 4)।
- **Task 4:** `WINDOW w3`-এ আগের ২ মাস + বর্তমান মাস। `COUNT(*) OVER w3 = 3` না হলে (Jan, Feb) NULL, অর্থাৎ অসম্পূর্ণ গড় দেখানো হয়নি।
- **Task 5:** `LAG(total)` আগের মাস দেয়। `PARTITION BY yr` থাকায় Jan-এর আগের মাস NULL।
- **Task 6:** `(এই মাস − আগের মাস) / আগের মাস × 100`। `NULLIF` শূন্য দিয়ে ভাগ ঠেকায়।
- **YoY:** `PARTITION BY mon ORDER BY yr` দিয়ে গত বছরের একই মাস।
- **`WHERE yr = 2025` বাইরের Query-তে:** খুব গুরুত্বপূর্ণ! ভেতরে (`monthly`-তে) 2025 filter করলে YoY-এর জন্য 2024-এর data হারিয়ে যেত। Window আগে পুরো data-তে চলেছে, filter পরে হয়েছে (Lesson 1.4)।
- **Insight:** June 2025 ছয় মাসের মধ্যে সর্বোচ্চ। Duplicate বাদ দেওয়ায় এটা আগের 128400 থেকে কমে 104400 হয়েছে। প্রতিটি মাসে বিক্রি 2024-এর একই মাসের চেয়ে বেশি, শুধু February ছাড়া।

---

## Task 7: Salesperson Performance Ranking (2025)

**প্রশ্ন:** 2025-এ কোন salesperson কত বিক্রি করেছেন, তাঁদের rank আর share কত, পরের জনের চেয়ে কত এগিয়ে, আর কতবার মাসের সেরা হয়েছেন?

```sql
WITH sp AS (
    SELECT emp_id, salesperson,
           COUNT(*)              AS orders,
           SUM(amount)           AS total_sales,
           ROUND(AVG(amount), 0) AS avg_sale
    FROM sales_clean
    WHERE YEAR(sale_date) = 2025
    GROUP BY emp_id, salesperson
),
monthly_rank AS (
    SELECT month_start, emp_id,
           RANK() OVER (PARTITION BY month_start ORDER BY SUM(amount) DESC) AS month_rank
    FROM sales_clean
    WHERE YEAR(sale_date) = 2025
    GROUP BY month_start, emp_id
),
tops AS (
    SELECT emp_id, SUM(month_rank = 1) AS months_as_top
    FROM monthly_rank
    GROUP BY emp_id
)
SELECT
    RANK() OVER (ORDER BY sp.total_sales DESC)                  AS sales_rank,
    sp.salesperson,
    sp.orders,
    sp.total_sales,
    sp.avg_sale,
    ROUND(100 * sp.total_sales / SUM(sp.total_sales) OVER (), 1) AS share_pct,
    sp.total_sales - LEAD(sp.total_sales) OVER (ORDER BY sp.total_sales DESC) AS ahead_of_next,
    COALESCE(t.months_as_top, 0)                                AS months_as_top,
    CASE NTILE(2) OVER (ORDER BY sp.total_sales DESC)
         WHEN 1 THEN 'Top Performer' ELSE 'Needs Support' END   AS performance_band
FROM sp
LEFT JOIN tops t ON t.emp_id = sp.emp_id
ORDER BY sales_rank;
```

**Output:**

| sales_rank | salesperson | orders | total_sales | avg_sale | share_pct | ahead_of_next | months_as_top | performance_band |
|---|---|---|---|---|---|---|---|---|
| 1 | Rahim Uddin | 8 | 236100 | 29513 | 46.4 | 84600 | 4 | Top Performer |
| 2 | Karim Hasan | 8 | 151500 | 18938 | 29.8 | 90700 | 1 | Top Performer |
| 3 | Fatema Akter | 6 | 60800 | 10133 | 12.0 | 700 | 1 | Needs Support |
| 4 | Nusrat Jahan | 4 | 60100 | 15025 | 11.8 | NULL | 0 | Needs Support |

_(4 rows)_

**ব্যাখ্যা:**

- `sp`: salesperson অনুযায়ী 2025-এর মোট, order আর গড়।
- `monthly_rank`: GROUP BY-এর ফলের ওপর সরাসরি Window, `RANK() OVER (PARTITION BY month_start ORDER BY SUM(amount) DESC)`। প্রতি মাসে কে কত নম্বরে।
- `tops`: `SUM(month_rank = 1)`। MySQL-এ শর্ত 1/0 দেয়, তাই যোগ করলে কতবার Top হয়েছেন তা পাওয়া যায়।
- `LEAD(total_sales) OVER (ORDER BY total_sales DESC)`: ঠিক নিচের জনের বিক্রি। বিয়োগ করলে কত এগিয়ে।
- `NTILE(2)`: ৪ জনকে দুই দলে ভাগ।
- **Insight:** Rahim Uddin মোট বিক্রির প্রায় অর্ধেক এনেছেন, আর ৬ মাসের ৪ মাসেই Top। Fatema Akter আর Nusrat Jahan-এর মধ্যে পার্থক্য মাত্র 700 টাকা। Nusrat-এর order সবচেয়ে কম (৪টি), কিন্তু তাঁর গড় বিক্রি (15025) Fatema-র (10133) চেয়ে বেশি।

---

## Task 8: Customer Purchase Trend Analysis

**প্রশ্ন:** প্রতিটি customer-এর কেনাকাটার পরিমাণ সময়ের সঙ্গে বাড়ছে না কমছে? কত দিন পরপর কেনেন?

**ধাপ ১: কেনাকাটা-স্তরের বিশ্লেষণ** (উদাহরণ হিসেবে Abdul Karim):

```sql
SELECT
    customer_name,
    sale_date,
    amount,
    ROW_NUMBER() OVER w                              AS purchase_no,
    LAG(amount) OVER w                               AS prev_amount,
    CASE
        WHEN LAG(amount) OVER w IS NULL THEN 'First'
        WHEN amount > LAG(amount) OVER w THEN 'Up'
        WHEN amount < LAG(amount) OVER w THEN 'Down'
        ELSE 'Same'
    END                                              AS vs_prev,
    DATEDIFF(sale_date, LAG(sale_date) OVER w)       AS days_since_prev,
    SUM(amount) OVER (w ROWS UNBOUNDED PRECEDING)    AS running_spend
FROM sales_clean
WHERE customer_name = 'Abdul Karim'
WINDOW w AS (PARTITION BY customer_id ORDER BY sale_date, sale_id)
ORDER BY sale_date;
```

**Output:**

| customer_name | sale_date | amount | purchase_no | prev_amount | vs_prev | days_since_prev | running_spend |
|---|---|---|---|---|---|---|---|
| Abdul Karim | 2024-01-05 | 35000 | 1 | NULL | First | NULL | 35000 |
| Abdul Karim | 2024-03-02 | 12000 | 2 | 35000 | Down | 57 | 47000 |
| Abdul Karim | 2024-05-19 | 4400 | 3 | 12000 | Down | 78 | 51400 |
| Abdul Karim | 2025-01-05 | 75000 | 4 | 4400 | Up | 231 | 126400 |
| Abdul Karim | 2025-03-11 | 12000 | 5 | 75000 | Down | 65 | 138400 |
| Abdul Karim | 2025-03-12 | 3600 | 6 | 12000 | Down | 1 | 142000 |
| Abdul Karim | 2025-05-09 | 35000 | 7 | 3600 | Up | 58 | 177000 |

_(7 rows)_

**ধাপ ২: সব customer-এর Trend Summary:**

```sql
WITH p AS (
    SELECT
        customer_id,
        customer_name,
        sale_date,
        amount,
        LAG(amount) OVER w                                AS prev_amount,
        DATEDIFF(sale_date, LAG(sale_date) OVER w)        AS gap_days,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date DESC, sale_id DESC)
                                                          AS recent_no,
        FIRST_VALUE(amount) OVER w                        AS first_amount,
        LAST_VALUE(amount)  OVER (w ROWS BETWEEN UNBOUNDED PRECEDING
                                          AND UNBOUNDED FOLLOWING) AS last_amount
    FROM sales_clean
    WINDOW w AS (PARTITION BY customer_id ORDER BY sale_date, sale_id)
),
summary AS (
    SELECT
        customer_name,
        COUNT(*)                                          AS purchases,
        SUM(amount > prev_amount)                         AS ups,
        SUM(amount < prev_amount)                         AS downs,
        ROUND(AVG(gap_days), 0)                           AS avg_gap_days,
        MAX(first_amount)                                 AS first_amount,
        MAX(last_amount)                                  AS last_amount,
        ROUND(AVG(CASE WHEN recent_no <= 2 THEN amount END), 0) AS recent_avg,
        ROUND(AVG(CASE WHEN recent_no >  2 THEN amount END), 0) AS earlier_avg
    FROM p
    GROUP BY customer_id, customer_name
)
SELECT *,
    CASE
        WHEN purchases < 3              THEN 'Not enough data'
        WHEN recent_avg > earlier_avg * 1.1 THEN 'Increasing'
        WHEN recent_avg < earlier_avg * 0.9 THEN 'Decreasing'
        ELSE 'Stable'
    END AS spending_trend
FROM summary
ORDER BY purchases DESC, customer_name;
```

**Output:**

| customer_name | purchases | ups | downs | avg_gap_days | first_amount | last_amount | recent_avg | earlier_avg | spending_trend |
|---|---|---|---|---|---|---|---|---|---|
| Mahmud Hasan | 10 | 7 | 2 | 58 | 15000 | 5400 | 4950 | 5900 | Decreasing |
| Abdul Karim | 7 | 2 | 4 | 82 | 35000 | 35000 | 19300 | 27680 | Decreasing |
| Shirin Akter | 7 | 4 | 2 | 87 | 6600 | 24000 | 14250 | 18520 | Decreasing |
| Habib Rahman | 5 | 2 | 1 | 118 | 3800 | 75000 | 42000 | 24600 | Increasing |
| Nasrin Sultana | 5 | 1 | 3 | 118 | 9000 | 8800 | 19400 | 7033 | Increasing |
| Rokeya Begum | 5 | 3 | 1 | 115 | 5000 | 8500 | 7550 | 6167 | Increasing |
| Selim Reza | 5 | 2 | 2 | 118 | 75000 | 24000 | 49500 | 27483 | Increasing |

_(7 rows)_

**ব্যাখ্যা:**

- ধাপ ১-এ `WINDOW w AS (PARTITION BY customer_id ORDER BY sale_date, sale_id)` একবার লিখে LAG, ROW_NUMBER আর running sum-এ ব্যবহার হয়েছে। `OVER (w ROWS UNBOUNDED PRECEDING)` দিয়ে Named Window-এ Frame যোগ করা হয়েছে।
- `vs_prev`: প্রতিটি কেনাকাটা আগেরটার চেয়ে বড় না ছোট।
- ধাপ ২-এ `recent_no` (উল্টো ক্রমে ROW_NUMBER): শেষ ২টি কেনাকাটা চিহ্নিত করে।
- `recent_avg` বনাম `earlier_avg`: শেষ ২টি কেনাকাটার গড় আগের সব কেনাকাটার গড়ের চেয়ে ১০% বেশি হলে "Increasing", ১০% কম হলে "Decreasing"।
- `LAST_VALUE(...) OVER (w ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)`: Lesson 5.3-এর Frame সমস্যার সমাধান এখানে কাজে লেগেছে।
- `SUM(amount > prev_amount)`: কতবার আগের চেয়ে বেশি কিনেছেন। প্রথম কেনাকাটায় `prev_amount` NULL, তাই শর্তও NULL, আর SUM সেটা উপেক্ষা করে।
- **Insight:** কোন customer-দের খরচ বাড়ছে আর কাদের কমছে, তা ধরে Marketing আলাদা অফার দিতে পারে, যেমন "Decreasing" customer-দের জন্য ছাড় কুপন।

---

## প্রজেক্ট Extension Challenges (নিজে করুন)

1. প্রতিটি category-র মাসিক বিক্রিতে ৩-মাসের Moving Average আর MoM % বের করুন (Calendar × Category CROSS JOIN সহ)।
2. প্রতিটি salesperson-এর জন্য "Best Month" (সর্বোচ্চ বিক্রির মাস) আর "Worst Month" বের করুন।
3. প্রতিটি customer-এর প্রথম কেনাকাটা কোন category-তে ছিল, আর পরে তাঁরা অন্য category-তে গেছেন কিনা (`FIRST_VALUE(category)` বনাম `LAST_VALUE(category)`)।
4. উপরের সব Task এক সঙ্গে একটি "Executive Summary" Query-তে আনুন: মোট বিক্রি, সেরা product, সেরা salesperson, সেরা মাস আর সর্বোচ্চ MoM growth।

---

# কোর্স সমাপ্তি ও পরবর্তী ধাপ

অভিনন্দন! আপনি MySQL Window Function-এর পুরো যাত্রা শেষ করেছেন:

| শিখেছেন | মূল ধারণা |
|---|---|
| Foundation | `OVER()` row না কমিয়ে হিসাব করে, Window চলে WHERE/GROUP BY-এর পরে |
| Ranking | ROW_NUMBER (unique), RANK (gap), DENSE_RANK (no gap), NTILE (bucket) |
| Aggregate Window | PARTITION BY = গ্রুপের মান, + ORDER BY = Running মান |
| Frame | ROWS = row গোনে, RANGE = মান দেখে, ডিফল্ট RANGE |
| Value Functions | LAG/LEAD = আগে/পরে, LAST_VALUE-এ পূর্ণ Frame লাগে |
| Problem Solving | CTE → Window → Filter/Aggregate ছাঁচ |
| Performance | কম row, কম আলাদা Window, Named Window, WHERE-এ Index |

**এখন কী করবেন:**

1. প্রতিটি Lesson-এর Practice Problem আর Quiz-এর উত্তর চ্যাটে পাঠান, আমি একটা একটা করে যাচাই করব।
2. ভুল হলে কেন ভুল হলো বুঝিয়ে দেব, তারপর সঠিক Query লিখতে সাহায্য করব (সরাসরি Solution আগে দেব না)।
3. কোনো Topic না বুঝলে বলুন, অন্য উদাহরণ দিয়ে আবার বোঝাব।
4. **Module 1, Lesson 1.1-এর Practice দিয়ে শুরু করুন।** উত্তর পাঠালেই আমরা এগোব।
