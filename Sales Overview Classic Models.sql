/*
-- In this project, I complete a sales analysis for the Classic Models sample database. 
*/

/*
-- #1. Provide a sales overview for the year 2004. Include a breakdown of product, country, and city, while also including the sales value, cost of sales, and net profit. 
*/

SELECT 
    o.orderdate,
    od.ordernumber,
    od.quantityordered,
    od.priceeach,
    p.productname,
    p.productline,
    p.productcode,
    p.buyprice,
    c.city,
    c.country
FROM 
    products p
INNER JOIN 
    orderdetails od ON od.productcode = p.productcode
INNER JOIN 
    orders o ON o.ordernumber = od.ordernumber
INNER JOIN 
    customers c ON c.customernumber = o.customernumber
WHERE 
    YEAR(o.orderdate) = 2004
ORDER BY 
    od.ordernumber ASC;


/*
-- #2. Provide a breakdown of products that are commonly purchased together, and any products that are rarely purchased together.
*/

WITH product_sales AS (
    SELECT 
        ordernumber, 
        od.productcode, 
        p.productline
    FROM
        orderdetails od
    INNER JOIN 
        products p ON od.productcode = p.productcode
)

SELECT DISTINCT
    t1.ordernumber,
    t1.productline AS product_one,
    t2.productline AS product_two
FROM
    product_sales t1
LEFT JOIN 
    product_sales t2 ON t1.ordernumber = t2.ordernumber
    AND t1.productline <> t2.productline;


/*
-- #3. Break down sales data by grouping customer credit limits into ranges. Maybe look for a pattern where higher credit limits are linked to higher sales. 
*/

WITH sales AS (
    SELECT 
        o.ordernumber,
        c.customernumber,
        od.productcode,
        od.quantityordered,
        od.priceeach,
        (od.priceeach * od.quantityordered) AS salesvalue,
        c.creditlimit
    FROM
        customers c
    INNER JOIN 
        orders o ON o.customernumber = c.customernumber
    INNER JOIN 
        orderdetails od ON od.ordernumber = o.ordernumber
)

SELECT 
    ordernumber,
    customernumber,
    CASE
        WHEN creditlimit < 75000 THEN 'a: Less than $75k'
        WHEN creditlimit BETWEEN 75000 AND 100000 THEN 'b: $75k to 100k'
        WHEN creditlimit BETWEEN 100000 AND 150000 THEN 'c: $100k to 150k'
        WHEN creditlimit > 150000 THEN 'd: Over $150k'
        ELSE 'Other'
    END AS creditlimit_group,
    SUM(salesvalue) AS salesvalue
FROM 
    sales
GROUP BY 
    ordernumber, customernumber, creditlimit_group;


/*
-- #4. Create a view demonstrating customer sales and include a column which shows the difference in value from their previous sale. Determine whether new customers making their first purchase are likely to spend more. 
*/

WITH main_cte AS (
    SELECT 
        ordernumber,
        orderdate,
        customernumber,
        SUM(salesvalue) AS salesvalue
    FROM (
        SELECT 
            o.ordernumber,
            o.orderdate,
            c.customernumber,
            (od.quantityordered * od.priceeach) AS salesvalue
        FROM
            orders o
        INNER JOIN 
            orderdetails od ON od.ordernumber = o.ordernumber
        INNER JOIN 
            customers c ON c.customernumber = o.customernumber
    ) main
    GROUP BY 
        ordernumber, 
        orderdate, 
        customernumber
),

sales_query AS (
    SELECT 
        t1.*, 
        t2.customername, 
        ROW_NUMBER() OVER (PARTITION BY t2.customername ORDER BY t1.orderdate) AS purchasenumber,
        LAG(t1.salesvalue) OVER (PARTITION BY t2.customername ORDER BY t1.orderdate) AS prevsalesvalue
    FROM 
        main_cte t1
    INNER JOIN 
        customers t2 ON t1.customernumber = t2.customernumber
)

SELECT 
    *, 
    (salesvalue - prevsalesvalue) AS purchase_value_change
FROM 
    sales_query
WHERE 
    prevsalesvalue IS NOT NULL;


/*
-- #5. Provide a view of where the customers of each office are located. 
*/

WITH main_cte AS (
    SELECT 
        c.customernumber, 
        c.customername, 
        c.city AS customercity,
        c.country AS customercountry,
        c.state AS customerstate,
        e.officecode,
        o1.ordernumber,
        (od.quantityordered * od.priceeach) AS salesvalue,
        p.productcode,
        p.productline,
        o.city AS officecity,
        o.state AS officestate,
        o.country AS officecountry
    FROM
        customers c
    INNER JOIN employees e ON e.employeenumber = c.salesrepemployeenumber
    INNER JOIN offices o ON o.officecode = e.officecode
    INNER JOIN orders o1 ON o1.customernumber = c.customernumber
    INNER JOIN orderdetails od ON od.ordernumber = o1.ordernumber
    INNER JOIN products p ON p.productcode = od.productcode
)

SELECT
    ordernumber,
    customercity,
    customercountry, 
    productline, 
    officecity,
    officecountry, 
    SUM(salesvalue) AS salesvalue
FROM 
    main_cte
GROUP BY
    ordernumber,
    customercity,
    customercountry,
    productline,
    officecity,
    officecountry;
    

/*
-- #6. Due to weather, some shipments could take up to 3 days to arrive. Provide a list of affected orders.
*/

SELECT 
    *,
    DATE_ADD(shippeddate, INTERVAL 3 DAY) AS latestarrival,
    CASE
        WHEN DATE_ADD(shippeddate, INTERVAL 3 DAY) > requireddate THEN 1
        ELSE 0
    END AS lateflag
FROM 
    orders
WHERE 
    CASE
        WHEN DATE_ADD(shippeddate, INTERVAL 3 DAY) > requireddate THEN 1
        ELSE 0
    END = 1;


/*
-- #7. Provide a breakdown of each customer and their sales, but include a "money owed column" to include any clients that have exceeded their credit limit.
*/

WITH cte_sales AS (
    SELECT 
        o.orderdate,
        od.ordernumber,
        c.customernumber,
        c.customername,
        od.productcode,
        c.creditlimit,
        (od.quantityordered * od.priceeach) AS salesvalue
    FROM 
        orders o
    INNER JOIN 
        orderdetails od ON od.ordernumber = o.ordernumber
    INNER JOIN 
        customers c ON o.customernumber = c.customernumber
),

runningTotalSales AS (
    SELECT 
        *,
        LEAD(orderdate) OVER (PARTITION BY customernumber ORDER BY orderdate) AS nextorderdate
    FROM (
        SELECT 
            orderdate,
            ordernumber,
            customernumber,
            customername,
            creditlimit,
            SUM(salesvalue) AS salesvalue
        FROM 
            cte_sales
        GROUP BY 
            orderdate,
            ordernumber,
            customernumber,
            customername,
            creditlimit
    ) subquery
),

cte_payments AS (
    SELECT *
    FROM 
        payments
),

main_cte AS (
    SELECT 
        t1.*,
        SUM(salesvalue) OVER (PARTITION BY t1.customernumber ORDER BY t1.orderdate) AS runningtotalsales,
        SUM(amount) OVER (PARTITION BY t1.customernumber ORDER BY t1.orderdate) AS runningtotalpayments
    FROM 
        runningTotalSales t1
    LEFT JOIN 
        cte_payments t2 ON t1.customernumber = t2.customernumber 
        AND t2.paymentdate BETWEEN t1.orderdate AND 
            CASE 
                WHEN t1.nextorderdate IS NULL THEN CURRENT_DATE() 
                ELSE t1.nextorderdate 
            END
)

SELECT 
    *,
    (runningtotalsales - runningtotalpayments) AS moneyowed,
    (creditlimit - (runningtotalsales - runningtotalpayments)) AS difference
FROM 
    main_cte;
