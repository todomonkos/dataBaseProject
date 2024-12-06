-- CREATING VIEWS FOR THE KPIs

-- FINANCIAL PERSPECTIVE
-- Total Sales and Revenue
CREATE VIEW kpi_total_sales_revenue AS
SELECT 
    SUM(total_revenue) AS total_sales,
    SUM(total_profit) AS total_profit
FROM fact_sales;

-- Profitability (MSRP Markup)
CREATE VIEW kpi_profitability AS
SELECT 
    dim_products.productLine,
    ROUND((AVG(dim_products.MSRP) - AVG(fact_sales.unit_price)) / AVG(dim_products.MSRP) * 100, 2) AS profitability_percentage
FROM fact_sales
JOIN dim_products ON fact_sales.productCode = dim_products.productCode
GROUP BY productLine;

-- Quarterly/Monthly Sales Trends 
CREATE VIEW kpi_monthly_sales_trends AS
SELECT 
    YEAR(orderDate) AS year,
    MONTH(orderDate) AS month,
    SUM(total_revenue) AS total_sales,
    SUM(total_profit) AS total_profit
FROM fact_sales
GROUP BY YEAR(orderDate), MONTH(orderDate);

-- Total Sales Volume by Region
CREATE VIEW kpi_sales_volume_region AS
SELECT 
    dr.country,
    dr.city,
    SUM(fs.total_revenue) AS total_sales
FROM fact_sales fs
JOIN dim_regions dr ON fs.officeCode = dr.officeCode
GROUP BY dr.country, dr.city;

-- Sales Volume by Product Line
CREATE VIEW kpi_sales_volume_product_line AS
SELECT 
    dim_products.productLine,
    SUM(total_revenue) AS total_sales,
    COUNT(*) AS total_orders
FROM fact_sales
JOIN dim_products ON fact_sales.productCode = dim_products.productCode
GROUP BY productLine;

-- Revenue per Order
CREATE VIEW kpi_revenue_per_order AS
SELECT 
    orderNumber,
    SUM(total_revenue) AS revenue_per_order
FROM fact_sales
GROUP BY orderNumber;

-- Best and Worst Performing Products
CREATE VIEW kpi_best_worst_products AS
SELECT 
    dp.productName,
    SUM(fs.total_revenue) AS total_sales
FROM fact_sales fs
JOIN dim_products dp ON fs.productCode = dp.productCode
GROUP BY dp.productName
ORDER BY total_sales DESC;

-- CUSTOMER PERSPECTIVE