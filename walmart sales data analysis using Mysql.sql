CREATE DATABASE IF NOT EXISTS WalmartSales;
use WalmartSales;
CREATE TABLE IF NOT EXISTS  sale(
 invoice_id varchar(30) NOT NULL PRIMARY KEY,
 branch varchar(5) NOT NULL,
 city VARCHAR(30) NOT NULL,
 customer_type VARCHAR(30) NOT NULL,
 gender varchar(10) NOT NULL,
 product_line varchar(100) not null,
 unit_price decimal(10,2) not null,
 quantity int not null,
 VAT float(6,4),
 total decimal(12,4) not null,
 date datetime not null,
 time TIME not null,
 payment_method varchar(15) not null,
 cogs decimal(10,2) ,
 gross_margin_pct float(11,9) not null,
 gross_income decimal(12,4) not null,
 rating float(2,1)not null
);


-- -------------------------------------------Feature engineering-------------------------------------- --

select time,
	(case
		when `time` between "00:00:00" and "12:00:00" then "morning"
        when `time` between "12:02:00" and "12:00:00" then "afternoon"
        else "evening"
    end ) as time_of_date from sale;
    
alter table sale add column time_of_day varchar(20);

update sale
set time_of_day=(
	case
			when `time` between "00:00:00" and "12:00:00" then "morning"
			when `time` between "12:02:00" and "12:00:00" then "afternoon"
			else "evening"
	end
);
-- -----------------------------------------day_name---------------------------------------------------------------- --

select date,
	dayname(date) as day_name
 from sale;


alter table sale add column day_name varchar(20);

update sale
set day_name=dayname(date);
-- -------------------------------------------month_name----------------------------------------------------------
alter table sale add column month_name varchar(20);

select date,
	monthname(date) as month_name from sale;

update sale
set month_name=monthname(date);

-- -------------------------------------------------------------------------------------------------------
-- -----------------------------------------Generic-------------------------------------------------------


select distinct(city) from sale;


select distinct(city), branch from sale;

-- How many unique product lines does the data have?
select count(distinct product_line) from sale as unique_product; 
-- What is the most common payment method?

-- What is the most selling product line?
select product_line,sum(quantity) from sale group by product_line; -- correct
select product_line,count(quantity) from sale group by product_line;

-- What is the total revenue by month?
select month_name,sum(total) as by_month from sale group by month_name order by by_month desc;

-- What month had the largest COGS?
select month_name,sum(cogs) as t_cogs from sale group by month_name order by t_cogs desc;
 
-- What product line had the largest revenue?
select product_line,sum(total) as t_pr from sale group by product_line order by t_pr desc;

-- What is the city with the largest revenue?

select city,sum(total) as t_city from sale group by city order by t_city desc;

-- What product line had the largest VAT?


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select avg(total) as average from sale;

select product_line,
	case
		when avg(total) > (select avg(total) from sale) then "good"
		else "Bad" 
    end as review  from sale group by product_line;


-- Which branch sold more products than average product sold?

select branch,sum(quantity) from sale group by branch having sum(quantity)>(select avg(quantity) from sale);

-- What is the most common product line by gender?
 
  select gender,product_line,count(gender) as t_count from  sale group by gender,product_line order by t_count desc;
  
  -- -------------------------------------------------------------------------------------------------------
  -- -------------------------------------------SALES-------------------------------------------------------
  
  
  -- Number of sales made in each time of the day per weekday
  select time_of_day,count(*) from sale where time_of_day="sunday"group by time_of_day;
  
  -- Which of the customer types brings the most revenue?
  select customer_type,sum(total) from sale group by customer_type;
  
  -- Which city has the largest tax percent/ VAT (Value Added Tax)?
   select city,sum(VAT) from sale group by city;
   
   -- Which customer type pays the most in VAT?
   
   
   -- ----------------------------------------------------------------------------------------------------
   -- -----------------------------------------Customer---------------------------------------------------
   
   -- How many unique customer types does the data have?
   select distinct(customer_type) from sale;
   -- How many unique payment methods does the data have?
   select distinct(payment_method) from sale;
   
   -- What is the most common customer type?
   
   select customer_type,count(customer_type) from sale group by customer_type;
   
   -- Which customer type buys the most?
   select customer_type,sum(total) from sale group by customer_type order by sum(total) desc;
   
   -- What is the gender of most of the customers?
   select gender,count(gender) from sale group by gender;
   
   -- What is the gender distribution per branch?
   
   select branch,gender,count(gender) from sale group by branch,gender order by branch;
   
   -- Which time of the day do customers give most ratings?
   
   select time_of_day,count(rating) from sale group by time_of_day;
   
  