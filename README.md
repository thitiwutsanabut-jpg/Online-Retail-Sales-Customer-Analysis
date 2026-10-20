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


## 💡 Key Insights & Strategic Recommendations

### 📌 Insight 1: Q4 Seasonal Peak & Post-Holiday Revenue Drop
* **Key Finding**: Based on monthly sales trends, monthly revenue remains stable at approximately **$0.5M - $0.8M** during the first three quarters before surging exponentially in Q4[cite: 6]. It reaches a peak of over **$1.4M** in November due to the holiday shopping season[cite: 6], followed by a sharp decline heading into the new year[cite: 6].
* **💡 Business Recommendation**:
  * **Pre-Holiday Inventory Planning**: Plan and stock top-selling products in advance during Q3 to prevent stockouts during peak demand in Q4.
  * **Post-Holiday Re-engagement**: Launch targeted post-holiday retention campaigns (e.g., bounce-back coupons valid for January and February) to sustain revenue levels in the first quarter of the year.

---

### 📌 Insight 2: High Revenue Concentration in Home Decor & Event Items
* **Key Finding**: The top 10 revenue-generating products are heavily concentrated in home decor, party accessories, and event supplies[cite: 6]. Leading items include `DOTCOM POSTAGE` ($206K), `REGENCY CAKESTAND 3 TIER` ($174K), and `PAPER CRAFT, LITTLE BIRDIE` ($168K)[cite: 6].
* **💡 Business Recommendation**:
  * **Product Bundling Strategy**: Implement cross-selling bundles (e.g., bundling cake stands with party decor items at a bundled discount) to drive higher Average Order Value (AOV) above $534.40[cite: 6].
  * **Supplier Negotiation**: Negotiate volume discounts with suppliers for top-performing items to optimize gross profit margins.

---

### 📌 Insight 3: Strong Customer Retention & Potential B2B Segment
* **Key Finding**: The store serves **4,000 unique customers** generating **20,000 total orders**[cite: 6], reflecting a strong average repeat rate of ~5 orders per customer. Furthermore, the overall Average Order Value (AOV) is notably high at **$534.40**[cite: 6].
* **💡 Business Recommendation**:
  * **VIP Loyalty Program**: Establish an exclusive loyalty program for high-frequency repeat buyers to increase Customer Lifetime Value (CLV) and defend against customer churn.
  * **B2B / Bulk Buying Incentives**: Given the high AOV, a significant portion of buyers likely consists of wholesale/B2B clients[cite: 6]. Introducing tiered bulk pricing and shipping discounts for high-volume orders will further encourage large-scale purchases.

## ⚠️ Limitations

1. **Incomplete December Data**: The dataset for December 2011 contains partial-month data only, resulting in an artificial drop in overall sales figures for the final month[cite: 6].
2. **Missing Customer Identifiers**: A portion of transactions lacks a `CustomerID`, requiring these rows to be excluded during customer behavior and repeat-purchase analysis.
3. **Absence of Cost/Profit Margin Data**: The dataset only records selling prices (`UnitPrice`) and total revenue (`Revenue`)[cite: 2] without cost of goods sold (COGS) or shipping fees. Consequently, the analysis is limited to Gross Sales and cannot calculate actual Net Profit Margins.




