create database if not exists salesdatawalmart;

CREATE TABLE IF NOT EXISTS sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct DECIMAL(6, 4) NOT NULL,       -- Change to DECIMAL for better precision
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct DECIMAL(11, 9),      -- Change to DECIMAL for better precision
    gross_income DECIMAL(12, 4),
    rating DECIMAL(2, 1)                  -- Change to DECIMAL for better precision
);





-- feature engineering-- 

-- time_of_day 

select 
    time,
     (CASE
	     when 'time' between "00:00:00" and "12:00:00"then "morning"
         when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
		else "evening"
     END   
	)as time_of_day
FROM  sales ;

alter table sales  add column time_of_day varchar(20);


 
update sales 
set time_of_day = (
CASE
	     when 'time' between "00:00:00" and "12:00:00"then "morning"
         when 'time' between "12:01:00" and "16:00:00" then "Afternoon"
		else "evening"
END
);

-- day name 

select date,
       dayname(date) as day_name
from sales;

Alter table sales add column day_name varchar(10);

update sales 
set day_name = dayname(date);

-- month name

select date,
        monthname(date) as month_name 
from sales;


alter table sales add column month_name varchar(15);

update sales 
set month_name = monthname(date);


-- Exploratory data analysis 

-- generic


-- how many unique cities does the data have 

select 
     distinct city
from sales;


-- in which city is each branch
select distinct branch
from sales;

select
distinct city,branch 
from sales;


-- product

-- how many uniqueproduct lines does the data have ?

SELECT COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method?

SELECT payment, COUNT(payment) AS cnt
FROM sales
GROUP BY payment
ORDER BY cnt DESC;


-- What is the most selling product line?

select * from sales;


SELECT product_line, COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- What is the total revenue by month?

select month_name as month,
sum(total) as total_revenue 
from sales
group by month_name 
order by total_revenue desc;

-- What month had the largest COGS(cost of the goods sold )?

select month_name as month,
sum(cogs) as cogs
from sales
group by month_name 
order by cogs desc;


-- What product line had the largest revenue?

select product_line, 
sum(total) as total_revenue
from sales 
group by product_line
order by total_revenue desc ;

-- What is the city with the largest revenue?

select city,
sum(total) as largest_revenue
from sales 
group by city
order by largest_revenue desc;


-- What product line had the largest VAT(value added tax)?

select product_line as pl,
avg(tax_pct) as avg_tax
from sales 
group by pl
order by avg_tax desc;


-- Which branch sold more products than average product sold?

select branch ,
sum(quantity) as qty
from sales 
group by branch
having sum(quantity) > (select avg(quantity) from sales); 

-- What is the most common product line by gender?

select gender,product_line,
count(gender) as total_cmt
from sales 
group by gender,product_line
order by total_cmt desc;

-- What is the average rating of each product line?

select round(avg(rating),2) as avg_rating,
product_line
from sales 
group by product_line
order by avg_rating desc;

-- sales
-- Number of sales made in each time of the day per weekday

select 
        Time_of_day,
        count(*) as total_sales
from sales 
where day_name = "sunday"
group by time_of_day 
order by total_sales desc;

-- Which of the customer types brings the most revenue?

select customer_type ,
sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city,
avg(tax_pct) as VAT
from sales 
group by city
order by VAT desc;


-- Which customer type pays the most in VAT?

select customer_type,
avg (tax_pct) as VAT
from sales
group by customer_type 
 order by VAT desc;
 
 -- customer
 -- How many unique customer types does the data have?
 
 select distinct customer_type from sales;
 
 -- How many unique payment methods does the data have?
 select distinct payment from sales;
 
 
-- What is the most common customer type
SELECT 
    customer_type, 
    COUNT(*) AS customer_count
FROM 
    sales
GROUP BY 
    customer_type
ORDER BY 
    customer_count DESC
limit 1;
    
    
-- Which customer type buys the most?

select customer_type,
count(*) as customer_count
from sales
group by customer_type
order by customer_count;

-- what is the gender of the most of the cutsomers 


select gender ,
count(*) as  customer_gender
from sales
group by gender 
order by customer_gender desc;

-- What is the gender distribution per branch?
select gender ,
count(branch) as gen_branch
from sales 
where branch = "B"
group by gender 
order by gen_branch desc;

-- Which time of the day do customers give most ratings?

select time_of_day,
avg(rating) as rat
from sales
group by time_of_day
order by rat desc;


-- Which time of the day do customers give most ratings per branch?

select time_of_day,
avg(rating) as rat
from sales
where branch = "A"
group by time_of_day
order by rat desc;

-- Which day fo the week has the best avg ratings?

SELECT day_name,
avg(rating) as rat
from sales 
group by day_name 
order by rat desc limit 1 ;


-- Which day of the week has the best average ratings per branch?

SELECT day_name,
avg(rating) as rat
from sales 
where branch = "C"
group by day_name 
order by rat desc limit 1 ;
