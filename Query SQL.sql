CREATE DATABASE sales_project;
USE sales_project;
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_city VARCHAR(50),
    customer_state VARCHAR(10)
);
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME
);
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    price DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100)
);
SHOW TABLES;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM products;

SELECT SUM(price) AS total_revenue
FROM order_items;

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM orders;

SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS bulan,
    COUNT(order_id) AS total_order
FROM orders
GROUP BY bulan
ORDER BY bulan;

SELECT 
    c.customer_id,
    SUM(oi.price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT 
    product_id,
    COUNT(*) AS total_sold
FROM order_items
GROUP BY product_id
ORDER BY total_sold DESC
LIMIT 10;

SELECT 
    p.product_category_name,
    COUNT(*) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY total_sold DESC
LIMIT 10;

SELECT 
    c.customer_city,
    SUM(oi.price) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 10;

#gabungkan data untuk tableau
SELECT 
    o.order_id,
    DATE(o.order_purchase_timestamp) AS order_date,
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    c.customer_id,
    c.customer_city AS city,
    oi.product_id,
    p.product_category_name AS category,
    oi.price AS revenue
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered';


SELECT 
    o.order_id,
    DATE(o.order_purchase_timestamp) AS order_date,
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    c.customer_id,
    c.customer_city AS city,
    oi.product_id,
    p.product_category_name AS category,
    COUNT(oi.order_item_id) AS quantity,
    SUM(oi.price) AS revenue
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY 
    o.order_id, order_date, year, month,
    c.customer_id, city,
    oi.product_id, category;

CREATE VIEW fact_sales AS
SELECT 
    o.order_id,
    DATE(o.order_purchase_timestamp) AS order_date,
    YEAR(o.order_purchase_timestamp) AS year,
    MONTH(o.order_purchase_timestamp) AS month,
    c.customer_id,
    c.customer_city AS city,
    oi.product_id,
    p.product_category_name AS category,
    COUNT(oi.order_item_id) AS quantity,
    SUM(oi.price) AS revenue
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY 
    o.order_id, order_date, year, month,
    c.customer_id, city,
    oi.product_id, category;
SHOW FULL TABLES;
SELECT * FROM fact_sales LIMIT 10;
SELECT * FROM fact_sales














































-- ==============================
-- 1. CREATE DATABASE & TABLES
-- ==============================
CREATE DATABASE IF NOT EXISTS sales_project;
USE sales_project;

CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_city VARCHAR(50),
    customer_state VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    price DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100)
);

-- ==============================
-- 2. CEK DATA (OPTIONAL)
-- ==============================
SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_items FROM order_items;
SELECT COUNT(*) AS total_products FROM products;

-- ==============================
-- 3. ANALISIS DASAR (OPTIONAL)
-- ==============================
SELECT SUM(price) AS total_revenue FROM order_items;

SELECT COUNT(DISTINCT order_id) AS total_orders FROM orders;

SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS bulan,
    COUNT(order_id) AS total_order
FROM orders
GROUP BY bulan
ORDER BY bulan;

-- ==============================
-- 4. VIEW FINAL UNTUK TABLEAU
-- ==============================
CREATE OR REPLACE VIEW fact_sales AS
SELECT 
    o.order_id,
    DATE(o.order_purchase_timestamp) AS order_date,
    c.customer_id,
    c.customer_city AS city,
    c.customer_state AS state,
    oi.product_id,
    p.product_category_name AS category,
    COUNT(oi.order_item_id) AS quantity,
    SUM(oi.price) AS revenue
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY 
    o.order_id,
    order_date,
    c.customer_id,
    city,
    state,
    oi.product_id,
    category;

-- ==============================
-- 5. VALIDASI DATA
-- ==============================
SELECT COUNT(*) AS total_rows FROM fact_sales;

SELECT * FROM fact_sales;

-- ==============================
-- 6. EXPORT KE CSV (AMAN)
-- ==============================
SELECT *
FROM fact_sales
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_sales.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';




SELECT 
    o.order_id,
    DATE(o.order_purchase_timestamp),
    c.customer_id,
    c.customer_city,
    c.customer_state,
    oi.product_id,
    p.product_category_name,
    COUNT(oi.order_item_id),
    SUM(oi.price)
FROM orders o
JOIN customers c 
    ON o.customer_id = c.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY 
    o.order_id,
    DATE(o.order_purchase_timestamp),
    c.customer_id,
    c.customer_city,
    c.customer_state,
    oi.product_id,
    p.product_category_name
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/fact_sales_fix.csv'
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n';