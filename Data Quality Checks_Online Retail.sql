select *
from online_retail t 
limit 10
------------chack row--------------------- 
select count(*)
from online_retail t 

select *
from online_retail t 
where t."InvoiceNo" is null 
and t."StockCode"   is null 

select 
       count(*) as total_raw,
       count(*) filter (
       where "Description" is null
       ) as null_Description
from online_retail
----------------chack all null ------------------

select 
    count(*) filter (
        where "Country" is null) as Null_Country,
    count(*) filter (
        where "CustomerID" is null ) as Null_CustomerID,
    count(*) filter (
        where "UnitPrice" is null ) as Null_UnitPrice,
    count(*) filter (
        where "InvoiceDate" is null ) as Null_InvoiceDate,
    count(*) filter (
        where "Quantity" is null ) as Null_Quantity,
    count(*) filter (
        where "StockCode" is null ) as Null_StockCode,
    count(*) filter (
        where "InvoiceNo" is null ) as Null_InvoiceNo,
    count(*) filter (
        where "Description" is null ) as Null_Description
from online_retail

---------------chack duplicate------------
SELECT
    "Country",
    "CustomerID",
    "UnitPrice",
    "InvoiceDate",
    "Quantity",
    "StockCode",
    "InvoiceNo",
    "Description",
    COUNT(*) AS duplicate_count
FROM online_retail
GROUP BY
    "Country",
    "CustomerID",
    "UnitPrice",
    "InvoiceDate",
    "Quantity",
    "StockCode",
    "InvoiceNo",
    "Description"
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-----------------invioce no  and quantity -0--------------
select *
from online_retail t 
where t."InvoiceNo" like 'c%'
    and "Quantity" < 0
    
 --------------------craate cte chack ---------------------------
with valid_sales as (
     select 
         "InvoiceNo"
         "StockCode",
         "Description",
         "Quantity",
         "InvoiceDate",
         "UnitPrice",
         "CustomerID",
         "Country",
         "Quantity" * "UnitPrice" as sales_amount
       from online_retail t 
       where 
           "InvoiceNo" is not null
           and "StockCode" is not null
           and "InvoiceDate" is not null
           and "InvoiceNo" not like 'c%'
           and "Quantity"> 0
           and "UnitPrice" >0
    )
    select * 
    from valid_sales 
    limit 10;
----------------create view ---------------------
 create or replace view public.valid_sales as 
     select 
         "InvoiceNo"
         "StockCode",
         "Description",
         "Quantity",
         "InvoiceDate",
         "UnitPrice",
         "CustomerID",
         "Country",
         "Quantity" * "UnitPrice" as sales_amount
       from public.online_retail
       where 
           "InvoiceNo" is not null
           and "StockCode" is not null
           and "InvoiceDate" is not null
           and "InvoiceNo" not like 'c%'
           and "Quantity"> 0
           and "UnitPrice" >0
           
select * 
from public.valid_sales
limit 10
-------------------------------------------------

select 
    "InvoiceNo",
    "StockCode",
    "Quantity",
    "UnitPrice",
    "Quantity"*"UnitPrice" as "Revenue"
 from online_retail t 
 
 --------------create Revenue---------------------
 alter table online_retail 
 add column "Revenue" numeric;
 
 update online_retail t 
 set "Revenue" = "Quantity"*"UnitPrice";
 
 select 
     "Quantity",
     "UnitPrice",
     "Revenue"
 from online_retail t 
 limit 10;
 
 --------------Check  anomalous sales figures, and excluded items.------------------------------------
 select 
   "InvoiceNo",
   "StockCode",
   "Description",
   "Quantity",
   "UnitPrice",
   "InvoiceDate",
   "Quantity"*"UnitPrice" as revenue
  from online_retail t 
  where 
    "Quantity" <=0
    or t."UnitPrice" <=0
  order by "InvoiceDate"
  
 ------------Investigate unusually high sales figures..---------

WITH sales AS (
    SELECT
        "InvoiceNo",
        "StockCode",
        "Description",
        "Quantity",
        "UnitPrice",
        "InvoiceDate",
        "Quantity" * "UnitPrice" AS revenue
    FROM online_retail
    WHERE "Quantity" > 0
      AND "UnitPrice" > 0
),
threshold AS (
    SELECT
        PERCENTILE_CONT(0.99)
        WITHIN GROUP (ORDER BY revenue) AS p99
    FROM sales
)
SELECT
    s.*,
    t.p99 AS threshold_p99
FROM sales s
CROSS JOIN threshold t
WHERE s.revenue > t.p99
ORDER BY s.revenue DESC;

----------------Check the Invoice No. that starts with C.-----------
select *
from online_retail t 
where Trim("InvoiceNo") ilike 'c%'

--------Summary of the number of items that met and did not meet the criteria.--
select 
  count(*) as total_rows,
  count(*) FILTER(
      where "InvoiceNo" is not null
      and "StockCode" is not null
      and "InvoiceDate" is not null
      and "Quantity" > 0
      and "UnitPrice" > 0
      and TRIM("InvoiceNo") not ilike 'c%'
 ) as included_row, 
 COUNT(*) filter (
     where "InvoiceNo" is null
     or "StockCode" is null
     or "InvoiceDate" is null
     or "Quantity" <=0
     or "UnitPrice"<=0
     or Trim("InvoiceNo") ilike 'c%'
 ) as excluded_rows
from online_retail

-------Check the total amount and number of sales transactions.--------
with sales as (
    select 
    "InvoiceNo",
    "Quantity",
    "UnitPrice",
    "Quantity" * "UnitPrice" as revenue
 from online_retail
 where "InvoiceNo" not like 'c%'
 and "Quantity" > 0
 and "UnitPrice" > 0
)
select 
    count(*) as total_rows,
    count(distinct "InvoiceNo") as total_invoice,
    sum("Quantity") as total_quantity,
    sum("revenue") as total_revenue
from sales;

-----------Verify whether it has actually been cleaned.------------
select 
  count(*) as remaining_invalid_rows
from online_retail t 
where "InvoiceNo" like 'c%'
 or "Quantity" <=0
 or "UnitPrice" <=0

-----------------------------------------------------------------------

