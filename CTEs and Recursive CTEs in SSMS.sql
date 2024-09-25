/*
CTEs/Recursive CTEs Exercises in SSMS
*/

/*
Construct a query that identifies the top 10 sales orders per month, aggregates these into a sum total (by month), and then compares each month's total to the previous month, on the same row, using nested subqueries.
*/

SELECT
	A.OrderMonth,
	A.Top10Total,
	PrevTop10Total = B.Top10Total
FROM
(
	SELECT
		OrderMonth,
		Top10Total = SUM(TotalDue)
	FROM (
		SELECT
			OrderDate,
			TotalDue,
			OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate),1),
			OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM
			Sales.SalesOrderHeader
		) x

	WHERE 
		OrderRank <= 10

	GROUP BY 
		OrderMonth
	) a

	LEFT JOIN

	(
	SELECT
		OrderMonth,
		Top10Total = SUM(TotalDue)
	FROM (
		SELECT
			OrderDate,
			TotalDue,
			OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate),1),
			OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM
			Sales.SalesOrderHeader
		) x

	WHERE 
		OrderRank <= 10

	GROUP BY 
		OrderMonth
	) b ON A.OrderMonth = DATEADD(MONTH, 1, B.OrderMonth) 

ORDER BY 1



/*
Refactor your previous query using CTEs.
*/

WITH Sales AS (
	SELECT
		OrderDate,
		TotalDue,
		OrderMonth = DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate),1),
		OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate), MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	FROM
		Sales.SalesOrderHeader
),

Top10 AS (
	SELECT
		OrderMonth,
		Top10Total = SUM(TotalDue)
	FROM 
		Sales
	WHERE 
		OrderRank <= 10

	GROUP BY 
		OrderMonth
)

SELECT
	A.OrderMonth,
	A.Top10Total,
	PrevTop10Total = B.Top10Total
FROM
	Top10 A
		LEFT JOIN Top10 B
			ON A.OrderMonth = DATEADD(MONTH, 1, B.OrderMonth) 
			
ORDER BY 1



/*
For this exercise, assume the CEO of our fictional company decided that the top 10 orders per month are actually outliers that need to be clipped out of our data before doing meaningful analysis.
Further, she would like the sum of sales AND purchases (minus these "outliers") listed side by side, by month.
*/

WITH Sales AS (
SELECT 
        OrderDate,
	OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
        TotalDue,
	OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM 
	Sales.SalesOrderHeader
),

SalesMinusTop10 AS (
	SELECT
		OrderMonth,
		TotalSales = SUM(TotalDue)
	FROM 
		Sales
	WHERE 
		OrderRank > 10
	GROUP BY 
		OrderMonth

),

Purchases AS (
	SELECT 
		OrderDate,
		OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
		TotalDue,
		OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	FROM Purchasing.PurchaseOrderHeader
),

PurchasesMinusTop10 AS (
	SELECT
		OrderMonth,
		TotalPurchases = SUM(TotalDue)
	FROM 
		Purchases
	WHERE 
		OrderRank > 10
	GROUP BY
		OrderMonth
)


SELECT
	A.OrderMonth,
	A.TotalSales,
	B.TotalPurchases

FROM SalesMinusTop10 A
	LEFT JOIN PurchasesMinusTop10 B
		ON A.OrderMonth = B.OrderMonth

ORDER BY 1



/*
Use a recursive CTE to generate a list of all odd numbers between 1 and 100.
*/

WITH OddNumberSeries AS (
	SELECT 
		1 AS MyNumber

	UNION ALL
		
	SELECT 
		MyNumber +2
	FROM
		OddNumberSeries
	WHERE
		MyNumber < 100
)

SELECT
	MyNumber
FROM 
	OddNumberSeries;


/*
Use a recursive CTE to generate a date series of all FIRST days of the month (1/1/2021, 2/1/2021, etc.)
from 1/1/2020 to 12/1/2029.
*/

WITH DateSeries AS (
	SELECT 
		CAST('01-01-2021' AS DATE) AS MyDate

	UNION ALL
		
	SELECT 
		DATEADD(MONTH, 1, MyDate)
	FROM
	 	DateSeries
	WHERE
		MyDate < CAST('12-01-2021' AS DATE)
)

SELECT
	MyDate
FROM 
	 DateSeries
OPTION(MAXRECURSION 12);
