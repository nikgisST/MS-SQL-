-- 1) Create Table Logs

CREATE TRIGGER tr_AddRecordToLogsOnAccountChange
ON Accounts FOR UPDATE
AS
	INSERT INTO Logs (AccountId, OldSum, NewSum)
		SELECT i.Id, d.Balance, i.Balance
			FROM inserted AS i
				JOIN deleted AS d 
				ON i.Id = d.Id
			WHERE i.Balance <> d.Balance

GO


CREATE TRIGGER tr_AddRecordToLogsOnAccountChange
ON Accounts FOR UPDATE
AS
INSERT INTO Logs (AccountId, OldSum, NewSum)
         VALUES 
         ( 
			(SELECT Id FROM inserted), 
			(SELECT Balance FROM deleted), 
			(SELECT Balance FROM inserted)
		 )




........................................................................................




-- 2) Create Table Emails

CREATE TRIGGER tr_AddEmailOnNewRecordInLogs
ON Logs FOR INSERT
AS
	INSERT INTO NotificationEmails (Recipient, [Subject], Body)
		VALUES
			(
				(SELECT AccountId FROM inserted),
				(SELECT 'Balance change for account: ' + CAST(AccountId AS NVARCHAR(MAX)) FROM inserted),
				(SELECT
					'On '
					+ FORMAT(GETDATE(), 'MMM dd yyyy h:mmtt')
					+ ' your balance was changed from '
					+ CAST(OldSum AS NVARCHAR(MAX))
					+ ' to '
					+ CAST(NewSum AS NVARCHAR(MAX))
					+ '.'
					FROM inserted)
			)




........................................................................................





-- 3) Deposit Money


CREATE PROCEDURE usp_DepositMoney(@AccountId INT, @MoneyAmount DECIMAL(12, 4))
AS
    BEGIN
	     IF @MoneyAmount < 0
		 BEGIN
	          THROW 50001, 'Money amount cannot be negative!', 1;
		 END
	UPDATE Accounts 
		SET Balance = Balance + @MoneyAmount                                    -- Balance += @MoneyAmount
		WHERE Id = @AccountId
    END

EXEC [dbo].[usp_DepositMoney] 1, 10

GO



........................................................................................




-- 4) Withdraw Money Procedure

CREATE PROCEDURE usp_WithdrawMoney(@AccountId INT, @MoneyAmount DECIMAL(12, 4))
AS
    BEGIN
	     IF @MoneyAmount < 0
		 BEGIN
	          THROW 50001, 'Money amount cannot be negative!', 1;
		 END
	UPDATE Accounts 
		SET Balance = Balance - @MoneyAmount                                    -- Balance -= @MoneyAmount
		WHERE Id = @AccountId
	END

EXEC [dbo].[usp_WithdrawMoney] 5, 25

GO



........................................................................................





-- 5) Money Transfer

CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(12, 4))
AS
	BEGIN TRANSACTION
		BEGIN TRY
			EXEC usp_WithdrawMoney @SenderId, @Amount;
			EXEC usp_DepositMoney @ReceiverId, @Amount;
		END TRY
		BEGIN CATCH
			ROLLBACK;
			THROW 50001, 'Something went wrong! Please try again later!', 1
		END CATCH
	COMMIT

EXEC [dbo].[usp_TransferMoney] 5, 1, 5000

GO



........................................................................................




-- 6) Trigger WRONG

DECLARE @IndexUser INT = 1
DECLARE @IndexItems INT = 1
DECLARE @GameName VARCHAR(50) = 'Bali'
DECLARE @GameID int = 212
DECLARE @UserID int
DECLARE @UserMoney DECIMAL(18, 4)
DECLARE @ItemPrice DECIMAL(18, 4)
DECLARE @ItemsLevel int
DECLARE @UserGameID int 
 
DECLARE @UserLevel int
 
DECLARE @Users TABLE (Id int PRIMARY KEY IDENTITY, UserId int , UserName varchar(50))
INSERT INTO @Users(UserId, UserName) SELECT ug.UserId, u.Username 
FROM Users AS u JOIN UsersGames AS ug ON u.Id = ug.UserId 
WHERE ug.UserId IN(12, 22, 37, 52, 61)
GROUP BY UserId, UserName
ORDER BY UserId DESC
--SELECT * FROM @Users
 
DECLARE @ItemsSelected TABLE(RowNumber int, Id int, [Name] varchar(50), Price Money, MinLevel int)
INSERT INTO @ItemsSelected (RowNumber, Id, [Name], Price, MinLevel) SELECT ROW_NUMBER() OVER(ORDER BY Id) AS RowNumber, i.Id, i.[Name], i.Price, i.MinLevel 
FROM Items AS i 
WHERE i.Id BETWEEN 251 AND 299 OR i.Id BETWEEN 501 AND 539
--SELECT * FROM @ItemsSelected
 
UPDATE UsersGames SET Cash += 50000 WHERE UserId IN (12, 22, 37, 52, 61) AND GameId = 212
 
WHILE(@IndexUser <= (SELECT MAX(Id) FROM @Users))
BEGIN
 
    SET @UserID = (SELECT u.UserId FROM @Users AS u WHERE u.Id = @IndexUser)
    SET @UserMoney = (SELECT Cash FROM UsersGames WHERE UserId = @UserID AND GameId = @GameID)
    SET @UserGameID = (SELECT Id FROM UsersGames WHERE UserId = @UserID AND GameId = @GameID)
    SET @UserLevel = (SELECT [Level] FROM UsersGames WHERE UserId = @UserID AND GameId = @GameID)
 
    WHILE(@IndexItems <= (SELECT MAX(RowNumber) FROM @ItemsSelected))
    BEGIN   
        
        SET @ItemsLevel = (SELECT i.MinLevel FROM @ItemsSelected AS i WHERE i.RowNumber = @IndexItems)
        SET @ItemPrice = (SELECT i.Price FROM Items As i WHERE i.Id = @IndexItems)
 
            BEGIN TRANSACTION
            
            IF (@ItemsLevel <= @UserLevel) AND (@UserMoney - @ItemPrice >= 0)
            BEGIN
                INSERT INTO UserGameItems
                SELECT [is].Id, @UserGameID FROM @ItemsSelected AS [is]
                WHERE [is].RowNumber = @IndexItems
 
                UPDATE UsersGames
                SET Cash -= @ItemPrice
                WHERE GameId = @GameID AND UserId = @UserID
 
                COMMIT TRANSACTION
            END 
            ELSE
                BEGIN
                    ROLLBACK TRANSACTION
                END
        SET @IndexItems += 1
    END
    SET @IndexUser += 1
    SET @IndexItems = 1
END
=============================================================================================================================
SELECT u.Username, g.[Name], ug.Cash, i.[Name] AS ItemName FROM Users AS u
JOIN UsersGames AS ug ON u.Id = ug.UserId
JOIN Characters AS c ON ug.CharacterId = c.Id
JOIN Games AS g ON ug.GameId = g.Id
JOIN UserGameItems AS ugi ON ug.Id = ugi.UserGameId
JOIN Items AS i ON ugi.ItemId = i.Id
WHERE ug.UserId IN(61, 52, 37, 22, 12) AND g.Id = 212 --AND ItemId BETWEEN 251 AND 299 OR ItemId BETWEEN 501 AND 539 --AND ugi.ItemId BETWEEN 251 AND 299 OR ugi.ItemId BETWEEN 501 AND 539
--GROUP BY ug.UserId, ug.[Level], u.Username, c.[Name], g.[Name], ug.Cash, i.[Name], i.Id, i.MinLevel, i.Price, g.Id
--ORDER BY ItemName
ORDER BY u.Username, i.[Name]
 
--From DB Diablo SoftUni



........................................................................................





-- 7) Massive Shopping

DECLARE @UserGameId INT = (
	SELECT ug.Id
		FROM UsersGames ug 
			JOIN Users u ON ug.UserId = u.Id
			JOIN Games g ON ug.GameId = g.Id
		WHERE u.Username = 'Stamat' AND g.[Name] = 'Safflower'
)

DECLARE @ItemsCost DECIMAL(18, 4)

-- 11-12 level

DECLARE @MinLevel INT = 11
DECLARE @MaxLevel INT = 12
DECLARE @PlayerCash DECIMAL(18, 4) = (
	SELECT Cash
		FROM UsersGames
		WHERE Id = @UserGameId
)

SET @ItemsCost = (
	SELECT SUM(Price)
		FROM Items
		WHERE MinLevel BETWEEN @MinLevel AND @MaxLevel
)

IF (@PlayerCash >= @ItemsCost)
BEGIN
	BEGIN TRANSACTION
		UPDATE UsersGames
			SET Cash -= @ItemsCost
			WHERE Id = @UserGameId
		  
		INSERT INTO UserGameItems (ItemId, UserGameId) (
			SELECT Id, @UserGameId
				FROM Items
				WHERE MinLevel BETWEEN @MinLevel AND @MaxLevel
		)
	COMMIT     
END

-- 19-21 level

SET @MinLevel = 19
SET @MaxLevel = 21
SET @PlayerCash = (
	SELECT Cash
		FROM UsersGames
		WHERE Id = @UserGameId
)

SET @ItemsCost = (
	SELECT SUM(Price)
		FROM Items
		WHERE MinLevel BETWEEN @MinLevel AND @MaxLevel
)

IF (@PlayerCash >= @ItemsCost)
BEGIN
	BEGIN TRANSACTION
		UPDATE UsersGames
			SET Cash -= @ItemsCost
			WHERE Id = @UserGameId
		  
		INSERT INTO UserGameItems (ItemId, UserGameId) (
			SELECT Id, @UserGameId
				FROM Items
				WHERE MinLevel BETWEEN @MinLevel AND @MaxLevel
		)
	COMMIT
END

-- result

SELECT i.[Name] AS [Item Name]
	FROM UserGameItems ugi
		JOIN Items i ON i.Id = ugi.ItemId
		JOIN UsersGames ug ON ug.Id = ugi.UserGameId
		JOIN Games g ON g.Id = ug.GameId
	WHERE g.[Name] = 'Safflower'
	ORDER BY [Item Name]



.....................................................................................................................................................




-- 8) Employees with Three Projects

CREATE PROCEDURE usp_AssignProject(@employeeId INT, @projectID INT)
AS
	DECLARE @EmployeesProjectsCount INT =
		(SELECT COUNT(*) FROM EmployeesProjects
			WHERE EmployeeID = @employeeId);

	IF (@EmployeesProjectsCount >= 3)
	   BEGIN
		    THROW 50001, 'The employee has too many projects!', 1;
       END
    


	INSERT INTO EmployeesProjects (EmployeeID, ProjectID)
		VALUES (@EmployeeId, @ProjectId);



CREATE PROCEDURE usp_AssignProject(@employeeId INT, @projectID INT)
AS
BEGIN TRANSACTION
	DECLARE @EmployeesProjectsCount INT =
		(SELECT COUNT(*) FROM EmployeesProjects
			WHERE EmployeeID = @employeeId);

	IF (@EmployeesProjectsCount >= 3)
	BEGIN
		RAISERROR('The employee has too many projects!', 16, 1);
		ROLLBACK;
	END

	INSERT INTO EmployeesProjects (EmployeeID, ProjectID)
		VALUES (@EmployeeId, @ProjectId);
COMMIT




............................................................................................................................................




-- 9) Delete Employees

CREATE TRIGGER tr_AddToDeleted_EmployeesOnDeletingEmployee
On Employees FOR DELETE
AS
	INSERT Deleted_Employees (FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary)
	SELECT FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary
		FROM deleted