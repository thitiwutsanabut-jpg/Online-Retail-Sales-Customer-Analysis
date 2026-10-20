# Online-Retail-Sales-Customer-Analysis
Online Retail Sales &amp; Customer Analysis using PostgreSQL and Power BI — analyzing sales trends, top products, and repeat customer behavior to derive actionable business insights.

## 📌 Objective
This project aims to analyze sales data and customer behavior for an online retail business. It utilizes **PostgreSQL** for data extraction and processing [cite: 1, 2], 
alongside **Power BI** for dashboard creation [cite: 1, 3]. The findings are then interpreted into **three key business insights**, 
accompanied by **actionable recommendations** that can be implemented in a real-world business context.

## 📊 Executive Summary & Key Dashboard Metrics

The performance overview dashboard reveals the following key figures:
<img width="1335" height="783" alt="image" src="https://github.com/user-attachments/assets/c275491e-beac-4823-a6c0-0e86740b2ae7" />


* **Gross Sales**: $10.67M (Total sales)
* **Average Order Value (AOV)**: $534.40 (Average order value)
* **Total Orders**: 20K (Total number of orders)
* **Unique Customers**: 4K (Total number of customers)

## 🛠️ Methodology & SQL Queries

### 1. Monthly Sales Trend Analysis
Analyze monthly sales trends to identify seasonal fluctuations:

SELECT 
    DATE_TRUNC('month', "InvoiceDate"::TIMESTAMP) AS sales_month,
    SUM("Revenue") AS total_revenue
FROM online_retail t
GROUP BY DATE_TRUNC('month', "InvoiceDate"::TIMESTAMP)
ORDER BY sales_month;
<img width="322" height="275" alt="image" src="https://github.com/user-attachments/assets/0b866e74-49c7-473b-aa47-49c1be4c8401" />

### 2. Best-Selling Products (Top 10)
Top 10 highest-revenue-generating products:

SELECT 
    "Description",
    SUM("Revenue") AS total_spent
FROM online_retail t
GROUP BY t."Description"
ORDER BY total_spent DESC
LIMIT 10;
<img width="410" height="216" alt="image" src="https://github.com/user-attachments/assets/ade29385-438b-4812-a0ab-63100e2fdc4f" />

### 3. Repeat Customer Identification (top 10)
Filter for the top 10 customers who have placed more than one order.

SELECT 
    "CustomerID",
    COUNT(DISTINCT t."InvoiceNo") AS count_invoiceno
FROM online_retail t
WHERE t."CustomerID" IS NOT NULL
GROUP BY "CustomerID"
HAVING COUNT(DISTINCT t."InvoiceNo") > 1
ORDER BY count_invoiceno DESC
LIMIT 10;
<img width="337" height="214" alt="image" src="https://github.com/user-attachments/assets/6fbade05-3334-4694-9d28-ab3f0a7509b1" />

### 4. Sales and Orders by Country (top10)
Analyze sales revenue and order volume by country for the top 10 countries.

SELECT 
    "Country",
    ROUND(SUM("Revenue")::NUMERIC, 2) AS total_sales,
    COUNT(DISTINCT "InvoiceNo") AS total_orders
FROM online_retail t
GROUP BY "Country"
ORDER BY total_sales DESC
LIMIT 10;
<img width="418" height="222" alt="image" src="https://github.com/user-attachments/assets/622aad50-0777-452f-8b89-9be85e2de1cf" />






