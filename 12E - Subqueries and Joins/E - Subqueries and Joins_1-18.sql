USE [SoftUni]
 
GO
 
-- Grouping Demo
  SELECT [JobTitle],
         AVG([Salary])
      AS [AverageSalary],
         COUNT([EmployeeID])
      AS [WorkersCount]
    FROM [Employees]
GROUP BY [JobTitle]
  HAVING AVG([Salary]) > 20000


........................................................................................



-- 1) Employee Address

SELECT TOP (5) 
           [e].[EmployeeID],                                    
           [e].[JobTitle],                                       
           [e].[AddressID],     -- [a].[AddressId]
           [a].[AddressText]                                  
      FROM [Employees]
        AS [e]
INNER JOIN [Addresses]                               -- LEFT JOIN [Addresses] 
        AS [a]
    ON [e].[AddressID] = [a].[AddressID]
ORDER BY [e].[AddressID] ASC                        -- ако има Null стойности в лявата таблица [e]., защото там е foreign key-я, а той може да е null (от Edit Design на таблицата проверявам), 
                                                     -- ако няма Null стойности в лявата таблица [e]., може да се сортира и по [a].[AddressID] и да се направи с INNER JOIN


........................................................................................



-- 2) Addresses with Towns

SELECT TOP (50) 
             [e].[FirstName], 
             [e].[LastName], 
             [t].[Name] 
          AS [Town],
             [a].[AddressText]
        FROM [Employees]
          AS [e]
  INNER JOIN [Addresses]                          --    LEFT JOIN [Addresses]
          AS [a]
      ON [e].[AddressID] = [a].[AddressID]
  INNER JOIN [Towns]                              --    LEFT JOIN [Towns]
          AS [t]
      ON [a].[TownID] = [t].[TownID]
ORDER BY [e].[FirstName], 
         [e].[LastName]


........................................................................................



-- 3) Sales Employee

SELECT [e].[EmployeeID], 
       [e].[FirstName], 
       [e].[LastName], 
       [d].[Name] 
      AS [DepartmentName]
    FROM [Employees]
      AS [e]
INNER JOIN [Departments]                              -- LEFT JOIN [Departments] 
      AS [d]
  ON [e].[DepartmentID] = [d].[DepartmentID]
   WHERE [d].[Name] = 'Sales'
ORDER BY [e].[EmployeeID]



........................................................................................



-- 4) Employee Departments  

SELECT TOP (5) 
         [e].[EmployeeID], 
         [e].[FirstName], 
         [e].[Salary], 
         [d].[Name] 
      AS [DepartmentName]
    FROM [Employees]
      AS [e]
INNER JOIN [Departments]                               -- LEFT JOIN [Departments]
      AS [d]
  ON [e].[DepartmentID] = [d].[DepartmentID]
   WHERE [Salary] > 15000
ORDER BY [e].[DepartmentID]                                  -- ORDER BY [d].[DepartmentID], САМО АКО Е INNER JOIN, A НЕ Е LEFT JOIN



........................................................................................




-- 5) Employees Without Project

SELECT TOP (3)                                                    
          [e].[EmployeeID],                                          -- АКО ПОЛЗВАМЕ [ep].[EmployeeID] ще има NULL стойности, защото това е резултатът от LEFT JOIN-а, там липсва инфо за EmployeeID и се запълват двете колони от дясната таблица с NULL
          [e].[FirstName]
     FROM [Employees]                                              -- ANTI-LEFT JOIN, защотото има клауза : WHERE [[]] IS NULL
       AS [e]
LEFT JOIN [EmployeesProjects]                                  -- защото ни трябват и null стойности
       AS [ep]
   ON [e].[EmployeeID] = [ep].[EmployeeID]                             -- лява и дясна таблица се задават от select и join подредбата, а не от условието след ON коя е първа и коя е втора
 WHERE [ep].[ProjectID] IS Null                                      -- МОЖЕ И ДРУГАТА КОЛОНА ОТ СЪЩАТА ТАБЛИЦА ДА СЕ ПОЛЗВА [ep].[EmployeeeID], защото и тя има стойности NULL
ORDER BY [e].[EmployeeID]                                           --  има разлика от коя колона ще го вземем, защото сега всичко в дясната таблица е null и не може да се подрежда смислено по нея



........................................................................................



-- 6) Employees Hired After

SELECT [e].[FirstName], 
       [e].[LastName], 
       [e].[HireDate], 
       [d].[Name] 
        AS [DeptName]
      FROM [Employees]
        AS [e]
INNER JOIN [Departments]                                   -- LEFT JOIN [Departments]
        AS [d]
        ON [e].[DepartmentID] = [d].[DepartmentID]
    WHERE YEAR([e].[HireDate]) > 01-01-1999 AND [d].[Name] IN ('Sales', 'Finance')               -- WHERE [e].[HireDate] > '1999-01-01' AND [d].[Name] IN ('Sales', 'Finance')                 -- 1999-01-01
ORDER BY [e].[HireDate]


........................................................................................


-- 7) Employees with Project

    SELECT TOP (5)
           [e].[EmployeeID],                            -- [ep].[EmployeeID]  защото е INNER JOIN и може и двете, защото няма NULL стойности
           [e].[FirstName],
           [p].[Name]
        AS [ProjectName]
      FROM [EmployeesProjects]
        AS [ep]
INNER JOIN [Employees]
        AS [e]
        ON [ep].[EmployeeID] = [e].[EmployeeID]
INNER JOIN [Projects]
        AS [p]
        ON [ep].[ProjectID] = [p].[ProjectID]
     WHERE YEAR([p].[StartDate]) > 13/8/2002 AND [p].[EndDate] IS NULL
  ORDER BY [e].[EmployeeID]                                                        -- ORDER BY [ep].[EmployeeID]


....................................................................................................................



-- 8) Employee 24

SELECT [e].[EmployeeID], 
       [e].[FirstName], 
   CASE 
       WHEN [p].[StartDate] >= '2005' THEN NULL                       -- YEAR([p].[StartDate]) >= 2005
       ELSE [p].[Name]
    END 
        AS [ProjectName]
      FROM [Employees] 
        AS [e]
INNER JOIN [EmployeesProjects]                                   -- LEFT JOIN [EmployeesProjects] 
        AS [ep] 
    ON [e].[EmployeeID] = [ep].[EmployeeID]
INNER JOIN [Projects]                                            -- LEFT JOIN [Projects] 
       AS [p] 
    ON [p].[ProjectID] = [ep].[ProjectID]
 WHERE [e].[EmployeeID] = 24



.........................................................................................................................



-- 9) Employee Manager

    SELECT [e].[EmployeeID],
           [e].[FirstName],
           [e].[ManagerID],                                     -- [m].[EmployeeID]
           [m].[FirstName]
        AS [ManagerName]
      FROM [Employees]
        AS [e]
INNER JOIN [Employees]                                          -- LEFT JOIN
        AS [m]
        ON [e].[ManagerID] = [m].[EmployeeID]                                         -- ON t1.FK = t2.PK
     WHERE [e].[ManagerID] IN (3, 7)                            -- [m].[EmployeeID]
  ORDER BY [e].[EmployeeID]



......................................................................................................................



-- 10) Employees Summary

SELECT TOP (50) 
           [e].[EmployeeID], 
           [e].[FirstName] + ' ' + [e].[LastName]                         -- CONCAT_WS(' ', [e].[FirstName], [e].[LastName])            -- CONCAT([e].[FirstName], ' ', [e].[LastName]) 
        AS [EmployeeName],
           [m].[FirstName] + ' ' + [m].[LastName]                         -- CONCAT_WS(' ', [m].[FirstName], [m].[LastName])            -- CONCAT([m].[FirstName], ' ', [m].[LastName]) 
        AS [ManagerName],
           [d].[Name]
      FROM [Employees]
        AS [e]
INNER JOIN [Employees]                              -- LEFT JOIN [Employees] 
        AS [m] 
    ON [e].[ManagerID] = [m].[EmployeeID]
INNER JOIN [Departments]                            -- LEFT JOIN [Departments] 
        AS [d] 
    ON [e].[DepartmentID] = [d].[DepartmentID]
ORDER BY [EmployeeID]



....................................................................................................................



-- 11) Min Average Salary

SELECT MIN([AverageSalary])
      FROM (
            SELECT AVG([Salary])
                AS [AverageSalary]
              FROM [Employees]
          GROUP BY [DepartmentID]
       )
        AS [MinAverageSalary]



..............................................................................................................




-- 12) Highest Peaks in Bulgaria

GO
 
USE [Geography]
 
GO

    SELECT [mc].[CountryCode],                 -- [c].[CountryCode]
           [m].[MountainRange],
           [p].[PeakName],
           [p].[Elevation]
      FROM [MountainsCountries]
        AS [mc]
INNER JOIN [Countries]
        AS [c]
        ON [mc].[CountryCode] = [c].[CountryCode]
INNER JOIN [Mountains]
        AS [m]
        ON [mc].[MountainId] = [m].[Id]
INNER JOIN [Peaks]
        AS [p]
        ON [p].[MountainId] = [m].[Id]
     WHERE [c].[CountryName] = 'Bulgaria' AND [p].[Elevation] > 2835
ORDER BY [p].[Elevation] DESC



...................................................................................................................




-- 13) Count Mountain Ranges

  SELECT [c].[CountryCode],
         COUNT([MountainId])
      AS [MountainRanges]
    FROM [MountainsCountries]
      AS [mc]
   WHERE [CountryCode] IN (
                                SELECT [CountryCode]
                                  FROM [Countries]
                                    AS [c]
                                 WHERE [CountryName] IN ('United States', 'Russia', 'Bulgaria')
                          )
GROUP BY [CountryCode]



SELECT [c].[CountryCode],
       COUNT([m].[MountainRange])
    AS [MountainRanges]
  FROM [Countries]
    AS [c]
INNER JOIN [MountainsCountries]
        AS [mc]
    ON [c].[CountryCode] = [mc].[CountryCode]
INNER JOIN [Mountains] 
        AS [m] 
   ON [mc].[MountainId] = [m].[Id]
   WHERE [c].[CountryName] IN ('United States', 'Russia', 'Bulgaria')
GROUP BY [c].[CountryCode]



.........................................................................................




-- 14) Countries With or Without Rivers

SELECT TOP (5) 
           [c].[CountryName], 
           [r].[RiverName]
      FROM [Countries] 
        AS [c]
LEFT JOIN [CountriesRivers] 
       AS [cr] 
       ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers] 
       AS [r] 
       ON [cr].[RiverId] = [r].[Id]
WHERE [c].[ContinentCode] =                                                    -- WHERE [c].[ContinentCode] = IN      
                            (                                                                                -- (
                              SELECT [ContinentCode]
                                FROM [Continents]
                                  AS [ct]
                               WHERE [ct].[ContinentName] IN ('Africa')             -- WHERE [ct].[ContinentName] = 'Africa'
                            )
ORDER BY [c].[CountryName]



SELECT TOP (5) 
          [c].[CountryName], 
          [r].[RiverName]
     FROM [Countries] 
       AS [c]
LEFT JOIN [Continents]
       AS [ct]
       ON [c].[ContinentCode] = [ct].[ContinentCode]
LEFT JOIN [CountriesRivers] 
       AS [cr] 
       ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers]                                            -- може и тук долу този join:  LEFT JOIN [Continents]
       AS [r]                                                                                    -- AS [ct]
       ON [cr].[RiverId] = [r].[Id]                                                          -- ON [c].[ContinentCode] = [ct].[ContinentCode]                          
    WHERE [ct].[ContinentName] IN ('Africa') 
ORDER BY [c].[CountryName]



......................................................................................................



-- 15) Continents and Currencies

SELECT [ContinentCode],
       [CurrencyCode],
       [CurrencyUsage]
  FROM (
            SELECT *,
                   DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC)
                AS [CurrencyRank]
              FROM (
                        SELECT [ContinentCode],
                               [CurrencyCode],
                               COUNT(*)
                            AS [CurrencyUsage]
                          FROM [Countries]
                      GROUP BY [ContinentCode], [CurrencyCode]
                        HAVING COUNT(*) > 1
                   )
                AS [CurrencyUsageSubquery]
       )
    AS [CurrencyRankingSubquery]
 WHERE [CurrencyRank] = 1



SELECT [rank].[ContinentCode],
       [rank].[CurrencyCode],
       [rank].[CurrencyUsage]
  FROM (
          SELECT [c].[ContinentCode],
                 [c]. [CurrencyCode],
            COUNT(*)                                -- COUNT([c].[CurrencyCode]) 
              AS [CurrencyUsage],
            DENSE_RANK() OVER (PARTITION BY [c].[ContinentCode] ORDER BY COUNT([c].[CurrencyCode]) DESC)
              AS [CurrencyRank]
            FROM [Countries]
              AS [c]
        GROUP BY [c].[ContinentCode], [c].[CurrencyCode]
                                                               -- HAVING COUNT(*) > 1
       ) 
         AS [rank]
 WHERE [rank].[CurrencyRank] = 1 AND [rank].[CurrencyUsage] > 1



.......................................................................




-- 16) Countries Without Any Mountains

SELECT COUNT([c].[CountryCode]) 
       AS [Count]
     FROM [Countries]
       AS [c]
LEFT JOIN [MountainsCountries] 
       AS [m] 
   ON [c].[CountryCode] = [m].[CountryCode]
WHERE [m].[MountainId] IS NULL



..........................................................................



-- 17) Highest Peak and Longest River by Country

SELECT TOP (5)
          [c].[CountryName],
          MAX([p].[Elevation])
       AS [HighestPeakElevation],
          MAX([r].[Length])
       AS [LongestRiverLength]
     FROM [Countries]
       AS [c]
LEFT JOIN [CountriesRivers]
       AS [cr]
       ON [cr].[CountryCode] = [c].[CountryCode]
LEFT JOIN [Rivers]
       AS [r]
       ON [cr].[RiverId] = [r].[Id]
LEFT JOIN [MountainsCountries]
       AS [mc]
       ON [mc].[CountryCode] = [c].[CountryCode]
LEFT JOIN [Mountains]
       AS [m]
       ON [mc].[MountainId] = [m].[Id]
LEFT JOIN [Peaks]
       AS [p]
       ON [p].[MountainId] = [m].[Id]
 GROUP BY [c].[CountryName]
 ORDER BY [HighestPeakElevation] DESC,
          [LongestRiverLength] DESC,
          [CountryName]



....................................................................



-- 18) Highest Peak Name and Elevation by Country

SELECT TOP (5)
         [CountryName]
      AS [Country],
         ISNULL([PeakName], '(no highest peak)')              -- ако стойността в [PeakName] е 0, изпиши 'no highest peak'
      AS [Highest Peak Name],
         ISNULL([Elevation], 0)
      AS [Highest Peak Elevation],
         ISNULL([MountainRange], '(no mountain)')
      AS [Mountain]
    FROM (
               SELECT [c].[CountryName],
                      [p].[PeakName],
                      [p].[Elevation],
                      [m].[MountainRange],
                      DENSE_RANK() OVER(PARTITION BY [c].[CountryName] ORDER BY [p].[Elevation] DESC)
                   AS [PeakRank]
                 FROM [Countries]
                   AS [c]
            LEFT JOIN [MountainsCountries]
                   AS [mc]
                   ON [mc].[CountryCode] = [c].[CountryCode]
            LEFT JOIN [Mountains]
                   AS [m]
                   ON [mc].[MountainId] = [m].[Id]
            LEFT JOIN [Peaks]
                   AS [p]
                   ON [p].[MountainId] = [m].[Id]
         ) 
      AS [PeakRankingSubquery]
   WHERE [PeakRank] = 1
ORDER BY [Country],
         [Highest Peak Name]



SELECT TOP (5)
         [CountryName]
      AS [Country],
         CASE
            WHEN [PeakName] IS NULL THEN '(no highest peak)'
            ELSE [PeakName]
         END
      AS [Highest Peak Name],
         CASE
            WHEN [Elevation] IS NULL THEN 0
            ELSE [Elevation]
         END
      AS [Highest Peak Elevation],
         CASE
            WHEN [MountainRange] IS NULL THEN '(no mountain)'
            ELSE [MountainRange]
         END
      AS [Mountain]
    FROM (
               SELECT [c].[CountryName],
                      [p].[PeakName],
                      [p].[Elevation],
                      [m].[MountainRange],
                      DENSE_RANK() OVER(PARTITION BY [c].[CountryName] ORDER BY [p].[Elevation] DESC)
                   AS [PeakRank]
                 FROM [Countries]
                   AS [c]
            LEFT JOIN [MountainsCountries]
                   AS [mc]
                   ON [mc].[CountryCode] = [c].[CountryCode]
            LEFT JOIN [Mountains]
                   AS [m]
                   ON [mc].[MountainId] = [m].[Id]
            LEFT JOIN [Peaks]
                   AS [p]
                   ON [p].[MountainId] = [m].[Id]
         ) 
      AS [PeakRankingSubquery]
   WHERE [PeakRank] = 1
ORDER BY [Country],
         [Highest Peak Name]

