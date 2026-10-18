Grocery capstone project:
SQL using DuckDB:


C:\Users\HP\Desktop\Grocery_Capstone>duckdb.exe grocery_analytics.duckdb

Orders:
D create table orders AS
  Select *
  from read_csv_auto('data/orders.csv');
D select count(*) as total_orders from orders;  ((3.42 million) ,3421083 )

products:
D create table products AS
                    Select *
                    from read_csv_auto('data/products.csv');
D select count(*) as total_products from products;      (134)

departments:
D create table departments AS
  Select * from read_csv_auto('data/departments.csv');
D select count(*) as total_departments from departments; (21)

order_products_prior:
D CREATE TABLE order_products_prior AS
  SELECT * FROM read_csv_auto('data/order_products__prior.csv');
D SELECT COUNT(*) AS total_prior_records
  FROM order_products_prior;                   ((32.43 million) ,32434489 )

order_products_train:
D CREATE TABLE order_products_train AS
  SELECT * FROM read_csv_auto('data/order_products__train.csv');
D SELECT COUNT(*) AS total_train_records
  FROM order_products_train;

---------------------------------
D show tables;
┌──────────────────────┐
│         name         │
│       varchar        │
├──────────────────────┤
│ aisles               │
│ departments          │
│ order_products_prior │
│ order_products_train │
│ orders               │
│ products             │
└──────────────────────┘
grocery_analytics D describe orders;
┌────────────────────────────────┐
│             orders             │
│                                │
│ order_id               bigint  │
│ user_id                bigint  │
│ eval_set               varchar │
│ order_number           bigint  │
│ order_dow              bigint  │
│ order_hour_of_day      varchar │
│ days_since_prior_order double  │
└────────────────────────────────┘
grocery_analytics D describe products;
┌───────────────────────┐
│       products        │
│                       │
│ product_id    bigint  │
│ product_name  varchar │
│ aisle_id      bigint  │
│ department_id bigint  │
└───────────────────────┘
grocery_analytics D describe order_products_prior;
┌──────────────────────────┐
│   order_products_prior   │
│                          │
│ order_id          bigint │
│ product_id        bigint │
│ add_to_cart_order bigint │
│ reordered         bigint │
└──────────────────────────┘
grocery_analytics D describe order_products_train;
┌──────────────────────────┐
│   order_products_train   │
│                          │
│ order_id          bigint │
│ product_id        bigint │
│ add_to_cart_order bigint │
│ reordered         bigint │
└──────────────────────────┘

----------------------------------------------------------
check missing values
products:
D SELECT
COUNT(*) AS total_rows, COUNT(*) - COUNT(product_id) AS missing_product_id,
COUNT(*) - COUNT(product_name) AS missing_product_name,
COUNT(*) - COUNT(aisle_id) AS missing_aisle_id, COUNT(*) - COUNT(department_id) AS missing_department_id FROM products;

D SELECT product_id, COUNT(*) AS occurrences FROM products
  GROUP BY product_id HAVING COUNT(*) > 1
  ORDER BY occurrences DESC;                          (0rows)

orders:
D SELECT
  COUNT(*) AS total_rows, COUNT(*) - COUNT(order_id) AS missing_order_id,
  COUNT(*) - COUNT(user_id) AS missing_user_id,
  COUNT(*) - COUNT(eval_set) AS missing_eval_set,
  COUNT(*) - COUNT(order_number) AS missing_order_number,
  COUNT(*) - COUNT(order_dow) AS missing_order_dow,
  COUNT(*) - COUNT(order_hour_of_day) AS missing_order_hour,
  COUNT(*) - COUNT(days_since_prior_order) AS missing_days_since_prior
  FROM orders;

departments:
D SELECT COUNT(*) AS total_rows,
  COUNT(*) - COUNT(department_id) AS missing_department_id,
  COUNT(*) - COUNT(department) AS missing_department_name
  FROM departments;

order_products_prior:
D SELECT COUNT(*) AS total_rows,
  COUNT(*) - COUNT(order_id) AS missing_order_id,
  COUNT(*) - COUNT(product_id) AS missing_product_id,
  COUNT(*) - COUNT(add_to_cart_order) AS missing_cart_order,
  COUNT(*) - COUNT(reordered) AS missing_reordered
  FROM order_products_prior;

order_products_train:
D SELECT COUNT(*) AS total_rows,
  COUNT(*) - COUNT(order_id) AS missing_order_id,
  COUNT(*) - COUNT(product_id) AS missing_product_id,
  COUNT(*) - COUNT(add_to_cart_order) AS missing_cart_order,
  COUNT(*) - COUNT(reordered) AS missing_reordered
  FROM order_products_train;

aisles:
D SELECT COUNT(*) AS total_rows, COUNT(*) - COUNT(aisle_id) AS missing_aisle_id, COUNT(*) - COUNT(aisle) AS missing_aisle_name
FROM aisles;
---------------------------
D CREATE TABLE order_summary AS SELECT
  order_id, COUNT(*) AS total_products,
  SUM(reordered) AS reordered_products FROM order_products_prior
  GROUP BY order_id;

D SELECT COUNT(*) AS total_orders FROM order_summary;
│    3214874     │
│ (3.21 million) │

----------------------product-order records
SELECT
    COUNT(*) AS total_order_product_records,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT product_id) AS unique_products,
    ROUND(AVG(add_to_cart_order), 2) AS avg_cart_position,
    ROUND(AVG(reordered) * 100, 2) AS reorder_rate_pct
FROM order_products_prior;

[total_order_product_records-32434489 | total_orders-3214874 | unique_products-49677 | avg_cart_position-8.35 | reorder_rate_pct-58.97]

-- 4. Top 10 most-purchased products
SELECT
    p.product_id,
    p.product_name,
    COUNT(*) AS times_purchased,
    SUM(op.reordered) AS times_reordered,
    ROUND(AVG(op.reordered) * 100, 2) AS reorder_rate_pct
FROM order_products_prior op
JOIN products p
    ON op.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY times_purchased DESC
LIMIT 10;

┌────────────┬────────────────────────┬─────────────────┬─────────────────┬──────────────────┐
│ product_id │      product_name      │ times_purchased │ times_reordered │ reorder_rate_pct │
│   int64    │        varchar         │      int64      │     int128      │      double      │
├────────────┼────────────────────────┼─────────────────┼─────────────────┼──────────────────┤
│      24852 │ Banana                 │          472565 │          398609 │            84.35 │
│      13176 │ Bag of Organic Bananas │          379450 │          315913 │            83.26 │
│      21137 │ Organic Strawberries   │          264683 │          205845 │            77.77 │
│      21903 │ Organic Baby Spinach   │          241921 │          186884 │            77.25 │


-- 5. Orders by hour of day
SELECT
    order_hour_of_day,
    COUNT(*) AS total_orders
FROM orders
WHERE eval_set = 'prior'
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day;

┌───────────────────┬──────────────┐
│ order_hour_of_day │ total_orders │
│       int32       │    int64     │
├───────────────────┼──────────────┤
│                10 │       271885 │
│                11 │       268006 │
│                15 │       266132 │
│                14 │       265556 │

-- 6. Orders by day of week
SELECT
    order_dow,
    COUNT(*) AS total_orders
FROM orders
WHERE eval_set = 'prior'
GROUP BY order_dow
ORDER BY order_dow;

┌───────────┬──────────────┐
│ order_dow │ total_orders │
│   int64   │    int64     │
├───────────┼──────────────┤
│         0 │       557772 │
│         1 │       556705 │
│         2 │       441955 │
│         5 │       425982 │
│         6 │       418848 │

-- 7. Department purchase analysis
SELECT
    d.department,
    COUNT(*) AS total_products_purchased,
    COUNT(DISTINCT op.order_id) AS orders_containing_products
FROM order_products_prior op
JOIN products p
    ON op.product_id = p.product_id
JOIN departments d
    ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY total_products_purchased DESC;

┌─────────────────┬──────────────────────────┬────────────────────────────┐
│   department    │ total_products_purchased │ orders_containing_products │
│     varchar     │          int64           │           int64            │
├─────────────────┼──────────────────────────┼────────────────────────────┤
│ produce         │                  9479291 │                    2409320 │
│ dairy eggs      │                  5414016 │                    2177338 │
│ snacks          │                  2887550 │                    1391447 │

-- 8. Top 10 aisles by purchase volume
SELECT
    a.aisle,
    COUNT(*) AS total_products_purchased,
    COUNT(DISTINCT op.order_id) AS orders_containing_products
FROM order_products_prior op
JOIN products p
    ON op.product_id = p.product_id
JOIN aisles a
    ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY total_products_purchased DESC
LIMIT 10;

┌───────────────────────────────┬──────────────────────────┬────────────────────────────┐
│             aisle             │ total_products_purchased │ orders_containing_products │
│            varchar            │          int64           │           int64            │
├───────────────────────────────┼──────────────────────────┼────────────────────────────┤
│ fresh fruits                  │                  3642188 │                    1790771 │
│ fresh vegetables              │                  3418021 │                    1427631 │
