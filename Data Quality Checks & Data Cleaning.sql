# Data Quality Checks & Data Cleaning

## 1. Check Missing Values (NULLs)

```sql

SELECT
    COUNT(*) FILTER (WHERE "InvoiceNo" IS NULL) AS missing_invoice_no,
    COUNT(*) FILTER (WHERE "StockCode" IS NULL) AS missing_stock_code,
    COUNT(*) FILTER (WHERE "Description" IS NULL) AS missing_description,
    COUNT(*) FILTER (WHERE "Quantity" IS NULL) AS missing_quantity,
    COUNT(*) FILTER (WHERE "InvoiceDate" IS NULL) AS missing_invoice_date,
    COUNT(*) FILTER (WHERE "UnitPrice" IS NULL) AS missing_unit_price,
    COUNT(*) FILTER (WHERE "CustomerID" IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE "Country" IS NULL) AS missing_country
FROM public.online_retail;
```

## 2. Check Duplicate Records

```sql

SELECT
    "InvoiceNo",
    "StockCode",
    "InvoiceDate",
    "CustomerID",
    "Quantity",
    "UnitPrice",
    COUNT(*) AS duplicate_count
FROM public.online_retail
GROUP BY
    "InvoiceNo",
    "StockCode",
    "InvoiceDate",
    "CustomerID",
    "Quantity",
    "UnitPrice"
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
```

## 3. Check Cancelled Transactions

```sql

SELECT
    COUNT(*) AS cancellation_rows,
    COUNT(DISTINCT "InvoiceNo") AS cancellation_invoices,
    SUM("Quantity"::numeric * "UnitPrice"::numeric) AS cancellation_amount
FROM public.online_retail
WHERE TRIM("InvoiceNo") ILIKE 'C%';
```

## 4. Check Non-Positive Quantities

```sql

SELECT
    "Quantity",
    COUNT(*) AS total_rows,
    SUM("Quantity"::numeric * "UnitPrice"::numeric) AS total_amount
FROM public.online_retail
WHERE "Quantity" <= 0
GROUP BY "Quantity"
ORDER BY "Quantity";
```

## 5. Check Non-Positive Unit Prices

```sql

SELECT
    "UnitPrice",
    COUNT(*) AS total_rows,
    SUM("Quantity"::numeric * "UnitPrice"::numeric) AS total_amount
FROM public.online_retail
WHERE "UnitPrice" <= 0
GROUP BY "UnitPrice"
ORDER BY "UnitPrice";
```

## 6. Calculate Revenue (Quantity × UnitPrice)

```sql

SELECT
    *,
    ROUND(
        "Quantity"::numeric * "UnitPrice"::numeric,
        2
    ) AS revenue
FROM public.online_retail;
```

## 7. Create Valid Sales View

```sql

CREATE OR REPLACE VIEW public.valid_sales AS
SELECT
    "InvoiceNo",
    "StockCode",
    "Description",
    "Quantity",
    "InvoiceDate",
    "UnitPrice",
    "CustomerID",
    "Country",
    ROUND(
        "Quantity"::numeric * "UnitPrice"::numeric,
        2
    ) AS sales_amount
FROM public.online_retail
WHERE TRIM("InvoiceNo") NOT ILIKE 'C%'
  AND "InvoiceNo" IS NOT NULL
  AND "StockCode" IS NOT NULL
  AND "InvoiceDate" IS NOT NULL
  AND "Quantity" > 0
  AND "UnitPrice" > 0;
```

## 8. Validate Cleaned Data

```sql

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT "InvoiceNo") AS total_orders,
    SUM("Quantity") AS total_quantity,
    ROUND(SUM(sales_amount), 2) AS total_sales
FROM public.valid_sales;
```

## 9. Identify High-Quantity Transactions

```sql

SELECT
    "InvoiceNo",
    "StockCode",
    "Description",
    "Quantity",
    "UnitPrice",
    sales_amount
FROM public.valid_sales
ORDER BY "Quantity" DESC
LIMIT 10;
```

## 10. Identify High-Sales Transactions

```sql

SELECT
    COUNT(*) AS high_sales_rows,
    MIN("Quantity") AS min_quantity,
    MAX("Quantity") AS max_quantity,
    ROUND(MIN(sales_amount), 2) AS min_sales_amount,
    ROUND(MAX(sales_amount), 2) AS max_sales_amount
FROM public.valid_sales
WHERE sales_amount > 10000;
```

## 11. Analyze Missing CustomerID Impact on Sales

```sql

SELECT
    CASE
        WHEN "CustomerID" IS NULL
            THEN 'Missing CustomerID'
        ELSE 'Has CustomerID'
    END AS customer_status,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT "InvoiceNo") AS total_orders,
    SUM("Quantity") AS total_quantity,
    ROUND(SUM(sales_amount), 2) AS total_sales
FROM public.valid_sales
GROUP BY
    CASE
        WHEN "CustomerID" IS NULL
            THEN 'Missing CustomerID'
        ELSE 'Has CustomerID'
    END
ORDER BY customer_status;
```

## 12. Check CustomerID Completeness at Invoice Level

```sql

WITH invoice_customer AS (
    SELECT
        "InvoiceNo",
        COUNT(*) AS total_rows,
        COUNT("CustomerID") AS rows_with_customer,
        COUNT(*) - COUNT("CustomerID") AS rows_without_customer
    FROM public.valid_sales
    GROUP BY "InvoiceNo"
)
SELECT
    COUNT(*) AS total_invoices_with_missing_customer,
    COUNT(*) FILTER (
        WHERE rows_with_customer > 0
    ) AS invoices_with_both_missing_and_known_customer,
    COUNT(*) FILTER (
        WHERE rows_with_customer = 0
    ) AS invoices_with_all_customer_ids_missing
FROM invoice_customer
WHERE rows_without_customer > 0;
```

## 13. Investigate High-Quantity Invoice Details

```sql

SELECT
    "InvoiceNo",
    "StockCode",
    "Description",
    "Quantity",
    "UnitPrice",
    "CustomerID",
    "Country",
    "InvoiceDate"
FROM public.online_retail
WHERE "InvoiceNo" IN ('581483', '541431')
ORDER BY "InvoiceNo", "StockCode";
```
