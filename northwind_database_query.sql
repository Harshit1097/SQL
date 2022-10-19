-- queries based on the Northwind database




-- 1. Concat first and last names and display full name
select firstname, lastname, concat(firstname, ' ', lastname) as FullName
from Employees;



-- 2. distinct ContactTitles in customer table
select contacttitle, count(CustomerID) as numbers from Customers
group by ContactTitle;



-- 3. Products with associated Supplier names
select a.productID, a.productname, b.companyname 
from Products a
join Suppliers b
on a.SupplierID = b.SupplierID
order by a.ProductID;



-- 4. Orders, Shipper and date for OrderID > 10300
select a.orderID, convert(date, a.orderdate) date, b.CompanyName
from Orders a
join Shippers b
ON a.ShipVia = b.ShipperID
where OrderID < 10300
order by a.OrderID;



-- 5. Total number of products in each category, sorted by decreasing number of products
select a.CategoryName, count(b.ProductID) as number_products
from categories a join Products b on a.CategoryID = b.CategoryID
group by a.CategoryName
order by number_products desc;



-- 6. Products that need reordering, based on stock level and reorder level
select Productname from Products
where 
	UnitsInStock + UnitsOnOrder <= ReorderLevel
	and
	Discontinued = 0;



-- 7. Sort customers by region, with the ones having NULL region being at the bottom end. 
----   Within each region, sort by customerID

select customerID, companyname, region, field = 
case
     when region is not null then 0
     else 1
     end
from customers
order by field, region, customerID;



-- 8. Top 3 countries with highest average freight charges in 2015

select top 3 shipcountry, avg(freight) as avg_freight
from Orders
where convert(date, OrderDate) like '2015%'
group by ShipCountry
order by avg_freight desc;



-- 9. Top 3 countries with highest average freight charges in the year preceeding the lates order date

select top 3 shipcountry, avg(freight) as avg_freight
from Orders
where orderdate between (select dateadd(year, -1, (select max(orderdate) from orders))) 
		and (select max(orderdate) from orders)
group by shipcountry
order by avg_freight desc;



-- 10. Inventory list - join data from 4 tables

select a.EmployeeID, a.LastName, b.OrderID, d.ProductName, c.Quantity 
from Employees a, Orders b, OrderDetails c, Products d
where a.EmployeeID = b.EmployeeID and c.ProductID = d.ProductID and b.OrderID = c.OrderID
order by b.OrderID, d.ProductID;



-- 11. Customers who have never placed any order

select Customers.CustomerID, Orders.OrderID from  Customers
left join Orders on Customers.CustomerID = Orders.CustomerID
where Orders.OrderID is null;



-- 12. Identify High value customers - who have made orders totaling $15,000 or above in the year 2016

select a.CustomerID, a.CompanyName, sum(c.UnitPrice*c.Quantity) as total_price 
from Customers a join Orders b on a.CustomerID = b.CustomerID join OrderDetails c on b.OrderID = c.OrderID
where convert(date, b.OrderDate) like '2016%'
group by a.CustomerID, a.CompanyName
having sum(c.UnitPrice*c.Quantity) >= 15000
order by total_price desc;



-- 13. Orders made on the last day of months

select OrderID, EmployeeID, OrderDate from Orders
where convert(date, OrderDate) = eomonth(OrderDate)
order by EmployeeID, OrderID;
