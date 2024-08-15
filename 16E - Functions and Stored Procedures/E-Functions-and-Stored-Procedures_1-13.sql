USE [SoftUni]
 
GO
 
-- 1) Employees with Salary Above 35000
-- Judge does not like CREATE OR ALTER statement

CREATE OR ALTER PROCEDURE [usp_GetEmployeesSalaryAbove35000]                           -- може и само Create или само Alter да си работят отделно
              AS
           BEGIN
                    SELECT [FirstName],
                           [LastName]
                      FROM [Employees]
                     WHERE [Salary] > 35000
             END                                                     -- да проверим къде се е създала: SDB: SoftUni --> Programmability --> Stored Procedures
 
 
EXEC [dbo].[usp_GetEmployeesSalaryAbove35000]
 
GO


...............................................................................................


-- 2) Employees with Salary Above Number

CREATE PROCEDURE [usp_GetEmployeesSalaryAboveNumber] @minSalary DECIMAL(18, 4)
              AS
           BEGIN
                    SELECT [FirstName],
                           [LastName]
                      FROM [Employees]
                     WHERE [Salary] >= @minSalary                   -- може да го сложим 48100, за да тестваме какъв резултат връща, преди да я EXEC-ютнем
             END
 
EXEC [dbo].[usp_GetEmployeesSalaryAboveNumber] 48100
 
GO


...........................................................................................




-- 3) Town Names Starting With

CREATE PROCEDURE [usp_GetTownsStartingWith] @oneletterstring CHAR(1)                            -- CHAR() - default in one
              AS
           BEGIN
                    SELECT [Name]
                        AS [Town]
                      FROM [Towns]
                     WHERE UPPER(SUBSTRING([Name], 1, 1)) = @oneletterstring                    -- WHERE SUBSTRING([Name], 1, LEN(@oneletterstring)) = @oneletterstring
             END
 
EXEC [dbo].[usp_GetTownsStartingWith] 'b'

GO

CREATE OR ALTER PROCEDURE usp_GetTownsStartingWith @String NVARCHAR(MAX)
              AS
           BEGIN
                    SELECT [Name]
                        AS [Town]
                      FROM [Towns]
                     WHERE LEFT([Name], LEN(@String)) = @String
            END
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,




CREATE PROCEDURE [usp_GetTownsStartingWith] @FistLetter CHAR(1)                            -- CHAR() - default in one
              AS
           BEGIN
                    SELECT [Name]
                     --   AS [Town]
                      FROM [Towns]
                     WHERE [Name] LIKE CONCAT(@FistLetter, '%')                           -- WHERE LEFT([Name], LEN(@String)) = @String
             END
 
EXEC [dbo].[usp_GetTownsStartingWith] 'b'

GO




..........................................................................................




-- 4) Employees from Town

CREATE PROCEDURE [usp_GetEmployeesFromTown] @townName VARCHAR(50)                                   -- проверявам типът от DB
              AS
           BEGIN
                        SELECT [e].[FirstName],
                               [e].[LastName]
                          FROM [Employees]
                            AS [e]
                    INNER JOIN [Addresses]
                            AS [a]
                            ON [e].[AddressID] = [a].[AddressID]
                    INNER JOIN [Towns]
                            AS [t]
                            ON [a].[TownID] = [t].[TownID]
                         WHERE [t].[Name] = @townName                      -- може да го сложим 'Sofia', за да тестваме какъв резултат връща, преди да я EXEC-ютнем
             END
 
EXEC [dbo].[usp_GetEmployeesFromTown] 'Monroe'
EXEC [dbo].[usp_GetEmployeesFromTown] 'Sofia'
EXEC [dbo].[usp_GetEmployeesFromTown] 'Bordeaux'
 
GO



....................................................................................




-- 5) Salary Level Function
-- Accepts Salary as a number and return salary level as a text

CREATE FUNCTION [ufn_GetSalaryLevel](@Salary DECIMAL(18,4))                                       -- (@Salary MONEY)
         RETURNS VARCHAR(8)
                      AS
                   BEGIN
                          DECLARE @salaryLevel VARCHAR(8)
 
                               IF @Salary < 30000
                                   SET @salaryLevel = 'Low'
                               ELSE IF @Salary BETWEEN 30000 AND 50000                            -- @Salary <= 50000
                                   SET @salaryLevel = 'Average'
                               ELSE                                            -- ELSE IF @Salary > 50000
                                   SET @salaryLevel = 'High'

                 RETURN @salaryLevel
                    END;

GO




,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,



CREATE OR ALTER FUNCTION [ufn_GetSalaryLevel](@salary DECIMAL(18,4))
         RETURNS VARCHAR(8)
                      AS
                   BEGIN
                           DECLARE @salaryLevel VARCHAR(8)
 
                                  IF @salary < 30000
                             BEGIN
                                  SET @salaryLevel = 'Low'
                             END
                                  ELSE IF @salary BETWEEN 30000 AND 50000
                             BEGIN
                                  SET @salaryLevel = 'Average'
                             END
                                  ELSE IF @salary > 50000
                             BEGIN
                                  SET @salaryLevel = 'High'
                             END
                 RETURN @salaryLevel
                    END

GO





....................................................................................




-- 6) Employees by Salary Level

CREATE PROCEDURE usp_EmployeesBySalaryLevel @salaryLevel VARCHAR(8)
              AS
           BEGIN
                    SELECT [FirstName],                                                      -- функцията може и да я използваме и в Select-a [dbo].[ufn_GetSalaryLevel]([Salary], и в Where
                           [LastName]
                      FROM [Employees]
                     WHERE [dbo].[ufn_GetSalaryLevel]([Salary]) = @salaryLevel               -- [Salary] - използваме тази съществуваща колона като параметър на функцията
             END
 
EXEC [dbo].[usp_EmployeesBySalaryLevel] 'High'
EXEC [dbo].[usp_EmployeesBySalaryLevel] 'Average'
 
GO




................................................................................





-- 7) Define Function

CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
    RETURNS BIT
             AS
          BEGIN
                    DECLARE @wordIndex INT = 1;                                                       -- RAISERROR се използва при транзакциите и при процедурите, а не във функции
                    WHILE (@wordIndex <= LEN(@word))
                    BEGIN
                            DECLARE @currentCharacter CHAR = SUBSTRING(@word, @wordIndex, 1);
 
                            IF CHARINDEX(@currentCharacter, @setOfLetters) = 0
                            BEGIN
                                RETURN 0;                                                                          -- след RETURN функцията приключва с отговора след нея
                            END

                            -- IF @currentCharacter = '!'
                            -- BEGIN
                            --       RAISERROR('Invalid character', 16, 1);                  -- SEVERITY(16) - грешките от 11-16 могат да се коригират от User-a (16 general errors); STATE(1) - на какъв етап от обработката на информацията се е случала грешката
                            -- END

                            SET @wordIndex += 1;
                    END
 
                    RETURN 1;
            END
 
GO
 
SELECT [dbo].[ufn_IsWordComprised]('oistmiahf', 'halves')                                    -- SELECT [dbo].[ufn_IsWordComprised]('oistmiahf', 'h!alves')   ще се хвърли създаденото съобщение горе в RAISERROR като грешка в конзолата долу

GO



...............................................................................................................................................................................................................




-- 8) Delete Employees and Departments

CREATE PROCEDURE usp_DeleteEmployeesFromDepartment @departmentId INT                                               -- за да изтрием 1 таблица, трябва да махнем всички релации, които са с ключе към нея
              AS                                                                                                   -- BACKUP --> SoftUni --> Tasks --> Back Up --> Full
           BEGIN
                    -- Store Employees' ID-s
                    DECLARE @employeesToDelete TABLE ([Id] INT);            
                    INSERT INTO @employeesToDelete
                                SELECT [EmployeeID] 
                                  FROM [Employees]
                                 WHERE [DepartmentID] = @departmentId
 
                    -- DELETE EMPLOYEES FROM MAPPING TABLE
                    DELETE
                      FROM [EmployeesProjects]
                     WHERE [EmployeeID] IN (
                                                SELECT *                             -- Select [Id]
                                                  FROM @employeesToDelete
                                           )
 
                    -- ManagerID  NULL
                    ALTER TABLE [Departments]
                    ALTER COLUMN [ManagerID] INT                -- ТО ВЕЧЕ СИ Е СИ Е INT?           -- ALTER COLUMN ManagerID INT NULL
                    
                    UPDATE [Departments]
                       SET [ManagerID] = NULL
                     WHERE [ManagerID] IN (
                                                SELECT *
                                                  FROM @employeesToDelete
                                          )
 
                    -- ManagerID TO NULL
                    UPDATE [Employees]
                       SET [ManagerID] = NULL
                     WHERE [ManagerID] IN (
                                                SELECT *
                                                  FROM @employeesToDelete
                                          )
 
                    -- DELETE EMPLOYEES
                    DELETE
                      FROM [Employees]
                     WHERE [DepartmentID] = @departmentId
 
                     -- DELETE DEPARTMENT
                     DELETE 
                       FROM [Departments]
                      WHERE [DepartmentID] = @departmentId
                       
                      -- COUNT: 0
                      SELECT COUNT(*)
                        FROM [Employees]
                       WHERE [DepartmentID] = @departmentId
             END
 
GO

EXEC [dbo].[usp_DeleteEmployeesFromDepartment] 7


-- ПРОВЕРКА: ПРАЗНО Е.

SELECT *
  FROM [Employees]
 WHERE [DepartmentID] = 7


-- -- ПРОВЕРКА: ВСИЧКО Е ВЪЗСТАНОВЕНО. Restore: 1) Прекъсваме връзката към DB; 2) Свързваме се отново; 3) После USE master; 4) Отиваме на SoftUni --> Tasks --> Restore --> Database --> OK

USE [master]

GO
 
USE [SoftUni]
 
SELECT *
  FROM [Employees]
 WHERE [DepartmentId] = 7

USE [Diablo]
 
GO


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,


CREATE OR ALTER PROCEDURE usp_DeleteEmployeesFromDepartment @DepartmentId INT                   
            AS                                                                                                  
           BEGIN
                    DELETE
                      FROM [EmployeesProjects]
                     WHERE [EmployeeID] IN (
                                               SELECT [EmployeeID]
                                                  FROM [Employees]
                                                 WHERE [DepartmentID] = @DepartmentId
                                           )

                    ALTER TABLE [Departments]
                    ALTER COLUMN [ManagerID] INT NULL               
                    
                    UPDATE [Employees]
                       SET [ManagerID] = NULL
                     WHERE [ManagerID] IN (
                                                SELECT [EmployeeID]
                                                  FROM [Employees]
                                                 WHERE [DepartmentID] = @DepartmentId
                                          )
                                        
                    UPDATE [Departments]
                       SET [ManagerID] = NULL
                     WHERE [DepartmentID] = @DepartmentId
 
                    DELETE
                      FROM [Employees]
                     WHERE [DepartmentID] = @DepartmentId
 
                     DELETE 
                       FROM [Departments]
                      WHERE [DepartmentID] = @DepartmentId
                       
                      SELECT COUNT(*)
                        FROM [Employees]
                       WHERE [DepartmentID] = @DepartmentId
             END

EXEC [dbo].[usp_DeleteEmployeesFromDepartment] 7





.......................................................................................................................




-- 9) Find Full Name

CREATE PROCEDURE usp_GetHoldersFullName
              AS
	               SELECT CONCAT_WS(' ', [FirstName], [LastName]) 
                     AS [Full Name]
		               FROM [AccountHolders]
 
EXEC [dbo].[usp_GetHoldersFullName]
 
GO
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

CREATE PROCEDURE usp_GetHoldersFullName
              AS
	               SELECT CONCAT([FirstName], ' ', [LastName])
                     AS [Full Name]
		               FROM [AccountHolders]
 
EXEC [dbo].[usp_GetHoldersFullName]
 
GO

,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,


CREATE PROCEDURE usp_GetHoldersFullName
              AS
	               SELECT [FirstName] + ' ' + [LastName]
                     AS [Full Name]
		               FROM [AccountHolders]
 
EXEC [dbo].[usp_GetHoldersFullName]
 
GO


,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,




-- 10) Find Full Name

CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan(@SuppliedNumber DECIMAL(12,4))                         -- (@number MONEY)
              AS
                 BEGIN
                      SELECT [ah].[FirstName],
                             [ah].[LastName]
                           --,SUM(a.Balance)
                        FROM [AccountHolders] 
                          AS [ah]
                   LEFT JOIN [Accounts] 
                          AS [a] 
                          ON [ah].[Id] = [a].[AccountHolderId]
                    GROUP BY [ah].[FirstName],
                             [ah].[LastName]
                      HAVING SUM([a].[Balance]) > @SuppliedNumber
                    ORDER BY [ah].[FirstName],
                             [ah].[LastName]
                  END
 
EXEC [dbo].[usp_GetHoldersWithBalanceHigherThan] 'Monika', 'Miteva'
EXEC [dbo].[usp_GetHoldersWithBalanceHigherThan] 'Petar', 'Kirilov'

GO





CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan(@SuppliedNumber DECIMAL(12,4))
              AS
           BEGIN
	               SELECT [ah].[FirstName],
                        [ah].[LastName]
                   FROM [AccountHolders]
                     AS [ah]
		          INNER JOIN
                        (
			                     	SELECT [AccountHolderId],
					                         SUM([Balance])
                                AS [TotalBalance]
                              FROM [Accounts]
				                  GROUP BY [AccountHolderId]
			                   ) 
                          [a]
                       ON [ah].[Id] = [a].[AccountHolderId]
	                  WHERE [TotalBalance] > @SuppliedNumber
		             ORDER BY [ah].[FirstName],
                          [ah].[LastName]
            END
 
EXEC [dbo].[usp_GetHoldersWithBalanceHigherThan] 'Monika', 'Miteva'
EXEC [dbo].[usp_GetHoldersWithBalanceHigherThan] 'Petar', 'Kirilov'

GO




.......................................................................................................................






-- 11) Future Value Function

CREATE FUNCTION ufn_CalculateFutureValue (@Sum DECIMAL(12,4), @YearlyInterestRate FLOAT, @Years INT)
       RETURNS DECIMAL(12,4)
                    AS
                      BEGIN
                           DECLARE @FV DECIMAL(12,4)
                               SET @FV = @Sum * POWER((1 + @YearlyInterestRate), @Years)
                            RETURN @FV
                        END

GO

SELECT * FROM [dbo].[ufn_CashInUsersGames] (1000, 0.1, 5)



.......................................................................................................................






-- 12) Calculating Interest

CREATE PROCEDURE usp_CalculateFutureValueForAccount (@AccountId INT, @YearlyInterestRate FLOAT)
		          AS
	              BEGIN
		                 SELECT	[ah].[Id]
                         AS [Account Id],
				                    [ah].[FirstName]
                         AS [First Name],
				                    [ah].[LastName]
                         AS [Last Name],
				                    [a].[Balance]
                         AS [Current Balance],
				                    dbo.ufn_CalculateFutureValue ([a].[Balance], @YearlyInterestRate, 5)
				                 AS [Balance in 5 years]
			                 FROM [AccountHolders]
                         AS [ah]
			           INNER JOIN [Accounts] 
                         AS [a]
			                   ON [ah].[Id] = [a].[AccountHolderId]
			                WHERE [a].[Id] = @AccountId
                  END

EXEC [dbo].[usp_CalculateFutureValueForAccount] 1, 'Susan', 'Cane', 123.12, 198.2860

GO




.......................................................................................................................





-- 13) Scalar Function: Cash in User Games Odd Rows

CREATE FUNCTION ufn_CashInUsersGames(@gameName NVARCHAR(50))                                                      -- TABLE-VALUED FUNCTION
  RETURNS TABLE
             AS
         RETURN                                                                                                   -- SINGLE EXPRESSION
                (
                    SELECT SUM([Cash])
                        AS [SumCash]
                      FROM (
                                SELECT [g].[Name],
                                       [ug].[Cash],                                                               -- ROW_NUMBER() OVER(PARTITION BY [g].[Name] ORDER BY [ug].[Cash] DESC) - може и такъв синтаксис, но това не важи за тази задача
                                       ROW_NUMBER() OVER(ORDER BY [ug].[Cash] DESC)                               -- Rows must be ordered by cash in descending order
                                    AS [RowNumber]
                                  FROM [UsersGames]
                                    AS [ug]
                            INNER JOIN [Games]
                                    AS [g]
                                    ON [ug].[GameId] = [g].[Id]
                                 WHERE [g].[Name] = @gameName
                           ) 
                        AS [RankingSubQuery]                                                                      -- ORDER BY [ug].[Cash] DESC
                     WHERE [RowNumber] % 2 <> 0                           --  !=                                  -- WHERE [ug].[Cash] % 2 != 0
                )
 
GO
 
SELECT * FROM [dbo].[ufn_CashInUsersGames]('Love in a mist')