-- https://dbmstutorials.com/teradata/teradata_example_tables.html
-- https://dbmstutorials.com/teradata/teradata-analytical-window-functions.html
-- https://dbmstutorials.com/teradata/teradata-analytical-window-functions-part-two.html

-- Employee Table DDL:

CREATE TABLE EMPLOYEE(
  emp_no INTEGER,
  emp_name VARCHAR(50),
  job_title VARCHAR(30),
  manager_id INTEGER,
  hire_date Date,
  salary DECIMAL(18,2),
  commission DECIMAL(18,2),
  dept_no INTEGER,
  primary key (emp_no)
);


-- Department Table DDL:

CREATE TABLE DEPARTMENT(
  dept_no INTEGER,
  department_name VARCHAR(30),
  loc_name  VARCHAR(30),
  primary key (dept_no)
);


-- Error Table DDL:

CREATE TABLE RUNTIME_ERROR(
  session_nr      DECIMAL(18,0),
  procedure_name  VARCHAR(50),
  proc_step_txt   VARCHAR(1000),
  error_cd        INTEGER,
  primary key (session_nr)
);


-- Department Table DML:

INSERT INTO DEPARTMENT VALUES(100, 'ACCOUNTS', 'JAIPUR');
INSERT INTO DEPARTMENT VALUES(200, 'R & D', 'NEW DELHI');
INSERT INTO DEPARTMENT VALUES(300, 'SALES', 'BENGALURU');
INSERT INTO DEPARTMENT VALUES(400, 'INFORMATION TECHNOLOGY', 'BHUBANESWAR');

-- Employee Table DML:

INSERT INTO EMPLOYEE VALUES( 1000245, 'PRADEEP', 'PRESIDENT', null, '1981-11-17', 5000, null, 100);
INSERT INTO EMPLOYEE VALUES( 1000258, 'BLAKE', 'SENIOR MANAGER', 1000245, '1981-05-01', 2850, null, 300);
INSERT INTO EMPLOYEE VALUES( 1000262, 'CLARK', 'MANAGER', 1000245, '1981-06-09', 2450, null, 100);
INSERT INTO EMPLOYEE VALUES( 1000276, 'JONES', 'MANAGER', 1000245, '1981-04-02', 2975, null, 200);
INSERT INTO EMPLOYEE VALUES( 1000288, 'SCOTT', 'SYSTEM ANALYST', 1000276, '1987-07-13', 3000, null, 200);
INSERT INTO EMPLOYEE VALUES( 1000292, 'FORD', 'SYSTEM ANALYST', 1000276, '1981-12-03', 3000, null, 200);
INSERT INTO EMPLOYEE VALUES( 1000294, 'SMITH', 'LDC', 1000292, '1980-12-17', 800, null, 200);
INSERT INTO EMPLOYEE VALUES( 1000299, 'ALLEN', 'SALESMAN', 1000258, '1981-02-20', 1600, 300, 300);
INSERT INTO EMPLOYEE VALUES( 1000310, 'WARD', 'SALESMAN', 1000258, '1981-02-22', 1250, 500, 300);
INSERT INTO EMPLOYEE VALUES( 1000312, 'MARTIN', 'SALESMAN', 1000258, '1981-09-28', 1250, 1400, 300);
INSERT INTO EMPLOYEE VALUES( 1000315, 'TURNER', 'SALESMAN', 1000258, '1981-09-08', 1500, 0, 300);
INSERT INTO EMPLOYEE VALUES( 1000326, 'ADAMS', 'LDC', 1000288, '1987-07-13', 1100, null, 200);
INSERT INTO EMPLOYEE VALUES( 1000336, 'JAMES', 'LDC', 1000258, '1981-12-03', 950, null, 300);
INSERT INTO EMPLOYEE VALUES( 1000346, 'MILLER', 'LDC', 1000262, '1982-01-23', 1300, null, 100);


-- Target Table DDL & Data:
CREATE TABLE target_table(
   id INTEGER,
   name VARCHAR(100),
   primary key (id)
);

INSERT INTO target_table VALUES(1,'Teradata');
INSERT INTO target_table VALUES(2,'Database');
INSERT INTO target_table VALUES(3,'Oracle');
INSERT INTO target_table VALUES(4,'Vertica');


-- Temp Table 1 DDL & Data:
CREATE TABLE temp_table_1(
   id INTEGER,
   name VARCHAR(100),
   primary key (id)
);

INSERT INTO temp_table_1 VALUES(1,'Teradata');
INSERT INTO temp_table_1 VALUES(2,'Database');
INSERT INTO temp_table_1 VALUES(5,'DB2');
INSERT INTO temp_table_1 VALUES(6,'MYSQL');

-- Temp Table 2 DDL & Data:

CREATE TABLE temp_table_2(
   id DECIMAL(38),
   name VARCHAR(100),
   primary key (id)
);

INSERT INTO temp_table_2 VALUES(1,'Teradata');
INSERT INTO temp_table_2 VALUES(2,'Database');
INSERT INTO temp_table_2 VALUES(52343434232343242,'DB2');
INSERT INTO temp_table_2 VALUES(6635645646464,'MYSQL');





-- -------------------------------------------------
-- Teradata Analytical Window Functions

-- Some of the commonly used analytical functions
-- Sum
-- Count
-- Avg
-- Min
-- Max
-- MSum
-- MAvg
-- MDiff
-- CSum


-- Syntax: Basic syntax of Ordered analytical window function

-- analytical_function_name([column_name]) 
-- OVER ([PARTITION BY COLUMN1] [ORDER BY COLUMN2] 
-- [ROWS BETWEEN n FOLLOWING|PRECEDING(start window) AND m FOLLOWING|PRECEDING|CURRENT ROW)(end window)])


-- Ordered analytical functions can be used in the following database objects
	-- Views
	-- INSERT/SELECT
	-- Macros
-- Restriction on ordered analytical functions
	-- Cannot be used on clob/blob datatypes.
	-- Cannot be used in Sub-queries.
	-- Cannot be used in WHERE clause but rows can be filtered using QUALIFY clause for these function.
	-- Distinct cannot be used along with analytical functions.


-- Window features: These are most important part of 
-- ordered analytical functions and should be understood 
-- properly in order to effectively use them.

	-- PARTITION BY: This is optional and can be used to further categorized data and perform analysis within sub categories. Example: In order to calculate sum of salary for each Department along with individual detail, partition by dept number is required.
	-- ORDER BY: This is optional and can be used to specify order in which rows should be processed.
	-- ROWS: This is also optional and should be used when user want to peek into other rows data to compute current row value.
		-- ROWS BETWEEN n FOLLOWING|PRECEDING(start window) AND m FOLLOWING|PRECEDING|CURRENT ROW(end window)
		-- ROW attribute require user to specify start window and end window of row. 
		-- PRECEDING, FOLLOWING and CURRENT ROW values are available to peek into previous rows, following rows and current row respectively. 
		-- User can either specify number(e.g 1,2,3) to check that many number of previous / following rows 
		-- Or specify UNBOUNDED to check all the previous / following rows.



-- =======================================================================
-- ANALYTICAL FUNCTIONS

-- SUM: This function is used to add values of particular column within specified 
-- pattern / number of rows.

-- Example 1: Total sum of salary within department against each of employee of that department

SELECT emp_name,salary,dept_no,
SUM(salary) over (PARTITION BY dept_no ORDER BY emp_name ) As Total_Dept_salary
FROM employee;


-- Example 2: Cumulative salary within each department
SELECT emp_name,salary,dept_no,
SUM(salary) over (PARTITION BY dept_no ORDER BY emp_name  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) As Custom_Dept_salary
FROM employee; 
-- Window here: all the previous rows  and current row


-- COUNT: This function is used to count number of rows within specified pattern / number of rows.

-- Example 1: Total count of employees within department against each of employee of that department.

SELECT emp_name,salary,dept_no,
COUNT(emp_name) over (PARTITION BY dept_no) As Total_Emps
FROM employee;

-- Example 2: Number of employees left for processing within department.

SELECT emp_name,salary,dept_no,
COUNT(emp_name) over (PARTITION BY dept_no ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING ) As Remaining_cnt
FROM employee
order by dept_no,Remaining_cnt desc; 
-- Window here: 1 following row to current row to all the following rows



-- AVG: This function is used to find average value of particular column within specified pattern / number of rows.

-- Example 1: Average salary within department against each of employee of that department

SELECT emp_name,salary,dept_no,
Avg(salary) over (PARTITION BY dept_no ORDER BY emp_name ) As Total_Dept_salary
FROM employee;

-- Example 2: Cumulative Average salary within each department

SELECT emp_name,salary,dept_no,
AVG(salary) over (PARTITION BY dept_no ORDER BY emp_name  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) As Cum_avg_Dept_salary
FROM employee; 
-- Window here: all the previous rows  and current row



-- MIN: This function is used to find minimum value of particular column within specified pattern / number of rows.

-- Example 1: Minimum salary within department against each of employee of that department

SELECT emp_name,salary,dept_no,
Min(salary) over (PARTITION BY dept_no ORDER BY emp_name ) As Min_Dept_salary
FROM employee;

-- Example 2: Cumulative Minimum salary within each department

SELECT emp_name,salary,dept_no,
Min(salary) over (PARTITION BY dept_no ORDER BY emp_name  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) As Cum_Min_Dept_salary
FROM employee; 
-- Window here: all the previous rows  and current row



-- MAX: This function is used to find maximum value of particular column within specified pattern / number of rows.

-- Example 1: Maximum salary within department against each of employee of that department

SELECT emp_name,salary,dept_no,
MAX(salary) over (PARTITION BY dept_no ORDER BY emp_name ) As Max_Dept_salary
FROM employee;

-- Example 2: Cumulative Maximum salary within each department

SELECT emp_name,salary,dept_no,
MAX(salary) over (PARTITION BY dept_no ORDER BY emp_name  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) As Cum_max_salary
FROM employee; 
-- Window here: all the previous rows  and current row



-- MSUM: This function is used to find moving sum within specified number of previous rows.
-- Syntax: 
	-- MSUM(aggregation_column, n, order_by_column[,other_order_by_columns])
	-- Here n specify window feature "ROWS n-1 PRECEDING"

-- Example 1: Moving total salary against each of employee considering only current and previous employee

-- SELECT emp_name, salary, dept_no, MSUM(salary,2,emp_name)   
-- FROM employee;  
-- Here 2 specify "ROWS 1 PRECEDING"




-- MAVG: This function is used to find moving average within specified number of previous rows.
-- Syntax: 
	-- MAVG(aggregation_column, n, order_by_column[,other_order_by_columns])
	-- Here n specify window feature "ROWS n-1 PRECEDING"

-- Example 1: Moving salary against each of employee considering only current and previous employee
-- SELECT emp_name, salary, dept_no, MAVG(salary,2,emp_name)   
-- FROM employee; 
-- Here 2 specify "ROWS 1 PRECEDING"



-- MDIFF: This function is used to find moving difference between the given column for the current row and the nth preceding row
-- Syntax: 
	-- MDIFF(aggregation_column, n, order_by_column[,other_order_by_columns])
	-- Here 'n' specify nth previous row


-- Example 1: Moving salary difference for current row and previous to previous row value
-- SELECT emp_name,salary,dept_no,
-- MDIFF(salary,2,emp_name desc)
-- FROM employee;




-- CSUM: This is equivalent to SUM window function as its aggregation that specifies "ROWS UNBOUNDED PRECEDING" as window feature.
	-- Syntax: 
	-- CSUM(aggregation_column, order_by_column[,other_order_by_columns])

-- Example 1: Cumulative salary against each of the employee

-- SELECT emp_name,salary,dept_no,
-- CSUM(salary,emp_name)
-- FROM employee;




-- QUALIFY: This clause can be used to filter rows based on Analytical functions.
-- Syntax: 
	-- QUALIFY (analytical_function([column_name]) OVER ([PARTITION BY COLUMN1] [ORDER BY COLUMN2] 
	-- [ROWS BETWEEN n FOLLOWING|PRECEDING(start window) AND m FOLLOWING|PRECEDING|CURRENT ROW)(end window)])) < | > | = | <> require_value_filter 

-- Example 1: Find top 2 ranked employees by salary within each department.

-- SELECT emp_name,salary,dept_no,
-- RANK() over (PARTITION BY dept_no ORDER BY salary ) As Dense_Rank_by_salary
-- FROM employee
-- QUALIFY(DENSE_RANK() over (PARTITION BY dept_no ORDER BY salary ))<=2;

-- Example 2: Find employees whose total department salary is greater than 9000.

-- SELECT emp_name,salary,dept_no,
-- SUM(salary) over (PARTITION BY dept_no ORDER BY emp_name ) As Total_Dept_salary
-- FROM employee
-- QUALIFY (SUM(salary) over (PARTITION BY dept_no ))>9000;



