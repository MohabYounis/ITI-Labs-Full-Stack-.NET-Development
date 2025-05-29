use iti

--1 Create a scalar function that takes date and returns Month name of that date.

CREATE FUNCTION GetMonthName(@date DATE)
RETURNS NVARCHAR(20)
AS
BEGIN
    RETURN DATENAME(MONTH, @date);
END;

select dbo.GetMonthName('04-04-1990')

--2 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.

create function getvalues(@x int , @y int)
returns @t table 
(
	col1 int
)
		as
		begin
			set @x += 1
			while @x<@y
				begin
				insert into @t
				select @x
				set @x += 1
				end
			return
		end
		    
select * from  dbo.getvalues(10,20)

--3 Create inline function that takes Student No and returns Department Name with Student full name.

create function getdeptname(@st_no int)
returns table 
		as return(
			 select Dept_Name, st_fname+' '+st_lname as fullname
			 from Student s inner join Department d
			 on s.Dept_Id=d.Dept_Id and s.St_Id = @st_no	
		)
select * from  dbo.getdeptname(1)

--4.	Create a scalar function that takes Student ID and returns a message to user 
--a.	If first name and Last name are null then display 'First name & last name are null'
--b.	If First name is null then display 'first name is null'
--c.	If Last name is null then display 'last name is null'
--d.	Else display 'First name & last name are not null'

create function getmsg(@st_id int)
returns nvarchar(50)  
     begin
	 declare @msg nvarchar(50)
	 declare @fname nvarchar(20)
	 declare @lname nvarchar(20)
	 select @fname=st_fname , @lname=St_Lname from student where St_Id = @st_id
	 if @fname is null and @lname is null
	 set @msg ='First name & last name are null'
	 else if @fname is null
	 set @msg ='first name is null'
	 else if @lname is null
	 set @msg ='last name is null'
	 else 
	 set @msg ='First name & last name are not null'
		 return @msg 
	 end

select dbo.getmsg(14) as msg
select dbo.getmsg(13)  as msg

--5 Create inline function that takes integer which represents manager ID and displays department name, Manager Name and hiring date 

create function getdetails(@mgr_id int)
returns table 
		as return(
			 select Dept_Name , Ins_Name , Manager_hiredate
			 from Department d inner join Instructor i
			 on i.Ins_Id=d.Dept_Manager and d.Dept_Manager=@mgr_id
		)
select * from  dbo.getdetails(1)

--6 Create multi-statements table-valued function that takes a string

alter function getstname(@string nvarchar(50))
returns @t table 
(
	studentName nvarchar(50)
)
		as
		begin
			 if @string ='first name'
						 insert into @t
	 					 select isnull(St_Fname,'') from Student
			 else if @string ='last name'
						 insert into @t
	 					 select isnull(St_Lname,'') from Student
			 else if @string ='full name'
						 insert into @t
	 					 select isnull(St_Fname+' '+St_Lname,'')  from Student
			 return
		end
		    
select * from  dbo.getstname('first name')
select * from  dbo.getstname('last name')
select * from  dbo.getstname('full name')

create schema tryLogin 

alter schema tryLogin transfer student
--7 Write a query that returns the Student No and Student first name without the last char

select St_Id 'Student No', substring(St_Fname,1,len(St_Fname)-1) 'Student first name' from student 

--8 Wirte query to delete all grades for the students Located in SD Department

delete Stud_Course from Stud_Course	 
		inner join student on 	 Stud_Course.St_Id = Student.St_Id 
		inner join Department on Department.Dept_Id = Student.Dept_Id
	where Dept_Name='SD'

--9 Using Merge statement between the following two tables [User ID, Transaction Amount]

merge into 'last transactions' as T
	using 'daily transactions' as S
		ON T.userid = S.userid
	when matched then
		update set T.amount = S.amount
	When not matched by target Then 
		insert(userid,amount)
		values(S.userid,S.amount)
	When not matched by Source
		Then delete;
