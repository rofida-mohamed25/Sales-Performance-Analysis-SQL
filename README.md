# Sales Performance Analysis using SQL Server

## Project Overview

This project analyzes sales data using **SQL Server** to understand sales performance, customer purchasing behavior, product performance, and data quality.

The analysis focuses on answering practical business questions and extracting insights that can support data-driven decisions.

---

## Business Objectives

- Analyze overall sales performance over time.
- Identify the highest-value customers.
- Identify the top-performing products within each category.
- Examine order and customer activity.
- Perform data quality checks before analysis.
- Practice SQL techniques used in real-world Data Analyst tasks.

---

## Tools & Technologies

- **SQL Server**
- **SQL Server Management Studio (SSMS)**
- **SQL**

### SQL Concepts Used

- SELECT / WHERE / ORDER BY
- DISTINCT
- Aggregate Functions
- GROUP BY / HAVING
- JOINs
- CASE WHEN
- Subqueries
- CTEs
- Window Functions
- RANK() / PARTITION BY
- Data Quality Checks
- Date Filtering

---

## Database Schema

The database contains the following main tables:

- Customers
- Orders
- OrdersDetails
- Product
- Categories
- Suppliers
- Shippers
- Employees
- 
---

## Business Questions

The analysis answers questions such as:

1. Which customers generate the highest total purchases?
2. How do total sales change across years?
3. What is the top-selling product in each category?
4. Which products have sales above a specific threshold?
5. Are there duplicate orders or duplicate order details?
6. Are there missing shipment dates?
7. Are there orders without a matching customer?
8. Which products have prices above the average product price?

---

## Key Insights

### 1. Top 5 Customers

The highest-value customer was **Save-a-lot Markets**, with total purchases of approximately **54.62K**.

The top five customers were:

| Rank | Customer | Total Purchases |
|---|---|---:|
| 1 | Save-a-lot Markets | 54,615.59 |
| 2 | QUICK-Stop | 54,570.29 |
| 3 | Ernst Handel | 51,897.00 |
| 4 | Rattlesnake Canyon Grocery | 45,324.05 |
| 5 | Königlich Essen | 25,488.11 |

**Business Insight:** The top customers contribute a significant share of sales, making customer retention and account management important areas for the business.

---

### 2. Sales Performance by Year

| Year | Total Sales |
|---|---:|
| 1996 | 105,731.60 |
| 1997 | 375,480.32 |
| 1998 | 269,486.69 |

**Business Insight:** Sales increased significantly from 1996 to 1997. Sales in 1998 remained higher than 1996 but were lower than the 1997 peak.

---

### 3. Top Product in Each Category

| Category | Top Product | Total Sales |
|---|---|---:|
| Beverages | Côte de Blaye | 79,577.00 |
| Condiments | Vegie-spread | 12,044.60 |
| Confections | Tarte au sucre | 32,081.50 |
| Dairy Products | Raclette Courdavault | 41,965.00 |
| Grains/Cereals | Gnocchi di nonna Alice | 27,185.20 |
| Meat/Poultry | Thüringer Rostbratwurst | 49,413.16 |
| Produce | Manjimup Dried Apples | 22,302.40 |
| Seafood | Carnarvon Tigers | 15,737.50 |

**Business Insight:** Côte de Blaye was the strongest product within the Beverages category, generating approximately 79.6K in sales.

---

## Data Quality Checks

Before analyzing the data, several validation checks were performed.

| Check | Result |
|---|---|
| Duplicate OrderIDs | No duplicates detected |
| Duplicate OrderID + ProductID | No duplicates detected |
| Missing ShippedDate | 21 orders |
| Orders without matching Customer | No unmatched orders detected |

### Data Quality Insight

The main issue identified was **21 orders with missing `ShippedDate` values**. These records should be investigated to determine whether the orders had not been shipped yet or whether shipment information was incomplete.

No duplicate orders or unmatched customer relationships were detected.

---

## Project Structure

```text
Sales-Performance-Analysis-SQL/
│
├── README.md
├── SalesAnalysis_ERD.png
│
├── SQL/
│   └── Sales_Analysis.sql
│
├── Top_5_Customers.png.jpg
├── Yearly_Sales.png.jpg
└── Top_Product_Per_Category.png.jpg
```

---

## Conclusion

This project demonstrates the use of SQL Server to perform a complete sales analysis workflow, including data exploration, business analysis, advanced SQL techniques, and data quality validation.

The project was designed to simulate practical tasks that a **Junior Data Analyst** may perform when working with relational business data.
