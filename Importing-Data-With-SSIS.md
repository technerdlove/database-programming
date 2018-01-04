# Here i create an SSIS package to import text into a database:
* The text file is NewEmployees. 
* This is a comma delimited file that lists 12 new employees including their position, hourly pay and hire date.  

## Steps
1. The data needs to be distributed between two tables--Employee and EmployeePosition.
2. It will also need to look up the key value for the Position.

## Outcome
![Image 1](/images/Importing-Data-With-SSIS/idssis1.png)

![Image 2](/images/Importing-Data-With-SSIS/idssis2.png)

![Image 3](/images/Importing-Data-With-SSIS/idssis3.png)

I created another file and changed the first names and email addresses. This was to account for a few errors I was getting and controlling for non-unique entries.  Here is my snippet of a query returning the new employees from my file:

![Image 4](/images/Importing-Data-With-SSIS/idssis4.png)

![Image 5](/images/Importing-Data-With-SSIS/idssis5.png)




