-- =====================================================================
-- Part 1: Worked Examples (17টি) — window_practice database
-- আগে window_functions_practice_db.sql চালান। প্রতিটি Query আলাদাভাবে চালানো যায়।
-- =====================================================================

USE window_practice;

-- ---------------------------------------------------------------------
-- উদাহরণ 1 — Department-এর গড়ের সঙ্গে বেতন তুলনা
-- Topic: OVER(), PARTITION BY | Difficulty: Easy
-- ---------------------------------------------------------------------
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    ROUND(AVG(e.salary) OVER (PARTITION BY e.dept_id), 0)            AS dept_avg,
    ROUND(AVG(e.salary) OVER (), 0)                                  AS company_avg,
    ROUND(e.salary - AVG(e.salary) OVER (PARTITION BY e.dept_id), 0) AS diff_from_dept_avg,
    ROUND(100 * e.salary / SUM(e.salary) OVER (PARTITION BY e.dept_id), 1) AS pct_of_dept_payroll
FROM employees e
JOIN departments d ON d.dept_id = e.dept_id
WHERE e.status = 'Active'
ORDER BY d.dept_id, e.salary DESC, e.emp_id;

-- ---------------------------------------------------------------------
-- উদাহরণ 2 — Ties থাকলে Ranking
-- Topic: ROW_NUMBER, RANK, DENSE_RANK | Difficulty: Easy
-- ---------------------------------------------------------------------
SELECT
    d.dept_name,
    e.emp_name,
    e.salary,
    ROW_NUMBER() OVER (PARTITION BY e.dept_id ORDER BY e.salary DESC, e.emp_id) AS row_num,
    RANK()       OVER w AS rank_no,
    DENSE_RANK() OVER w AS dense_rank_no
FROM employees e
JOIN departments d ON d.dept_id = e.dept_id
WHERE e.dept_id IN (1, 3)
WINDOW w AS (PARTITION BY e.dept_id ORDER BY e.salary DESC)
ORDER BY d.dept_id, row_num;

-- ---------------------------------------------------------------------
-- উদাহরণ 3 — Customer Segmentation (Quartile)
-- Topic: NTILE | Difficulty: Medium
-- ---------------------------------------------------------------------
WITH spend AS (
    SELECT c.customer_id, c.customer_name,
           COUNT(*)            AS orders,
           SUM(s.total_amount) AS total_spent
    FROM sales s
    JOIN customers c ON c.customer_id = s.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    orders,
    total_spent,
    NTILE(4) OVER (ORDER BY total_spent DESC, customer_id) AS quartile,
    CASE NTILE(4) OVER (ORDER BY total_spent DESC, customer_id)
        WHEN 1 THEN 'Platinum' WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'   ELSE 'Bronze'
    END AS tier
FROM spend
ORDER BY total_spent DESC, customer_id;

-- ---------------------------------------------------------------------
-- উদাহরণ 4 — মাসিক Running Total (YTD)
-- Topic: SUM, COUNT, AVG OVER, Running Total | Difficulty: Medium
-- ---------------------------------------------------------------------
WITH m AS (
    SELECT DATE_FORMAT(sale_date, '%Y-%m') AS month,
           SUM(total_amount) AS monthly_sales,
           COUNT(*)          AS orders
    FROM sales
    WHERE sale_date BETWEEN '2025-01-01' AND '2025-12-31'
    GROUP BY DATE_FORMAT(sale_date, '%Y-%m')
)
SELECT
    month,
    monthly_sales,
    orders,
    SUM(monthly_sales) OVER w AS ytd_sales,
    SUM(orders)        OVER w AS ytd_orders,
    ROUND(SUM(monthly_sales) OVER w / SUM(orders) OVER w, 2) AS ytd_avg_order_value
FROM m
WINDOW w AS (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
ORDER BY month;

-- ---------------------------------------------------------------------
-- উদাহরণ 5 — একই দিনে একাধিক বিক্রি: ROWS বনাম RANGE
-- Topic: ROWS, RANGE, Window Frame | Difficulty: Medium
-- ---------------------------------------------------------------------
SELECT
    sale_id,
    sale_date,
    total_amount,
    SUM(total_amount) OVER (ORDER BY sale_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS rows_running,
    SUM(total_amount) OVER (ORDER BY sale_date
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS range_running,
    SUM(total_amount) OVER (ORDER BY sale_date
        RANGE BETWEEN INTERVAL 2 DAY PRECEDING AND CURRENT ROW) AS last_3_days_sales
FROM sales
WHERE sale_date BETWEEN '2025-03-01' AND '2025-03-31'
ORDER BY sale_date, sale_id;

-- ---------------------------------------------------------------------
-- উদাহরণ 6 — Electronics-এর ৩-মাসের Moving Average ও Rolling Sum
-- Topic: Moving Average, Rolling Sum | Difficulty: Medium
-- ---------------------------------------------------------------------
WITH e AS (
    SELECT
        sales_month,
        revenue,
        AVG(revenue) OVER w AS ma3,
        SUM(revenue) OVER w AS rs3
    FROM monthly_sales
    WHERE category = 'Electronics'
    WINDOW w AS (ORDER BY sales_month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m')         AS month,
    revenue,
    ROUND(ma3, 0)                             AS moving_avg_3m,
    rs3                                       AS rolling_sum_3m,
    ROUND(100 * (revenue - ma3) / ma3, 1)     AS vs_moving_avg_pct
FROM e
WHERE YEAR(sales_month) = 2025
ORDER BY sales_month;

-- ---------------------------------------------------------------------
-- উদাহরণ 7 — Furniture-এর MoM: LAG-এর ফাঁদ
-- Topic: LAG, LEAD, Month-over-Month | Difficulty: Medium
-- ---------------------------------------------------------------------
SELECT
    DATE_FORMAT(sales_month, '%Y-%m')                     AS month,
    revenue,
    DATE_FORMAT(LAG(sales_month) OVER w, '%Y-%m')         AS lag_row_month,
    ROUND(100 * (revenue - LAG(revenue) OVER w) / LAG(revenue) OVER w, 2) AS naive_mom_pct,
    CASE WHEN LAG(sales_month) OVER w = sales_month - INTERVAL 1 MONTH
         THEN ROUND(100 * (revenue - LAG(revenue) OVER w) / LAG(revenue) OVER w, 2)
    END                                                   AS verified_mom_pct,
    LEAD(revenue) OVER w                                  AS next_month_revenue
FROM monthly_sales
WHERE category = 'Furniture'
  AND sales_month BETWEEN '2024-01-01' AND '2024-12-01'
WINDOW w AS (ORDER BY sales_month)
ORDER BY sales_month;

-- ---------------------------------------------------------------------
-- উদাহরণ 8 — Year-over-Year Growth
-- Topic: LAG + PARTITION BY, YoY | Difficulty: Medium
-- ---------------------------------------------------------------------
WITH m AS (
    SELECT sales_month,
           SUM(revenue) AS revenue,
           COUNT(*)     AS categories
    FROM monthly_sales
    GROUP BY sales_month
),
y AS (
    SELECT
        sales_month,
        revenue,
        LAG(revenue)    OVER (PARTITION BY MONTH(sales_month) ORDER BY YEAR(sales_month)) AS revenue_ly,
        LAG(categories) OVER (PARTITION BY MONTH(sales_month) ORDER BY YEAR(sales_month)) AS categories_ly
    FROM m
)
SELECT
    DATE_FORMAT(sales_month, '%Y-%m')                 AS month,
    revenue                                           AS revenue_2025,
    revenue_ly                                        AS revenue_2024,
    ROUND(100 * (revenue - revenue_ly) / revenue_ly, 2) AS yoy_growth_pct,
    categories_ly                                     AS categories_last_year
FROM y
WHERE YEAR(sales_month) = 2025
ORDER BY sales_month;

-- ---------------------------------------------------------------------
-- উদাহরণ 9 — Category-র সবচেয়ে দামি, সস্তা ও দ্বিতীয় দামি পণ্য
-- Topic: FIRST_VALUE, LAST_VALUE, NTH_VALUE | Difficulty: Medium
-- ---------------------------------------------------------------------
SELECT
    category,
    product_name,
    unit_price,
    FIRST_VALUE(product_name) OVER w        AS most_expensive,
    LAST_VALUE(product_name)  OVER w        AS cheapest,
    NTH_VALUE(unit_price, 2)  OVER w        AS second_position_price
FROM products
WHERE is_active = 1
WINDOW w AS (
    PARTITION BY category
    ORDER BY unit_price DESC, product_id
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY category, unit_price DESC, product_id;

-- ---------------------------------------------------------------------
-- উদাহরণ 10 — প্রতিটি Category-র Top 2 Product (2025)
-- Topic: Top N per Group | Difficulty: Medium
-- ---------------------------------------------------------------------
WITH pr AS (
    SELECT p.category, p.product_name,
           SUM(s.quantity)     AS units_sold,
           SUM(s.total_amount) AS revenue
    FROM sales s
    JOIN products p ON p.product_id = s.product_id
    WHERE s.sale_date BETWEEN '2025-01-01' AND '2025-06-30'
    GROUP BY p.category, p.product_id, p.product_name
),
ranked AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY category ORDER BY revenue DESC)        AS product_rank,
        ROUND(100 * revenue / SUM(revenue) OVER (PARTITION BY category), 1)   AS pct_of_category
    FROM pr
)
SELECT category, product_rank, product_name, units_sold, revenue, pct_of_category
FROM ranked
WHERE product_rank <= 2
ORDER BY category, product_rank, product_name;

-- ---------------------------------------------------------------------
-- উদাহরণ 11 — Duplicate Sale খুঁজে বের করা
-- Topic: Duplicate Detection (ROW_NUMBER + COUNT OVER) | Difficulty: Medium
-- ---------------------------------------------------------------------
WITH d AS (
    SELECT
        sale_id, sale_date, customer_id, product_id, total_amount,
        ROW_NUMBER() OVER g AS copy_no,
        COUNT(*)     OVER (PARTITION BY sale_date, customer_id, product_id, emp_id,
                                        quantity, unit_price, discount_pct, payment_method) AS copies
    FROM sales
    WINDOW g AS (PARTITION BY sale_date, customer_id, product_id, emp_id,
                              quantity, unit_price, discount_pct, payment_method
                 ORDER BY sale_id)
)
SELECT *,
       CASE WHEN copy_no = 1 THEN 'Keep' ELSE 'Delete' END AS action
FROM d
WHERE copies > 1
ORDER BY sale_date, copy_no;

-- ---------------------------------------------------------------------
-- উদাহরণ 12 — কর্মীদের সবচেয়ে লম্বা টানা উপস্থিতি (Attendance Streak)
-- Topic: Gaps & Islands, Consecutive Days | Difficulty: Hard
-- ---------------------------------------------------------------------
WITH worked AS (
    SELECT emp_id, attendance_date,
           DATE_SUB(attendance_date,
                    INTERVAL ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY attendance_date) DAY) AS grp
    FROM employee_attendances
    WHERE status IN ('Present', 'Late')
),
streaks AS (
    SELECT emp_id,
           MIN(attendance_date) AS streak_start,
           MAX(attendance_date) AS streak_end,
           COUNT(*)             AS days
    FROM worked
    GROUP BY emp_id, grp
),
ranked AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY emp_id ORDER BY days DESC, streak_start) AS rn,
           COUNT(*)     OVER (PARTITION BY emp_id)                                 AS total_streaks
    FROM streaks
)
SELECT e.emp_name, r.streak_start, r.streak_end,
       r.days AS longest_streak_days, r.total_streaks
FROM ranked r
JOIN employees e ON e.emp_id = r.emp_id
WHERE r.rn = 1
ORDER BY longest_streak_days DESC, e.emp_name;

-- ---------------------------------------------------------------------
-- উদাহরণ 13 — টানা কয়েক দিন কেনাকাটা করা Customer
-- Topic: Consecutive Days, Gaps & Islands | Difficulty: Hard
-- ---------------------------------------------------------------------
WITH daily AS (
    SELECT customer_id, sale_date,
           COUNT(*)          AS purchases,
           SUM(total_amount) AS amount
    FROM sales
    GROUP BY customer_id, sale_date
),
g AS (
    SELECT *,
           DATE_SUB(sale_date,
                    INTERVAL ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY sale_date) DAY) AS grp
    FROM daily
)
SELECT
    c.customer_name,
    MIN(g.sale_date)  AS streak_start,
    MAX(g.sale_date)  AS streak_end,
    COUNT(*)          AS consecutive_days,
    SUM(g.purchases)  AS purchases,
    SUM(g.amount)     AS streak_amount
FROM g
JOIN customers c ON c.customer_id = g.customer_id
GROUP BY g.customer_id, c.customer_name, g.grp
HAVING COUNT(*) >= 2
ORDER BY consecutive_days DESC, streak_start;

-- ---------------------------------------------------------------------
-- উদাহরণ 14 — Customer Wallet-এর Running Balance
-- Topic: Running Balance, ROWS বনাম RANGE | Difficulty: Medium
-- ---------------------------------------------------------------------
WITH t AS (
    SELECT customer_id, txn_id, txn_datetime, txn_type,
           CASE WHEN txn_type IN ('Deposit', 'Refund') THEN amount ELSE -amount END AS signed_amount
    FROM customer_transactions
)
SELECT
    customer_id, txn_id, txn_datetime, txn_type, signed_amount,
    SUM(signed_amount) OVER (PARTITION BY customer_id ORDER BY txn_datetime, txn_id
                             ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS balance_rows,
    SUM(signed_amount) OVER (PARTITION BY customer_id ORDER BY txn_datetime)  AS balance_range,
    CASE WHEN SUM(signed_amount) OVER (PARTITION BY customer_id ORDER BY txn_datetime, txn_id
                                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) < 0
         THEN 'OVERDRAWN' ELSE 'OK' END                                       AS status
FROM t
ORDER BY customer_id, txn_datetime, txn_id;

-- ---------------------------------------------------------------------
-- উদাহরণ 15 — বিভাগভিত্তিক Median বেতন
-- Topic: Median Calculation | Difficulty: Hard
-- ---------------------------------------------------------------------
WITH r AS (
    SELECT
        e.dept_id, e.salary,
        ROW_NUMBER() OVER (PARTITION BY e.dept_id ORDER BY e.salary) AS rn,
        COUNT(*)     OVER (PARTITION BY e.dept_id)                   AS cnt,
        AVG(e.salary) OVER (PARTITION BY e.dept_id)                  AS avg_sal
    FROM employees e
    WHERE e.status = 'Active'
)
SELECT
    d.dept_name,
    MAX(r.cnt)                            AS employees,
    ROUND(MAX(r.avg_sal), 0)              AS avg_salary,
    ROUND(AVG(r.salary), 0)               AS median_salary,
    ROUND(MAX(r.avg_sal) - AVG(r.salary), 0) AS avg_minus_median
FROM r
JOIN departments d ON d.dept_id = r.dept_id
WHERE r.rn IN (FLOOR((r.cnt + 1) / 2), CEIL((r.cnt + 1) / 2))
GROUP BY d.dept_id, d.dept_name
ORDER BY d.dept_id;

-- ---------------------------------------------------------------------
-- উদাহরণ 16 — মাসিক Customer Retention
-- Topic: Customer Retention (LAG, ROW_NUMBER) | Difficulty: Hard
-- ---------------------------------------------------------------------
WITH cm AS (
    SELECT DISTINCT customer_id,
           CAST(DATE_FORMAT(sale_date, '%Y-%m-01') AS DATE) AS month_start
    FROM sales
),
flags AS (
    SELECT customer_id, month_start,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY month_start) AS nth_active_month,
           LAG(month_start) OVER (PARTITION BY customer_id ORDER BY month_start) AS prev_active_month
    FROM cm
),
monthly AS (
    SELECT month_start,
           COUNT(*)                                                       AS active_customers,
           SUM(nth_active_month = 1)                                      AS new_customers,
           SUM(COALESCE(prev_active_month = month_start - INTERVAL 1 MONTH, 0)) AS retained_customers
    FROM flags
    GROUP BY month_start
),
final AS (
    SELECT *,
           LAG(active_customers) OVER (ORDER BY month_start) AS prev_month_active
    FROM monthly
)
SELECT
    DATE_FORMAT(month_start, '%Y-%m') AS month,
    active_customers,
    new_customers,
    retained_customers,
    prev_month_active,
    ROUND(100 * retained_customers / prev_month_active, 1) AS retention_pct
FROM final
WHERE month_start >= '2025-01-01'
ORDER BY month_start;

-- ---------------------------------------------------------------------
-- উদাহরণ 17 — Salesperson Performance Scorecard
-- Topic: Employee Performance Analysis | Difficulty: Hard
-- ---------------------------------------------------------------------
WITH s AS (
    SELECT emp_id,
           COUNT(CASE WHEN sale_date BETWEEN '2025-01-01' AND '2025-06-30' THEN 1 END)          AS orders_h1_2025,
           SUM(CASE WHEN sale_date BETWEEN '2025-01-01' AND '2025-06-30' THEN total_amount END) AS sales_h1_2025,
           SUM(CASE WHEN sale_date BETWEEN '2024-07-01' AND '2024-12-31' THEN total_amount END) AS sales_h2_2024
    FROM sales
    GROUP BY emp_id
),
a AS (
    SELECT emp_id,
           ROUND(100 * SUM(status IN ('Present', 'Late')) / COUNT(*), 1) AS attendance_pct,
           SUM(status = 'Late')                                          AS late_days
    FROM employee_attendances
    GROUP BY emp_id
)
SELECT
    e.emp_name,
    s.orders_h1_2025,
    s.sales_h1_2025,
    RANK() OVER (ORDER BY s.sales_h1_2025 DESC)                          AS sales_rank,
    ROUND(100 * s.sales_h1_2025 / SUM(s.sales_h1_2025) OVER (), 1)       AS share_pct,
    s.sales_h2_2024,
    ROUND(100 * (s.sales_h1_2025 - s.sales_h2_2024) / s.sales_h2_2024, 1) AS growth_pct,
    a.attendance_pct,
    a.late_days,
    CASE NTILE(3) OVER (ORDER BY s.sales_h1_2025 DESC)
        WHEN 1 THEN 'Star' WHEN 2 THEN 'Solid' ELSE 'Needs Coaching'
    END                                                                   AS band
FROM s
JOIN employees e ON e.emp_id = s.emp_id
LEFT JOIN a      ON a.emp_id = s.emp_id
ORDER BY sales_rank;
