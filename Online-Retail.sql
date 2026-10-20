--------Monthly sales------------------------
select
  DATE_TRUNC('month',"InvoiceDate"::TIMESTAMP) AS sales_month ,
  SUM("Revenue") as total_revenue
  from online_retail t 
  group by date_trunc('month',"InvoiceDate"::TIMESTAMP)
  order by sales_month
  
  ------Best-selling products----------------
  select 
  	"Description",
  	SUM("Revenue") as total_spent 
  from online_retail t 
  group by t."Description" 
  order by total_spent desc
  limit 10
  ------------Find repeat customers top 10 ------------  
  select
  	"CustomerID",
  	count(distinct t."InvoiceNo") as count_invoiceno
  from online_retail t
  where t."CustomerID"  is not null 
  group by "CustomerID" 
  having count(distinct t."InvoiceNo") > 1
  order by count_invoiceno desc
  limit 10
  -------------Sales and number of orders by country top 10-----------  
  select 
  	"Country",
  	Round(SUM("Revenue")::numeric,2) as total_sales,
  	COUNT(DISTINCT"InvoiceNo") as total_orders
  from online_retail t 
  group by "Country" 
  order by total_sales  desc
  limit 10
 
  
  
 
  
