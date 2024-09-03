/*
-- Questions provided by SQLZoo - https://sqlzoo.net/wiki/AdventureWorks
-- Queried in SQL Server Management Studio using the AdventureWorks 2022 database.
*/


/*
-- #1. Show the first name and the email address of customer with CompanyName 'Bike World'
*/

SELECT 
	CustomerID,
	Name AS businessName,
	p.FirstName AS customerName,
	ea.EmailAddress AS customerEmail

FROM sales.customer c

INNER JOIN sales.store st
	ON c.StoreID = st.BusinessEntityID

INNER JOIN person.person p
	ON p.BusinessEntityID = c.PersonID

INNER JOIN person.EmailAddress ea
	ON ea.BusinessEntityID = c.PersonID

WHERE Name = 'Bike World';

/*
-- Result:
+------------+-------------+-------------+-------------------------------+
| CustomerID | BusinessName | CustomerName |        CustomerEmail        |
+------------+-------------+-------------+-------------------------------+
|   29809    |  Bike World  |    Kerim     | kerim0@adventure-works.com  |
+------------+-------------+-------------+-------------------------------+
*/


/*
-- #2. Show the CompanyName for all customers with an address in City 'Dallas'.
*/

SELECT 
	ad.City AS businessCity,
	st.Name AS businessName

FROM sales.customer c

INNER JOIN sales.store st
	ON c.StoreID = st.BusinessEntityID

INNER JOIN person.BusinessEntityAddress bea
	ON st.BusinessEntityID = bea.AddressID

INNER JOIN person.Address ad
	ON bea.AddressID = ad.AddressID

WHERE City = 'Dallas'

GROUP BY 
	st.Name,
	ad.City
;


/*
-- Result:
+-------------+-----------------+
| businessCity | businessName   |
+-------------+-----------------+
| Dallas      | Bike Universe   |
| Dallas      | Channel Outlet  |
| Dallas      | Fifth Bike Store|
+-------------+-----------------+
*/


/*
-- #3. How many items with ListPrice more than $1000 have been sold?
*/

SELECT 
	SUM(sod.OrderQty) AS Total

FROM sales.SalesOrderDetail sod

INNER JOIN Production.Product p ON 
	p.ProductID = sod.ProductID

WHERE p.ListPrice > 1000;

/*
-- Result:
+-------+
| Total |
+-------+
| 64940 |
+-------+
*/


/*
-- #4. Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight.
*/

SELECT 
	c.CustomerID,
	s.Name,
	SUM(soh.SubTotal + soh.TaxAmt + soh.Freight) AS totalPurchased
	
FROM sales.Customer c

INNER JOIN  sales.SalesOrderHeader soh
	ON c.CustomerID = soh.CustomerID

INNER JOIN sales.SalesOrderDetail sod
	ON soh.SalesOrderID = sod.SalesOrderID

INNER JOIN sales.Store s
	ON s.BusinessEntityID = c.StoreID

	WHERE (soh.SubTotal + soh.TaxAmt + soh.Freight) > 100000

GROUP BY 
    c.CustomerID,
    s.Name

ORDER BY 
    totalPurchased DESC;

/*
-- Result (limited to 10 rows):
+-----------+------------------------------+-------------------+
| CustomerID | Name                        |  totalPurchased   |
+-----------+------------------------------+-------------------+
| 29641     | Westside Plaza               | 31497626.5716     |
| 29701     | Outdoor Equipment Store      | 27997622.1201     |
| 29913     | Field Trip Store             | 20946237.681      |
| 29616     | Sheet Metal Manufacturing    | 18609627.8608     |
| 29646     | Fitness Toy Store            | 17871356.367      |
| 29923     | Roadway Bicycle Supply       | 17777330.4011     |
| 30074     | Tenth Bike Store             | 17299519.9214     |
| 29715     | Excellent Riding Supplies    | 17284546.2819     |
| 29716     | Farthermost Bike Shop        | 16894853.0341     |
| 30103     | Metropolitan Equipment       | 16721970.9152     |
+-----------+------------------------------+-------------------+
*/

/*
-- #5. Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'
*/

SELECT 

	st.Name AS companyName,
	p.Name AS productName,
	SUM(sod.OrderQty) AS totalPurchased
 
FROM sales.Customer c

INNER JOIN sales.SalesOrderHeader soh
	ON soh.CustomerID = c.CustomerID

INNER JOIN sales.SalesOrderDetail sod
	ON sod.SalesOrderID = soh.SalesOrderID

INNER JOIN Production.Product p
	ON p.ProductID = sod.ProductID

INNER JOIN sales.Store st
	ON st.BusinessEntityID = c.StoreID

WHERE p.Name = 'Racing Socks, L' AND st.Name = 'Riding Cycles'

GROUP BY 
	st.Name,
	p.Name

/*
-- Result:
+----------------+-------------------+----------------+
| CompanyName    | ProductName       | totalPurchased |
+----------------+-------------------+----------------+
| Riding Cycles  | Racing Socks, L   | 13             |
+----------------+-------------------+----------------+
*/



