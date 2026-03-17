-- ============================================
-- SUPPLY CHAIN ANALYTICS & INVENTORY OPTIMIZATION
-- Business Analysis 
-- ============================================



-- 1. Products needing reorder

SELECT *
FROM supply_chain_analytics.reorder_recommendation
WHERE reorder_status = 'Reorder Required'
ORDER BY reorder_point DESC;
-- ==================================================================================================



-- 2. Top producs at stockout risk

SELECT 
    product_name,
    product_category,
    days_until_stockout
FROM supply_chain_analytics.stockout_risk_analysis
ORDER BY days_until_stockout ASC
LIMIT 10;
-- ==================================================================================================



-- 3. Overstock Products(Excess Inventory)

SELECT *
FROM supply_chain_analytics.stockout_risk_analysis
WHERE days_until_stockout > 60
ORDER BY days_until_stockout DESC;
-- ==================================================================================================



-- 4. Total inventory value

SELECT 
    SUM(avg_inventory_level * avg_inventory_cost) AS total_inventory_value
FROM supply_chain_analytics.product_supply_chain_summary;
-- ==================================================================================================



-- 5. Top revenue generating products

SELECT 
    product_name,
    SUM(total_revenue) AS revenue
FROM supply_chain_analytics.product_supply_chain_summary
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10;
-- ==================================================================================================



-- 6. Low profitable products

SELECT 
    product_name,
    SUM(total_profit) AS profit
FROM supply_chain_analytics.product_supply_chain_summary
GROUP BY product_name
ORDER BY profit ASC
LIMIT 10;
-- ==================================================================================================



-- 7. Slow moving producs(Low inventory turnover)

SELECT 
    product_name,
    inventory_turnover_ratio
FROM supply_chain_analytics.inventory_turnover_analysis
ORDER BY inventory_turnover_ratio ASC
LIMIT 10;
-- ==================================================================================================



-- 8. Fulfillment performance analysis

SELECT 
    product_name,
    avg_fulfillment_days
FROM supply_chain_analytics.product_supply_chain_summary
ORDER BY avg_fulfillment_days DESC;
-- ==================================================================================================
