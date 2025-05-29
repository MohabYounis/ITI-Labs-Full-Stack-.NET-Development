-- [1] Create a stored procedure without parameters to show the number of students per department name.[use ITI DB] 
create proc stNum
as
	select Dept_name, count(*) as Students_number
	from student s inner join department d
		on s.Dept_Id = d.Dept_Id
	group by Dept_Name

stNum

-- [2] Create a stored procedure that will check for the number of employees in the project 100 if they are more than 3 
--     print message to the user “'The number of employees in the project 100 is 3 or more'” 
--     if they are less display a message to the user “'The following employees work for the project 100'” 
--     in addition to the first name and last name of each one. [Company DB]
alter proc empCheck
as
	declare @count int, @allnames varchar(500)
	select @count = count(*)
	from Works_for
	where Pno = 100
	if @count >= 3
		select 'The number of employees in the project 100 is 3 or more'
	else
		begin
			select @allnames = concat(@allnames, ',', fname, ' ', lname)
			from Employee e inner join Works_for w on SSN = ESSn
			where Pno = 100

			select concat('The following employees work for the project 100', ' ', @allnames)
		end

empCheck

-- [3] Create a stored procedure that will be used in case there is an old employee has left the project 
--     and a new one become instead of him. The procedure should take 3 parameters 
--     (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [Company DB]
alter proc updateWorksOn @oldNum int, @newNum int, @pNum int
as
	begin try
		update Works_for
			set Essn = @newNum
		where Essn = @oldNum and Pno = @pNum
	end try
	begin catch
		select @@error
	end catch

updateWorksOn 102672,112233,100

-- [4] add column budget in project table and insert any draft values in it then 
--     then Create an Audit table with the following structure 
--     ProjectNo UserName ModifiedDate Budget_Old Budget_New 
--     p2 Dbo 2008-01-31 95000 200000
create table Audit(
pno int,
u_name varchar(100),
modified_date datetime,
old_budget int,
new_budget int
)

create trigger t1
on project
after update
	as
		if update(budget)
			begin
				declare @pno int, @old int, @new int

				select @old = budget, @pno = Pnumber from deleted
				select @new = budget from inserted
			
				insert into Audit values(@pno, suser_name(), getdate(), @old, @new)
			end

update project
	set Budget = 55555
where pnumber = 100

select * from audit

-- [5] Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--     “Print a message for user to tell him that he can’t insert a new record in that table”
create trigger t2
on department
instead of insert
	as
		select 'Not Allowed'

insert into Department (dept_name)
values('test trigger')

-- [6] Create a trigger that prevents the insertion Process for Employee table in March [Company DB].
alter trigger t3
on employee
instead of insert
	as
		if format(getdate(), 'MMMM') = 'march'
			select 'Not Allowed'
		else
			begin
				insert into Employee
				select * from inserted
			end

insert into employee (fname, lname, Salary, SSN)
values('Mokrem', 'Ahmed', 15000, 145987)

-- [7] Create a trigger on student table after insert to add Row in Student Audit table 
--     (Server User Name , Date, Note) where note will be “[username] Insert New Row with Key=[Key Value] 
--     in table [table name]”

create table studentAudit (u_name varchar(100), insert_date datetime, note varchar(200))

alter trigger t4
on student
for insert
	as
		BEGIN
			INSERT INTO studentAudit
			SELECT 
				SUSER_NAME(), 
				GETDATE(), 
				'[ ' + SUSER_NAME() + ' ] Inserted New Row with Key = ' + CAST(St_Id AS VARCHAR) + ' in table [student]'
			FROM inserted;
		END;

insert into student (st_id,st_fname, st_lname)
values(1256,'ahmed', 'mohamed')

select * from studentaudit

-- [8] Create a trigger on student table instead of delete to add Row in Student Audit table 
--     (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”
create trigger t5
on student
instead of delete
as
	begin
		insert into studentAudit
		select
			suser_name(),
			getdate(),
			'Try to delete row with key = ' + convert(varchar,st_id)
		from deleted
	end

delete from student
	where st_id = 1256

select * from studentaudit