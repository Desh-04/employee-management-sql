USE MotorsCertification;

--STEP 3
--Delete the columns in productlines which are useless that do not infer anything:
ALTER TABLE productlines DROP COLUMN htmlDescription;
ALTER TABLE productlines DROP COLUMN image;

SELECT * FROM productlines;

--STEP 4
--Use a select statement to verify all insertions as well as updates:
SELECT TOP 3 * FROM offices;
SELECT TOP 3 * FROM employees;
SELECT TOP 3 * FROM customers;
SELECT TOP 3 * FROM orders;
SELECT TOP 3 * FROM payments;
SELECT TOP 3* FROM products;
SELECT TOP 3 * FROM orderdetails;

--STEP 5
--Find out the highest and the lowest amount:SELECT MAX(amount) AS HighestAmount, MIN(amount) AS LowestAmount 
FROM payments;

--STEP 6
--Give the unique count of customerName from customers:
SELECT COUNT(DISTINCT customerName) AS UniqueCustomerCount 
FROM customers;

--STEP 7
--Create a view from customers and payments named cust_payment and select customerName, amount, contactLastName, contactFirstName who have paid:
CREATE VIEW cust_payment AS
SELECT 
    cust.customerName, 
    pys.amount, 
    cust.contactLastName, 
    cust.contactFirstName
FROM customers cust
JOIN payments pys
ON cust.customerNumber = pys.customerNumber;

SELECT * FROM cust_payment;
--Truncate and Drop the view after operation:
--[Views doesn't store actual data, so don't have to truncate lets only Drop]
--Drop View
DROP VIEW cust_payment;

--STEP 8
-- Create a stored procedure on products which displays productLine for Classic Cars.
CREATE PROCEDURE GetClassicCars
AS
BEGIN
    SELECT productName, productLine 
    FROM products 
    WHERE productLine = 'Classic Cars';
END;

EXEC GetClassicCars;

--STEP 9
--Create a function to get the creditLimit of customers less than 96800:
CREATE FUNCTION GetCreditLimitBelow96800();
RETURNS TABLE
AS
RETURN
(
    SELECT customerNumber, customerName, creditLimit
    FROM customers
    WHERE creditLimit < 96800
);

SELECT * FROM GetCreditLimitBelow96800();

--STEP 10
--Create Trigger to store transaction record for employee table which displays employeeNumber, lastName, FirstName and office code upon insertion:
CREATE TRIGGER TrackEmployeeInsert
ON employees
AFTER INSERT
AS
BEGIN
    -- Capture newly inserted employee details
    SELECT employeeNumber AS ID, lastName AS Surname, firstName AS GivenName, officeCode AS Office_Location
    FROM inserted;
END;

INSERT INTO employees (employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES 
(2025, 'Lilly', 'Pritchet', '4325', 'lilly@classicmodelcars.com', 3, 1143, 'Sales Coordinator');

--STEP 11
--Create a Trigger to display customer number if the amount is greater than 10,000CREATE TRIGGER ShowHighPaymentCustomer
ON payments
AFTER INSERT
AS
BEGIN
    -- Check for payments greater than 10,000 and display customerNumber
    SELECT customerNumber 
    FROM inserted 
    WHERE amount > 10000;
END;

INSERT INTO payments (customerNumber, checkNumber, paymentDate, amount)
VALUES (144, 'DD123456', '2025-09-04', 80000.00);

--STEP12
--Create Users, Roles and Logins according to 3 Roles: Admin, HR, and Employee. 
--Admin can view full database and has full access, HR can view and access only employee and offices table.
--Employee can view all tablesonly.
--Note: work from Admin role for any changes to be made for database.

-- 1. Create Logins for Users
CREATE LOGIN MasterAdmin WITH PASSWORD = 'SecurePassAdmin@99';
CREATE LOGIN HRManager WITH PASSWORD = 'HR_SafeKey_456';
CREATE LOGIN StaffMember WITH PASSWORD = 'EmpAccess_789!';

--2. Create Database Users
USE MotorsCertification;
CREATE USER AdminControl FOR LOGIN MasterAdmin;
CREATE USER HRAccess FOR LOGIN HRManager;
CREATE USER GeneralViewer FOR LOGIN StaffMember;

--3.Define Roles and Assign Permissions
CREATE ROLE SystemManager;
CREATE ROLE HRUnit;
CREATE ROLE DataViewer;

--4.Grant Permissions Based on Roles
GRANT CONTROL ON DATABASE::MotorsCertification TO SystemManager; --Full Access for SystemManager
GRANT SELECT, INSERT, UPDATE, DELETE ON employees TO HRUnit; --HR Can Only Access employees and offices
GRANT SELECT, INSERT, UPDATE, DELETE ON offices TO HRUnit;
GRANT SELECT ON SCHEMA::dbo TO DataViewer; --Employees Can Only View All Tables

--5.Assign Users to Roles
ALTER ROLE SystemManager ADD MEMBER AdminControl;
ALTER ROLE HRUnit ADD MEMBER HRAccess;
ALTER ROLE DataViewer ADD MEMBER GeneralViewer;

SELECT * FROM sys.database_role_members

-- STEP 13
--Schedule a Job which backups and schedule it according to developer preference.

BACKUP DATABASE MotorsCertification TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.EDUREKA\MSSQL\Backup\MotorsCertification1.bak';











