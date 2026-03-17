/* =========================================================
   ####################### PROJECT: Supply Chain Analytics & Inventory Optimization #########################
   ####################### FILE: 02_view_creation.sql
   ####################### PURPOSE: Creating View for future analysis #########################
   ========================================================= */

-- product supply chain summary

CREATE VIEW product_supply_chain_summary AS 
	SELECT
		o.product_name,
        o.product_category,
        o.product_department,
        o.total_orders,
        o.total_units_sold,
        o.total_revenue,
        o.total_profit,
        i.avg_inventory_level,
		i.avg_inventory_cost,
        f.avg_fulfillment_days
	FROM 
	(
		SELECT 
			product_name,
            product_category,
            product_department,
            COUNT(order_id) AS total_orders,
            SUM(order_quantity) AS total_units_sold,
            SUM(gross_sales) AS total_revenue,
            SUM(profit) AS total_profit
		FROM supply_chain_analytics.orders_and_shipments
        GROUP BY product_name, product_category, product_department
	) o
	LEFT JOIN 
    (
		SELECT 
			product_name,
            AVG(warehouse_inventory) AS avg_inventory_level,
            AVG(inventory_cost_per_unit) AS avg_inventory_cost
		FROM supply_chain_analytics.inventory
        GROUP BY product_name
	) i
    ON o.product_name = i.product_name
    LEFT JOIN 
    (
		SELECT 
			product_name,
            AVG(`warehouse_order_fulfillment_(days)`) AS avg_fulfillment_days
		FROM supply_chain_analytics.fulfillment
		GROUP BY product_name
	) f
    ON o.product_name = f.product_name;
-- =============================================================================================================================================    


 -- inventory optimization view   
    
CREATE VIEW inventory_optimization AS
SELECT
    product_name,
    product_category,
    avg_inventory_level,
    total_units_sold,
    avg_inventory_level /
	NULLIF(
		total_units_sold /
		(SELECT DATEDIFF(MAX(order_date), MIN(order_date))
		 FROM orders_and_shipments),
	0) AS days_of_inventory,
    CASE
        WHEN avg_inventory_level /
			NULLIF(
				total_units_sold /
				(SELECT DATEDIFF(MAX(order_date), MIN(order_date))
				 FROM orders_and_shipments),
			0) < 7
        THEN 'Understock Risk'
        WHEN avg_inventory_level /
			NULLIF(
				total_units_sold /
				(SELECT DATEDIFF(MAX(order_date), MIN(order_date))
				 FROM orders_and_shipments),
			0) BETWEEN 7 AND 30
        THEN 'Optimal'
        ELSE 'Overstock'
    END AS inventory_status
FROM product_supply_chain_summary;
-- =============================================================================================================================================


-- fulfillment efficiency view

CREATE VIEW fulfillment_efficiency AS
SELECT
    product_name,
    avg_fulfillment_days,
    CASE
        WHEN avg_fulfillment_days <= 2 THEN 'Fast'
        WHEN avg_fulfillment_days <= 5 THEN 'Normal'
        ELSE 'Slow'
    END AS fulfillment_status
FROM product_supply_chain_summary;
-- =============================================================================================================================================


-- product profitability view

CREATE VIEW product_profitability AS
SELECT
    product_name,
    total_revenue,
    total_profit,
    ROUND(((total_profit / NULLIF(total_revenue,0)) * 100), 2) AS profit_margin
FROM product_supply_chain_summary;
-- =============================================================================================================================================



-- inventory turnover analysis view

CREATE VIEW inventory_turnover_analysis AS
SELECT
    product_name,
    avg_inventory_level,
    total_units_sold,
    total_units_sold / NULLIF(avg_inventory_level, 0) AS inventory_turnover_ratio,
    CASE
        WHEN total_units_sold / NULLIF(avg_inventory_level, 0) >= 5 THEN 'High Efficiency'
        WHEN total_units_sold / NULLIF(avg_inventory_level, 0) >= 2 THEN 'Moderate Efficiency'
        ELSE 'Low Efficiency'
    END AS turnover_status
FROM product_supply_chain_summary;
-- =============================================================================================================================================



-- reorder recommendation view

CREATE VIEW reorder_recommendation AS
SELECT
    product_name,
    avg_inventory_level,
    avg_daily_sales,
    avg_daily_sales * 21 AS reorder_point,

    CASE
        WHEN avg_inventory_level <= avg_daily_sales * 21
        THEN 'Reorder Required'
        ELSE 'Stock Sufficient'
    END AS reorder_status
FROM
(
    SELECT
        product_name,
        avg_inventory_level,
        total_units_sold / 1095 AS avg_daily_sales
    FROM product_supply_chain_summary
) t;
-- =============================================================================================================================================



-- stockout risk analysis view

CREATE VIEW stockout_risk_analysis AS
SELECT
    product_name,
    product_category,
    total_units_sold,
    avg_inventory_level,
    total_units_sold / 1095 AS avg_daily_sales,
    avg_inventory_level /
    NULLIF(total_units_sold / 1095,0) AS days_until_stockout,
    CASE
        WHEN avg_inventory_level /
             NULLIF(total_units_sold / 1095,0) <= 15
        THEN 'High Risk'
        WHEN avg_inventory_level /
             NULLIF(total_units_sold / 1095,0) <= 45
        THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS stockout_risk_level
FROM product_supply_chain_summary;
-- =============================================================================================================================================



-- shipment delay analysis view

CREATE VIEW shipment_delay_analysis AS
SELECT
    product_name,
    AVG(DATEDIFF(shipment_date, order_date)) AS avg_actual_shipping_days,
    AVG(`shipment_days_-_scheduled`) AS avg_scheduled_days,
    AVG(DATEDIFF(shipment_date, order_date)) 
    - AVG(`shipment_days_-_scheduled`) AS avg_delay,
    CASE
        WHEN AVG(DATEDIFF(shipment_date, order_date)) - AVG(`shipment_days_-_scheduled`) > 0
        THEN 'Delayed'
        WHEN AVG(DATEDIFF(shipment_date, order_date)) - AVG(`shipment_days_-_scheduled`) < 0
        THEN 'Early'
        ELSE 'On Time'
    END AS shipment_status
FROM orders_and_shipments
WHERE shipment_date >= order_date
GROUP BY product_name;
-- =============================================================================================================================================



-- delivery performance view

CREATE VIEW delivery_performance AS
SELECT
COUNT(*) AS total_orders,
SUM(CASE 
        WHEN DATEDIFF(shipment_date, order_date) <= `shipment_days_-_scheduled` 
        THEN 1 
        ELSE 0 
    END) AS on_time_orders,
ROUND(
    SUM(CASE 
            WHEN DATEDIFF(shipment_date, order_date) <= `shipment_days_-_scheduled` 
            THEN 1 
            ELSE 0 
        END) * 100.0 / COUNT(*),
2) AS on_time_delivery_rate
FROM orders_and_shipments
WHERE shipment_date >= order_date;
-- =============================================================================================================================================



-- shipment delay trend view
CREATE VIEW shipment_delay_trend AS
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS shipment_year_month,
    AVG(DATEDIFF(shipment_date, order_date)) AS avg_actual_shipping_days,
    AVG(`shipment_days_-_scheduled`) AS avg_scheduled_days,
    AVG(DATEDIFF(shipment_date, order_date)) 
      - AVG(`shipment_days_-_scheduled`) AS avg_delay
FROM orders_and_shipments
WHERE shipment_date IS NOT NULL
  AND order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY shipment_year_month;
-- =============================================================================================================================================