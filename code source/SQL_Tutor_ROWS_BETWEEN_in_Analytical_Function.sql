-- ================================ FRAME CLAUSE ================================  
-- https://etl-sql.com/rows-between-in-analytical-function/
-- https://www.youtube.com/watch?v=ehISssB7fKk


-- frame clause --> rows between unbounded preceding and current row --> default 

-- n preceding = n before current row
-- n following = n after current row

-- n -> angka, unbounded

-- UNBOUNDED PRECEDING: All rows before current row are considered.
-- UNBOUNDED FOLLOWING: All rows after the current row are considered.
-- CURRENT ROW: Range starts or ends at CURRENT ROW.

-- ========================================================================================================

-- Difference between range and row

-- RANGE
-- order by column (price) --> nilai dari column partition duplicate / sama --> nilai hasilnya juga SAMA, ambil last valuenya

-- ROWS
-- order by column (price) --> nilai dari column partition duplicate / sama --> nilai hasilnya BERBEDA


-- ========================================================================================================

-- Create a Table with dummy data.

create table vt_rows_between
(
sid int
);

-- Load some dummy data into the table.
insert into vt_rows_between select 1;
insert into vt_rows_between select 2;
insert into vt_rows_between select 3;
insert into vt_rows_between select 4;
insert into vt_rows_between select 5;
insert into vt_rows_between select 6;
insert into vt_rows_between select 7;
insert into vt_rows_between select 8;
insert into vt_rows_between select 9;
insert into vt_rows_between select 10;


-- Select all data
select * from vt_rows_between;



-- Case1: To read previous row value
-- In many cases, we may want to read value from previous row 
-- only then we can specify 1 preceding and 1 preceding. 
-- This is how we can access previous row value in the 
-- current row.

select
	sid,
	sum(sid) over(
	order by sid rows between 1 preceding and 1 preceding) as sid2
from
	vt_rows_between;

-- add before and current 

select
	sid,
	sum(sid) over(
	order by sid rows between 1 preceding and current row) as sid2
from
	vt_rows_between;
	
-- add two row

select
	sid,
	sum(sid) over(
	order by sid rows between 2 preceding and 1 preceding) as sid2
from
	vt_rows_between;
	

-- Case2: To read all the previous rows
-- If we want to consider all the previous row in analytical 
-- function then we can specify UNBOUNDED preceding and 1 preceding. 
-- In this example we will do sum of all the previous rows only 
-- excluding current row.

select
	sid,
	sum(sid) over(
	order by sid rows between UNBOUNDED preceding and 1 preceding) as sid2
from
	vt_rows_between;
	

-- Case3: To read previous 2 rows only
-- If we want to read only specific precious rows then 
-- we can mention the number to read limited rows in 
-- place of all the previous rows. In this example we can 
-- specify 2 preceding and 1 preceding to read only 
-- previous 2 rows.

select
	sid,
	sum(sid) over(
	order by sid rows between 2 preceding and 1 preceding) as sid2
from
	vt_rows_between;
	

-- Case4: To read the next row only
-- In some cases, we may want to do some computation 
-- depending on the next row value in such case we can 
-- specify 1 following and 1 following

select
	sid,
	sum(sid) over(
	order by sid rows between 1 following and 1 following) as sid2
from
	vt_rows_between;
	
-- Case5: To read all the following rows
-- If we want to read all the following rows or next 
-- rows then we can specify 1 following and unbounded preceding

select
	sid,
	sum(sid) over(
	order by sid rows between 1 following and unbounded following) as sid2
from
	vt_rows_between;
	

-- Case6: To read next 2 rows only
-- In some case, we may want to read the next few rows 
-- only and not all during computation. In such cases , 
-- we can specify numbers to read only limit next rows and 
-- not all. In this example we will use 
-- 1 following and 2 following

select
	sid,
	sum(sid) over(
	order by sid rows between 1 following and 2 following) as sid2
from
	vt_rows_between;
	

-- Case7: If you want to include current row
-- In some cases, we may want to include current row 
-- as well in the calculation then we can specify current 
-- row and then following/preceding as per requirement. 
-- In this example we will use current row and 2 following

select
	sid,
	sum(sid) over(
	order by sid rows between current row and 2 following) as sid2
from
	vt_rows_between;
	
-- Case8: Calculate sum of all rows till current row
-- If we want to consider all the previous till current row 
-- then we can use UNBOUNDED preceding and current row

select
	sid,
	sum(sid) over(
	order by sid rows between UNBOUNDED preceding and current row) as sid2
from
	vt_rows_between;