/*
Data Science Salaries Analysis Project
Analyzed in pgAdmin using PostgreSQL

- Dataset: Data Science Salaries 2023 on Kaggle
*/

/*
1. Average, median, and range of global data science salaries by employment type. 
*/

SELECT 
    employment_type, 
    ROUND(AVG(salary_in_usd),2) AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd) AS median_salary,
    MAX(salary_in_usd) - MIN(salary_in_usd) AS salary_range
FROM ds_salaries

GROUP BY 
    employment_type

ORDER BY 
   employment_type,
   avg_salary;

/* Result:
+------------------+--------------+---------------+--------------+
| employment_type  | avg_salary   | median_salary | salary_range |
+------------------+--------------+---------------+--------------+
| CT               | 113,446.90   | 75,000        | 408,500      |
| FL               | 51,807.80    | 50,000        | 88,000       |
| FT               | 138,328.32   | 135,000       | 444,868      |
| PT               | 39,533.71    | 21,669        | 119,995      |
+------------------+--------------+---------------+--------------+
*/


/*
2. Average, median, and range of global data science salaries by experience level. 
*/

SELECT 
    experience_level, 
    ROUND(AVG(salary_in_usd),2) AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd) AS median_salary,
    MAX(salary_in_usd) - MIN(salary_in_usd) AS salary_range
FROM ds_salaries

GROUP BY 
    experience_level

ORDER BY 
   experience_level,
   avg_salary;

/* Result:
+----------------+--------------+---------------+--------------+
| experience_level | avg_salary   | median_salary | salary_range |
+-----------------+--------------+---------------+--------------+
| EN              | 78,546.28    | 70,000        | 294,591      |
| EX              | 194,930.93   | 196,000       | 401,000      |
| MI              | 104,525.94   | 100,000       | 444,868      |
| SE              | 153,077.79   | 146,000       | 415,834      |
+-----------------+--------------+---------------+--------------+
*/

/*
3. Average, median, and range of global data science salaries by job title. 
*/

SELECT 
    job_title, 
    ROUND(AVG(salary),2) AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary,
    MAX(salary) - MIN(salary) AS salary_range
FROM ds_salaries

GROUP BY 
    job_title

ORDER BY 
    avg_salary,
    job_title;

/* Result (Limited to 10):
+------------------------------+--------------+---------------+--------------+
| job_title                    | avg_salary   | median_salary | salary_range |
+------------------------------+--------------+---------------+--------------+
| Product Data Scientist       | 8,000.00     | 8,000         | 0            |
| Staff Data Analyst           | 15,000.00    | 15,000        | 0            |
| Autonomous Vehicle Technician | 26,277.50    | 26,277.50     | 38,555      |
| Compliance Data Analyst      | 30,000.00    | 30,000        | 0            |
| Insight Analyst              | 38,500.00    | 38,500        | 7,000        |
| Finance Data Analyst         | 45,000.00    | 45,000        | 0            |
| Data DevOps Engineer         | 50,000.00    | 50,000        | 0            |
| AI Programmer                | 55,000.00    | 55,000        | 30,000       |
| ETL Engineer                 | 58,750.00    | 58,750        | 22,500       |
| BI Data Engineer             | 60,000.00    | 60,000        | 0            |
+------------------------------+--------------+---------------+--------------+
*/

/*
4. Average, median, and range of global data science salaries by company size (large, medium, small). 
*/

SELECT 
    company_size, 
    ROUND(AVG(salary_in_usd),2) AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd) AS median_salary,
    MAX(salary_in_usd) - MIN(salary_in_usd) AS salary_range
FROM ds_salaries

GROUP BY 
    company_size

ORDER BY 
   company_size,
   avg_salary;

/* Result:
+--------------+--------------+---------------+--------------+
| Company Size | avg_salary   | median_salary | salary_range |
+--------------+--------------+---------------+--------------+
| L            | 118,372.62   | 109,000       | 418,425      |
| M            | 143,130.55   | 140,000       | 444,868      |
| S            | 78,226.68    | 62,146        | 410,321      |
+--------------+--------------+---------------+--------------+
*/

/*
5. Average, median, and range of data science salaries by country/region. 
*/

SELECT 
    company_location, 
    ROUND(AVG(salary_in_usd),2) AS avg_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd) AS median_salary,
    MAX(salary_in_usd) - MIN(salary_in_usd) AS salary_range
FROM ds_salaries

GROUP BY 
    company_location

ORDER BY 
   avg_salary,
   company_location;

/* Result (Limited to 10):
+------------------+--------------+---------------+--------------+
| company_location | avg_salary   | median_salary | salary_range |
+------------------+--------------+---------------+--------------+
| MK               | 6,304.00     | 6,304         | 0            |
| BO               | 7,500.00     | 7,500         | 0            |
| AL               | 10,000.00    | 10,000        | 0            |
| MA               | 10,000.00    | 10,000        | 0            |
| VN               | 12,000.00    | 12,000        | 0            |
| SK               | 12,608.00    | 12,608        | 0            |
| MD               | 18,000.00    | 18,000        | 0            |
| GH               | 18,500.00    | 18,500        | 23,000       |
| TR               | 19,058.00    | 20,171        | 18,016       |
| HN               | 20,000.00    | 20,000        | 0            |
+------------------+--------------+---------------+--------------+
*/

/*
6. Identifying how global salaries differ based on the percentage of remote work. 
*/

SELECT remote_ratio AS remote_percentage,
       ROUND(AVG(salary_in_usd),2) AS avg_salary,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary_in_usd) AS median_salary,
       MIN(salary_in_usd) AS min_salary,
       MAX(salary_in_usd) AS max_salary
    
FROM ds_salaries
    
GROUP BY 
    remote_ratio
    
ORDER BY 
    remote_ratio;

/* Result:
+-------------------+-------------+--------------+-------------+-------------+
| remote_percentage | avg_salary  | median_salary| min_salary  | max_salary  |
+-------------------+-------------+--------------+-------------+-------------+
| 0                 | 144316.20   | 139600       | 5882        | 450000      |
| 50                | 78400.69    | 63312        | 5409        | 423000      |
| 100               | 136512.29   | 135000       | 5132        | 416000      |
+-------------------+-------------+--------------+-------------+-------------+
*/

/*
7. Analyizing average global salaries between hybrid, on-site, and remote work types.
*/

SELECT CASE 
          WHEN remote_ratio = 0 THEN 'On Site'
          WHEN remote_ratio = 100 THEN 'Remote'
          ELSE 'Hybrid'
       END AS work_type,
       ROUND(AVG(salary_in_usd),2) AS avg_salary
FROM ds_salaries
    
GROUP BY 
    CASE 
        WHEN remote_ratio = 0 THEN 'On Site'
        WHEN remote_ratio = 100 THEN 'Remote'
        ELSE 'Hybrid'
    END
    
ORDER BY 
    work_type;

/* Result:
+-----------+-------------+
| work_type | avg_salary  |
+-----------+-------------+
| Hybrid    | 78400.69    |
| On Site   | 144316.20   |
| Remote    | 136512.29   |
+-----------+-------------+
*/

/*
8. Investigating the impact of company size on salaries in the US. 
*/

SELECT 
    company_size,
    ROUND(AVG(salary_in_usd), 2) AS avg_salary_us
FROM 
    ds_salaries

WHERE company_location = 'US'

GROUP BY
    company_size 

ORDER BY company_size DESC;

/* Result:
+---------------+---------------+
| company_size  | avg_salary_us |
+---------------+---------------+
| S             | 104961        |
| M             | 152495        |
| L             | 154475        |
+---------------+---------------+
*/


/*
9. Top 10 highest paying data science job titles based on average salary in the United States.
*/

SELECT
    job_title,
    ROUND(AVG(salary_in_usd),2) AS avg_salary_us
FROM 
    ds_salaries

WHERE company_location = 'US'
    
GROUP BY
    job_title 

ORDER BY  
    avg_salary_us DESC
    
LIMIT 10;

/* Result:
+------------------------------------------+---------------+
| job_title                                | avg_salary_us |
+------------------------------------------+---------------+
| Data Analytics Lead                      | 405000.00     |
| Data Science Tech Lead                   | 375000.00     |
| Director of Data Science                 | 294375.00     |
| Principal Data Scientist                 | 255500.00     |
| Cloud Data Architect                     | 250000.00     |
| Applied Data Scientist                   | 238000.00     |
| Head of Data                             | 233183.33     |
| Machine Learning Software Engineer       | 217400.00     |
| Data Lead                                | 212500.00     |
| Head of Data Science                     | 202355.00     |
+------------------------------------------+---------------+
*/


/*
10. Top 10 highest paying data science job titles based on average salary for the rest of the world.
*/

SELECT
    job_title,
    ROUND(AVG(salary_in_usd),2) AS avg_salary_world
FROM 
    ds_salaries

WHERE company_location NOT LIKE 'US'
    
GROUP BY
    job_title 

ORDER BY  
    avg_salary_world DESC
    
LIMIT 10;

/* Result:
+------------------------------------------+---------------+
| job_title                             | avg_salary_world |
+------------------------------------------+---------------+
| Machine Learning Software Engineer      | 167440.00      |
| Principal Data Scientist                | 159174.00      |
| Marketing Data Analyst                  | 144327.00      |
| Director of Data Science                | 138435.43      |
| Research Engineer                       | 137026.00      |
| Data Analytics Manager                  | 133000.00      |
| AI Developer                            | 130332.70      |
| Data Architect                          | 128275.00      |
| Big Data Architect                      | 125802.50      |
| Deep Learning Researcher                | 123405.00      |
+-----------------------------------------+----------------+
*/

/*
11. Identifying the top 10 US job titles with global counterparts and ranking them based on salary differences between US and global averages.
*/

WITH top_5_job_titles AS (
	SELECT
    		job_title,
    		ROUND(AVG(salary_in_usd),2) AS avg_salary_us
	FROM
    		ds_salaries

	WHERE
    		company_location = 'US'

	GROUP BY
    		job_title

	ORDER BY 
    		AVG(salary_in_usd) DESC

	LIMIT 25
), 
    
global_salaries AS (
	SELECT 
    		job_title,
    		ROUND(AVG(salary_in_usd),2) AS avg_salary_global
	FROM
    		ds_salaries
  
	WHERE company_location NOT LIKE 'US'

	GROUP BY
    		job_title

	ORDER BY 
    		AVG(salary_in_usd) DESC

	LIMIT 25
)

SELECT 
    t5jt.job_title,
    avg_salary_us,
    avg_salary_global
FROM 
    top_5_job_titles AS t5jt

LEFT JOIN 
    global_salaries AS gs
ON t5jt.job_title = gs.job_title

WHERE avg_salary_global IS NOT NULL

ORDER BY 
    avg_salary_us DESC;

/* Result:
+--------------------------------------+---------------+------------------+
|           job_title                  | avg_salary_us | avg_salary_global|
+--------------------------------------+---------------+------------------+
| Director of Data Science             | 294375.00     | 138435.43        |
| Principal Data Scientist             | 255500.00     | 159174.00        |
| Head of Data                         | 233183.33     | 109868.75        |
| Machine Learning Software Engineer   | 217400.00     | 167440.00        |
| Head of Data Science                 | 202355.00     | 108387.50        |
| AI Developer                         | 200000.00     | 130332.70        |
| Data Science Manager                 | 199379.58     | 121071.83        |
| Data Scientist Lead                  | 183000.00     | 89306.00         |
| Research Scientist                   | 179146.21     | 117878.50        |
| Machine Learning Scientist           | 175678.57     | 110894.40        |
+--------------------------------------+---------------+------------------+
*/

/*
12. Comparing salaries across experience levels for the US, Canada, and Mexico. 
*/

WITH avg_salaries AS (
SELECT
    company_location AS country,
    experience_level,
    ROUND(AVG(salary_in_usd),2) AS salary
    
FROM 
    ds_salaries

WHERE company_location IN ('US', 'CA', 'MX')

GROUP BY 
    company_location,
    experience_level
)

SELECT 
    country,
    salary,
    CASE experience_level
        WHEN 'MI' THEN 'Mid-Level'
        WHEN 'EN' THEN 'Entry-Level'
        WHEN 'SE' THEN 'Senior-Level'
        WHEN 'EX' THEN 'Executive-Level'
    END AS experience_level,
    ROW_NUMBER() OVER(PARTITION BY country ORDER BY salary DESC) AS experience_rank
FROM
    avg_salaries

ORDER BY 
    country ASC,
    experience_level ASC,
    experience_rank ASC;

/* Result:
+---------+-----------+----------------+-----------------+
| country |  salary   | experience_level | experience_rank |
+---------+-----------+----------------+-----------------+
| CA      | 76605.57  | Entry-Level     | 4              |
| CA      | 112058.75 | Executive-Level | 2              |
| CA      | 88669.60  | Mid-Level       | 3              |
| CA      | 150201.98 | Senior-Level    | 1              |
| MX      | 49500.00  | Mid-Level       | 2              |
| MX      | 128918.50 | Senior-Level    | 1              |
| US      | 102400.64 | Entry-Level     | 4              |
| US      | 207445.52 | Executive-Level | 1              |
| US      | 127822.54 | Mid-Level       | 3              |
| US      | 158683.52 | Senior-Level    | 2              |
+---------+-----------+----------------+-----------------+
*/
