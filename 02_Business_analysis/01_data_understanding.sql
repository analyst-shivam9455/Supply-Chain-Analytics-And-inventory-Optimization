/* =========================================================
   ####################### PROJECT: Supply Chain Analytics & Inventory Optimization #########################
   ####################### FILE: 01_data_understanding.sql
   ####################### PURPOSE: Initial data exploration and quality validation #########################
   ========================================================= */


/* =========================================================
   1️ DATABASE & TABLE STRUCTURE VALIDATION
   ========================================================= */
USE supply_chain_analytics;


-- Check available tables
SHOW TABLES;

-- Describe structure of each table

DESCRIBE supply_chain_analytics.orders_and_shipments;

DESCRIBE supply_chain_analytics.inventory;

DESCRIBE supply_chain_analytics.fulfillment;



/* =========================================================
   2️ DATA VOLUME ANALYSIS
   ========================================================= */

-- Total records in each table

SELECT COUNT(*) AS total_orders_records
FROM supply_chain_analytics.orders_and_shipments;

SELECT COUNT(*) AS total_inventory_records
FROM supply_chain_analytics.inventory;

SELECT COUNT(*) AS total_fulfillment_records
FROM supply_chain_analytics.fulfillment;



/* =========================================================
   3️ BUSINESS METRICS OVERVIEW 
   ========================================================= */

-- Total Units Sold
SELECT SUM(order_quantity) AS total_units_sold
FROM supply_chain_analytics.orders_and_shipments;

-- Total Revenue
SELECT SUM(gross_sales) AS total_revenue
FROM supply_chain_analytics.orders_and_shipments;

-- Total Profit
SELECT SUM(profit) AS total_profit
FROM supply_chain_analytics.orders_and_shipments;

-- Total Unique Products
SELECT COUNT(DISTINCT product_name) AS total_unique_products
FROM supply_chain_analytics.orders_and_shipments;

-- Total Unique Categories
SELECT COUNT(DISTINCT product_category) AS total_categories
FROM supply_chain_analytics.orders_and_shipments;

-- Total Unique Departments
SELECT COUNT(DISTINCT product_department) AS total_departments
FROM supply_chain_analytics.orders_and_shipments;



/* =========================================================
   4️ DATE RANGE VALIDATION
   ========================================================= */

SELECT 
    MIN(order_date) AS start_date,
    MAX(order_date) AS end_date
FROM supply_chain_analytics.orders_and_shipments;



/* =========================================================
   5️ NULL VALUE CHECK (DATA QUALITY)
   ========================================================= */

SELECT
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_product,
    SUM(CASE WHEN order_quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN gross_sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profit,
    SUM(CASE WHEN order_date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
    SUM(CASE WHEN shipment_date IS NULL THEN 1 ELSE 0 END) AS null_shipment_date
FROM supply_chain_analytics.orders_and_shipments;



/* =========================================================
   6️ DUPLICATE CHECK
   ========================================================= */

-- Check duplicate order IDs

SELECT order_id, COUNT(*) AS occurrence_count
FROM supply_chain_analytics.orders_and_shipments
GROUP BY order_id
HAVING COUNT(*) > 1;



/* =========================================================
   7️ OUTLIER & ANOMALY CHECK
   ========================================================= */

-- Check for negative sales or profit

SELECT *
FROM supply_chain_analytics.orders_and_shipments
WHERE gross_sales < 0
   OR profit < 0;


-- Inventory range check

SELECT 
    MIN(warehouse_inventory) AS min_inventory,
    MAX(warehouse_inventory) AS max_inventory
FROM supply_chain_analytics.inventory;


-- Fulfillment days range check

SELECT
    MIN(`warehouse_order_fulfillment_(days)`) AS min_fulfillment_days,
    MAX(`warehouse_order_fulfillment_(days)`) AS max_fulfillment_days
FROM supply_chain_analytics.fulfillment;



/* =========================================================
   8️ JOIN INTEGRITY VALIDATION
   ========================================================= */

-- Products in orders but missing in inventory

SELECT DISTINCT o.product_name
FROM supply_chain_analytics.orders_and_shipments o
LEFT JOIN supply_chain_analytics.inventory i
ON o.product_name = i.product_name
WHERE i.product_name IS NULL;


-- Products in orders but missing in fulfillment

SELECT DISTINCT o.product_name
FROM supply_chain_analytics.orders_and_shipments o
LEFT JOIN supply_chain_analytics.fulfillment f
ON o.product_name = f.product_name
WHERE f.product_name IS NULL;


/* =========================================================
   END OF DATA UNDERSTANDING PHASE
   Dataset validated for further analysis and modeling.
   ========================================================= */