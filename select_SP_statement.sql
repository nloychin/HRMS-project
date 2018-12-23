USE napat_l;
GO
--1
CREATE PROCEDURE Select_Emp_Info_Join_1
AS
	Select ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Address1, co.Country_Name, st.State_Name, ct.City_Name, ed.Emp_Mobile,
	ds.Desig_Name
	from Employee_Details AS ed 
	LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
	LEFT JOIN State AS st ON (ed.Emp_State_Id = st.State_Id)
	LEFT JOIN City AS ct ON (ed.Emp_City_Id = ct.City_Id)
	LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id);
RETURN
GO

EXEC Select_Emp_Info_Join_1
GO

--2
CREATE PROCEDURE Select_State_Info_Sort_ACS
AS
	SELECT st.State_Name, ct.Country_Name
	FROM State AS st LEFT JOIN Country AS ct ON (st.Country_Id = ct.Country_Id)
	ORDER BY st.State_Name ASC;
RETURN
GO

EXEC Select_State_Info_Sort_ACS
GO
--3
CREATE PROCEDURE Select_First3_Country_Sort
AS
	SELECT TOP(3) Country_Id, Country_Name
	FROM Country ORDER BY Country_Name ASC;
RETURN
GO

EXEC Select_First3_Country_Sort
GO
--4
CREATE PROCEDURE Select_Emp_Fname_StartA
AS
	SELECT * FROM Employee_Details WHERE LEFT(LOWER(Emp_First_Name), 1) = 'a';
RETURN
GO

EXEC Select_Emp_Fname_StartA
GO
--5
CREATE PROCEDURE Select_Emp_Fname_EndA
AS
	SELECT * FROM Employee_Details WHERE RIGHT(LOWER(Emp_First_Name), 1) = 'a';
RETURN
GO

EXEC Select_Emp_Fname_EndA
GO
--6
CREATE PROCEDURE Select_Emp_Inactive
AS
	SELECT * FROM Employee_Details WHERE Emp_Active = 0;
RETURN
GO

EXEC  Select_Emp_Inactive
GO
--7
CREATE PROCEDURE Select_Emp_Info_Rename_Columns
AS
	SELECT Emp_First_Name AS [First Name], Emp_Last_Name AS [Last Name], Emp_Middle_Name AS [Middle Name] 
	FROM Employee_Details;
RETURN
GO

EXEC  Select_Emp_Info_Rename_Columns
GO
--8
CREATE PROCEDURE Select_Print_total_num_Emp
AS
	SELECT COUNT(Emp_Id) AS [Total Number of Employees] FROM Employee_Details;
RETURN
GO

EXEC Select_Print_total_num_Emp
GO
--9
CREATE PROCEDURE Select_Print_total_num_Emp_Mname_Null
AS
	SELECT COUNT(Emp_Id) AS [Total Number of Employees] FROM Employee_Details WHERE (Emp_Middle_Name = 'NULL');
RETURN
GO

EXEC Select_Print_total_num_Emp_Mname_Null
GO

--10
CREATE PROCEDURE Select_Emp_Info_Mname_ChangeNull
AS
	SELECT Emp_First_Name AS [First Name], Emp_Last_Name AS [Last Name], 
	CASE WHEN Emp_Middle_Name = 'NULL' 
	THEN 'Not Applicable' 
	ELSE Emp_Middle_Name END
	AS [Middle Name] 
	FROM Employee_Details;
RETURN
GO

EXEC Select_Emp_Info_Mname_ChangeNull
GO

--11
CREATE PROCEDURE Select_Emp_Info_Concate_Names
AS
	SELECT CONCAT(Emp_First_Name, ' ',
	CASE WHEN Emp_Middle_Name = 'NULL' 
	THEN '' 
	ELSE CONCAT(Emp_Middle_Name,' ') END
	,Emp_Last_Name) AS [Full Name]
	FROM Employee_Details;
RETURN
GO

EXEC Select_Emp_Info_Concate_Names
GO
-- 12
CREATE PROCEDURE Select_Emp_Info_Sort_CountryName
AS
	SELECT * FROM Employee_Details AS ed 
	JOIN Country AS ct ON ed.Emp_Country_Id = ct.Country_Id
	ORDER BY ct.Country_Name ASC;
RETURN
GO

EXEC Select_Emp_Info_Sort_CountryName
GO
-- 13
CREATE PROCEDURE Select_First10_Emp_Info_Sort_Fname
AS
	SELECT TOP(10) * FROM Employee_Details ORDER BY Emp_First_Name ASC;
RETURN
GO

EXEC Select_First10_Emp_Info_Sort_Fname
GO
-- 14
CREATE PROCEDURE Select_Emp_Info_City_Live
AS
	SELECT * FROM Employee_Details AS ed
	JOIN City AS ct ON ed.Emp_City_Id = ct.City_Id
	WHERE ct.City_Name = 'Dallas' OR ct.City_Name = 'Algiers';
RETURN
GO

EXEC Select_Emp_Info_City_Live
GO
-- 15
CREATE PROCEDURE Select_Emp_Info_City_Live_SLetter
AS
	SELECT * FROM Employee_Details AS ed
	JOIN City AS ct ON ed.Emp_City_Id = ct.City_Id
	WHERE LEFT(LOWER(ct.City_Name), 1) = 'a' OR LEFT(LOWER(ct.City_Name), 1) = 'd';
RETURN
GO

EXEC Select_Emp_Info_City_Live_SLetter
GO
-- 16
CREATE PROCEDURE Select_Emp_Info_DOB_Range
AS
	SELECT ed.Emp_First_Name, ed.Emp_Last_Name, co.Country_Name, ds.Desig_Name, ed.Emp_DOB
	FROM Employee_Details AS ed 
	LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
	LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
	WHERE ed.Emp_DOB BETWEEN '1984-02-01 00:00:00' AND '1986-03-01 00:00:00'
RETURN
GO

EXEC Select_Emp_Info_DOB_Range
GO
-- 17
CREATE PROCEDURE Select_Emp_Info_Highest_Salary
AS
	SELECT ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Middle_Name, co.Country_Name, ds.Desig_Name, MAX(sl.Emp_Salary) As [Highest Salary]
	FROM Employee_Details AS ed 
	LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
	LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
	RIGHT JOIN Salary AS sl ON (ed.Emp_Id = sl.Emp_Id)
	GROUP BY ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Middle_Name, co.Country_Name, ds.Desig_Name
	ORDER BY ed.Emp_First_Name;
RETURN
GO

EXEC Select_Emp_Info_Highest_Salary
GO
-- 18
CREATE PROCEDURE Select_Emp_Info_Current_Salary
AS
	SELECT ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Middle_Name, co.Country_Name, ds.Desig_Name, sl.Emp_Salary AS [Current Salary]
	FROM Employee_Details AS ed 
	LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
	LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
	JOIN (SELECT * FROM Salary AS sl1
		  WHERE sl1.Emp_Salary_Change_Year = (SELECT MAX(sl2.Emp_Salary_Change_Year)
											  FROM Salary AS sl2 
											  WHERE sl1.Emp_Id = sl2.Emp_Id)) AS sl ON (ed.Emp_Id = sl.Emp_Id)
	ORDER BY ed.Emp_First_Name;
RETURN
GO

EXEC Select_Emp_Info_Current_Salary
GO
-- 19
CREATE PROCEDURE Select_Emp_Info_Highest_Salary_Range
AS
	SELECT ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Middle_Name, co.Country_Name, ds.Desig_Name, sl.Emp_Salary AS [Highest Salary]
	FROM Employee_Details AS ed 
	LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
	LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
	JOIN (SELECT * FROM Salary AS sl1
				WHERE sl1.Emp_Salary_Change_Year = (SELECT MAX(sl2.Emp_Salary_Change_Year)
											FROM Salary AS sl2 
											WHERE sl1.Emp_Id = sl2.Emp_Id)) AS sl ON (ed.Emp_Id = sl.Emp_Id)
	WHERE sl.Emp_Salary BETWEEN 50000 AND 100000
RETURN
GO

EXEC Select_Emp_Info_Highest_Salary_Range
GO
-- 20
CREATE PROCEDURE Select_First3_Char_Emp_Name
AS
	SELECT SUBSTRING(Emp_First_Name, 1, 3) AS [Employee 3 First name] FROM Employee_Details;
RETURN
GO

EXEC Select_First3_Char_Emp_Name
GO
-- 21
CREATE PROCEDURE Select_Emp_Fname_Replace_Letter
AS
	SELECT REPLACE(Emp_First_Name, 'a', '$') AS [New Name] FROM Employee_Details;
RETURN
GO

EXEC Select_Emp_Fname_Replace_Letter
GO
-- 22
CREATE PROCEDURE Select_Emp_Info_JoinDate
AS
	SELECT Emp_First_Name AS [First Name], datepart(year,Emp_JoinDate) AS [Year], CONVERT(varchar(3),datename(month,Emp_JoinDate)) AS [Month], 
			datepart(day,Emp_JoinDate) [Day]
	FROM Employee_Details; 
RETURN
GO

EXEC Select_Emp_Info_JoinDate
GO
-- 23
CREATE PROCEDURE Select_Emp_Info_JoinDate_2014
AS
	SELECT * FROM Employee_Details WHERE datepart(year,Emp_JoinDate) = 2014;
RETURN
GO

EXEC Select_Emp_Info_JoinDate_2014
GO
-- 24
CREATE PROCEDURE Select_Emp_Info_JoinDate_Before_Jan2014
AS
	SELECT * FROM Employee_Details WHERE datepart(year,Emp_JoinDate) < 2014;
RETURN
GO

EXEC Select_Emp_Info_JoinDate_Before_Jan2014
GO
-- 25
CREATE PROCEDURE Select_Desig_Salary_Spend_1
AS
	SELECT ds.Desig_Name, SUM(sl.Emp_Salary) AS [Total Salary]
	FROM Employee_Details AS ed 
	LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
	LEFT JOIN (SELECT * FROM Salary AS sl1
				WHERE sl1.Emp_Salary_Change_Year = (SELECT MAX(sl2.Emp_Salary_Change_Year)
											FROM Salary AS sl2 
											WHERE sl1.Emp_Id = sl2.Emp_Id)) AS sl ON (ed.Emp_Id = sl.Emp_Id)
	GROUP BY  ds.Desig_Name ORDER BY ds.Desig_Name;
RETURN
GO

EXEC Select_Desig_Salary_Spend_1
GO

CREATE PROCEDURE Select_Desig_Salary_Spend_2
AS
	SELECT Desig_Name, SUM(TotalSpendYear) AS [Total Salary Spend]
	FROM (SELECT Desig_Name, Emp_Salary, Emp_Salary_Change_Year, NextYear, DiffYear, Emp_Salary*DiffYear AS TotalSpendYear
		FROM (SELECT Desig_Name, Emp_Salary, Emp_Salary_Change_Year, NextYear, 
				CAST(DATEDIFF(Day, Emp_Salary_Change_Year, NextYear) AS float)/365 AS DiffYear
			FROM (SELECT Desig_Name, Emp_Salary, Emp_Salary_Change_Year, 
					CASE WHEN NextYear IS NULL
					THEN getdate()
					ELSE NextYear END AS NextYear
				FROM (SELECT Desig_Name, Emp_Salary, Emp_Salary_Change_Year,
						(	SELECT MIN(Emp_Salary_Change_Year)
							FROM (SELECT ds.Desig_Name, sl.Emp_Salary_Change_Year, sl.Emp_Salary
								FROM Employee_Details AS ed 
								LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
								RIGHT JOIN Salary AS sl ON (ed.Emp_Id = sl.Emp_Id)) AS t2
							WHERE t2.Desig_Name = t1.Desig_Name AND t2.Emp_Salary_Change_Year > t1.Emp_Salary_Change_Year
						) AS NextYear
					FROM (SELECT ds.Desig_Name, sl.Emp_Salary_Change_Year, sl.Emp_Salary
							FROM Employee_Details AS ed 
							LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
							RIGHT JOIN Salary AS sl ON (ed.Emp_Id = sl.Emp_Id)) AS t1
					) AS t3
				) AS t4
			) AS t5
		) AS t
	GROUP BY Desig_Name
RETURN
GO

EXEC Select_Desig_Salary_Spend_2
GO

-- 26
CREATE PROCEDURE Select_Desig_EmpNo
AS
	SELECT ds.Desig_Name AS [Designation Name], COUNT(ed.Emp_Id) AS [Total Number of Employee]
	FROM Employee_Details AS ed 
	RIGHT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
	GROUP BY ds.Desig_Name ORDER BY ds.Desig_Name;
RETURN
GO

EXEC Select_Desig_EmpNo
GO
-- 27
CREATE PROCEDURE Select_Desig_Salary_Avg
AS
	SELECT ds.Desig_Name, AVG(sl.Emp_Salary) AS [Total Salary]
	FROM Employee_Details AS ed 
	LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
	LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
	JOIN (SELECT * FROM Salary AS sl1
				WHERE sl1.Emp_Salary_Change_Year = (SELECT MAX(sl2.Emp_Salary_Change_Year)
											FROM Salary AS sl2 
											WHERE sl1.Emp_Id = sl2.Emp_Id)) AS sl ON (ed.Emp_Id = sl.Emp_Id)
	GROUP BY  ds.Desig_Name ORDER BY ds.Desig_Name;
RETURN
GO

EXEC Select_Desig_Salary_Avg
GO
-- 28
CREATE PROCEDURE Select_EmpNo_JoinDate
AS
	SELECT  datepart(year,Emp_JoinDate) AS [Joined Year], datepart(month,Emp_JoinDate) AS [Joined Month], Count(Emp_First_Name) AS [Number of employees]
	FROM Employee_Details
	GROUP BY datepart(year,Emp_JoinDate), datepart(month,Emp_JoinDate)
	ORDER BY datepart(year,Emp_JoinDate), datepart(month,Emp_JoinDate)
RETURN
GO

EXEC Select_EmpNo_JoinDate
GO
-- 29
CREATE PROCEDURE Select_Emp_NullSalary
AS
	SELECT * FROM Employee_Details as ed
	LEFT JOIN (SELECT * FROM Salary AS sl1
				WHERE sl1.Emp_Salary_Change_Year = (SELECT MAX(sl2.Emp_Salary_Change_Year)
											FROM Salary AS sl2 
											WHERE sl1.Emp_Id = sl2.Emp_Id)) AS sl ON (ed.Emp_Id = sl.Emp_Id) 
	WHERE sl.Emp_Salary IS NULL
RETURN
GO

EXEC Select_Emp_NullSalary
GO
--30
CREATE PROCEDURE Select_Emp_Salary_Sum_1
AS
	SELECT sub1.Emp_First_Name,  
	CASE WHEN sub1.Salary IS NULL 
	THEN 0 
	ELSE sub1.Salary END AS [Sum Salary]
	FROM (
	SELECT ed.Emp_First_Name, SUM(sl.Emp_Salary) AS Salary
	FROM Employee_Details AS ed
	LEFT JOIN Salary AS sl ON ed.Emp_Id = sl.Emp_Id
	GROUP BY ed.Emp_First_Name) AS sub1;
RETURN
GO

EXEC Select_Emp_Salary_Sum_1
GO

CREATE PROCEDURE Select_Emp_Salary_Sum_2
AS
	SELECT Emp_First_Name, 
			CASE WHEN SumSalary IS NULL
			THEN 0 
			ELSE SumSalary END AS SumSalary
	FROM (SELECT Emp_First_Name, SUM(TotalGainYear) AS SumSalary
		FROM (SELECT Emp_First_Name, Emp_Salary, Emp_Salary_Change_Year, NextYear, DiffYear,  Emp_Salary*DiffYear AS TotalGainYear
			FROM (SELECT Emp_First_Name, Emp_Salary, Emp_Salary_Change_Year, NextYear, 
						CAST(DATEDIFF(Day, Emp_Salary_Change_Year, NextYear) AS float)/365 AS DiffYear
				FROM (SELECT Emp_First_Name, Emp_Salary, Emp_Salary_Change_Year,
						CASE WHEN NextYear IS NULL
						THEN getdate()
						ELSE NextYear END NextYear
					FROM (SELECT Emp_First_Name, Emp_Salary, Emp_Salary_Change_Year,
						 (SELECT MIN(Emp_Salary_Change_Year)
							FROM (SELECT ed.Emp_First_Name, sl.Emp_Salary, sl.Emp_Salary_Change_Year
								FROM Employee_Details AS ed
								LEFT JOIN Salary AS sl ON ed.Emp_Id = sl.Emp_Id
								) AS t2
							WHERE t2.Emp_First_Name = t1.Emp_First_Name AND t2.Emp_Salary_Change_Year > t1.Emp_Salary_Change_Year
							) AS NextYear
						FROM (SELECT ed.Emp_First_Name, sl.Emp_Salary, sl.Emp_Salary_Change_Year
								FROM Employee_Details AS ed
								LEFT JOIN Salary AS sl ON ed.Emp_Id = sl.Emp_Id
							 ) AS t1	
						) AS t3
					) AS t4
				) AS t5
			) AS t6
		GROUP BY Emp_First_Name
		) AS t;
RETURN
GO

EXEC Select_Emp_Salary_Sum_2
GO
	

-- 31
CREATE PROCEDURE Select_Emp_Salary_Percent_Case
AS
	SELECT Emp_First_Name, Emp_Salary, 
			CASE WHEN RowNum = 1 THEN Emp_Salary*0.1
				 WHEN RowNum = 2 THEN Emp_Salary*0.2
				 WHEN RowNum = 3 THEN Emp_Salary*0.15
				 ELSE Emp_Salary*0.30 END AS Percent_Salary
	FROM (SELECT ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Middle_Name, co.Country_Name, ds.Desig_Name, sl.Emp_Salary,
				row_number() OVER(ORDER BY ed.Emp_First_Name) AS RowNum
			FROM Employee_Details AS ed 
			LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
			LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
			JOIN (SELECT * FROM Salary AS sl1
						WHERE sl1.Emp_Salary_Change_Year = (SELECT MAX(sl2.Emp_Salary_Change_Year)
													FROM Salary AS sl2 
													WHERE sl1.Emp_Id = sl2.Emp_Id)) AS sl ON (ed.Emp_Id = sl.Emp_Id)
		) AS t;
RETURN
GO

EXEC Select_Emp_Salary_Percent_Case
GO

-- 32
CREATE PROCEDURE Select_Emp_Day_Work
AS
	SELECT [Full Name], DATEDIFF(Day, Emp_JoinDate, Today) AS Days_Work
	FROM (SELECT CONCAT(Emp_First_Name, ' ',
			CASE WHEN Emp_Middle_Name = 'NULL' 
			THEN '' 
			ELSE CONCAT(Emp_Middle_Name,' ') END
			,Emp_Last_Name) AS [Full Name], Emp_JoinDate, getdate() AS Today
		FROM Employee_Details WHERE Emp_Active = 1) AS t;
RETURN
GO

EXEC Select_Emp_Day_Work
GO
-- 33
CREATE PROCEDURE Select_Emp_Highest_Appraisal
AS
	SELECT TOP(1) Emp_First_Name, Appraisal
	FROM (SELECT Emp_First_Name, MAX(Emp_Salary) - MIN(Emp_Salary) AS Appraisal
		FROM (SELECT ed.Emp_First_Name, sl.Emp_Salary, sl.Emp_Salary_Change_Year
										FROM Employee_Details AS ed
										LEFT JOIN Salary AS sl ON ed.Emp_Id = sl.Emp_Id) AS t1
		GROUP BY Emp_First_Name) AS t2
	ORDER BY Appraisal DESC;
RETURN
GO

EXEC Select_Emp_Highest_Appraisal
GO
-- 34
CREATE PROCEDURE Select_Emp_3Highest_Salary
AS
	SELECT Emp_First_Name, Emp_Last_Name, Emp_Middle_Name, Country_Name, Desig_Name, [Current Salary]
	FROM (SELECT ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Middle_Name, co.Country_Name, ds.Desig_Name, 
				sl.Emp_Salary AS [Current Salary], row_number() OVER(ORDER BY sl.Emp_Salary DESC) AS RowNum
		FROM Employee_Details AS ed 
		LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
		LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
		JOIN (SELECT * FROM Salary AS sl1
					WHERE sl1.Emp_Salary_Change_Year = (SELECT MAX(sl2.Emp_Salary_Change_Year)
												FROM Salary AS sl2 
												WHERE sl1.Emp_Id = sl2.Emp_Id)) AS sl ON (ed.Emp_Id = sl.Emp_Id)
		) AS t
	WHERE RowNum = 3;
RETURN
GO

EXEC Select_Emp_3Highest_Salary
GO
-- 35
CREATE FUNCTION Average_Emp_Salary()
RETURNS TABLE
AS
RETURN
(
	SELECT ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Middle_Name, co.Country_Name, ds.Desig_Name, AVG(sl.Emp_Salary) As [Average Salary]
	FROM Employee_Details AS ed 
	LEFT JOIN Country AS co ON (ed.Emp_Country_Id = co.Country_Id)
	LEFT JOIN Designation AS ds ON (ed.Desig_Id = ds.Desig_Id)
	RIGHT JOIN Salary AS sl ON (ed.Emp_Id = sl.Emp_Id)
	GROUP BY ed.Emp_First_Name, ed.Emp_Last_Name, ed.Emp_Middle_Name, co.Country_Name, ds.Desig_Name
);

GO
SELECT * FROM Average_Emp_Salary();


