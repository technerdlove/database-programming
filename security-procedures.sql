/*
The task here is to create views and procedures for different users and schema.

Create a schema for every Position. There should also be a role for every position. 
Create at least one view for every schema that would represent a typical perspective on the data for employees who hold that position. 

All the following procedures should be part of the manager's schema:

Create a stored procedure that lets a manager update an Employee's information.

Create a stored procedure that assigns a driver to a route for a day. 

Create a stored procedure that returns how many hours an employee worked during two dates. 
*/

--Create a stored procedure that lets a manager update an Employee's information.
USE MetroAlt
GO
DROP PROC DriverSchema.usp_ManagerUpdatePersonal
GO
CREATE PROC DriverSchema.usp_ManagerUpdatePersonal
@LastName nvarchar (255),
@FirstName nvarchar (255), 
@Address nvarchar (255), 
@City nvarchar (255) = 'Seattle',  --makes a default. If you don't enter anything for that field, it defaults to Seattle
@Zip nchar (5), 
@Phone nchar (10),
@EmployeeId int
--we haven't included email because the data just has the company email
AS
--as a bonus, create a way to check if the employeeID actually exists in the database
IF EXISTS --if the employee is in the list.  Exist returns a boolean, true or false
(SELECT EmployeeKey FROM Employee
WHERE EmployeeKey = @EmployeeID)
BEGIN --this is like a curly brace. Begin is the opening curly brace
UPDATE Employee
SET 
EmployeeLastName = @LastName, 
EmployeeFirstName = @FirstName,
EmployeeAddress = @Address, 
EmployeeCity = @City, 
EmployeeZipCode = @Zip,
EmployeePhone = @Phone 
WHERE EmployeeKey = @EmployeeId
--RETURN 1
--you could put in a try catch, so that if there are any errors it would show
--you could also check if the employee exists.  Here we do that
END --this is like a curly brace.  End is the ending curly brace
ELSE
BEGIN --begin curly brace
DECLARE @msg nvarchar (30)
SET @msg = 'Employee does not exist'
PRINT @msg --PRINT doesn't work outside of management studion.  
--If you are working in an ASP.NET page, or a C# or Java environment print doesn't work.  You need a return statement.  
--RETURN @msg --in asp.net, the return would return the message value
--RETURN 0 --can't return a message, can only return an integer
END --end curly brace

EXEC DriverSchema.usp_UpdatePersonal
@LastName = 'Kenner-Jones', 
@FirstName = 'Susanne',
@Address = '234 Some Other Street', 
@City = 'Seattle', 
@Zip = '98100',
@Phone = '2067779999',
--@EmployeeId = 1 
@EmployeeId = 6000

