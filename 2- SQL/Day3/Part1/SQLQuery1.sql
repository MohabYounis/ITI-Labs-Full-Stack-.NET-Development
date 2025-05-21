use Company_SD

-- Display the Department id, name and id and the name of its manager.
select Dnum, Dname, SSN, Fname
from Employee, Departments
where MGRSSN = SSN

--	Display the name of the departments and the name of the projects under its control.
select Dname, Pname
from Project P, Departments D
where P.Dnum = D.Dnum
order by Dname

--	Display the full data about all the dependence associated with the name of the employee they depend on him/her.
select Fname+' '+Lname as [FullName], D.*
from Employee E inner join Dependent D
on SSN = ESSN

--	Display the Id, name and location of the projects in Cairo or Alex city.
select Pnumber, Pname, Plocation
from Project
where City in ('Cairo', 'Alex')

--	Display the Projects full data of the projects with a name starts with "a" letter.
select *
from Project
where Pname like 'a%'

--	display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
select *
from Employee
where Dno = 30 and Salary between 1000 and 2000 

--	Retrieve the names of all employees in department 10 who works more than or equal10 hours per week on "AL Rabwah" project.
select Fname
from Employee E, Works_for WF, Project P 
where SSN = ESSN and Pnumber = Pno and E.Dno = 10 and Hours >= 10 and Pname = 'AL Rabwah'

--	Find the names of the employees who directly supervised with Kamel Mohamed.
select E.Fname+' '+E.Lname as [Full Name]
from Employee E, Employee S
where S.SSN = E.Superssn and S.Fname = 'Kamel' and S.Lname = 'Mohamed'

--	Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
select Fname+' '+Lname as [Full Name], Pname
from Employee E, Works_for WF, Project P
where SSN = ESSn and Pno = Pnumber
order by Pname

--	For each project located in Cairo City , find the project number, the controlling department name,
--  the department manager last name ,address and birthdate.
select Pnumber, Dname, Lname, E.Address, Bdate
from Employee E, Project P, Departments D
where SSN = MGRSSN and D.Dnum = P.Dnum and City = 'Cairo'

--  Display All Data of the managers
select E.*
from Employee E, Departments D
where SSN = MGRSSN

--	Display All Employees data and the data of their dependents even if they have no dependents
select E.*, D.*
from Employee E left outer join Dependent D
on SSN = ESSN

--  Insert your personal data to the employee table as a new employee in department number 30,
--  SSN = 102672, Superssn = 112233, salary=3000.
insert into Employee
values('Mohab','Younis',102672,'1/16/2000','Menoufia','M',3000,112233,30)

select *
from Employee
where SSN = 102672

--	Insert another employee with personal data your friend as new employee in department number 30,
--  SSN = 102660, but don’t enter any value for salary or supervisor number to him.
insert into Employee(Fname,Lname,SSN,Dno)
values('Amr','Younis',102660,30)

select *
from Employee
where SSN = 102660

--	Upgrade your salary by 20 % of its last value.
update Employee
set Salary *= 1.2
where SSN = 102672

select Fname, Salary
from Employee
where SSN = 102672






