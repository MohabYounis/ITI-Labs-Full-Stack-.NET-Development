use ITI

-- 1 Create a view that displays student full name, course name if the student has a grade more than 50. 
alter view VStudCours([Full Name], [Course Name], Grades)
WITH ENCRYPTION
as 
	select St_Fname+' '+St_Lname, Crs_Name, Grade
	from Student S 
	inner join Stud_Course SC on S.St_Id = SC.St_Id and Grade > 50
	inner join Course C on C.Crs_Id = SC.Crs_Id
	with check option

select * from VStudCours

--2 Create an Encrypted view that displays manager names and the topics they teach.
alter view VMang([Manager Name], [Topic])
WITH ENCRYPTION
as
	select Ins_name, Top_Name 
	from Department D 
	inner join Instructor I on D.Dept_Manager = I.Ins_Id
	inner join Ins_Course IT on I.Ins_Id = IT.Ins_Id
	inner join Course C on C.Crs_Id = IT.Crs_Id
	inner join Topic T on T.Top_Id = C.Top_Id

select * from VMang

--3	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
create view Vinst ([Instructor Name], [Department Name])
with encryption
as 
	select Ins_Name, Dept_Name
	from Instructor I 
	inner join Department D on I.Dept_Id = D.Dept_Id and Dept_Name In ('SD', 'Java')
	with check option

select * from Vinst

--4 Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
--		Note: Prevent the users to run the following query 
--		Update V1 set st_address=’tanta’
--		Where st_address=’alex’;

create view V1 
with encryption 
as 
	select * from student
	where St_Address in ('Alex', 'Cairo')
	with check option

select * from V1

update v1 
	set St_Address = 'tanta' --- xxxxx
	where St_Address = 'Alex'

--5	Create a view that will display the project name and the number of employees work on it. “Use Company DB”
use Company_SD

alter view Vproj
with encryption
as
	select Pname, count(*) as EmNum
	from Works_for Wf
	inner join Project P on Wf.Pno = P.Pnumber
	group by Pname

select * from Vproj

--6	Create the following schema and transfer the following tables to it 
	--	Company Schema 
	--	Department table (Programmatically)
	--	Project table (by wizard)
	--	Human Resource Schema
	--	Employee table (Programmatically)
create schema Company
alter schema Company transfer Departments

--7	Create index on column (manager_Hiredate) that allow u to cluster the data in table Department. What will happen?  - Use ITI DB
use iti

-- can't use clustered cause the table have primary key and already one clustered index
create nonclustered index myIndex1
on Department(Manager_hiredate) --but we can create non clustered index

--8	Create index that allow u to enter unique ages in student table. What will happen?  - Use ITI DB
create unique index myIndex2
on Student(St_Age) --Can Not Do That Because Age Values Are Duplicated

--9	Create a cursor for Employee table that increases Employee salary by 10% if Salary <3000
--	and increases it by 20% if Salary >=3000. Use company DB
use Company_SD

declare c1 cursor
for select Salary
	from Employee
for update 
declare @sal int
open c1 
fetch c1 into @sal
while @@FETCH_STATUS = 0
	begin
		if @sal < 3000
			update Employee
				set Salary = @sal * 1.1
			where current of c1
		else
			update Employee
				set Salary = @sal * 1.2
			where current of c1
		fetch c1 into @sal
	end
close c1 
deallocate c1

select salary from Employee

--10 Display Department name with its manager name using cursor. Use ITI DB
use iti 

declare c1 cursor
for select Dept_name, Dept_Manager
	from Department
for read only
declare @Dname varchar(20), @Dmang varchar(20)
open c1
fetch c1 into @Dname,@Dmang
while @@FETCH_STATUS =0
	begin
		select @Dname, @Dmang
		fetch c1 into @Dname, @Dmang
	end
close c1
deallocate c1

--11 Try to display all instructor names in one cell separated by comma. Using Cursor . Use ITI DB
declare c1 cursor
for select distinct Ins_Name
	from Instructor
for read only
declare @all varchar(300), @name varchar(20)
open c1
fetch c1 into @name
while @@FETCH_STATUS = 0
	begin
		set @all = concat(@all, ',', @name)
		fetch c1 into @name
	end
select @all 
close C1
deallocate c1

--12 Try to generate script from DB ITI that describes all tables and views in this DB
	
	--Error because of the encryption of views
