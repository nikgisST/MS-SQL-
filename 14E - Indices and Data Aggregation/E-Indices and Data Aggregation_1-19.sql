USE [Gringotts]

GO


-- 1) Records' Count

SELECT COUNT([Id]) 
    AS [Count]
  FROM [WizzardDeposits]


.............................................


-- 2) Longest Magic Wand

SELECT MAX([MagicWandSize]) 
    AS [LongestMagicWand]
  FROM [WizzardDeposits]


............................................


-- 3) Longest Magic Wand Per Deposit Groups

SELECT [DepositGroup],
      MAX([MagicWandSize])
      AS [LongestMagicWand]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]


..............................................


-- 4) Smallest Deposit Group Per Magic Wand Size

SELECT TOP (2)
         [DepositGroup]
  --  AVG([MagicWandSize])        -- МОЖЕ И ТУК ДА ИМА АГРЕГИРАЩА ФУНКЦИЯ
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]                                                        -- агрегиращите функции COUNT(), MIN(), MAX(), AVG() може да се ползват в SELECT, HAVING, ORDER BY
ORDER BY AVG([MagicWandSize])                                                  -- НЕ МОГАТ ДА СЕ ИЗПОЛЗВАТ В WHERE И JOIN (FROM) !!!


..................................................


-- 5) Deposits Sum

SELECT [DepositGroup],                                       -- в Select могат да се ползват само колоните, по които групираме + агрегиращите функции
      SUM([DepositAmount])                                   -- но вътре в агрегиращите финкции може да се използва, която и да е колона
      AS [TotalSum]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]


.......................................................


-- 6) Deposits Sum for Ollivander Family

SELECT [DepositGroup],
      SUM([DepositAmount])
      AS [TotalSum]            
    FROM [WizzardDeposits]
  WHERE [MagicWandCreator] = 'Ollivander Family'                                 -- филтрира данните преди групиране (предварително филтриране)             -- MORE APPROPRIATE FOR ME
GROUP BY [DepositGroup]


SELECT [DepositGroup],
      SUM([DepositAmount])
      AS [TotalSum]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup], 
         [MagicWandCreator]                                            -- HAVING clause MUST BE contained in either an aggregate function or the GROUP BY clause
  HAVING [MagicWandCreator] = 'Ollivander Family'                      -- филтрира данните след групирането, т.е. при него използваме агрегираните данни


..............................................................
 

-- 7) Deposits Filter

  SELECT [DepositGroup],                                             -- Ако имаше и JOIN в задачата той щеше да се изпише след FROM и преди WHERE
      SUM([DepositAmount])
      AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'                    -- where се използва преди групирането и преди да се правят агрегирани данни - SUM (агрег. функции), внасянето на where клауза променя агрегираните данни
GROUP BY [DepositGroup]
  HAVING SUM([DepositAmount]) < 150000                               -- защото агрегацията се извършва след WHERE и не може да се обедини с реда Where с второ условие, свързано с AND
ORDER BY [TotalSum] DESC                                             -- при HAVING не може да се използва елиаса [TotalSum], защото те са част от Select, който се изпълнява след HAVING, НО МОЖЕМ ДА ПОЛЗВАМЕ АГРЕГ. Ф-ЦИЯ В HAVING: SUM([DepositAmount])
-- ORDER BY SUM([DepositAmount]) DESC                                -- при ORDER BY може да се използва елиаса [TotalSum], защото те са част от Select, който се изпълнява преди ORDER BY
                                                                     -- при ORDER BY може да се използва и елиаса, и агрегиращата функция

                                                                     -- В HAVING може да се използва коя и да е друга колона, неизброена в Select, стига с нея да върви и агрегираща функция
                                                                     -- можеше да има и коренно различна колона, която не е изброена в Select-a, например: ( HAVING SUM([MagicWandSize]) < 150000 )

..................................................................   



-- 8) Deposit Charge

SELECT [DepositGroup], 
       [MagicWandCreator], 
       MIN([DepositCharge])
    FROM [WizzardDeposits]
GROUP BY [DepositGroup], 
         [MagicWandCreator]
ORDER BY [MagicWandCreator] ASC, 
         [DepositGroup] ASC


...................................................................



-- 9) Age Groups

  SELECT [AgeGroup],                                                            -- CASE WHEN е също част от Select, който се изпълнява след Group by, затова не може директно за новата колона, образувана от Case, да се прави GROUP BY
         COUNT(*)
      AS [WizardCount]
    FROM (
              SELECT                                                            -- след Select няма * или колона, а директно Case
                     CASE
                          WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
                          WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
                          WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
                          WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
                          WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
                          WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
                          ELSE '[61+]'
                      END
                  AS [AgeGroup]
                FROM [WizzardDeposits]
         )
      AS [AgeGroupSubquery]     -- AS [AgeGroupSubquery], [WizzardDeposits]            -- името на вложената заявка не е нужно, но ни трябва например, ако селектираме данни от него и може да изброяваме и таблица едновременно след него
GROUP BY [AgeGroup]                                                                    -- НУЖНО е при MULTIPLE SELECT от вложена заявка 



..................................................................



-- 10) First Letter

SELECT DISTINCT 
                SUBSTRING ([FirstName], 1, 1)                    -- SELECT DISTINCT Customer_N FROM Orders;
             AS [FirstLetter]
           FROM [WizzardDeposits] 
       GROUP BY [FirstName], 
                [DepositGroup]
         HAVING [DepositGroup] = 'Troll Chest'
       ORDER BY [FirstLetter] ASC


SELECT DISTINCT                                                  -- SELECT Customer_N FROM Orders GROUP BY Customer_N;
                SUBSTRING ([FirstName], 1, 1) 
             AS [FirstLetter]
           FROM [WizzardDeposits] 
          WHERE [DepositGroup] = 'Troll Chest'
       GROUP BY [FirstName], 
                [DepositGroup]
       ORDER BY [FirstLetter] ASC



SELECT                                                          -- SELECT DISTINCT == GROUP BY SUBSTRING (FirstName, 1, 1)
      SUBSTRING ([FirstName], 1, 1) 
             AS [FirstLetter]
           FROM [WizzardDeposits] 
          WHERE [DepositGroup] = 'Troll Chest'
       GROUP BY SUBSTRING ([FirstName], 1, 1), 
                [DepositGroup]
       ORDER BY [FirstLetter] ASC



SELECT                                                          -- SELECT DISTINCT == GROUP BY SUBSTRING (FirstName, 1, 1)
      SUBSTRING ([FirstName], 1, 1) 
             AS [FirstLetter]
           FROM [WizzardDeposits] 
       GROUP BY SUBSTRING ([FirstName], 1, 1), 
                [DepositGroup]
         HAVING [DepositGroup] = 'Troll Chest'                            -- MORE APPROPRIATE FOR ME
       ORDER BY [FirstLetter] ASC



......................................................................................................................................



-- 11) Average Interest

  SELECT [DepositGroup],
         [IsDepositExpired],
         AVG([DepositInterest])
      AS [AverageInterest]
    FROM [WizzardDeposits]
   WHERE [DepositStartDate] > '01/01/1985'
GROUP BY [DepositGroup], 
         [IsDepositExpired]
ORDER BY [DepositGroup] DESC,
         [IsDepositExpired] ASC



................................................................................................................



-- 12) Rich Wizard, Poor Wizard
                                                                                           -- МИНУТА 1:23:00
SELECT SUM([Difference])                                                                   -- Count(*) не брои нулевите стойности след Left Join (брои само с match-анатите стойности), в колоната има стойности от 1 нагоре
    AS [SumDifference]                                                                     -- Count([Id]) брои и показва и нулевите стойности в колоните като изписва 0, там някъдето няма нищо
  FROM (
                SELECT [FirstName]
                    AS [Host Wizard],
                       [DepositAmount]     
                    AS [Host Wizard Deposit],
                       LEAD([FirstName]) OVER(ORDER BY [Id])                               -- LEAD връща стойността по колона от следващия ред, която от своя страна е наредена по някакъв критерий
                    AS [Guest Wizard],
                       LEAD([DepositAmount]) OVER(ORDER BY [Id])
                    AS [Guest Wizard Deposit],
                       [DepositAmount] - LEAD([DepositAmount]) OVER(ORDER BY [Id])
                    AS [Difference]
                  FROM [WizzardDeposits]
       ) AS [DifferenceSubQuery]                                                          -- слагаме му име, защото Select-ираме от вложената заявка, която е в реда за Select



SELECT SUM([Difference])                                                                  -- функциите SUM и COUNT могат да се използват и без GROUP
    AS [SumDifference]
  FROM (
        SELECT [wd1].[FirstName] 
            AS [Host Wizard],
               [wd1].[DepositAmount] 
            AS [Host Wizard Deposit],
               [wd2].[FirstName] 
            AS [Guest Wizard],
               [wd2].[DepositAmount] 
            AS [Guest Wizard Deposit],
               [wd1].[DepositAmount] - [wd2].[DepositAmount]
            AS [Difference]
          FROM [WizzardDeposits]
            AS [wd1]
    INNER JOIN [WizzardDeposits]                                                  -- INNER JOIN, защото трябва да игнорираме последният wizard в базата
            AS [wd2]
            ON [wd1].[Id] + 1 = [wd2].[Id]
       ) AS [DifferenceSubQuery]                                                  -- слагаме му име, защото Select-ираме от вложената заявка, която е в реда за Select




....................................................................................




-- 13) Departments Total Salaries

SELECT [DepartmentID], 
       SUM([Salary]) 
      AS [TotalSalary]
    FROM [Employees]
GROUP BY [DepartmentID]
ORDER BY [DepartmentID] ASC



.............................................................................




-- 14) Employees Minimum Salaries

SELECT [DepartmentID], 
       MIN([Salary])
    FROM [Employees]
   WHERE [HireDate] > '2000-01-01' AND [DepartmentID] IN (2, 5, 7)
GROUP BY [DepartmentID]



...............................................................




-- 15) Employees Average Salaries

SELECT *
  INTO [EmployeesWithSalaryOver30000]       
  FROM [Employees]
 WHERE [Salary] > 30000
 
DELETE
  FROM [EmployeesWithSalaryOver30000]
 WHERE [ManagerID] = 42
 
UPDATE [EmployeesWithSalaryOver30000]
   SET [Salary] += 5000
 WHERE [DepartmentID] = 1
 
  SELECT [DepartmentID],
         AVG([Salary])
      AS [AverageSalary]
    FROM [EmployeesWithSalaryOver30000]
GROUP BY [DepartmentID]



...............................................................................................................................................................................................................


-- Instead of delete in real world                                            -- Select all non-deleted employees                                            -- Delete all with ManagerID 3
ALTER TABLE [EmployeesWithSalaryOver30000]                                    SELECT * FROM [EmployeesWithSalaryOver30000]                                   UPDATE [EmployeesWithSalaryOver30000]
ADD [IsDeleted] BIT DEFAULT(0) NOT NULL                                       WHERE [IsDeleted] = 0                                                             SET [IsDeleted] = 1
                                                                                                                                                              WHERE [ManagerID] = 3
-- Alter table може да добавя колони, които да съдържат Null стойности                                                                                              
-- или ако искаме колоната да е NOT NULL, то поне трябва да й зададем 
-- default стойност                                                                                          


................................................................................................................................................................................................................




-- 16) Employees Maximum Salaries

SELECT [DepartmentID], 
       MAX([Salary]) 
      AS [MaxSalary]
    FROM [Employees]
GROUP BY [DepartmentID]
  HAVING MAX([Salary]) < 30000 OR MAX([Salary]) > 70000                        -- НЕ ВАЖИ: MAX([Salary]) <= 30000 OR MAX([Salary]) >= 70000, както и MAX([Salary]) NOT IN (30000, 70000), защото граничните стойности са инклузив, а по условие не трябва да са


  SELECT [DepartmentID], 
       MAX([Salary]) 
      AS [MaxSalary]
    FROM [Employees]
GROUP BY [DepartmentID]
  HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000



..................................................................................................



-- 17) Employees Count Salaries

SELECT 
      COUNT(*)                              -- COUNT([Salary])                -- COUNT([EmployeeID]) 
   AS [Count]
 FROM [Employees]
WHERE [ManagerID] IS NULL


.......................................................................


-- 18) 3rd Highest Salary

GO

USE [SoftUni]

GO


SELECT
DISTINCT [DepartmentID],
         [Salary]
      AS [ThirdHighestSalary]
    FROM (
              SELECT [DepartmentID],
                     [Salary],
                     DENSE_RANK() OVER(PARTITION BY [DepartmentID] ORDER BY [Salary] DESC)                       -- DENSE_RANK() се изпълнява на 5 място заедно с Select 
                  AS [SalaryRank]
                FROM [Employees]
         )
      AS [SalaryRankingSuquery]
   WHERE [SalaryRank] = 3

,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

SELECT [DepartmentID],
       [Salary]
      AS [ThirdHighestSalary]
    FROM (
              SELECT [DepartmentID],
                     [Salary],                                                                                    -- МОЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕ
                     DENSE_RANK() OVER(PARTITION BY [DepartmentID] ORDER BY [Salary] DESC)
                  AS [SalaryRank]
                FROM [Employees]
         )
      AS [SalaryRankingSuquery]
GROUP BY [DepartmentID],
      -- [Salary]
  HAVING [SalaryRank] = 3

,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

SELECT [DepartmentID],
       [Salary]
      AS [ThirdHighestSalary]
    FROM (
              SELECT [DepartmentID],
                     [Salary],
                     DENSE_RANK() OVER(PARTITION BY [DepartmentID] ORDER BY [Salary] DESC)                             -- ПОВТОРЕНИЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕЕ
                  AS [SalaryRank]
                FROM [Employees]
                GROUP BY [DepartmentID],
                         [Salary]
         )
      AS [SalaryRankingSuquery]
GROUP BY [DepartmentID],
         [Salary],
         [SalaryRank]
  HAVING [SalaryRank] = 3


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,


SELECT [DepartmentID],
       [Salary]
      AS [ThirdHighestSalary]
    FROM (
              SELECT [DepartmentID],
                     [Salary],
                     DENSE_RANK() OVER(PARTITION BY [DepartmentID] ORDER BY [Salary] DESC)                         -- ДРУГОООООООООООООООООООООО
                  AS [SalaryRank]
                FROM [Employees]
                GROUP BY [DepartmentID],
                         [Salary]
         )
      AS [Subquery]
  WHERE [Subquery].[SalaryRank] = 3                                                  -- станало е таблица [SalaryRankingSuquery] с колона в нея, тази ранкираната [SalaryRank]

,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,




....................................................................................................................




-- 19) Salary Challenge

SELECT TOP (10)
         [e].[FirstName],
         [e].[LastName],
         [e].[DepartmentID]
    FROM [Employees]
      AS [e]
   WHERE [e].[Salary] > (                                                                        -- операторът > очаква да сравни само по една стойност от двете му страни
                              SELECT AVG([Salary])
                                  AS [AverageSalary]
                                FROM [Employees]
                                  AS [eSub]                                                      -- така сравнено вложената заявка ще върна само 1 стойност, която отговаря на равенството
                               WHERE [eSub].[DepartmentID] = [e].[DepartmentID]                  -- [eSub].[DepartmentID] дава средната заплата само на този Department, НА КОЙТО МУ Е ДОШЪЛ РЕД от външния Select
                            GROUP BY [DepartmentID]
                         )
ORDER BY [e].[DepartmentID]


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,


SELECT TOP (10)
         [e].[FirstName],
         [e].[LastName],
         [e].[DepartmentID]
    FROM [Employees]
      AS [e]
INNER JOIN
          (
              SELECT [DepartmentID]
              --    AS [DeptId],
                     AVG([Salary])
              --    AS [Average]
                FROM [Employees]
            GROUP BY [DepartmentID]
          )
        AS [Subquery]
        ON [e].[DepartmentID] = [Subquery].[DepartmentID]                                         -- ON [e].[DepartmentID] = [Subquery].[DeptID]
     WHERE [e].[Salary] > [AVG([Salary])]                         --> AVG([Salary])               --  WHERE [e].[Salary] > [Subquery].[Average]
  ORDER BY [e].[DepartmentID]


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,


WITH [CTE] -- WITH [avr]
  AS (                                                                  -- COMMON TABLE EXPRESSION (CTE) temporary named result set created from a simple SELECT statement that can be used in a subsequent SELECT statement
         SELECT [DepartmentID],
                AVG([Salary]) 
             AS [Average]
           FROM [Employees]
       GROUP BY [DepartmentID]
     )

SELECT TOP(10)
          [e].[FirstName],
          [e].[LastName],
          [e].[DepartmentID]
      FROM [Employees]
        AS [e]
INNER JOIN [CTE]
        ON [CTE].[DepartmentID] = [e].[DepartmentID]
     WHERE [e].[Salary] > [CTE].[Average]                               -- > AVG([Salary])          -- -- > [AVG([Salary])]
  ORDER BY [CTE].[DepartmentID]



,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,



SELECT TOP (10)
         [e].[FirstName],
         [e].[LastName],
         [e].[DepartmentID]
     FROM 
          (     
            SELECT
                  [DepartmentID],
                  [FirstName],
                  [LastName],
                  [Salary],
                  AVG(Salary) OVER (PARTITION BY [DepartmentID])                                                          
                                  AS [AverageSalary]
                                FROM [Employees]
          )
            AS [eSub]                                              
    WHERE [eSub].[Salary] > [eSub].[AverageSalary]                  
-- ORDER BY [e].[DepartmentID]