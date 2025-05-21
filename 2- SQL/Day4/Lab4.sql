use Company_SD

/* 1-Display (Using Union Function)
	  a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
	  b.	 And the male dependence that depends on Male Employee.
*/
select D.Dependent_name, D.Sex
from Employee E inner join Dependent D
	on SSN = ESSN and D.Sex = 'F' and E.Sex = 'F'
union all
select D.Dependent_name, D.Sex
from Employee E inner join Dependent D
	on SSN = ESSN and D.Sex = 'M' and E.Sex = 'M'

-- 2-For each project, list the project name and the total hours per week (for all employees) spent on that project.
select Pname, sum(Hours) [Total Hours]
from Company.Project P inner join Works_for WF
	on Pnumber = Pno
group by Pname

-- 3-Display the data of the department which has the smallest employee ID over all employees' ID.
select *
from Departments 
where Dnum = (select Dno
			  from Employee
			  where SSN = (select min(SSN) from Employee))
-------------
select d.*
from employee e inner join Departments d
	on e.Dno = d.Dnum
where e.ssn = (select min(ssn) from employee)

-- 4-For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
select Dname, max(Salary) Max, min(Salary) Min, avg(isnull(Salary,0)) Average
from Employee inner join Departments
	on Dno = Dnum
group by Dname

-- 5-List the full name of all managers who have no dependents.
select Fname+' '+Lname as [Full Name]
from Employee
	where SSN in (select MGRSSN from Departments where MGRSSN not in (select ESSN from Dependent))

-- 6-For each department-- if its average salary is less than the average salary of all employees--
-- display its number, name and number of its employees.

select Dnum, Dname, count(*) employeesNum
from Departments D inner join Employee E
	on Dnum = Dno
group by Dnum, Dname
	having Avg(isnull(Salary,0)) < (select avg(isnull(Salary,0)) from Employee)

-- 7-Retrieve a list of employee’s names and the projects names they are working on ordered by
-- department number and within each department,ordered alphabetically by last name, first name.
select e.Fname+' '+e.Lname [Full Name], p.Pname
from 
	Employee e inner join Works_for w on SSN = ESSn
	inner join Project p on Pno = Pnumber
order by Dno, [Full Name]

-- 8-Try to get the max 2 salaries using sub query
select top(2) Salary
from Employee
order by Salary desc

-- 9-Get the full name of employees that is similar to any dependent name
select distinct Fname+' '+Lname [Full Name]
from Employee inner join Dependent
	on SSN = ESSN and Dependent_name like '%'+Fname+' '+Lname+'%'

-- 10-Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
select SSN, Fname, Lname
from Employee
	where Exists (select * from	Dependent where ESSN = SSN) --distinct result
----------------
select ssn, fname, lname
from employee
where ssn in (select essn from dependent)
----------------
select distinct SSN, Fname, Lname
from Employee inner join Dependent
	on SSN = ESSN

-- 11-In the department table insert new department called "DEPT IT”, with id 100,
-- employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'
insert into Departments (Dname, Dnum, MGRSSN, [MGRStart Date])
values('DEPT IT', 101, 112233, '1-11-2006')

-- 12-Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574) moved to be the manager of the new department (id = 100),
-- and they give you(your SSN =102672) her position (Dept. 20 manager) 
--	a.	First try to update her record in the department table
--	b.	Update your record to be department 20 manager.
--	c.	Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)
update Departments
	set MGRSSN = 968574, [MGRStart Date] = GETDATE()
	where Dnum = 100
update Employee
	set Dno = 100
	where SSN = 968574
update Departments
	set MGRSSN = 102672, [MGRStart Date] = GETDATE()
	where Dnum = 20
update Employee
	set Dno = 20
	where SSN = 102672
update Employee
	set Superssn = 102672
	where SSN = 102660

-- 13-Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344)
-- so try to delete his data from your database in case you know that you will be temporarily in his position.
-- Hint: (Check if Mr. Kamel has dependents, works as a department manager,
-- supervises any employees or works in any projects and handle these cases).
if exists (select * from Dependent where ESSn = 223344)
	begin
	delete from Dependent
		where ESSN = 223344
	end
else
	select 'No Data'
if exists(select * from Departments where MGRSSN = 223344)
	begin
	update Departments
		set MGRSSN = 102672, [MGRStart Date] = GETDATE()
		where MGRSSN = 223344
	end
else
	select 'No Data'
if exists(select * from Works_for where ESSn = 223344)
	begin
	update Works_for
		set ESSn = 102672, Hours = 0
		where ESSn = 223344
	end
else
	select 'No Data'
if exists(select * from Employee where SSN = 223344)
	begin
	update Employee
		set Superssn = 102672
		where Superssn = 223344
	delete from Employee
		where SSN = 223344
	end
else
	select 'No Data'
----------------
update Employee
	set Superssn = 102672
where Superssn = 223344
update Works_for
	set ESSn = 102672
where ESSn = 223344
update Departments
	set MGRSSN = 102672
where MGRSSN = 223344
delete from Dependent
Where ESSN = 223344
delete from Employee
where SSN = 223344

-- 14-Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
update Employee 
	set Salary *= 1.3
where SSN in (select ESSn from Project inner join Works_for on Pnumber = Pno and Pname = 'Al Rabwah')
