Create database PartShipmentDB
go
use PartShipmentDB
go
Create table Supplier 
(
SNo	varchar(5),
SName 	varchar(20), 
City 	varchar(30),
Registration smalldatetime,
Constraint PKSup primary key (SNo)
)

 
create table Part
(
 PNo varchar(5),
 Pname varchar(10),
 Color varchar(10),
 Weight float,
 City varchar(30),
 Constraint PKPart Primary Key (PNo) 
)


Create table Shipment 
(
SNo	varchar(5) ,
PNo	varchar(5),
Qty	numeric(5), 
Shipweight 	float
Constraint PKShip primary key (SNo,PNo),
Constraint FKShip1 foreign key (SNo) references Supplier(SNo),
Constraint FKShip2 foreign key (PNo) references Part(PNo)
)


insert into Supplier values ('S0001','Smith','London','1990-08-09')
insert into Supplier values ('S0002','Jones','Paris','1990-08-04')
insert into Supplier values ('S0003','Blake','Paris', '1994-02-06')
insert into Supplier values ('S0004','Clark','London','1975-03-05')
insert into Supplier values ('S0005','Adams','Athens','1990-09-01')
insert into Supplier values ('S0006','Tiger','Athens','1930-03-08')
insert into Supplier values ('S0007','Scott','Bangkok','1937-03-08')



Insert  into Part  values  ( 'P0001' , 'Nut' , 'Red' , 126.0 , 'London')
Insert  into Part  values  ( 'P0002' , 'Bolt' , 'Green', 17.0 , 'Paris')
Insert  into Part  values  ( 'P0003' , 'Screw' , 'Yellow', 17.0 , 'Oslo')
Insert  into Part  values  ( 'P0004' , 'Cam' , 'Red' , 18.0 , 'London')
Insert  into Part  values  ( 'P0005' , 'Cog' , 'Yellow' , 12.0 , 'Paris')
Insert  into Part  values  ( 'P0006' , 'Saw' , 'Red' , 19.0 , 'London')
Insert  into Part  values  ( 'P0007' , 'Nail' , 'Red' , 19.0 , 'Paris')
 


Insert into Shipment values ('S0001','P0001',300,4800)
Insert into Shipment values ('S0001','P0002',200,3400)
Insert into Shipment values ('S0001','P0003',400,6800)
Insert into Shipment values ('S0001','P0004',200,3600)
Insert into Shipment values ('S0001','P0005',100,1200)
Insert into Shipment values ('S0001','P0006',100,1900)
Insert into Shipment values ('S0002','P0001',300,4800)
Insert into Shipment values ('S0002','P0002',400,6800)
Insert into Shipment values ('S0003','P0002',200,3400)
Insert into Shipment values ('S0004','P0002',200,3400)
Insert into Shipment values ('S0004','P0004',300,5400)
Insert into Shipment values ('S0004','P0005',400,4800)
Insert into Shipment values ('S0005','P0005',1300,15600)
Insert into Shipment values ('S0006','P0007',2,38)


select * from Shipment

--EXISTS predicate
--1. Show details of suppliers that have made shipments.
--Join
Select distinct s.*
From Supplier s join shipment sh on s.SNo=sh.SNo
--In
Select *
From supplier
where SNo in (Select SNo
              From shipment)
--Exists
Select *
From Supplier s
Where exists (Select *
              From Shipment sh
			  where sh.SNo=s.SNo)
/*S0001	Smith	London	1990-08-09 00:00:00
S0002	Jones	Paris	1990-08-04 00:00:00
S0003	Blake	Paris	1994-02-06 00:00:00
S0004	Clark	London	1975-03-05 00:00:00
S0005	Adams	Athens	1990-09-01 00:00:00
S0006	Tiger	Athens	1930-03-08 00:00:00*/
--2. Show full details of all parts that have been shipped by supplier S0002
--Join
Select p.*
From part p join shipment sh on p.PNo=sh.PNo
Where SNo='S0002'
--In
Select *
From Part
Where PNo in (Select PNo
              From Shipment
			  Where SNo='S0002')
--Exists
Select p.*
From Part p
Where Exists (select PNo
              From Shipment sh
			  Where sh.PNo=p.PNo and SNo='S0002')
/*P0001	Nut	Red	126	London
P0002	Bolt	Green	17	Paris*/

--CASE expression
--3. Show details of suppliers and descriptions.
--Description is
--If city is London then: capital of England.
--If city is Paris then: capital of France
--Else: N/A

Select SNo, SName, City, (CASE 
							WHen City='London' then 'capital of England'
							when City='Paris' then 'capital of France'
							Else 'N/A'
							end) cityDescription
from Supplier

/*S0001	Smith	London	capital of England
S0002	Jones	Paris	capital of France
S0003	Blake	Paris	capital of France
S0004	Clark	London	capital of England
S0005	Adams	Athens	N/A
S0006	Tiger	Athens	N/A
S0007	Scott	Bangkok	N/A
*/

/*4 how detail of suppliers.
If year of registration <1945 then: before 1945
If year of registration from 1946 to 1975 then: before 1975
Else: after 1975
*/
Select SNo, SName, Registration,
					(CASE 
					when Year (Registration) <1945 then 'before 1945'
					when year(registration) <1975 then 'before 1975'
					end) timeReg
from Supplier

/*
S0001	Smith	1990-08-09 00:00:00	NULL
S0002	Jones	1990-08-04 00:00:00	NULL
S0003	Blake	1994-02-06 00:00:00	NULL
S0004	Clark	1975-03-05 00:00:00	NULL
S0005	Adams	1990-09-01 00:00:00	NULL
S0006	Tiger	1930-03-08 00:00:00	before 1945
S0007	Scott	1937-03-08 00:00:00	before 1945
*/

--5. How many red, green, yellow, white parts in each city
Select City, SUM(Case color when 'red' then 1 else 0 end) redcolor
			, sum(case color when 'green' then 1 else 0 end) Greencolor
			, sum(case color when 'yellow' then 1 else 0 end) YellowColor
			, sum(case color when 'white' then 1 else 0 end) WhiteColor
from Part
group by City

/*
London	3	0	0	0
Oslo	0	0	1	0
Paris	1	1	1	0
*/

--6. Show exactly three parts that have the most weight.
select top 3*
from part
order by weight desc

/*
P0001	Nut	Red	126	London
P0006	Saw	Red	19	London
P0007	Nail	Red	19	Paris
*/

--7. Which parts are in the three most weight?
select * 
from Part
where Weight IN ( select distinct top 3 weight
					from Part
					order by weight desc) 

/*
P0001	Nut	Red	126	London
P0004	Cam	Red	18	London
P0006	Saw	Red	19	London
P0007	Nail	Red	19	Paris
*/

--8. Show detail of the parts and rank of the parts based on weight. (Use RANK or DENSE_RANK)select PNo, Pname, Weight, (RAnk () Over (Order by weight desc)) Rank_weighfrom Part/*
P0001	Nut	126	1
P0006	Saw	19	2
P0007	Nail	19	2
P0004	Cam	18	4
P0002	Bolt	17	5
P0003	Screw	17	5
P0005	Cog	12	7
*/

select PNo, Pname, Weight, (Dense_RAnk () Over (Order by weight desc)) Rank_weighfrom Part/*P0001	Nut	126	1
P0006	Saw	19	2
P0007	Nail	19	2
P0004	Cam	18	3
P0002	Bolt	17	4
P0003	Screw	17	4
P0005	Cog	12	5
*/

--9. Which are the heaviest parts?
Insert into Part values ('P0009', 'ABC', 'Yellow', 126, 'NewYork')
select TOP 1 with ties*
from Part
order by weight desc

/*
P0001	Nut	Red	126	London
P0009	ABC	Yellow	126	NewYork
*/
-- 10. Which supplier has shipped the most parts? Show the name and number.select top 1 with ties s.SNo, s.SName, SUM(Qty)from supplier s Join shipment sh ON s.SNo=sh.SNogroup by s.SNo, s.SNameorder by sum(Qty) DESC/*S0001	Smith	1300
S0005	Adams	1300
*/

--11. Create a view”Supplier1990” of Suppliers registerd before 1990. The view has supplier number, name, 
--and registraiton year.
Create view Supplier1990
AS
Select SNo, SName, Year(Registration) Regyear
from Supplier
where Year(Registration)<1990

select* from Supplier1990

/*
S0004	Clark	1975
S0006	Tiger	1930
S0007	Scott	1937
*/

--12. Create a view of suppliers in Paris and all the parts that have been shipped by these suppliers. The 
--view ‘Supplier_Paris’ has: Sno, Sname, Pno, Pname, color, Qty, city.

create view Supplier_Paris AS
select s.SNo, SName, Pname, p.PNo, Color, Qty, p.City
from Supplier s, Shipment sh, Part p
where s.SNo=sh.SNo and sh.PNo=p.PNo
		And s.City='Paris'
/*
S0002	Jones	Nut	Red	300	London
S0002	Jones	Bolt	Green	400	Paris
S0003	Blake	Bolt	Green	200	Paris
*/

--13. Create a view of suppliers that have shipped parts located at the same city of the suppliers.
Create view view_abc as
select s.*
from Supplier s, Shipment sh, Part p
where s.SNo=sh.SNo And sh.PNo=p.PNo
		and s.City=p.City
/*
S0001	Smith	London	1990-08-09 00:00:00
S0001	Smith	London	1990-08-09 00:00:00
S0001	Smith	London	1990-08-09 00:00:00
S0002	Jones	Paris	1990-08-04 00:00:00
S0003	Blake	Paris	1994-02-06 00:00:00
S0004	Clark	London	1975-03-05 00:00:00
*/

--14. Write a query to get supplier name register in 1930. Use ‘Supplier1990’ view
select *
from Supplier1990
where Regyear=1930

/*
S0006	Tiger	1930
*/

--15. Write a query to get part number, name has been shipped by supplier in Paris. Use ‘Supplier_Paris’
--view
select Pname
from Supplier_Paris

/*
Nut
Bolt
Bolt
*/