# Online Retail SQL Analysis
## Project Overview

This project analyzes transaction-level retail sales data using PostgreSQL. The goal is to answer business questions related to revenue trends, product performance, customer behavior, order value distribution, and cancellations.

The project uses SQL to clean, aggregate, and analyze the data. The final results are saved in `results.txt`.

## Dataset

The dataset used is the **UCI Online Retail dataset**, which contains transactions from a UK-based online retailer between December 2010 and December 2011.

The dataset includes the following fields:

- `InvoiceNo`
- `StockCode`
- `Description`
- `Quantity`
- `InvoiceDate`
- `UnitPrice`
- `CustomerID`
- `Country`

Citation: Chen, D. (2015). Online Retail [Dataset]. UCI Machine Learning Repository. https://doi.org/10.24432/C5BW33.

## Tools Used

- PostgreSQL
- SQL
- VS Code
- Terminal / psql

## Data Cleaning Assumptions

For valid sales analysis, I excluded:

- Cancellation invoices where `InvoiceNo` starts with `C`
- Account adjustment invoices where `InvoiceNo` starts with `A`
- Rows where `Quantity * UnitPrice <= 0`

For customer-level analysis, I only included transactions where `CustomerID` is not missing.

Cancellation-related queries were handled separately so that cancellations could still be analyzed without mixing them into valid sales revenue.

## Business Questions Answered

This project answers the following questions:
# Revenue
1. What was the monthly revenue in the given time period?
2. What is the total value sales revenue generated in this time period?
3. What are the top 10 products that generated the most revenue?
4. What are the revenues generated for each country?

# Customers
5. What percentage of the total revenue came from the top 10 customers by revenue?
6. What are the top 10 customers (recorded) that had the most orders?
7. What are the top 10 customers (recorded) that generated the most revenue?
8. What is the customer (Recorded) repeat purchase rate?

# Quantity
9. What are the top 10 products that had the most quantity sold?

# Cancellations
10. What is the cancelled sales as a percentage of valid sale revenue?
11. Which products have a cancellation rate greater than 10 percent?

# Order Values
12. What is the average order value (Excluding invalid orders)?
13. What is the order value distribution (Excluding invalid orders)?

## Key Findings
- The total valid revenue is **£10655622.48**.
- Sales were distributed across 38 countries, with vast majority of valid revenue is generated domestically, from the United Kingdom.
- The top 10 recorded customers contributed to **17.26%** of total valid revenue.
- **65.58%** of recorded customers have made repeating purchases, indicating strong customer retention.
- Cancelled orders account for **8.42%** of total valid revenue.
- A total of **132** product have order cancellation rate higher than **10%**, which could indicate inaccurate description and/or product quality issues.
- The valid order have an average order value of **£533.88**, with the following quantiles: Minimum: **£0.38**, **10%**: **£69.35**, **25%**: **£152.49**, **50%**: **£303.83**, **75%**: **£495.50**, **90%**: **£940.70**, Maximum: **£168469.60**, we see that the order value distribution is right-skewed.
- [View the interactice dashboard on Tableau Public](https://public.tableau.com/app/profile/owen.ling/viz/UCIOnlineRetailerAnalysisDashboard/OnlineRetalierAnalysisDashboard)
Here is a Preview: [Online Retalier Analysis Dashboard.pdf](https://github.com/user-attachments/files/29224701/Online.Retalier.Analysis.Dashboard.pdf)



## Recommendations
- A customer loyalty program should be considered given the high returning customer rate, such as giving discounts to orders for returning customers.
- Conducting product audit for products that have cancellation rate higher than 10%.
- Conduct more marketing/advertising in Netherlands, EIRE, Germany, and France, to expand the international market.
