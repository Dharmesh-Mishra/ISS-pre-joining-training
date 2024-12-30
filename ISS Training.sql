-- 1. Need for database
-- Ans: Database is collection of interrelated data, DBMS is a set of programs to access those data. Traditional file system had many drawbacks like data redundancy, data inconsistency, difficulty in accessing data, data integrity and concurrent access by multiple users. A database along with a DBMS can solve these problems. Databases are used to store, manage, retrieve large amount of data effectively. They provide us a structured way to handle all the data while ensuring data security, consistency and integrity.

-- 2. Basic Queries

-- create database
create database ISS_Training;
use ISS_Training;

-- create tables
create table Customers
(cust_id int primary key auto_increment,
cust_name varchar(100) not null,
email_id varchar(100) unique);

create table Products
(prod_id int primary key,
prod_name varchar(100) not null,
price decimal(10,2));

create table Orders
(order_id int primary key auto_increment,
customer_id int,
product_id int,
quantity int not null,
order_date date not null,
foreign key (customer_id) references Customers(cust_id),
foreign key (product_id) references Products(prod_id));

-- inserting values
insert into Customers (cust_name, email_id) values('Dharmesh', 'dharmeshmishra88@gmail.com'), ('Varun', 'varun@gmail.com'), 
('Sanjay','sanjay@gmail.com'),('Pragnya','pragnya@gmail.com');

insert into Products values (101, 'Bat', 500), (102, 'Ball', 50), (103, 'Football', 500), (120, 'T.V.', 30000);

insert into Orders (customer_id, product_id, quantity, order_date)values (1,101,2,'2024-12-22'), (1,102,20,'2024-12-22');
insert into Orders (customer_id, product_id, quantity, order_date)values (2,101,2,'2024-12-24'), (3,102,20,'2024-12-25');
-- select, distinct, where, and, or, order by
select * from Customers;
select * from Products;
select * from Orders;
select distinct price from Products;
select * from Products where price >1000;
select * from Orders where order_date < '2024-12-25' and quantity > 10;
select * from Orders where order_date < '2024-12-25' or quantity > 10;

select * from Products order by price;
select * from Products order by price desc;

update Products set price= 60 where prod_id= 102;
delete from Products where prod_id=103;

-- sql injection
select * from Customers where cust_id=420 or 1=1;

-- select top, like, wildcard, in, between , alias
select * from Products order by price desc limit 1;
select * from Customers where cust_name like 'D%';
select * from Products where prod_name like 'B%';
select * from Products where prod_name like 'B%t';
select * from Products where price in (100,500,1000);
select * from Orders where order_date between '2024-12-01' and '2024-12-31';
select * from Products where price between 50 and 500;
select prod_id as 'Product id', prod_name as 'Product name' from Products;

-- joins

select c.cust_name, p.prod_name, quantity
from Customers c
inner join Products p
inner join Orders o
on c.cust_id=o.customer_id and p.prod_id=o.product_id;

select c.cust_id, c.cust_name, order_id
from Customers c
left join Orders o
on c.cust_id=o.customer_id;

select p.prod_id, prod_name, order_id
from Orders o
right join Products p
on p.prod_id=o.product_id;

select cust_name, prod_name, order_id
from Customers c
left join Orders o on c.cust_id=o.customer_id
left join Products p on p.prod_id=o.product_id
union
select cust_name, prod_name, order_id
from Products p
left join Orders o on p.prod_id=o.product_id
left join Customers c on c.cust_id=o.customer_id;


-- select into, insert into select
create table OrderSummary as
select cust_name, sum(quantity) as 'Total Order Quantity'
from Orders o inner join Customers c 
on o.customer_id=c.cust_id
group by cust_name;

select * from OrderSummary;

create table tempcust
(cust_id int,
cust_name varchar(100),
email_id varchar(100));

insert into tempcust select * from Customers where cust_id=1;
select * from tempcust;

-- constraints not null, unique, check, default

create table Employee
(emp_id int primary key auto_increment,
emp_name varchar(100) not null,
email_id varchar(100) unique,
age int,
gender varchar(10) check (gender IN ('Male', 'Female')),
dept varchar(100) default 'Trainee',
salary decimal(10,2));

-- index
create index idx_email on Employee(email_id);
show index from Employee;

-- alter and drop
create table demo1
(id int primary key,
dname varchar(50));

alter table demo1 add description varchar(50);
alter table demo1 modify description varchar(200);
alter table demo1 rename column dname to title;
alter table demo1 add unique(title);
alter table demo1 drop column description;
drop table demo1;


-- views
Create View OrderDetails as
select
o.order_id,
c.cust_name as 'Customer Name',
p.prod_name as 'Product Name',
quantity,
price,
order_date
from Orders o 
join Customers c on c.cust_id=o.customer_id
join Products p on p.prod_id=o.product_id;

select * from OrderDetails;

-- null values and null functions
select * from Customers;
insert into Customers (cust_name, email_id) values ('Chirag', NULL);
select * from Customers where email_id is null;
select * from Customers where email_id is not null;
select cust_id, cust_name, coalesce(email_id,'NO EMAIL ID') as email from Customers;
select cust_id, cust_name, ifnull(email_id, 'NO EMAIL ID') as email from Customers;

-- group by and having

select customer_id, sum(quantity) 
from Orders
group by customer_id;

select customer_id, sum(quantity) 
from Orders
group by customer_id
having sum(quantity) >20;

-- stored procedure code

-- USE `iss_training`;
-- DROP procedure IF EXISTS `CustomerOrders`;

-- DELIMITER $$
-- USE `iss_training`$$
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `CustomerOrders`(IN cust_id INT)
-- BEGIN
-- 	select * from Orders where customer_id=cust_id;
-- END$$

-- DELIMITER ;

CALL CustomerOrders(1);
CALL CustomerOrders(2);

-- stored procedure code

-- USE `iss_training`;
-- DROP procedure IF EXISTS `GetQuantity`;

-- DELIMITER $$
-- USE `iss_training`$$
-- CREATE PROCEDURE GetQuantity (IN cust_id INT, OUT total INT)
-- BEGIN
-- 	select sum(quantity) INTO total
--     from Orders 
--     where customer_id=cust_id;
-- END$$

-- DELIMITER ;

CALL GetQuantity(1, @total);
select @total;


-- 4. Concept of normalization
-- efficiently organizing data in a database to eliminate redundant data i.e. storing same data multiple places
-- 1NF : atomic values- values of every column cant be divided further and no repeating columns
-- 2NF : in 1nf and no partial dependency of any columns on pk. eg- a table has primary as a combination of 2 columns, then non primary should not depend on only 1 pk.
-- 3NF : in 2nf and no transitive dependency for non prime attributes .all non prime depend on pk

-- eg - if order table contains all info regarding order,customer, products
create table Orders1
(order_id int primary key,
customer_name varchar(100),
customer_email varchar(100),
product_name varchar(100),
product_price decimal(10,2),
quantity int,
order_date date);

-- this table is in un normalized and after normalization we get 3 different tables as below

-- create table Customers
-- (cust_id int primary key auto_increment,
-- cust_name varchar(100) not null,
-- email_id varchar(100) unique);

-- create table Products
-- (prod_id int primary key,
-- prod_name varchar(100) not null,
-- price decimal(10,2));

-- create table Orders
-- (order_id int primary key auto_increment,
-- customer_id int,
-- product_id int,
-- quantity int not null,
-- order_date date not null,
-- foreign key (customer_id) references Customers(cust_id),
-- foreign key (product_id) references Products(prod_id));