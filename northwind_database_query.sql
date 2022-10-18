select * from Employees;

-- 11.
select firstname, lastname, title, convert(date, birthdate) from Employees
order by birthdate;

-- 12.
select firstname, lastname, concat(firstname, ' ', lastname) as FullName
from Employees;

-- 13.
select OrderID, ProductID, UnitPrice, Quantity, UnitPrice*Quantity as TotalPrice
from OrderDetails
order by OrderID, ProductID;

-- 14.
select count(customerID) from Customers;

-- 15.
select min(orderdate) from Orders;

-- 16.
select distinct(country) from Customers;

-- 17.
select contacttitle, count(CustomerID) as numbers from Customers
group by ContactTitle;

-- 18.
select a.productID, a.productname, b.companyname 
from Products a
join Suppliers b
on a.SupplierID = b.SupplierID
order by a.ProductID;

-- 19.
select a.orderID, convert(date, a.orderdate) date, b.CompanyName
from Orders a
join Shippers b
ON a.ShipVia = b.ShipperID
where OrderID < 10300
order by a.OrderID;

-- 20.
select a.CategoryName, count(b.ProductID) as number_products
from categories a join Products b on a.CategoryID = b.CategoryID
group by a.CategoryName
order by number_products desc;

-- 21.
select Country, City, count(CustomerID) as customers
from Customers
group by Country, City;

-- 22.
select productID, productname from Products
where UnitsInStock < ReorderLevel
order by ProductID;

-- 23.
select Productname from Products
where 
	UnitsInStock + UnitsOnOrder <= ReorderLevel
	and
	Discontinued = 0;


-- 24.
select customerID, companyname, region, field = 
case
	when region is not null then 0
	else 1
	end
from customers
order by field, region, customerID;



-- 25.
select top 3 shipcountry, avg(freight) as avg_freight
from Orders
group by ShipCountry
order by avg_freight desc;


-- 26.
select top 3 shipcountry, avg(freight) as avg_freight
from Orders
where convert(date, OrderDate) like '2015%'
group by ShipCountry
order by avg_freight desc;


-- 28.
select top 3 shipcountry, avg(freight) as avg_freight
from Orders
where orderdate between (select dateadd(year, -1, (select max(orderdate) from orders))) 
		and (select max(orderdate) from orders)
group by shipcountry
order by avg_freight desc;


-- 29.
select a.EmployeeID, a.LastName, b.OrderID, d.ProductName, c.Quantity 
from Employees a, Orders b, OrderDetails c, Products d
where a.EmployeeID = b.EmployeeID and c.ProductID = d.ProductID and b.OrderID = c.OrderID
order by b.OrderID, d.ProductID;


-- 30.
