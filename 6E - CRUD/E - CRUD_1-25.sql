USE [SoftUni]
 
GO

-- 2) Find All the Information About Departments

SELECT * FROM [Departments]

.............................................................
 
-- Problem 03

SELECT [Name] 
  FROM [Departments]
 


-- Problem 04

SELECT [FirstName], 
       [LastName], 
       [Salary] 
  FROM [Employees]
 


-- Problem 05

SELECT [FirstName],
       [MiddleName],
       [LastName]
  FROM [Employees]
 

.............................................................


-- Problem 06

SELECT CONCAT([FirstName], '.', [LastName], '@', 'softuni.bg')
    AS [Full Email Address]
  FROM [Employees]
 

-- + Middle name - които няма такова име стават 2 двуеточия

SELECT CONCAT([FirstName], '.', [MiddleName], '.', [LastName], '@', 'softuni.bg')
    AS [Full Email Address],
       [MiddleName]
  FROM [Employees]
 

-- Problem 06  + Middle name with + operator - цялото с трите имена става NULL само защото средното име е Null

SELECT [FirstName] + '.' + [MiddleName] + '.' + [LastName] + '@' + 'softuni.bg'
    AS [Full Email Address],
       [MiddleName]
  FROM [Employees]

 
-- Problem 06 + Middle name with removing .. защото: NULL + '.' = NULL цялото като е null Concat ще го изпусне

SELECT CONCAT([FirstName], '.', [MiddleName] + '.', [LastName], '@', 'softuni.bg')
    AS [Full Email Address],
       [MiddleName]
  FROM [Employees]
 

.............................................................



-- Problem 07

SELECT DISTINCT [Salary]
           FROM [Employees]
 
  
.............................................................


-- 8) Find All Information About Employees

SELECT * FROM [Employees]
WHERE [JobTitle] = 'Sales Representative'


.............................................................


-- Problem 09

SELECT [FirstName],
       [LastName],
       [JobTitle]
  FROM [Employees]
 WHERE [Salary] BETWEEN 20000 AND 30000       -- [Salary] >= 20000 AND [Salary] <= 30000, ако не искаме да се включват граничните стоиности: BETWEEN 2000.01 AND 29999.99
 

.............................................................


-- Problem 10

SELECT CONCAT([FirstName], ' ', [MiddleName], ' ', [LastName])
    AS [Full name]
  FROM [Employees]
 WHERE [Salary] IN (25000, 14000, 12500, 23600)                      -- WHERE [Salary] = 25000 OR [Salary] = 12500 OR [Salary] = 14000 OR [Salary] = 23600
 


-- Problem 10 + Function

SELECT CONCAT_WS(' ', [FirstName], [MiddleName], [LastName])
    AS [Full name]
  FROM [Employees] AS [e]
 WHERE [Salary] IN (25000, 14000, 12500, 23600)


.................................................................



-- Problem 11

SELECT [FirstName],
       [LastName]
  FROM [Employees]
 WHERE [ManagerID] IS NULL     -- обратното е IS NOT NULL, не става =


.............................................................


-- 12) Find All Employees with a Salary More Than 50000

SELECT [FirstName],
       [LastName],
       [Salary]
 FROM [Employees]
WHERE [Salary] > 50000
ORDER BY [Salary] DESC


.............................................................
 


-- Problem 13

SELECT TOP (5) 
         [FirstName],
         [LastName]
    FROM [Employees]
ORDER BY [Salary] DESC                         -- алгоритъм: 1) Order by Column ASC/DESC;    2) Select Top (X) ColumnNames
 


............................................................................................................





-- 14) Find All Employees Except Marketing

SELECT [FirstName],
       [LastName]
    FROM [Employees]
WHERE [DepartmentID] != 4



...........................................................................................


-- Problem 15
  SELECT *
    FROM [Employees]
ORDER BY [Salary]   DESC,                -- Equal, ако заплатите са равни отива на др ред и прави долното нареждане и така докрая, накрая ги взима в реда на появяване order of arrival (по ID-то)
         [FirstName]    ,     -- ASC
         [LastName] DESC,
         [MiddleName]         -- ASC
 


...........................................................................................



-- 16) Create View Employees with Salaries


CREATE VIEW [V_EmployeesSalaries]
         AS
            (
                SELECT [FirstName],
                       [LastName],
                       [Salary]
                  FROM [Employees] 
            ) 


.............................................................




-- Problem 17
-- Views store temporaly the SELECT query, not the resultset!!!

GO
 
CREATE VIEW [V_EmployeeNameJobTitle]
         AS
            (
                SELECT CONCAT([FirstName], ' ', [MiddleName], ' ', [LastName])
                    AS [Full Name],
                       [JobTitle]
                  FROM [Employees] 
            ) 

GO
 
SELECT * FROM [V_EmployeeNameJobTitle]                -- за Judge само create view, без GO, SELECT, GO 

GO
 

SELECT [FirstName] + ' ' + ISNULL([MiddleName], 'Niki') + ' ' + [LastName]      -- ISNULL([MiddleName], 'Replacement')  или да замести със стойност от съседна колона ISNULL([MiddleName], [JobTitle])
                    AS [Full Name],
                       [JobTitle]
                  FROM [Employees] 



...........................................................................................



-- 18) Distinct Job Titles

SELECT DISTINCT [JobTitle]
           FROM [Employees]



...........................................................................................



-- Problem 19

SELECT TOP (10) * FROM [Projects]
ORDER BY [StartDate],                  
         [Name]
 

SELECT
TOP (10) *, FORMAT([StartDate], 'yyyy-MM-dd')   -- може и др формат 'dd/MM/yyyy', излиза като резултат само годината без часа
    FROM [Projects]
ORDER BY [StartDate],                 
         [Name]

.....................................................................................


-- 20) Last 7 Hired Employees

SELECT TOP (7) 
         [FirstName],
         [LastName],
         [HireDate]
    FROM [Employees]
ORDER BY [HireDate] DESC


.....................................................................



-- Problem 21

--SELECT * FROM [Employees] 
--SELECT [DepartmentID] FROM [Departments] WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
 

UPDATE [Employees]
   SET [Salary] += 0.12 * [Salary]        -- SET [Salary] *= 1.12       --You can use Reverse Query if the changed value is const: SET [Salary] -= 0.12 * [Salary] това не може така
 WHERE [DepartmentID] IN (1, 2, 4, 11)
 
SELECT [Salary] FROM [Employees]


RESTORE DATABASE [SoftUni] FROM DISK = 'BackUpPath.bak'    -- restore, use DB, която искаме и после select и проверяваме всички данни пак какви бяха
 

UPDATE [Employees]
   SET [Salary] += 0.12 * [Salary]
 WHERE [DepartmentID] IN 
                         (
                            SELECT [DepartmentID]
                              FROM [Departments]
                             WHERE [Name] IN ('Engineering', 'Tool Design', 'Marketing', 'Information Services')
                         )


.............................................................................................................



-- 22) All Mountain Peaks


GO

USE [Geography]

GO

SELECT [PeakName] FROM [Peaks] 
ORDER BY [PeakName] ASC


.......................................................................



-- 23) Biggest Countries by Population


SELECT TOP (30) 
       [CountryName],
       [Population]
  FROM [Countries]
WHERE [ContinentCode] = 'EU'
ORDER BY [Population] DESC,
         [CountryName] ASC


...................................................


 
-- Problem 24

  SELECT [CountryName],                        -- CASE WHEN ->  If [CurrencyCode] = 'EUR' then display 'Euro'                                          
         [CountryCode],                        --               else display 'Not Euro'
         CASE [CurrencyCode]
              WHEN 'EUR' THEN 'Euro'
              ELSE 'Not Euro'
         END
      AS [Currency]
    FROM [Countries]
ORDER BY [CountryName]


............................................



-- 25) All Diablo Characters

GO

USE [Diablo]

GO

SELECT [Name] FROM [Characters]
ORDER BY [Name] ASC