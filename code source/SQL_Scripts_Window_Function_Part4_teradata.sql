-- https://dbmstutorials.com/teradata/teradata_example_tables.html
-- https://dbmstutorials.com/teradata/teradata-analytical-window-functions.html
-- https://dbmstutorials.com/teradata/teradata-analytical-window-functions-part-two.html


-- Other commonly used analytical functions
-- Rank
-- Dense_Rank
-- Row_Number
-- Lag
-- Lead
-- First_Value
-- Last_Value

-- RANK: This function is used to find rank within categories or sub-categories. 
-- Rank function will miss next number(rank) if there are 2 records with same value.

-- Example 1: Rank of employees by salary within department.

SELECT emp_name,salary,dept_no,
RANK() over (PARTITION BY dept_no ORDER BY salary ) As Rank_by_salary
FROM employee;



-- DENSE_RANK: This function is used to find rank within categories or sub-categories. Dense Rank function will not miss next number(rank) if there are 2 records with same value. This is also sometime called as class rank.

-- Example 1: Dense Rank of employees by salary within department.
SELECT emp_name,salary,dept_no,
DENSE_RANK() over (PARTITION BY dept_no ORDER BY salary ) As Dense_Rank_by_salary
FROM employee;



-- ROW_NUMBER: This function is used to find continuous number within categories or sub-categories based on the window feature values.

-- Example 1: Row number against employees by salary within department.
SELECT emp_name,salary,dept_no,
ROW_NUMBER() over (PARTITION BY dept_no ORDER BY salary,emp_name ) As row_number_Dept_salary
FROM employee;



-- Difference between row_number(), rank() and dense_rank() window functions in SQL
--  https://javarevisited.blogspot.com/2016/07/difference-between-rownumber-rank-and-denserank-sql-server.html#axzz87OVtTWFs

-- The row_number() function always generates a unique ranking even with duplicate records
-- 
-- The rank() and dense_rank() will give the same ranking to rows that cannot be distinguished 
-- by the order by clause, but dense_rank will always generate a contiguous sequence of ranks 
-- like (1,2,3,...), whereas rank() will leave gaps after two or more rows with the same rank 

-- * -> same in value/duplicate order
--                       *  *
-- value       12 14 15 23 23 25
-- row_number() 1  2  3  4  5  6
-- rank()       1  2  3  4  4  6
-- dense_rank() 1  2  3  4  4  5






-- LAG: This function will return the value of expression column for nth preceding row within each partition(if specified).
-- Syntax:
	-- LAG(expression_column, n , default_value) OVER ([PARTITION BY COLUMN1] [ORDER BY COLUMN2])
	
	-- expression_column -> Lag value to be checked for column
	-- n                 -> Value of "n" will be` 1 if not specified, will be equivalent to "n PRECEDING"
	-- default_value     -> If no row satisfy the window condition then default_value specified in the function will be returned and if value is not specified then null will be returned.

-- Example 1: This Lag function will return 2nd previous value (n=2) from the current row and default_value specfied is -1 when no row satisfy the window condition.
SELECT emp_name,salary,dept_no,
LAG(salary,2,-1) over (PARTITION BY dept_no ORDER BY salary ) As lag_salary
FROM employee;
-- Note: Some value are -1 because they are not satisfying window condition as there is no previous to previous row to get value within their partition.

-- Example 2: This will return return previous value (n=1) from the current row and null when no row satisfy the window condition as default_value is not specfied.
SELECT emp_name,salary,dept_no,
LAG(salary) over (PARTITION BY dept_no ORDER BY salary ) As lag_salary
FROM employee;
-- Note: Some value are null because they are not satisfying window condition as there is no previous row to get value within their partition.





-- LEAD: Lead return the value of expression column for nth following row within each partition(if specified).
-- Syntax:
	-- LEAD(expression_column, n , default_value) OVER ([PARTITION BY COLUMN1] [ORDER BY COLUMN2])
	
	-- expression_column -> Lag value to be checked for column
	-- n                 -> Value of "n" will be` 1 if not specified, will be equivalent to "n PRECEDING"
	-- default_value     -> If no row satisfy the window condition then default_value specified in the function will be returned and if value is not specified then null will be returned.

-- Example 1: This Lag function will return 2nd following value (n=2) from the current row and default_value specfied is -1 when no row satisfy the window condition.
SELECT emp_name,salary,dept_no,
LEAD(salary,2,-1) over (PARTITION BY dept_no ORDER BY salary ) As lead_salary
FROM employee;
-- Note: Some value are -1 because they are not satisfying window condition as there is no next to next row to get value within their partition.

-- Example 2: This will return return next value (n=1) from the current row and null when no row satisfy the window condition as default_value is not specfied.
SELECT emp_name,salary,dept_no,
LEAD(salary) over (PARTITION BY dept_no ORDER BY salary ) As lead_salary
FROM employee;
-- Note: Some value are null because they are not satisfying window condition as there is no next row to get value within their partition.





-- FIRST_VALUE: This function is used to get the value of expression column for 1st row within each partition.

-- Example 1: This will return value of 1st row for the given column within each partition.
SELECT emp_name,salary,dept_no,
FIRST_VALUE(salary) over (PARTITION BY dept_no ORDER BY emp_name ) As first_salary
FROM employee;





-- LAST_VALUE: This function is used to get the value of expression column for last row within each partition. 
-- By default LAST_VALUE() return the current value of expression column. 
-- Default window set for this function is "UNBOUNDED PRECEDING AND CURRENT ROW" 
-- and to get the last value within partition this value need to be overridden.


-- Example 1: This will return value of current row for the given column within each partition.
SELECT emp_name,salary,dept_no,
LAST_VALUE(salary) over (PARTITION BY dept_no ORDER BY emp_name) As last_salary
FROM employee;

-- Example 2: Default window is changed, this will return value of last row for the given column within each partition.
SELECT emp_name,salary,dept_no,
LAST_VALUE(salary) over (PARTITION BY dept_no ORDER BY emp_name ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) As last_salary
FROM employee;






-- QUALIFY: This clause can be used to filter rows based on Analytical functions.
-- Syntax: 
-- QUALIFY (analytical_function([column_name]) OVER ([PARTITION BY COLUMN1] [ORDER BY COLUMN2] [ROWS BETWEEN n FOLLOWING|PRECEDING(start window) AND m FOLLOWING|PRECEDING|CURRENT ROW)(end window)])) < | > | = | <> require_value_filter 
-- 
-- Example 1: Find top 2 ranked employees by salary within each department.
-- SELECT emp_name,salary,dept_no,
-- RANK() over (PARTITION BY dept_no ORDER BY salary ) As Dense_Rank_by_salary
-- FROM tutorial_db.employee
-- QUALIFY (DENSE_RANK() over (PARTITION BY dept_no ORDER BY salary ))<=2;


-- Example 2: Find employees whose total department salary is greater than 9000.
-- SELECT emp_name,salary,dept_no,
-- SUM(salary) over (PARTITION BY dept_no ORDER BY emp_name ) As Total_Dept_salary
-- FROM tutorial_db.employee
-- QUALIFY (SUM(salary) over (PARTITION BY dept_no ))>9000;







