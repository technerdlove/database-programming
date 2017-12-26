/*
 * Add an XML Schema Collection to the database MetroAlt called MaintenanceSchema
 * Create a new table BusMaintenance
*/
USE MetroAlt
CREATE XML SCHEMA COLLECTION sch_memo --can only have one schema per collection
AS --open quote. pasted xsd file. It's important that you don't put any whitespace in front of the xml.
'<?xml version="1.0" encoding="utf-8"?>
<!--
attributeFormDefault="unqualified" means: Do the elements of your document have a prefix like this

xmlns:xs="http://www.w3.org/2001/XMLSchema". xs is a shortcut for the schema. 

<xs:element name="memo"> element is a schema term. Want to separate schema elements from the memo elements.


-->
<xs:schema attributeFormDefault="unqualified" elementFormDefault="qualified" targetNamespace="http://www.MetroAlt.com/memo" xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="memo">
    <xs:complexType> <!--complex because it contains elements-->
      <xs:sequence>
        <xs:element name="heading"> <!-- this is the first element-->
          <xs:complexType>
            <xs:sequence>
              <xs:element name="to" type="xs:string" />
              <xs:element name="from" type="xs:string" />
              <xs:element name="about" type="xs:string" />
              <xs:element name="date" type="xs:date" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
        <xs:element name="body">
          <xs:complexType>
            <xs:sequence>
              <xs:element maxOccurs="unbounded" name="p" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
'--close quote

CREATE TABLE memos
(
	memoId INT IDENTITY (1,1),
	memoText XML(sch_memo) --associates the schema with the file.
)



INSERT INTO memos (memoText)
VALUES 
('<?xml version="1.0" encoding="utf-8"?> 
<?xml-stylesheet type="text/xsl" href="memo.xslt"?>

<!--THE PURPOSE OF THIS ENTIRE FILE IS TO ADD MEMO TO THE METROALT DATABASE IN SQL SERVER-->
<m:memo xmlns:m="http://www.MetroAlt.com/memo">
  <m:heading>
    <m:to>Drivers</m:to>
	<m:from>Dispatchers</m:from>
    <m:about>Road Closures</m:about>
    <m:date>2015-07-28</m:date> <!-- Date must be entered as YYYY-MM-DD if you want it as date and not a string in xml-->
  </m:heading>
<!-- Without the namespace, the stuff in the body can be really complicated and confusing in html. 
The namespace separates it out.-->
  <m:body>
    <!-- Put more than one paragraph tag in the body because we will create a schema from this document.
    When put more than one paragraph tag, the schema will say that you can have as many paragraphs as you want.
    If you put one, the schema will say that you can only have one paragraph.-->
    <m:p>There are several road closures this week.</m:p>
    <m:p>Watch for bulletins and notices.</m:p>
  </m:body>
  
</m:memo>
')


--select xml from structured data
SELECT *
FROM Employee
FOR XML RAW, ELEMENTS, ROOT('employees') -- THREE MODES:RAW, EXPLICIT, AND AUTO

USE MetroAlt
SELECT *
FROM Employee
WHERE EmployeeCity='Kent'
FOR XML RAW('employee'), ELEMENTS, ROOT('employees')



SELECT PositionName, EmployeeLastName, EmployeeFirstName, EmployeeEmail
FROM Employee
INNER JOIN EmployeePosition
ON Employee.EmployeeKey=EmployeePosition.EmployeeKey
INNER JOIN Position
ON Position.PositionKey=EmployeePosition.PositionKey
WHERE EmployeeCity='Bellevue'
FOR XML AUTO, ELEMENTS, ROOT ('Employees')
