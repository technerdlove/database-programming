
/*--summary of how many buses are assigned to each bus barn
*/
--use the following drop statement only if necessary
--DROP VIEW vw_TotalBusesInEachBusBarn
USE MetroAlt
GO
CREATE VIEW vw_TotalBusesInEachBusBarn
AS
SELECT COUNT (b.BusKey) AS [Number of Buses],
b.BusBarnKey AS [Bus Barn]
FROM Bus b
INNER JOIN BusBarn x
ON b.BusBarnKey=x.BusBarnKey
GROUP BY b.BusBarnKey

/*
A schedule for a particular bus route
(do this as a stored procedure where the 
buskey can be passed as a parameter. 
This will simply be a schedule of the stops 
not the times since somehow that table didn't get populated.)
*/
USE MetroAlt
--use the following drop statement only if necessary
--DROP PROC usp_ScheduleOfStops
GO
CREATE PROC usp_ScheduleOfStops
@particularBusRoute Int -- parameter necessary for the stored procedure
AS
SELECT br.BusRouteKey AS [Bus Route],
bs.BusStopKey AS [Bus Stop],
bs.BusStopAddress AS [Address],
bs.BusStopCity AS [City],
bs.BusStopZipcode AS [Zipcode]
FROM BusStop bs
INNER JOIN BusRouteStops brs
ON brs.BusStopKey=bs.BusStopKey
INNER JOIN BusRoute br
ON br.BusRouteKey=brs.BusRouteKey
WHERE br.BusRouteKey = @particularBusRoute

EXEC usp_ScheduleOfStops '9'


/*
The count of employees by position
*/
USE MetroAlt
--use the following drop statement only if necessary
--DROP VIEW vw_CountOfEmployeesByPosition
GO
CREATE VIEW vw_CountOfEmployeesByPosition
AS
SELECT COUNT (es.EmployeeKey) AS [Employees],
es.PositionKey AS [Position]
FROM EmployeePosition es
INNER JOIN Employee e
ON es.EmployeeKey = e.EmployeeKey
GROUP BY es.PositionKey 



/*--The total revenues per city per year
*/
USE MetroAlt
--use the following drop statement only if necessary
--DROP VIEW vw_TotalRevenuesPerCityPerYear
GO 
CREATE VIEW vw_TotalRevenuesPerCityPerYear
AS
Select Year(BusScheduleAssignmentDate) as[Year]
,BusRoutezone,
case 
When Year(BusScheduleAssignmentDate)=2012 then 2.40
When Year(BusScheduleAssignmentDate)=2013 then 3.15
When Year(BusScheduleAssignmentDate)=2014 then 3.25
When Year(BusScheduleAssignmentDate)=2015 
then 3.50
end
 [Bus Fare],
Count(Riders) as [total Riders],
case 
When Year(BusScheduleAssignmentDate)=2012 then 2.40
When Year(BusScheduleAssignmentDate)=2013 then 3.15
When Year(BusScheduleAssignmentDate)=2014 then 3.25
When Year(BusScheduleAssignmentDate)=2015 
then 3.50
end *  count(riders) as [Total Fares]
from BusRoute br
inner join BusScheduleAssignment bsa
on br.BusRouteKey=bsa.BusRouteKey
inner Join Ridership r
on r.BusScheduleAssigmentKey=
bsa.BusScheduleAssignmentKey
Group by Year(BusScheduleAssignmentDate),
busRouteZone


/*
The total amount earned by a driver in a year 
(make it a stored procedure and pass in year and driverKey as parameters)
*/

USE MetroAlt
--use the following drop statement only if necessary
--DROP PROC usp_TotalAmountEarnedByADriverInAYear
GO
CREATE PROC usp_TotalAmountEarnedByADriverInAYear
@year int
AS
Select EmployeeLastName,
EmployeefirstName,
PositionName,
YEar(BusScheduleAssignmentDate) [Year],
EmployeeHourlyPayRate,
Sum(DateDiff(hh, BusDriverShiftSTarttime, BusDriverShiftStopTime)) [total Hours],
Sum(DateDiff(hh, BusDriverShiftSTarttime, BusDriverShiftStopTime)) * EmployeeHourlyPayRate [Annual Pay]
From employee e
inner Join EmployeePosition ep
on e.EmployeeKey = ep.EmployeeKey
inner join Position p
on  p.PositionKey=ep.PositionKey
inner join BusScheduleAssignment bsa
on e.EmployeeKey=bsa.EmployeeKey
inner Join BusDriverShift bs
on bs.BusDriverShiftKey =bsa.BusDriverShiftKey
Where YEar(BusScheduleAssignmentDate)=@year --changed this to year parameter
--And e.EmployeeKey=16
Group by  EmployeeLastName,
EmployeefirstName,
PositionName,
YEar(BusScheduleAssignmentDate),
EmployeeHourlyPayRate
