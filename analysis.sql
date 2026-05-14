--This is the query file for analysis
--1: What was the monthly revenue in the given time period? 
SELECT 
    extract(year from InvoiceDate) as Year, 
    extract(month from InvoiceDate) as Month,
    sum(Quantity * UnitPrice) as Revenue
FROM Online_Retail 
WHERE InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0
GROUP BY 
    extract(year from InvoiceDate),
    extract(month from Invoicedate)
ORDER BY
    extract(year from InvoiceDate),
    extract(month from Invoicedate);


--2: What is the total value sales revenue generated in this time period?
SELECT
    sum(Quantity * UnitPrice) as "Total Revenue"
FROM Online_Retail
WHERE InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0;


--3: Which 10 products generated the most revenue?
SELECT StockCode, Description, sum(Quantity * UnitPrice) AS Revenue
FROM Online_Retail
WHERE InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0
GROUP BY StockCode, Description
ORDER BY sum(Quantity * UnitPrice) DESC
LIMIT 10;


--4: What are the revenues generated for each country?
SELECT Country, sum(Quantity * UnitPrice) AS Revenue
FROM Online_Retail
WHERE InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0
GROUP BY Country
ORDER BY sum(Quantity * UnitPrice) DESC;


--5: What percentage of the total revenue came from the top 10 customers by revenue?
SELECT round(100.0 *sum(CASE WHEN RowNum <= 10 THEN Revenue ELSE 0 END) / sum(Revenue), 2)
        as "Percentage of Revenue from Top 10 Customers"
FROM (SELECT CustomerID, sum(Quantity * UnitPrice) as Revenue, ROW_NUMBER()
        OVER (ORDER BY sum(Quantity * UnitPrice) DESC) as RowNum
        FROM Online_Retail
        WHERE CustomerID IS NOT NULL AND InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0
        GROUP BY CustomerID
        ORDER BY sum(Quantity * UnitPrice) DESC);


--6: What are the top 10 customers (recorded) that had the most orders?
SELECT CustomerID, count(DISTINCT InvoiceNo)
FROM Online_Retail
WHERE CustomerID IS NOT NULL AND InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0
GROUP BY CustomerID
ORDER BY count(DISTINCT InvoiceNo) DESC
LIMIT 10;


--7: What are the top 10 customers (recorded) that generated the most revenue?
SELECT CustomerID, sum(Quantity * UnitPrice) as Revenue
FROM Online_Retail
WHERE CustomerID IS NOT NULL AND InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0
GROUP BY CustomerID
ORDER BY sum(Quantity * UnitPrice) DESC
LIMIT 10;


--8: What is the customer (Recorded) repeat purchase rate?
SELECT round(100.0*sum(CASE WHEN OrderNum > 1 THEN 1.0 ELSE 0.0 END)/count(*), 2)
         as "Repeat Purchase Rate from Recorded Customers "
FROM (SELECT CustomerID, count(DISTINCT InvoiceNo) as OrderNum
FROM Online_Retail
WHERE CustomerID IS NOT NULL AND InvoiceNo NOT LIKE 'C%' 
    AND UnitPrice * Quantity >0.0 AND InvoiceNo NOT LIKE 'A%'
GROUP BY CustomerID);


--9: What are the top 10 products that had the most quantity sold?
SELECT StockCode, Description, sum(Quantity) as "Quantity sold"
FROM Online_Retail
WHERE InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0
GROUP BY StockCode, Description
ORDER BY sum(Quantity) DESC
LIMIT 10;


--10: What is the cancelled sales as a percentage of valid sale revenue?
SELECT round((100.0 * sum(CASE WHEN InvoiceNo LIKE 'C%' THEN abs(Quantity * UnitPrice) ELSE 0 END)/
        sum(CASE WHEN InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0
        THEN Quantity * UnitPrice ELSE 0 END)), 2)
         as "Percentage of Revenue Lost"
FROM Online_Retail;


--11: Which products have a cancellation rate greater than 10 percent?
SELECT StockCode, Description, "Cancellation Rate"
FROM (SELECT StockCode, Description, 
        (1.0*count(DISTINCT CASE WHEN InvoiceNo LIKE 'C%' THEN InvoiceNo END)
        /NULLIF(count(DISTINCT CASE WHEN InvoiceNo NOT LIKE 'A%' AND (InvoiceNo LIKE 'C%' OR UnitPrice * Quantity >0.0)
         THEN InvoiceNo END), 0))*100.0 as "Cancellation Rate"
    FROM Online_Retail
    GROUP BY StockCode, Description
    ORDER BY "Cancellation Rate" DESC)
WHERE "Cancellation Rate" > 10.0;


--12: What is the average order value (Excluding invalid orders)?
SELECT round(sum(Quantity*UnitPrice)/count(DISTINCT InvoiceNo), 2) as "Average Order Value"
FROM Online_Retail
WHERE InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice * Quantity >0.0;


--13: What is the order value distribution (Excluding invalid orders)?
SELECT round(CAST(percentile_cont(0.0) WITHIN GROUP (ORDER BY OrderValue) AS numeric), 2) as "Minimum Order Value",
    round(CAST(percentile_cont(0.10) WITHIN GROUP (ORDER BY OrderValue) AS numeric), 2) as "10% quantile",
    round(CAST(percentile_cont(0.25) WITHIN GROUP (ORDER BY OrderValue) AS numeric), 2) as "25% quantile",
    round(CAST(percentile_cont(0.50) WITHIN GROUP (ORDER BY OrderValue) AS numeric), 2) as "50% quantile",
    round(CAST(percentile_cont(0.75) WITHIN GROUP (ORDER BY OrderValue) AS numeric), 2) as "75% quantile",
    round(CAST(percentile_cont(0.90) WITHIN GROUP (ORDER BY OrderValue) AS numeric), 2) as "90% quantile",
    round(CAST(percentile_cont(1.0) WITHIN GROUP (ORDER BY OrderValue) AS numeric), 2) as "Maximum Order Value"

FROM (SELECT InvoiceNo, sum(Quantity * UnitPrice) as OrderValue
    FROM Online_retail
    WHERE InvoiceNo NOT LIKE 'C%' AND InvoiceNo NOT LIKE 'A%' AND UnitPrice*Quantity > 0 
    GROUP BY InvoiceNo);






