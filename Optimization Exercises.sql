/*
SQL Optimization Exercises
These exercises demonstrate my skills in SQL optimization using techniques including temporary tables,
UPDATE statements, indexed queries, and variables. The exercises showcase my ability to solve complicated
data problems and contribute to improved database management and efficiency. 
*/

/*
Making use of temp tables and UPDATE statements, re-write an optimized version of the following query:

SELECT 
       A.BusinessEntityID
      ,A.Title
      ,A.FirstName
      ,A.MiddleName
      ,A.LastName
      ,B.PhoneNumber
      ,PhoneNumberType = C.Name
      ,D.EmailAddress

FROM AdventureWorks2019.Person.Person A
	LEFT JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID
	LEFT JOIN AdventureWorks2019.Person.PhoneNumberType C
		ON B.PhoneNumberTypeID = C.PhoneNumberTypeID
	LEFT JOIN AdventureWorks2019.Person.EmailAddress D
		ON A.BusinessEntityID = D.BusinessEntityID
*/

CREATE TABLE #ContactInfo (
	BusinessEntityID INT,
	Title VARCHAR(32),
	FirstName VARCHAR(32),
	MiddleName VARCHAR(32),
	LastName VARCHAR(32),
	PhoneNumber VARCHAR(25),
	PhoneNumberTypeID VARCHAR(25),
	PhoneNumberType VARCHAR(50),
	EmailAddress VARCHAR(50)
)

INSERT INTO #ContactInfo (
	BusinessEntityID,
	Title,
	MiddleName,
	FirstName,
	LastName
)

SELECT 
    BusinessEntityID,
    Title,
    FirstName,
    MiddleName,
		LastName
FROM Person.Person 

UPDATE A 
	SET 
		PhoneNumber = B.PhoneNumber,
		PhoneNumberTypeID = B.PhoneNumberTypeID
	FROM
		#ContactInfo A 
	INNER JOIN Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID

UPDATE A 
	SET 
		PhoneNumberType = B.Name
	FROM
		#ContactInfo A
	INNER JOIN Person.PhoneNumberType B
		ON A.PhoneNumberTypeID = B.PhoneNumberTypeID		

UPDATE A
	SET 
		EmailAddress = B.EmailAddress
	FROM
		#ContactInfo A

	LEFT JOIN Person.EmailAddress B
		ON A.BusinessEntityID = B.BusinessEntityID

SELECT 
	*
FROM
	#ContactInfo


/*
Using indexes, further optimize your solution to the "Optimizing With UPDATE" exercise. 
*/

CREATE TABLE #ContactInfo (
	BusinessEntityID INT,
	Title VARCHAR(32),
	FirstName VARCHAR(32),
	MiddleName VARCHAR(32),
	LastName VARCHAR(32),
	PhoneNumber VARCHAR(25),
	PhoneNumberTypeID VARCHAR(25),
	PhoneNumberType VARCHAR(50),
	EmailAddress VARCHAR(50)
)

INSERT INTO #ContactInfo (
	BusinessEntityID,
	Title,
	MiddleName,
	FirstName,
	LastName
)

SELECT 
	    BusinessEntityID,
        Title,
        FirstName,
        MiddleName,
		LastName
FROM Person.Person 

CREATE CLUSTERED INDEX ContactInfoIdx ON #ContactInfo(BusinessEntityID)

UPDATE A 
	SET 
		PhoneNumber = B.PhoneNumber,
		PhoneNumberTypeID = B.PhoneNumberTypeID
	FROM
		#ContactInfo A 
	INNER JOIN Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID

CREATE NONCLUSTERED INDEX ContactInfoIdx2 ON #ContactInfo(PhoneNumberTypeID)

UPDATE A 
	SET 
		PhoneNumberType = B.Name
	FROM
		#ContactInfo A
	INNER JOIN Person.PhoneNumberType B
		ON A.PhoneNumberTypeID = B.PhoneNumberTypeID		


UPDATE A
	SET 
		EmailAddress = B.EmailAddress
	FROM
		#ContactInfo A

	LEFT JOIN Person.EmailAddress B
		ON A.BusinessEntityID = B.BusinessEntityID

SELECT 
	*
FROM
	#ContactInfo


/*
Create a view named vw_Top10MonthOverMonth in your AdventureWorks database, based on the query below. Assign the view to the Sales schema.

WITH Sales AS
(
SELECT
OrderDate
,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
,TotalDue
,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
)
,Top10Sales AS
(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth
)
SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total
 
FROM Top10Sales A
LEFT JOIN Top10Sales B
ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)
ORDER BY 1
*/

CREATE VIEW SalesTop10MoM AS 

WITH Sales AS (
	SELECT 
		OrderDate,
		OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1),
		TotalDue,
		OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	FROM
		Sales.SalesOrderHeader
		),

Top10Sales AS (
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
	Top10Sales A

LEFT JOIN Top10Sales B
	ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)
 

/*
Refactor the provided code to utilize variables instead of embedded scalar subqueries.

SELECT
	BusinessEntityID
	,JobTitle
	,VacationHours
	,MaxVacationHours = (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)
	  ,PercentOfMaxVacationHours = (VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee)

FROM AdventureWorks2019.HumanResources.Employee

WHERE (VacationHours * 1.0) / (SELECT MAX(VacationHours) FROM AdventureWorks2019.HumanResources.Employee) >= 0.8
*/

DECLARE @MaxVacationHrs FLOAT
SET @MaxVacationHrs =  (SELECT MAX(VacationHours) FROM HumanResources.Employee)

SELECT
	   BusinessEntityID,
     JobTitle,
     VacationHours,
	   MaxVacationHours = @MaxVacationHrs,
	   PercentOfMaxVacationHours = (VacationHours * 1.0) / @MaxVacationHrs

FROM HumanResources.Employee

WHERE VacationHours * 1.0 / @MaxVacationHrs >= 0.8
