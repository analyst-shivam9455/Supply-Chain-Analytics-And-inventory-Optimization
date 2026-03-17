# 📦 Supply Chain Analytics & Inventory Optimization Dashboard

## 📌 Project Overview

This project focuses on analyzing supply chain operations and optimizing inventory management using SQL and Power BI.

The goal is to identify key business problems such as stockouts, overstocking, shipment delays, and inefficient inventory usage, and provide data-driven insights to improve decision-making.

---

## 🎯 Business Objectives

- Identify products at **high stockout risk**
- Detect **overstocked / slow-moving inventory**
- Analyze **shipment delays and logistics performance**
- Track **revenue and profit contribution by products**
- Optimize **inventory turnover and replenishment decisions**

---

## 🗂️ Dataset Description

The project uses supply chain data consisting of:

- Order & shipment details
- Inventory levels and costs
- Fulfillment performance

### Key Columns:
- `order_id`, `product_name`, `order_quantity`
- `shipment_date`, `order_date`, `shipment_mode`
- `warehouse_inventory`, `inventory_cost_per_unit`
- `gross_sales`, `profit`, `discount`

---

## 🛠️ Tools & Technologies

- SQL (MySQL)
- Power BI
- Data Modeling
- DAX (for KPI calculations)

---

## 📊 Key KPIs

- Total Revenue
- Total Profit
- Total Orders
- Inventory Turnover Ratio
- Products at Stockout Risk
- Products Needing Reorder


---

## 📈 Key Business Insights

- Identified products at **high stockout risk**, helping prevent potential revenue loss  
- Detected **slow-moving inventory**, reducing excess holding costs  
- Found that a significant portion of shipments are **delayed**, indicating logistics inefficiencies  
- Observed that a small number of products contribute to the majority of revenue (**Pareto effect**)  
- Identified regional variations in demand for better inventory allocation  

---

## 🧠 Business Analysis Performed

- Reorder point analysis
- Stockout risk evaluation
- Inventory turnover analysis
- Shipment delay analysis
- Revenue and profit analysis

---

## 📊 Dashboard Overview

The Power BI dashboard consists of 5 main pages:

### 1. Supply Chain Overview
- Revenue trends
- Top products
- Regional demand

### 2. Inventory Optimization
- Inventory vs demand
- Stockout risk
- Slow-moving products

### 3. Stock out Risk and reorder planning
- Products needing reorder
- Stockout risk level
- Days untill stockout

### 4. Fulfillment & Logistics Performance
- Shipment delays
- fulfillment Status distribution
- Shipping mode efficiency

### 5. Profit and Cost Optimization
- Profit Margin v/s Inventory
- Profit v/s Inventory
- Top and Bottom profitable products

---

## 📁 Project Structure
├── dataset/
├── sql/
│ └── supply_chain_business_analysis.sql
├── dashboard/
│ └── supply_chain_dashboard.pbix
├── README.md


---

## 🚀 How to Use

1. Import dataset into MySQL
2. Run SQL scripts to create views and analysis tables
3. Load data into Power BI
4. Build dashboard using provided metrics and insights

---

## 📌 Key Learnings

- Understanding of real-world supply chain problems  
- Data-driven decision making for inventory optimization  
- SQL-based data transformation and analysis  
- Building professional dashboards in Power BI  

---

## 🔗 Future Improvements

- Real-time data integration
- Demand forecasting using machine learning
- Automated reorder recommendations
- Advanced supply chain KPIs

---

## 👤 Author

Shivam Kasaudhan  
Data Analyst

---
