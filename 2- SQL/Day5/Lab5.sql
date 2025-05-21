-- Part-1: Use ITI DB
use ITI

--[1] Retrieve number of students who have a value in their age.
select count(St_Age)
from Student

--[2] Get all instructors Names without repetition
select distinct Ins_Name
from Instructor

--[3] Display student with the following Format (use isNull function)
select St_Id as [Student ID],
	   isnull(St_Fname,'')+' '+ isnull(St_Lname,'') as [Student Full Name],
	   Dept_Name as [Department name]
from Student s inner join Department d
	on d.Dept_Id = s.Dept_Id

--[4] Display instructor Name and Department Name
--    Note: display all the instructors if they are attached to a department or not
select Ins_Name, isnull(Dept_Name,'')
from Instructor i left join Department d
	on d.Dept_Id = i.Dept_Id

--[5] Display student full name and the name of the course he is taking
--    For only courses which have a grade
select concat(St_Fname, ' ', St_Lname) [full name], Crs_Name
from Student s inner join Stud_Course sc on s.St_Id = sc.St_Id
     inner join Course c on c.Crs_Id = sc.Crs_Id
where grade is not null

--[6] Display number of courses for each topic name
select t.Top_Name, count(Crs_Id) [Courses Num]
from Topic t inner join Course c
	on t.Top_Id = c.Top_Id
group by t.Top_Name

--[7] Display max and min salary for instructors
select max(salary) as maxS, min(salary) as minS
from Instructor

--[8] Display instructors who have salaries less than the average salary of all instructors.
select * from Instructor
where Salary < (select avg(isnull(Salary, 0)) from Instructor)

--[9] Display the Department name that contains the instructor who receives the minimum salary.
select Dept_Name
from Instructor i inner join Department d
	on i.Dept_Id = d.Dept_Id and Salary = (select min(salary) from Instructor)

--[10] Select max two salaries in instructor table. 
-- max two salaries with repeatition
select * 
from(
	select *,  DENSE_RANK() over(order by salary desc) as DR
	from instructor) as newtable
where DR <=2
-- max two salaries without repeatition
select * 
from(
	select *,  Row_Number() over(order by salary desc) as RN
	from instructor) as newtable
where RN <=2
-- top two salaries = max two salaries without repeatition
select top(2)*
from Instructor
order by Salary desc, ins_name

--[11] Select instructor name and his salary 
--	   but if there is no salary display instructor bonus keyword. “use coalesce Function”
select Ins_Id ,coalesce(salary, bonus, '')
from Instructor  -- there is no bounse column!

--[12] Select Average Salary for instructors 
select AVG(isnull(Salary, 0))
from Instructor

--[13] Select Student first name and the data of his supervisor
select stu.St_Fname ,sup.*
from Student stu inner join student sup
on stu.St_super = sup.St_Id

--[14] Write a query to select the highest two salaries in Each Department
--     for instructors who have salaries. “using one of Ranking Functions”
select Ins_Id, Dept_Id, Salary, RN
from(
	select *, ROW_NUMBER() over(partition by dept_id order by salary desc) as RN
	from Instructor 
	where Salary is not null) as newtable
where RN <= 2

--[15] Write a query to select a random student from each department.  “using one of Ranking Functions”
select *
from(
     select *, ROW_NUMBER() over(partition by dept_id order by newid()) as RN
     from Student) as newtable
where RN = 1
-------------------------------------------------------------------------------------------------------------
--Part-2: Use AdventureWorks DB
use AdventureWorks2012;

--[1] Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema)
--    to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
select SalesOrderID, ShipDate
from Sales.SalesOrderHeader
where OrderDate between '7/28/2002' and '7/29/2014';

--[2] Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select ProductID, Name
from Production.Product
where StandardCost < 110.00;

--[3] Display ProductID, Name if its weight is unknown
select ProductID, Name
from Production.Product
where Weight is null;

--[4] Display all Products with a Silver, Black, or Red Color
select Name, Color
from Production.Product
where Color in ('Silver', 'Black', 'Red');

--[5] Display any Product with a Name starting with the letter B
select Name
from Production.Product
where name like 'B%';

--[6] Write a query that displays any Product description with underscore value in its description.
update Production.ProductDescription 
set Description = 'Chromoly steel_High of defects'
where ProductDescriptionID = 3;

select *
from Production.ProductDescription 
where Description LIKE '%[_]%';

--[7] Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table
--    for the period between  '7/1/2001' and '7/31/2014'
select OrderDate, sum(TotalDue) as [Sum TotalDue]
from Sales.SalesOrderHeader
group by OrderDate
having OrderDate between '2001/01/07' and '2014/07/31';

--[8] Display the Employees HireDate (note no repeated values are allowed)
select distinct HireDate
from HumanResources.Employee;

--[9] Calculate the average of the unique ListPrices in the Product table
select avg(distinct ListPrice)
from Production.Product;

--[10] Display the Product Name and its ListPrice within the values of 100 and 120 
--     the list should has the following format "The [product name] is only! [List price]" 
--     (the list will be sorted according to its ListPrice value)
select concat('The ', Name, ' is only! ', ListPrice)
from Production.Product
where ListPrice between 100 and 120
order by ListPrice desc;

--[11] Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table 
--     in a newly created table named [store_Archive]
-- with data
select rowguid, Name, SalesPersonID, Demographics into store_archive
from Sales.Store;

select * 
from store_archive; -- 701 row
-- only structure of table
select rowguid, Name, SalesPersonID, Demographics into store_archive2
from Sales.Store
where 1 = 2;

--[12] Using union statement, retrieve the today’s date in different styles using convert or format funtion.
select format(getdate(), 'dd MM yyyy' )
union
select format(getdate(), 'dddd MMM yyyy' )
union
select format(getdate(), 'dd MM yyyy hh:mm:ss tt' )
union
select format(getdate(), 'hh tt' )
union
select format(getdate(), 'ddd-MMM-yy' )
union
select convert(nchar(20), getdate(), 101)
union
select convert(nchar(20), getdate(), 102)
union
select convert(nchar(20), getdate(), 103)
union
select convert(nchar(20), getdate(), 104)
union
select convert(nchar(20), getdate(), 105);

select format(eomonth(getdate(), 1), 'dddd MM yyyy')