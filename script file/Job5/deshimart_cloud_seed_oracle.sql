-- =====================================================================
-- DeshiMart assessment database - CLOUD SEED (Job 5) (Set A)
-- Target DBMS : Oracle Database
-- Purpose     : Loads the DeshiMart data for Job 5 (without the large order_history table).
-- Run as      : the application schema owner (see the specification sheet).
-- Data is identical for every DBMS so the assessor's answer key applies.
-- =====================================================================
SET DEFINE OFF
SET FEEDBACK OFF
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

CREATE TABLE branches (
  branch_id    NUMBER(10) PRIMARY KEY,
  branch_name  VARCHAR2(40) NOT NULL UNIQUE,
  area         VARCHAR2(40) NOT NULL
);

CREATE TABLE categories (
  category_id        NUMBER(10) PRIMARY KEY,
  category_name      VARCHAR2(40) NOT NULL,
  parent_category_id NUMBER(10) NULL,
  CONSTRAINT fk_cat_parent FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);

CREATE TABLE products (
  product_id    NUMBER(10) PRIMARY KEY,
  product_code  VARCHAR2(12) NOT NULL UNIQUE,
  product_name  VARCHAR2(60) NOT NULL,
  category_id   NUMBER(10) NOT NULL,
  unit_price    NUMBER(10,2) NOT NULL,
  is_active     CHAR(1) DEFAULT 'Y' NOT NULL,
  CONSTRAINT fk_prod_cat FOREIGN KEY (category_id) REFERENCES categories(category_id),
  CONSTRAINT ck_prod_price CHECK (unit_price > 0),
  CONSTRAINT ck_prod_active CHECK (is_active IN ('Y','N'))
);

CREATE TABLE stock (
  stock_id     NUMBER(10) PRIMARY KEY,
  product_id   NUMBER(10) NOT NULL,
  branch_id    NUMBER(10) NOT NULL,
  qty_on_hand  NUMBER(10) DEFAULT 0 NOT NULL,
  CONSTRAINT fk_stock_prod FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT fk_stock_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  CONSTRAINT uq_stock UNIQUE (product_id, branch_id),
  CONSTRAINT ck_stock_qty CHECK (qty_on_hand >= 0)
);

CREATE TABLE customers (
  customer_id  NUMBER(10) PRIMARY KEY,
  full_name    VARCHAR2(80) NOT NULL,
  phone        VARCHAR2(15) NOT NULL UNIQUE,
  email        VARCHAR2(80) NULL,
  area         VARCHAR2(40) NOT NULL,
  joined_on    DATE NOT NULL
);

CREATE TABLE staff (
  staff_id       NUMBER(10) PRIMARY KEY,
  staff_name     VARCHAR2(60) NOT NULL,
  job_role       VARCHAR2(30) NOT NULL,
  branch_id      NUMBER(10) NOT NULL,
  supervisor_id  NUMBER(10) NULL,
  CONSTRAINT fk_staff_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  CONSTRAINT fk_staff_sup FOREIGN KEY (supervisor_id) REFERENCES staff(staff_id)
);

CREATE TABLE orders (
  order_id      NUMBER(10) PRIMARY KEY,
  customer_id   NUMBER(10) NULL,
  branch_id     NUMBER(10) NOT NULL,
  staff_id      NUMBER(10) NOT NULL,
  order_date    DATE NOT NULL,
  channel       VARCHAR2(10) NOT NULL,
  status        VARCHAR2(10) NOT NULL,
  delivery_fee  NUMBER(8,2) DEFAULT 0 NOT NULL,
  CONSTRAINT fk_ord_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  CONSTRAINT fk_ord_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
  CONSTRAINT fk_ord_staff FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
  CONSTRAINT ck_ord_channel CHECK (channel IN ('ONLINE','COUNTER')),
  CONSTRAINT ck_ord_status CHECK (status IN ('PENDING','DELIVERED','CANCELLED')),
  CONSTRAINT ck_ord_fee CHECK (delivery_fee >= 0)
);

CREATE TABLE order_items (
  order_id    NUMBER(10) NOT NULL,
  line_no     NUMBER(10) NOT NULL,
  product_id  NUMBER(10) NOT NULL,
  qty         NUMBER(10) NOT NULL,
  unit_price  NUMBER(10,2) NOT NULL,
  CONSTRAINT pk_order_items PRIMARY KEY (order_id, line_no),
  CONSTRAINT fk_oi_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT fk_oi_prod FOREIGN KEY (product_id) REFERENCES products(product_id),
  CONSTRAINT ck_oi_qty CHECK (qty > 0)
);

CREATE TABLE payments (
  payment_id  NUMBER(10) PRIMARY KEY,
  order_id    NUMBER(10) NOT NULL,
  method      VARCHAR2(10) NOT NULL,
  amount      NUMBER(10,2) NOT NULL,
  paid_at     TIMESTAMP NOT NULL,
  CONSTRAINT fk_pay_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  CONSTRAINT ck_pay_method CHECK (method IN ('COD','BKASH','CARD')),
  CONSTRAINT ck_pay_amount CHECK (amount > 0)
);

INSERT INTO branches (branch_id, branch_name, area) VALUES (1, 'Dhanmondi', 'Dhanmondi');
INSERT INTO branches (branch_id, branch_name, area) VALUES (2, 'Uttara', 'Uttara');
INSERT INTO branches (branch_id, branch_name, area) VALUES (3, 'Mirpur', 'Mirpur');
INSERT INTO branches (branch_id, branch_name, area) VALUES (4, 'Gulshan', 'Gulshan');

INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (1, 'Grocery', NULL);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (2, 'Rice and Staples', 1);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (3, 'Oil and Spices', 1);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (4, 'Fresh Produce', 1);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (5, 'Beverages', 1);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (6, 'Snacks', 1);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (7, 'Household', NULL);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (8, 'Cleaning', 7);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (9, 'Personal Care', 7);
INSERT INTO categories (category_id, category_name, parent_category_id) VALUES (10, 'Baby Care', 7);

INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (1, 'GR-RIC-001', 'Miniket Rice 5 kg', 2, 420.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (2, 'GR-RIC-002', 'Chinigura Rice 2 kg', 2, 290.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (3, 'GR-RIC-003', 'Red Lentils 1 kg', 2, 135.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (4, 'GR-RIC-004', 'Atta 2 kg', 2, 130.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (5, 'GR-OIL-001', 'Soybean Oil 5 L', 3, 845.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (6, 'GR-OIL-002', 'Mustard Oil 1 L', 3, 285.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (7, 'GR-OIL-003', 'Turmeric Powder 200 g', 3, 95.00, 'N');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (8, 'GR-OIL-004', 'Chilli Powder 200 g', 3, 110.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (9, 'GR-OIL-005', 'Iodised Salt 1 kg', 3, 42.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (10, 'GR-FRS-001', 'Potato 1 kg', 4, 55.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (11, 'GR-FRS-002', 'Onion 1 kg', 4, 90.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (12, 'GR-FRS-003', 'Farm Eggs (12)', 4, 150.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (13, 'GR-FRS-004', 'Broiler Chicken 1 kg', 4, 210.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (14, 'GR-BEV-001', 'Black Tea 400 g', 5, 240.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (15, 'GR-BEV-002', 'Mango Juice 1 L', 5, 120.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (16, 'GR-BEV-003', 'Mineral Water 1.5 L', 5, 30.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (17, 'GR-SNK-001', 'Chanachur 350 g', 6, 80.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (18, 'GR-SNK-002', 'Cream Biscuits 300 g', 6, 65.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (19, 'HH-CLN-001', 'Dishwashing Liquid 500 ml', 8, 145.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (20, 'HH-CLN-002', 'Laundry Detergent 1 kg', 8, 185.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (21, 'HH-PC-001', 'Bath Soap 125 g', 9, 55.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (22, 'HH-PC-002', 'Toothpaste 200 g', 9, 160.00, 'N');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (23, 'HH-BBY-001', 'Baby Diapers M (40)', 10, 1150.00, 'Y');
INSERT INTO products (product_id, product_code, product_name, category_id, unit_price, is_active) VALUES (24, 'HH-BBY-002', 'Baby Wipes (80)', 10, 220.00, 'Y');

INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (1, 1, 1, 21);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (2, 2, 1, 46);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (3, 3, 1, 70);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (4, 4, 1, 71);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (5, 5, 1, 88);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (6, 6, 1, 19);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (7, 7, 1, 34);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (8, 8, 1, 82);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (9, 9, 1, 85);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (10, 10, 1, 77);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (11, 11, 1, 59);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (12, 12, 1, 79);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (13, 13, 1, 76);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (14, 14, 1, 68);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (15, 15, 1, 81);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (16, 16, 1, 62);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (17, 17, 1, 36);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (18, 18, 1, 6);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (19, 19, 1, 84);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (20, 20, 1, 16);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (21, 21, 1, 20);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (22, 22, 1, 42);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (23, 23, 1, 18);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (24, 24, 1, 63);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (25, 1, 2, 7);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (26, 2, 2, 68);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (27, 3, 2, 46);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (28, 4, 2, 32);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (29, 5, 2, 56);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (30, 6, 2, 38);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (31, 7, 2, 50);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (32, 8, 2, 51);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (33, 9, 2, 54);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (34, 10, 2, 71);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (35, 11, 2, 87);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (36, 12, 2, 0);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (37, 13, 2, 49);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (38, 14, 2, 17);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (39, 15, 2, 77);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (40, 16, 2, 74);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (41, 17, 2, 43);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (42, 18, 2, 42);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (43, 19, 2, 64);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (44, 20, 2, 24);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (45, 21, 2, 88);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (46, 22, 2, 79);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (47, 23, 2, 45);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (48, 24, 2, 9);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (49, 1, 3, 12);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (50, 2, 3, 52);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (51, 3, 3, 65);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (52, 4, 3, 60);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (53, 5, 3, 17);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (54, 6, 3, 57);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (55, 7, 3, 80);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (56, 8, 3, 76);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (57, 9, 3, 69);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (58, 10, 3, 20);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (59, 11, 3, 60);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (60, 12, 3, 70);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (61, 13, 3, 82);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (62, 14, 3, 20);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (63, 15, 3, 56);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (64, 16, 3, 73);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (65, 17, 3, 39);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (66, 18, 3, 59);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (67, 19, 3, 78);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (68, 20, 3, 67);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (69, 21, 3, 71);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (70, 22, 3, 72);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (71, 23, 3, 9);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (72, 24, 3, 79);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (73, 1, 4, 34);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (74, 2, 4, 22);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (75, 3, 4, 12);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (76, 4, 4, 72);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (77, 5, 4, 9);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (78, 6, 4, 85);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (79, 7, 4, 60);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (80, 8, 4, 66);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (81, 9, 4, 24);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (82, 10, 4, 67);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (83, 11, 4, 35);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (84, 12, 4, 21);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (85, 13, 4, 86);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (86, 14, 4, 64);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (87, 15, 4, 66);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (88, 16, 4, 40);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (89, 17, 4, 38);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (90, 18, 4, 77);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (91, 19, 4, 57);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (92, 20, 4, 45);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (93, 21, 4, 76);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (94, 22, 4, 88);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (95, 23, 4, 70);
INSERT INTO stock (stock_id, product_id, branch_id, qty_on_hand) VALUES (96, 24, 4, 67);

INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (1, 'Nusrat Jahan', '01966344002', 'nusrat.jahan@outlook.com', 'Dhanmondi', DATE '2026-05-08');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (2, 'Tanvir Ahmed', '01687534778', 'tanvir.ahmed@yahoo.com', 'Uttara', DATE '2025-06-08');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (3, 'Farhana Islam', '01704571784', NULL, 'Mirpur', DATE '2025-07-16');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (4, 'Rakib Hossain', '01467147513', 'rakib.hossain@outlook.com', 'Gulshan', DATE '2025-04-22');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (5, 'Sadia Rahman', '01470107981', 'sadia.rahman@outlook.com', 'Mohammadpur', DATE '2024-02-12');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (6, 'Imran Kabir', '01419084520', 'imran.kabir@yahoo.com', 'Banani', DATE '2026-04-09');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (7, 'Mitu Akter', '01772837929', NULL, 'Dhanmondi', DATE '2025-10-30');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (8, 'Arif Chowdhury', '01516229486', 'arif.chowdhury@yahoo.com', 'Uttara', DATE '2023-11-01');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (9, 'Jannat Ferdous', '01736016105', 'jannat.ferdous@outlook.com', 'Mirpur', DATE '2024-12-24');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (10, 'Shakil Mia', '01900875475', 'shakil.mia@gmail.com', 'Gulshan', DATE '2025-10-16');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (11, 'Tahmina Begum', '01699229836', NULL, 'Mohammadpur', DATE '2024-11-19');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (12, 'Rashed Karim', '01693186032', 'rashed.karim@gmail.com', 'Banani', DATE '2026-01-20');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (13, 'Sumaiya Sultana', '01907370283', 'sumaiya.sultana@outlook.com', 'Dhanmondi', DATE '2023-10-10');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (14, 'Habib Uddin', '01426468616', 'habib.uddin@yahoo.com', 'Uttara', DATE '2024-01-19');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (15, 'Lamia Haque', '01524776472', NULL, 'Mirpur', DATE '2024-10-29');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (16, 'Mahfuz Alam', '01777188413', 'mahfuz.alam@gmail.com', 'Gulshan', DATE '2023-01-11');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (17, 'Rumana Khatun', '01375682052', 'rumana.khatun@yahoo.com', 'Mohammadpur', DATE '2026-02-24');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (18, 'Sabbir Sarkar', '01898319489', 'sabbir.sarkar@outlook.com', 'Banani', DATE '2024-03-15');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (19, 'Nadia Parvin', '01749482141', NULL, 'Dhanmondi', DATE '2025-06-12');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (20, 'Kamal Biswas', '01410521854', 'kamal.biswas@outlook.com', 'Uttara', DATE '2023-05-11');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (21, 'Afsana Mim', '01552441064', 'afsana.mim@yahoo.com', 'Mirpur', DATE '2023-02-01');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (22, 'Zahid Hasan', '01313041189', 'zahid.hasan@yahoo.com', 'Gulshan', DATE '2024-10-07');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (23, 'Priya Das', '01979906593', NULL, 'Mohammadpur', DATE '2026-05-01');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (24, 'Ovi Roy', '01661584645', 'ovi.roy@gmail.com', 'Banani', DATE '2025-06-13');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (25, 'Shirin Nahar', '01345414659', 'shirin.nahar@gmail.com', 'Dhanmondi', DATE '2026-01-15');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (26, 'Fahim Talukder', '01538012911', 'fahim.talukder@gmail.com', 'Uttara', DATE '2023-09-15');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (27, 'Tania Yasmin', '01759406925', NULL, 'Mirpur', DATE '2025-04-30');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (28, 'Riyad Molla', '01663632280', 'riyad.molla@outlook.com', 'Gulshan', DATE '2026-01-13');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (29, 'Munni Bari', '01886423004', 'munni.bari@outlook.com', 'Mohammadpur', DATE '2025-09-07');
INSERT INTO customers (customer_id, full_name, phone, email, area, joined_on) VALUES (30, 'Asif Iqbal', '01645291280', 'asif.iqbal@outlook.com', 'Banani', DATE '2025-11-18');

INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (1, 'Mahmudul Hasan', 'Branch Manager', 1, NULL);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (2, 'Shathi Akter', 'Branch Manager', 2, NULL);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (3, 'Rezaul Karim', 'Branch Manager', 3, NULL);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (4, 'Nasrin Sultana', 'Branch Manager', 4, NULL);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (5, 'Jubayer Ahmed', 'Sales Associate', 1, 1);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (6, 'Pinky Das', 'Sales Associate', 2, 2);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (7, 'Arman Hossain', 'Sales Associate', 3, 3);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (8, 'Lima Khatun', 'Sales Associate', 4, 4);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (9, 'Sohel Rana', 'Delivery Lead', 3, 3);
INSERT INTO staff (staff_id, staff_name, job_role, branch_id, supervisor_id) VALUES (10, 'Ayesha Siddika', 'Sales Associate', 1, 1);

INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1001, 24, 2, 2, DATE '2026-03-10', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1002, 26, 2, 2, DATE '2026-04-03', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1003, 3, 3, 3, DATE '2026-04-16', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1004, 17, 4, 4, DATE '2026-01-13', 'ONLINE', 'PENDING', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1005, 24, 2, 2, DATE '2026-03-28', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1006, 25, 4, 4, DATE '2026-05-04', 'ONLINE', 'CANCELLED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1007, 29, 4, 8, DATE '2026-01-09', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1008, 4, 1, 5, DATE '2026-02-03', 'ONLINE', 'PENDING', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1009, 27, 1, 10, DATE '2026-05-09', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1010, 6, 4, 4, DATE '2026-06-19', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1011, 11, 1, 5, DATE '2026-04-22', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1012, 13, 1, 10, DATE '2026-03-11', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1013, NULL, 2, 6, DATE '2026-03-11', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1014, 20, 3, 9, DATE '2026-02-24', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1015, 3, 3, 3, DATE '2026-06-06', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1016, 30, 3, 7, DATE '2026-05-22', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1017, 27, 2, 6, DATE '2026-01-07', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1018, 25, 3, 9, DATE '2026-06-16', 'ONLINE', 'PENDING', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1019, 6, 2, 6, DATE '2026-05-07', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1020, 16, 3, 9, DATE '2026-02-25', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1021, 2, 1, 1, DATE '2026-05-28', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1022, 16, 1, 5, DATE '2026-06-25', 'ONLINE', 'CANCELLED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1023, NULL, 3, 3, DATE '2026-06-25', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1024, 8, 1, 1, DATE '2026-04-22', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1025, 16, 4, 4, DATE '2026-04-24', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1026, 29, 1, 1, DATE '2026-02-15', 'ONLINE', 'CANCELLED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1027, 29, 1, 5, DATE '2026-04-13', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1028, 9, 3, 7, DATE '2026-06-29', 'ONLINE', 'CANCELLED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1029, 15, 1, 10, DATE '2026-06-02', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1030, 3, 4, 8, DATE '2026-01-06', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1031, 14, 2, 2, DATE '2026-03-04', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1032, 11, 3, 7, DATE '2026-05-01', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1033, 15, 3, 3, DATE '2026-02-26', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1034, 23, 3, 9, DATE '2026-02-26', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1035, 10, 3, 7, DATE '2026-06-17', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1036, 19, 1, 1, DATE '2026-05-21', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1037, 6, 2, 2, DATE '2026-04-17', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1038, 19, 1, 1, DATE '2026-01-25', 'COUNTER', 'PENDING', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1039, 21, 3, 9, DATE '2026-01-02', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1040, 6, 2, 2, DATE '2026-06-23', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1041, 3, 4, 4, DATE '2026-05-10', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1042, 9, 3, 9, DATE '2026-04-25', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1043, 23, 1, 5, DATE '2026-05-22', 'COUNTER', 'CANCELLED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1044, NULL, 1, 1, DATE '2026-01-27', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1045, 28, 3, 7, DATE '2026-06-10', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1046, 17, 4, 8, DATE '2026-05-18', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1047, 16, 1, 1, DATE '2026-01-29', 'COUNTER', 'CANCELLED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1048, 21, 1, 5, DATE '2026-04-13', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1049, NULL, 3, 9, DATE '2026-04-29', 'COUNTER', 'PENDING', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1050, 4, 2, 2, DATE '2026-04-25', 'ONLINE', 'CANCELLED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1051, 15, 4, 4, DATE '2026-04-20', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1052, 12, 2, 2, DATE '2026-05-21', 'ONLINE', 'CANCELLED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1053, 9, 4, 8, DATE '2026-04-17', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1054, 28, 2, 6, DATE '2026-05-16', 'ONLINE', 'PENDING', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1055, 1, 1, 10, DATE '2026-03-22', 'ONLINE', 'CANCELLED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1056, 4, 2, 6, DATE '2026-06-07', 'ONLINE', 'CANCELLED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1057, 1, 3, 3, DATE '2026-04-01', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1058, 30, 2, 2, DATE '2026-03-27', 'ONLINE', 'PENDING', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1059, 28, 1, 1, DATE '2026-02-16', 'ONLINE', 'CANCELLED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1060, 3, 4, 4, DATE '2026-01-29', 'COUNTER', 'CANCELLED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1061, 7, 3, 7, DATE '2026-05-24', 'ONLINE', 'CANCELLED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1062, 14, 1, 10, DATE '2026-01-14', 'ONLINE', 'PENDING', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1063, 15, 1, 1, DATE '2026-04-22', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1064, 9, 2, 6, DATE '2026-01-04', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1065, 22, 1, 10, DATE '2026-02-14', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1066, 30, 2, 6, DATE '2026-03-13', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1067, 29, 4, 4, DATE '2026-01-14', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1068, 14, 2, 2, DATE '2026-03-07', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1069, 17, 4, 4, DATE '2026-05-20', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1070, 13, 1, 1, DATE '2026-05-02', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1071, 16, 1, 10, DATE '2026-02-02', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1072, 12, 2, 6, DATE '2026-05-24', 'COUNTER', 'PENDING', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1073, 8, 1, 5, DATE '2026-03-11', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1074, 17, 3, 7, DATE '2026-01-19', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1075, 8, 3, 3, DATE '2026-03-26', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1076, 13, 1, 1, DATE '2026-05-22', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1077, NULL, 2, 2, DATE '2026-06-11', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1078, 7, 4, 8, DATE '2026-02-22', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1079, NULL, 1, 5, DATE '2026-01-03', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1080, 25, 2, 6, DATE '2026-01-03', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1081, 15, 3, 7, DATE '2026-02-09', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1082, 16, 2, 6, DATE '2026-02-21', 'ONLINE', 'DELIVERED', 40.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1083, 30, 4, 8, DATE '2026-01-29', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1084, 17, 2, 6, DATE '2026-04-13', 'ONLINE', 'DELIVERED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1085, 14, 2, 2, DATE '2026-02-12', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1086, 5, 1, 10, DATE '2026-03-22', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1087, 18, 4, 4, DATE '2026-01-17', 'ONLINE', 'CANCELLED', 60.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1088, 13, 3, 9, DATE '2026-03-02', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1089, NULL, 2, 6, DATE '2026-06-01', 'COUNTER', 'DELIVERED', 0.00);
INSERT INTO orders (order_id, customer_id, branch_id, staff_id, order_date, channel, status, delivery_fee) VALUES (1090, 11, 1, 1, DATE '2026-02-27', 'COUNTER', 'PENDING', 0.00);

INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1001, 1, 2, 2, 290.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1001, 2, 8, 4, 110.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1001, 3, 22, 3, 160.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1001, 4, 17, 2, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1002, 1, 21, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1002, 2, 14, 4, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1003, 1, 1, 2, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1004, 1, 5, 4, 845.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1005, 1, 10, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1005, 2, 18, 4, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1005, 3, 12, 2, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1006, 1, 11, 2, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1006, 2, 18, 2, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1007, 1, 12, 3, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1008, 1, 20, 1, 185.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1008, 2, 10, 3, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1008, 3, 21, 4, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1009, 1, 3, 3, 135.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1009, 2, 16, 2, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1009, 3, 10, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1010, 1, 12, 4, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1010, 2, 14, 2, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1010, 3, 19, 2, 145.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1011, 1, 18, 3, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1011, 2, 21, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1012, 1, 11, 2, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1012, 2, 4, 4, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1012, 3, 22, 3, 160.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1012, 4, 16, 3, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1013, 1, 16, 2, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1013, 2, 11, 1, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1013, 3, 1, 3, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1013, 4, 2, 3, 290.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1014, 1, 18, 1, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1014, 2, 1, 2, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1015, 1, 9, 4, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1016, 1, 11, 3, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1016, 2, 20, 4, 185.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1016, 3, 16, 3, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1017, 1, 17, 3, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1017, 2, 24, 2, 220.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1017, 3, 13, 1, 210.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1018, 1, 17, 3, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1019, 1, 21, 1, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1019, 2, 4, 4, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1019, 3, 20, 2, 185.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1019, 4, 7, 2, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1020, 1, 12, 2, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1020, 2, 21, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1020, 3, 13, 2, 210.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1021, 1, 9, 3, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1021, 2, 18, 2, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1022, 1, 17, 1, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1022, 2, 12, 4, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1023, 1, 1, 3, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1023, 2, 2, 3, 290.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1023, 3, 4, 1, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1023, 4, 12, 2, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1024, 1, 6, 4, 285.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1024, 2, 18, 4, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1024, 3, 14, 3, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1025, 1, 3, 3, 135.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1026, 1, 21, 3, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1026, 2, 9, 3, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1027, 1, 4, 2, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1027, 2, 5, 3, 845.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1028, 1, 12, 3, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1028, 2, 18, 3, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1028, 3, 17, 1, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1028, 4, 4, 1, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1029, 1, 20, 2, 185.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1029, 2, 16, 3, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1029, 3, 18, 2, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1029, 4, 1, 1, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1030, 1, 10, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1030, 2, 16, 3, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1031, 1, 7, 4, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1031, 2, 4, 4, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1031, 3, 19, 1, 145.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1031, 4, 16, 4, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1032, 1, 12, 2, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1033, 1, 13, 1, 210.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1033, 2, 1, 3, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1033, 3, 8, 2, 110.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1033, 4, 7, 3, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1034, 1, 12, 4, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1035, 1, 1, 1, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1035, 2, 10, 4, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1036, 1, 8, 4, 110.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1036, 2, 18, 1, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1036, 3, 13, 2, 210.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1037, 1, 17, 4, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1037, 2, 11, 3, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1038, 1, 23, 2, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1038, 2, 5, 4, 845.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1038, 3, 22, 1, 160.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1038, 4, 11, 2, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1039, 1, 17, 1, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1039, 2, 12, 3, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1039, 3, 3, 2, 135.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1040, 1, 24, 4, 220.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1040, 2, 6, 1, 285.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1040, 3, 23, 2, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1041, 1, 9, 3, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1041, 2, 1, 2, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1041, 3, 15, 4, 120.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1041, 4, 20, 1, 185.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1042, 1, 9, 4, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1042, 2, 15, 4, 120.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1042, 3, 24, 3, 220.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1043, 1, 23, 3, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1043, 2, 22, 2, 160.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1044, 1, 18, 3, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1044, 2, 13, 3, 210.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1044, 3, 23, 4, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1045, 1, 21, 3, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1045, 2, 16, 1, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1045, 3, 22, 3, 160.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1045, 4, 2, 3, 290.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1046, 1, 17, 4, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1046, 2, 8, 4, 110.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1046, 3, 1, 3, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1046, 4, 14, 2, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1047, 1, 17, 1, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1047, 2, 7, 1, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1047, 3, 12, 1, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1047, 4, 1, 2, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1048, 1, 11, 1, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1048, 2, 10, 1, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1049, 1, 11, 1, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1049, 2, 20, 3, 185.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1049, 3, 6, 2, 285.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1049, 4, 4, 2, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1050, 1, 1, 4, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1051, 1, 14, 2, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1052, 1, 9, 2, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1052, 2, 14, 3, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1052, 3, 4, 1, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1053, 1, 24, 2, 220.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1053, 2, 20, 4, 185.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1054, 1, 12, 3, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1054, 2, 17, 3, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1055, 1, 24, 3, 220.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1055, 2, 21, 4, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1055, 3, 4, 4, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1056, 1, 19, 1, 145.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1056, 2, 13, 3, 210.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1056, 3, 12, 4, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1057, 1, 23, 3, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1058, 1, 7, 1, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1058, 2, 2, 2, 290.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1059, 1, 10, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1060, 1, 2, 1, 290.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1060, 2, 5, 3, 845.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1060, 3, 15, 4, 120.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1060, 4, 18, 3, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1061, 1, 9, 2, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1061, 2, 21, 4, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1062, 1, 1, 1, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1062, 2, 10, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1063, 1, 6, 1, 285.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1063, 2, 23, 1, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1063, 3, 10, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1064, 1, 3, 1, 135.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1064, 2, 10, 1, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1064, 3, 18, 2, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1065, 1, 12, 1, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1065, 2, 7, 2, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1065, 3, 6, 3, 285.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1065, 4, 16, 1, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1066, 1, 23, 1, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1066, 2, 4, 3, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1066, 3, 7, 4, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1066, 4, 10, 1, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1067, 1, 1, 3, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1068, 1, 22, 4, 160.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1068, 2, 19, 4, 145.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1068, 3, 23, 4, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1069, 1, 14, 4, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1070, 1, 4, 2, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1070, 2, 8, 2, 110.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1070, 3, 14, 3, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1071, 1, 7, 3, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1071, 2, 23, 2, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1072, 1, 11, 3, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1072, 2, 23, 1, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1072, 3, 8, 2, 110.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1073, 1, 15, 3, 120.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1073, 2, 2, 1, 290.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1073, 3, 9, 1, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1073, 4, 24, 3, 220.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1074, 1, 4, 3, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1075, 1, 6, 4, 285.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1075, 2, 19, 3, 145.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1075, 3, 9, 4, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1076, 1, 13, 1, 210.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1076, 2, 18, 1, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1076, 3, 23, 1, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1077, 1, 15, 1, 120.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1078, 1, 23, 4, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1078, 2, 17, 1, 80.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1078, 3, 4, 1, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1078, 4, 14, 3, 240.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1079, 1, 21, 2, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1080, 1, 4, 2, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1080, 2, 11, 1, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1080, 3, 12, 1, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1080, 4, 6, 2, 285.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1081, 1, 19, 2, 145.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1081, 2, 23, 2, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1082, 1, 12, 1, 150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1083, 1, 11, 3, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1083, 2, 9, 1, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1083, 3, 18, 4, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1084, 1, 9, 1, 42.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1084, 2, 18, 2, 65.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1085, 1, 19, 2, 145.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1085, 2, 1, 1, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1086, 1, 15, 1, 120.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1086, 2, 23, 3, 1150.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1087, 1, 4, 1, 130.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1087, 2, 11, 1, 90.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1087, 3, 15, 2, 120.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1088, 1, 24, 2, 220.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1088, 2, 7, 4, 95.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1088, 3, 21, 4, 55.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1088, 4, 16, 1, 30.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1089, 1, 2, 2, 290.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1089, 2, 15, 2, 120.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1089, 3, 1, 4, 420.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1089, 4, 6, 4, 285.00);
INSERT INTO order_items (order_id, line_no, product_id, qty, unit_price) VALUES (1090, 1, 7, 3, 95.00);

INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (1, 1001, 'COD', 1700.00, TIMESTAMP '2026-03-10 12:20:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (2, 1002, 'CARD', 1130.00, TIMESTAMP '2026-04-03 17:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (3, 1003, 'BKASH', 900.00, TIMESTAMP '2026-04-16 13:40:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (4, 1005, 'BKASH', 710.00, TIMESTAMP '2026-03-28 18:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (5, 1007, 'COD', 490.00, TIMESTAMP '2026-01-09 18:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (6, 1009, 'BKASH', 635.00, TIMESTAMP '2026-05-09 14:20:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (7, 1010, 'BKASH', 1430.00, TIMESTAMP '2026-06-19 20:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (8, 1011, 'COD', 365.00, TIMESTAMP '2026-04-22 21:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (9, 1012, 'COD', 1330.00, TIMESTAMP '2026-03-11 11:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (10, 1014, 'COD', 945.00, TIMESTAMP '2026-02-24 16:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (11, 1016, 'COD', 1160.00, TIMESTAMP '2026-05-22 16:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (12, 1017, 'CARD', 930.00, TIMESTAMP '2026-01-07 20:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (13, 1019, 'CARD', 1175.00, TIMESTAMP '2026-05-07 11:40:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (14, 1020, 'CARD', 830.00, TIMESTAMP '2026-02-25 21:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (15, 1021, 'COD', 316.00, TIMESTAMP '2026-05-28 09:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (16, 1023, 'CARD', 2560.00, TIMESTAMP '2026-06-25 15:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (17, 1024, 'CARD', 2180.00, TIMESTAMP '2026-04-22 19:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (18, 1025, 'BKASH', 445.00, TIMESTAMP '2026-04-24 11:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (19, 1027, 'BKASH', 2855.00, TIMESTAMP '2026-04-13 18:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (20, 1029, 'COD', 1070.00, TIMESTAMP '2026-06-02 17:20:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (21, 1030, 'BKASH', 240.00, TIMESTAMP '2026-01-06 12:30:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (22, 1031, 'COD', 1205.00, TIMESTAMP '2026-03-04 09:40:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (23, 1032, 'CARD', 300.00, TIMESTAMP '2026-05-01 18:20:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (24, 1033, 'COD', 2015.00, TIMESTAMP '2026-02-26 11:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (25, 1034, 'BKASH', 660.00, TIMESTAMP '2026-02-26 09:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (26, 1035, 'COD', 680.00, TIMESTAMP '2026-06-17 20:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (27, 1037, 'CARD', 590.00, TIMESTAMP '2026-04-17 11:30:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (28, 1039, 'CARD', 800.00, TIMESTAMP '2026-01-02 13:40:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (29, 1040, 'BKASH', 3505.00, TIMESTAMP '2026-06-23 11:40:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (30, 1041, 'COD', 1691.00, TIMESTAMP '2026-05-10 12:20:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (31, 1042, 'CARD', 1368.00, TIMESTAMP '2026-04-25 10:40:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (32, 1044, 'CARD', 5425.00, TIMESTAMP '2026-01-27 13:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (33, 1045, 'COD', 1585.00, TIMESTAMP '2026-06-10 20:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (34, 1046, 'COD', 2560.00, TIMESTAMP '2026-05-18 20:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (35, 1048, 'BKASH', 185.00, TIMESTAMP '2026-04-13 19:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (36, 1051, 'CARD', 480.00, TIMESTAMP '2026-04-20 13:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (37, 1053, 'CARD', 1180.00, TIMESTAMP '2026-04-17 18:20:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (38, 1057, 'BKASH', 3510.00, TIMESTAMP '2026-04-01 09:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (39, 1063, 'COD', 1585.00, TIMESTAMP '2026-04-22 15:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (40, 1064, 'COD', 360.00, TIMESTAMP '2026-01-04 21:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (41, 1065, 'COD', 1285.00, TIMESTAMP '2026-02-14 12:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (42, 1066, 'COD', 2035.00, TIMESTAMP '2026-03-13 11:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (43, 1067, 'CARD', 1260.00, TIMESTAMP '2026-01-14 14:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (44, 1068, 'BKASH', 5860.00, TIMESTAMP '2026-03-07 14:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (45, 1069, 'COD', 1020.00, TIMESTAMP '2026-05-20 18:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (46, 1070, 'BKASH', 1260.00, TIMESTAMP '2026-05-02 19:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (47, 1071, 'COD', 2645.00, TIMESTAMP '2026-02-02 15:30:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (48, 1073, 'BKASH', 1392.00, TIMESTAMP '2026-03-11 14:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (49, 1074, 'COD', 450.00, TIMESTAMP '2026-01-19 11:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (50, 1075, 'BKASH', 1803.00, TIMESTAMP '2026-03-26 20:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (51, 1076, 'COD', 1485.00, TIMESTAMP '2026-05-22 20:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (52, 1077, 'CARD', 120.00, TIMESTAMP '2026-06-11 11:30:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (53, 1078, 'BKASH', 5530.00, TIMESTAMP '2026-02-22 10:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (54, 1080, 'COD', 1110.00, TIMESTAMP '2026-01-03 20:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (55, 1081, 'BKASH', 2650.00, TIMESTAMP '2026-02-09 20:10:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (56, 1082, 'BKASH', 190.00, TIMESTAMP '2026-02-21 18:40:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (57, 1083, 'CARD', 632.00, TIMESTAMP '2026-01-29 14:00:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (58, 1084, 'BKASH', 232.00, TIMESTAMP '2026-04-13 19:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (59, 1085, 'CARD', 710.00, TIMESTAMP '2026-02-12 11:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (60, 1088, 'CARD', 1070.00, TIMESTAMP '2026-03-02 10:50:00');
INSERT INTO payments (payment_id, order_id, method, amount, paid_at) VALUES (61, 1089, 'BKASH', 3640.00, TIMESTAMP '2026-06-01 12:20:00');


COMMIT;

-- Verification: row counts you must see after loading
SELECT 'branches' AS table_name, COUNT(*) AS row_count FROM branches;
SELECT 'categories' AS table_name, COUNT(*) AS row_count FROM categories;
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM products;
SELECT 'stock' AS table_name, COUNT(*) AS row_count FROM stock;
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers;
SELECT 'staff' AS table_name, COUNT(*) AS row_count FROM staff;
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM orders;
SELECT 'order_items' AS table_name, COUNT(*) AS row_count FROM order_items;
SELECT 'payments' AS table_name, COUNT(*) AS row_count FROM payments;
