use Day3

create table Instructor
(
Id int primary key,
Fname varchar(20),
Lname varchar(20),
Salary int default 3000,
Netsalary as (Salary+Overtime),
Overtime int unique,
BD date,
age as (year(getdate())-year(BD)),
Hiredate date default getdate(),
Address varchar(50),
constraint c1 check(Address in ('Cairo','Alex')),
constraint c2 check(Salary between 1000 and 5000),
)

create table Course
(
CID int primary key,
Cname varchar(20),
Duration int unique
)

create table Lab 
(
CID int,
LTD int,
Location varchar(20),
Capacity int,
constraint c3 primary key (CID,LTD),
constraint c4 foreign key (CID) references Course(CID)
	on delete cascade on update cascade,
constraint c5 check(Capacity < 20)
)

create table Instructor_Courses
(
Ins_Id int,
Course_Id int
constraint c6 primary key (Ins_Id,Course_Id)
Constraint c7 foreign key (Ins_ID) references Instructor(Id)
	on delete cascade on update cascade,
constraint c8 foreign key (Course_Id) references Course(CID)
	on delete cascade on update cascade
)

-- insert an instructor 
insert into Instructor(Id,Fname,Lname,Salary,Overtime,BD,Address)
values(1,'Mohab','Younis',4500,8,'1/16/2000','Cairo')

select * 
from Instructor
where Id = 1

-- insert a course
insert into Course
values(1,'SQL',20)

select * 
from Course
where CID = 1

-- insert a lab
insert into Lab
values(1,1,'3rd floor',19)

-- inser the courses to instructors 
insert into Instructor_Courses
values(1,1)

select * 
from Instructor_Courses
where Ins_Id = 1 and Course_Id = 1