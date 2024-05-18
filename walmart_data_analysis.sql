create database walmart_sales;
drop database walmart_sales;

create database walmart;
use walmart;
select * from walmartsalesdata;

-- find  total no of rows & duplicates rows --
select count(*) from walmartsalesdata;

SELECT * 
FROM walmartsalesdata 
WHERE `Invoice ID` IN (
    SELECT `Invoice ID` 
    FROM walmartsalesdata 
    GROUP BY `Invoice ID` 
    HAVING COUNT(*) > 1
);


-- find to delete duplicates rows --

delete from walmartsalesdata
WHERE `Invoice ID` IN (
    SELECT `Invoice ID` 
    FROM walmartsalesdata 
    GROUP BY `Invoice ID` 
    HAVING COUNT(*) > 1
);

-- find null values --

select * from walmartsalesdata
where 'invoice id' is null;

-- if null values found then replace it (currently no null value) --

set sql_safe_updates = 0;
update walmartsalesdata
set city = "N/A"
where city is null;

-- if multiple null values found then replace it (currently no null value)--

UPDATE walmartsalesdata
SET column1 = 'N/A', column2 = 0, column3 = 'Unknown'
WHERE column1 IS NULL OR column2 IS NULL OR column3 IS NULL;


/* how to check/identify the column datatype  */

SELECT 'Quantity', DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'walmartsalesdata'
and column_name = 'Quantity';


/* how to change the column datatype  */

ALTER TABLE walmartsalesdata
MODIFY `branch` VARCHAR(20) NOT NULL,
MODIFY `city` VARCHAR(20) NOT NULL,
MODIFY `Customer type` VARCHAR(30) NOT NULL,
MODIFY `Gender` VARCHAR(10) NOT NULL,
MODIFY `Product line` VARCHAR(100) NOT NULL,
MODIFY `Unit price` decimal(10,2) NOT NULL,
MODIFY `Quantity` int NOT NULL,
MODIFY `Tax 5%` decimal(6,4) NOT NULL,
MODIFY `Total` decimal(12,4) NOT NULL,
MODIFY `date` datetime NOT NULL,
MODIFY `time` time NOT NULL,
MODIFY `payment` VARCHAR(20) NOT NULL,
MODIFY `cogs` decimal(10,2) NOT NULL,
MODIFY `gross margin percentage` decimal(11,9) not null,
MODIFY `gross income` decimal(12,4) NOT NULL,
MODIFY `Rating` decimal(6,4) NOT NULL;





-- --------Feature Engineering ----------------
-- time_of_day

select time , case 
                   when time between '00:00:00' and '12:00:00' then 'Morning'
                   when time between '12:01:00' and '16:00:00' then 'Afternoon'
                   else 'Evening'
              end as time_of_day
from walmartsalesdata;

alter table walmartsalesdata
add column time_of_day varchar(30) not null;

alter table walmartsalesdata
modify time_of_day varchar(30);

set sql_safe_updates = 0;
update walmartsalesdata
set time_of_day = 
(case 
                   when time between '00:00:00' and '12:00:00' then 'Morning'
                   when time between '12:01:00' and '16:00:00' then 'Afternoon'
                   else 'Evening'
              end);

select * from walmartsalesdata;


-- find day_name --

alter table walmartsalesdata
add column day_name varchar(20);

update walmartsalesdata
set day_name = dayname(date)
where day_name is null;


-- find month_name --

alter table walmartsalesdata
add column month_name varchar(20);

update walmartsalesdata
set month_name = monthname(date)
where month_name is null;


-- How many unique cities does the data have 

select distinct(city) as unique_city from walmartsalesdata;

-- in which city is each branch ?

select distinct city , branch as unique_city_branch from walmartsalesdata;

-- How many unique product lines does the data have ?

 select count(distinct `product line`) as unique_product_line from walmartsalesdata;
 
 -- what is most common payment method
 
 select payment , count(payment) from walmartsalesdata
 group by payment;

 -- what is most selling product line
 
 select `Product line` , count(`Product line`) as most_selling_product from walmartsalesdata
 group by `Product line`
 order by most_selling_product desc;
 
  -- what is total revenue by month
  
  select month_name , sum(total) as revenue from walmartsalesdata
  group by month_name
  order by revenue desc;
  
  
-- what months had largest cogs

select month_name , sum(cogs) as largest_cogs from walmartsalesdata
group by month_name
order by largest_cogs desc;


-- what product line had the largest revenue ?
 
 select `Product line` , sum(total) as revenue from walmartsalesdata
 group by `Product line`
 order by revenue desc;

-- what is the city with the largest revenue ?

select city , sum(total) as revenue from walmartsalesdata
group by city
order by revenue desc;


-- which branch sold more products than avg products sold ?

select branch , sum(quantity) as more_sold from walmartsalesdata
group by branch
having more_sold > (select avg(Quantity) from walmartsalesdata);


-- what is the most common poduct line by gender

select `Product line` , gender , count(*) as total_qty  from walmartsalesdata
group by  `Product line` , Gender
order by total_qty desc;


-- what is average rating of each product line





