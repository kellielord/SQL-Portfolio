--Questions provided by https://www.richardtwatson.com/open/Reader/ClassicModels.html 
--Questions answered using MySQL Workbench with the Classic Models Database

-- Prepare a list of offices sorted by country, state, city.

SELECT 
    officeCode,
    country,
    state,
    city
FROM 
	offices
ORDER BY
    country,
    state,
    city;


-- How many employees are there in the company?

SELECT 
    COUNT(DISTINCT employeeNumber)
FROM
    employees;


-- What is the total of payments received?

SELECT 
     SUM(amount)
FROM 
     payments;


-- List the product lines that contain 'Cars'.

SELECT DISTINCT
    productLine
FROM
    products
WHERE productLine LIKE '%Cars%';


-- Report total payments for October 28, 2004.

SELECT 
    SUM(amount) AS total
FROM
    payments
WHERE
    paymentDate >= '2004-10-28 00:00:00'
    AND paymentDate < '2004-10-29 00:00:00';


-- Report those payments greater than $100,000.

SELECT 
    paymentDate,
    amount
FROM
    payments
WHERE
    amount > 100000


-- List the products in each product line.

SELECT 
    productLine,
    productName
FROM
    products
ORDER BY
    productLine, 
    productName;


-- How many products in each product line?

SELECT 
    productLine,
    COUNT(*) AS products
FROM
    products
GROUP BY 
    productLine
ORDER BY 
    productLine;



-- What is the minimum payment received?

SELECT 
    MIN(amount) AS minPayment
FROM
    payments;


-- List all payments greater than twice the average payment.

SELECT 
    paymentDate,
    amount
FROM
    payments
WHERE 
    amount > 2 * (SELECT AVG(amount) FROM payments)
ORDER BY 
    amount;



-- What is the average percentage markup of the MSRP on buyPrice?

SELECT 
    AVG((MSRP - buyPrice) / buyPrice * 100) AS avgMarkup
FROM 
    products;


-- How many distinct products does ClassicModels sell?

SELECT 
     COUNT(DISTINCT productCode) AS distinctProducts
FROM
     products;


-- Report the name and city of customers who don't have sales representatives?

SELECT 
    customerNumber, 
    customerName, 
    city,
    salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL


-- What are the names of executives with VP or Manager in their title? Use the CONCAT function to combine the employee's first name and last name into a single field for 
reporting.

SELECT 
    CONCAT(firstName, " ", lastName, ", ", jobTitle) AS title
FROM
    employees
WHERE 
    jobTitle LIKE '%VP%' OR jobTitle LIKE '%Manager%'


-- Which orders have a value greater than $5,000?

SELECT 
    orderNumber,
    quantityOrdered,
    priceEach,
    (quantityOrdered * priceEach) AS total
FROM
    orderdetails
WHERE
    (quantityOrdered * priceEach) >= 5000
ORDER BY total;
        
