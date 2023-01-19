select * from [dbo].[orders]

-- DERIVED DATA --
drop table if exists #db
;with db as 
	(
	select  *,
        Quantity * Product_Price as Quantity_Price, 
        year(Order_Date) as Year, 
		month(Order_Date) as Month,
		Day(Order_Date) as Day
	from [dbo].[orders]
	)

select *
into #db
from db

-- Unique Items -- 
select count(distinct Item_Name)
from #db

-- Price of Items--
-- maximum priced top 3 items --
select  distinct Item_Name, Product_Price
from #db
order by Product_Price desc 
offset 0 rows  
fetch next 3 rows only

-- avg price --
select  avg(Product_Price) as avg_price
from #db

-- Total Quantity ordered -- 
select sum(cast(Quantity as int)) as Total_Quantity_Ordered
from #db

-- Total Revenue -- 
select sum(Quantity_Price) as Total_Revenue 
from #db

-- Revenue based on Year -- 
select Year, round(sum(Quantity_Price),2) as Total_Revenue_on_years
from #db
group by Year
order by Year desc

-- Top Selling & least selling items based on quantities sold -- 
select Item_Name, sum(cast(Quantity as int)) as Quantity_Sold
from #db
group by Item_Name, Quantity
order by 2 desc

-- Revenue generated based on Items sold -- 
select Item_Name, round(sum(Quantity_Price),2) as Revenue
from #db
group by Item_Name, Quantity_Price
order by 2 desc

-- Revenue generated during new year eve -- 
select Year, sum(Quantity_Price) as Revenue, sum(cast(Quantity as int)) as Quantiy_Sold
from #db
where Month = 12 and Day = 31
group by Year

--Which was the best month for sales -- 
select Year, Month, count(Order_ID) as total_orders,
       rank () over ( order by count(Order_ID) desc ) ranking
from #db
where year = 2017 -- change year based on need
group by Year,Month
order by 4 asc





