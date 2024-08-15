-- 1) Find Names of All Employees by First Name

USE [SoftUni]

GO

SELECT [FirstName],
       [LastName]
    FROM [Employees]
  WHERE LEFT([FirstName], 2) = 'Sa'    - след LEFT първо се подава колона от текстов тип, а след това дава броя символи, които искаме да вземем, 'Sa_&' означава поне още 1 символ след това да търси или повече



SELECT [FirstName],
       [LastName]
    FROM [Employees]
  WHERE [FirstName] LIKE 'Sa%'    - след Sa написано с % може да има или изобщо да няма букви след това (% == 0+ символа)



..................................................................................................



-- 2) Find Names of All Employees by Last Name
 
SELECT [FirstName],
       [LastName]
    FROM [Employees]
  WHERE CHARINDEX('ei', [LastName]) > 0   - щом е по-голямо от 0, значи го съдържа търсения стринг 'ei' в тази колона с фамилни имена
                                          - CHARINDEX('ei', [LastName]) > 0 връща 0, ако 'ei' го няма в [LastName], a ако го има връща индекса, на които се намира, който е по-голям от 0 (индексите тук започват да се броят от 1 до N)


SELECT [FirstName],
       [LastName]
    FROM [Employees]
  WHERE [LastName] LIKE '%ei%'        - 1) ei...;   2) ...ei;   3) ...ei...;   4) ei



-- 3) Find First Names of All Employees

SELECT [FirstName]
   FROM [Employees]
  WHERE [DepartmentID] IN (3, 10) AND YEAR([HireDate]) BETWEEN 1995 AND 2005    -- YEAR връща само годината като число от датата


SELECT [FirstName]
   FROM [Employees]
  WHERE [DepartmentID] = 10 OR [DepartmentID] = 3 AND YEAR([HireDate]) BETWEEN 1995 AND 2005  


.................................................................................................................


-- 4) Find All Employees Except Engineers

SELECT [FirstName],
       [LastName]
  FROM [Employees] 
 WHERE CHARINDEX('engineer', [JobTitle]) = 0    -- ако > 0, думата 'engineer' се съдържа в текста на колона JobTitle
       

SELECT [FirstName],
       [LastName]
    FROM [Employees]
  WHERE [JobTitle] NOT LIKE '%engineer%'      -- не става WHERE [JobTitle] <> 'engineer', защото връща и Design Engineer нищо, че съдържа думата, <> трябва да различи целия текст напълно в колоната, а не различава по шаблон както %%


                                                       -- Collation: CS - Case-sensitine - разпознава малки и големи букви отделно -->  А не е равно на а
                                                       -- АS - Accent-sensitive - разпознава О-то с точки отгоре с О-то без точки отгоре --> ö не е същото като о

...............................................................


-- 5) Find Towns with Name Length

SELECT [Name]
   FROM [Towns]
  WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name] ASC                                       


SELECT [Name]
   FROM [Towns]
  WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
ORDER BY [Name] ASC    


............................................................



-- 6) Find Towns Starting With

SELECT *
   FROM [Towns]
  WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name]                                     -- ASC        
 

SELECT *
   FROM [Towns]
  WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]                                     -- ASC        


SELECT *
   FROM [Towns]
  WHERE SUBSTRING([Name], 1, 1) IN ('M', 'K', 'B', 'E')
ORDER BY [Name] 


SELECT *
   FROM [Towns]
  WHERE SUBSTRING([Name], 1, 1) = 'M' OR SUBSTRING([Name], 1, 1) = 'K' OR SUBSTRING([Name], 1, 1) = 'B' OR SUBSTRING([Name], 1, 1) = 'E'
ORDER BY [Name] 


.........................................................................................



-- 7) Find Towns Not Starting With

SELECT *
   FROM [Towns]
  WHERE LEFT([Name], 1) NOT IN ('R', 'B', 'D')
ORDER BY [Name]   


SELECT *
   FROM [Towns]
  WHERE [Name] NOT LIKE '[DBR]%'
ORDER BY [Name] 


SELECT *
   FROM [Towns]
  WHERE SUBSTRING([Name], 1, 1) NOT IN ('D', 'R', 'B')
ORDER BY [Name] 


SELECT *
   FROM [Towns]
  WHERE SUBSTRING([Name], 1, 1) <> 'R' AND SUBSTRING([Name], 1, 1) <> 'D' AND SUBSTRING([Name], 1, 1) <> 'B'     
ORDER BY [Name] 


SELECT *
   FROM [Towns]
  WHERE SUBSTRING([Name], 1, 1) != 'R' AND SUBSTRING([Name], 1, 1) != 'D' AND  SUBSTRING([Name], 1, 1) != 'B'     
ORDER BY [Name] 


........................................................................


-- 8) Create View Employees Hired After 2000 Year


CREATE VIEW [V_EmployeesHiredAfter2000]
    AS 
      (
          SELECT [FirstName],  
                 [LastName]
            FROM [Employees]
          WHERE YEAR([HireDate]) > 2000        
      )

..........................................................


-- 9) Length of Last Name

SELECT [FirstName],  
       [LastName]
  FROM [Employees]
WHERE LEN([LastName]) = 5


SELECT [FirstName],  
       [LastName]
  FROM [Employees]
WHERE LEN([LastName]) IN (5)


...................................................



10) Rank Employees by Salary

SELECT [EmployeeID],
       [FirstName],
       [LastName],
       [Salary],
       DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID])    -- ако допълним след EmployeeID DESC вътрешните таблички от по 3 реда средно ще започнат от голямото EmployeeID към намаляващото
    AS [Rank]
  FROM [Employees]
 WHERE [Salary] BETWEEN 10000 AND 50000
ORDER BY [Salary] DESC

-- SELECT [EmployeeID],
      -- [FirstName],
       -- [LastName],
       -- [Salary],
       -- DENSE_RANK() OVER (ORDER BY [EmployeeID])    -- без where клаузата и без partition by ранкът съвпада с EmployeeID-тата
   -- AS [Rank]
  -- FROM [Employees]
-- ORDER BY [Salary] DESC


...............................................................................................



11) Find All Employees with Rank 2

SELECT *
  FROM (                                        -- query-то вътре се изпълнява първо и след като това стане вече ще съществува DENSE_RANK, с който може да се работи по-нататък по всякакъв начин                                   
            SELECT [EmployeeID],
            [FirstName],       
            [LastName],
            [Salary],
            DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID])    
         AS [Rank]
       FROM [Employees]                                                           
      WHERE [Salary] BETWEEN 10000 AND 50000                          -- В subquery не може да се прави order by
   )  
    AS [RankingSubquery] 
  WHERE [Rank] = 2                              -- тук и да допълня [RANK] = 2 нищо няма да стане, защото where се изпълнява преди select и неговите производни: ROW_NUMBER, RANK, DENSE_RANK, т.е. създаденият DENSE_RANK го няма
ORDER BY [Salary] DESC  


.....................................................................................



12) Countries Holding 'A' 3 or More Times

GO

USE [Geography]

GO

SELECT [CountryName]
    AS [Country Name],                               -- case-insensitive using case-sensitive collation - YES  (CI, CS)
       [ISOCode]                                     -- case-sensitive using case-insensitive collation - NO   (CI)
    AS [ISO Code]
  FROM [Countries]
 WHERE LOWER([CountryName]) LIKE '%a%a%a%'      -- ползваме LOWER, за да го направим case-insensitively (без значение на малки и големи букви)
ORDER BY [ISO Code] ASC


SELECT [CountryName]
    AS [Country Name],                             
       [ISOCode]                                  
    AS [ISO Code]
  FROM [Countries]
 WHERE LEN([CountryName]) - LEN(REPLACE(LOWER([CountryName]), 'a', '')) >= 3
ORDER BY [ISO Code] ASC


...........................................................................
 


13) Mix of Peak and River Names

-- SELECT COUNT(*) FROM [Peaks]  --- 48
-- SELECT COUNT(*) FROM [Rivers]    --- 30
-- multiple select --- 1440 (прави всички комбинации между всеки ред от двете таблици)
 
SELECT [p].[PeakName],                                                                      -- multiple select при него изброяваме колкото искаме таблици, ненавързани помежду си == CROSS JOIN
       [r].[RiverName],
       LOWER(CONCAT(SUBSTRING([p].[PeakName], 1, LEN([p].[PeakName]) - 1), [r].[RiverName]))      -- STUFF(RiverName, 1, 1 '')
    AS [Mix]
  FROM [Peaks]             
     AS [p],
        [Rivers]
     AS [r]
WHERE RIGHT(LOWER([p].[PeakName]), 1) = LEFT(LOWER([r].[RiverName]), 1)             -- 80 комбинации
ORDER BY [Mix] ASC

-- STUFF:

SELECT STUFF('SQL Tutorial', 1, 3, 'HTML')    -- изтрива 3 броя символи, започва от първа позиция, изсъртва от мястото на първия символ текста с кавичките 'HTML'


-- 14) Games from 2011 and 2012 Year

GO

USE [Diablo]

GO

SELECT TOP (50) 
       [Name],
       FORMAT([Start], 'yyyy-MM-dd') AS [Start]
  FROM [Games]
 WHERE YEAR([Start]) IN (2011, 2012)                 -- WHERE YEAR([Start]) >= 2011 AND YEAR([Start]) <= 2012    
ORDER BY [Start] ASC,                      
         [Name] ASC             


SELECT TOP (50) 
       [Name],
       FORMAT([Start], 'yyyy-MM-dd') AS [Start]
  FROM [Games]
 WHERE DATEPART(YEAR, [Start]) IN (2011, 2012)                 
ORDER BY [Start],                      
         [Name]

....................................................................................


-- 15) User Email Providers

SELECT [Username],
       SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]) - CHARINDEX('@', [Email]))
    AS [Email Provider]
  FROM [Users]
ORDER BY [Email Provider] ASC,
         [Username] ASC


SELECT [Username],
       SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email]))
    AS [Email Provider]
  FROM [Users]
ORDER BY [Email Provider],
         [Username]



............................................................................


-- 16) Get Users with IP Address Like Pattern

SELECT [Username],
       [IpAddress]
    AS [IP Address]
  FROM [Users]
 WHERE [IpAddress] LIKE '___.1_%._%.___'                     -- LIKE '___.1%.%.___'
ORDER BY [Username] ASC


..............................................................................



-- 17) Show All Games with Duration and Part of the Day

SELECT [Name]
    AS [Game],
         CASE 
           WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'         -- HOUR връща като число часа, в които е започнал, но я няма като функция и затова използваме DATEPART, за да ни даде часа
           WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
           ELSE 'Evening'
         END                                                                                         -- DATEPART връща информация за частта от дата, която искаме и то в формата, от който избираме
    AS [Part of the day],
         CASE 
           WHEN [Duration] <= 3  THEN 'Extra Short'
           WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
           WHEN [Duration] > 6  THEN 'Long'
           ELSE 'Extra Long'
         END                                                                                      
      AS [Duration]
    FROM [Games] 
      AS [g]                                    -- слагаме елиаси на имената на таблиците, когато новата колона е със същото име като старата, АКО искаме да сортираме по новото текстово репрезентиране (от CASE/END) позваме само Duration,
ORDER BY [Game],                                                                                                                          -- AKO искаме да сортираме по INT() - старите цифрови данни, ползваме [g].[Duration]
         [Duration],
         [Part of the day]


-- DEMO
     END                                                                                      
    AS [Duration],
       [g].[Duration]
    AS [DurationInt]
  FROM [Games] 
    AS [g]                                 
ORDER BY [Duration]                                                                                                                          


-- DEMO2

SELECT *,
      YEAR([HireDate])
   AS [HireYear]
 FROM [Employees]
WHERE [DepartmentID] IN (3, 10) AND YEAR([HireDate]) BETWEEN 1995 AND 2005


-- 18) Orders Table

SELECT [ProductName],
       [OrderDate],
DATEADD (DAY, 3, [OrderDate]) 
       AS [Pay Due],
DATEADD (MONTH, 1, [OrderDate]) 
       AS [Deliver Due]
     FROM [Orders]


....................................................................................


-- 19) People Table

SELECT [Name],
       DATEDIFF (YEAR, [Birthdate], GETDATE()) AS [Age in Years],                -- (YEAR, [Birthdate], '01/01/2022')
       DATEDIFF (MONTH, [Birthdate], GETDATE()) AS [Age in Months],
       DATEDIFF (DAY, [Birthdate], GETDATE()) AS [Age in Days],
       DATEDIFF (MINUTE [Birthdate], GETDATE()) AS [Age in Minutes]
 FROM [People]