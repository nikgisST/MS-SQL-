CREATE TABLE Categories
             (
                Id INT PRIMARY KEY IDENTITY,
                [Name] VARCHAR(50) NOT NULL
             )

CREATE TABLE Addresses
             (
                Id INT PRIMARY KEY IDENTITY,
                StreetName NVARCHAR(100) NOT NULL,    -- UNICODE
                StreetNumber INT NOT NULL,
                Town VARCHAR(30) NOT NULL,
                Country VARCHAR(50) NOT NULL,
                ZIP INT NOT NULL
             )
 
CREATE TABLE Publishers
             (
                Id INT PRIMARY KEY IDENTITY,
                [Name] VARCHAR(30) UNIQUE NOT NULL,    
                AddressId INT NOT NULL FOREIGN KEY REFERENCES Addresses(Id),
                Website NVARCHAR(40) NULL,
                Phone NVARCHAR(20) NULL
             )

CREATE TABLE PlayersRanges
             (
                Id INT PRIMARY KEY IDENTITY,
                PlayersMin INT NOT NULL,   
                PlayersMax INT NOT NULL
             )

CREATE TABLE Boardgames
             (
                Id INT PRIMARY KEY IDENTITY,
                [Name] NVARCHAR(30) NOT NULL,   
                YearPublished INT NOT NULL,
                Rating DECIMAL(18,2) NOT NULL,
                CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
                PublisherId INT NOT NULL FOREIGN KEY REFERENCES Publishers(Id),
                PlayersRangeId INT NOT NULL FOREIGN KEY REFERENCES PlayersRanges(Id)
             )

CREATE TABLE Creators
             (
                Id INT PRIMARY KEY IDENTITY,
                FirstName NVARCHAR(30) NOT NULL,   
                LastName NVARCHAR(30) NOT NULL,
                Email NVARCHAR(30) NOT NULL
             )

CREATE TABLE CreatorsBoardgames
             (
                CreatorId INT NOT NULL FOREIGN KEY REFERENCES Creators(Id),
                BoardgameId INT NOT NULL FOREIGN KEY REFERENCES Boardgames(Id),
                PRIMARY KEY(CreatorId, BoardgameId)
             )



INSERT INTO [Boardgames]
            ([Name], [YearPublished], [Rating], [CategoryId], [PublisherId], [PlayersRangeId])
     VALUES 
            ('Deep Blue', 2019, 5.67, 1, 15, 7),
            ('Paris', 2016, 9.78, 7, 1, 5),
            ('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
            ('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
            ('One Small Step', 2019, 5.75, 5, 9, 2)

INSERT INTO [Publishers]
            ([Name], [AddressId], [Website], [Phone])
     VALUES 
            ('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
            ('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
            ('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')


-- 3
UPDATE [PlayersRanges]
   SET [PlayersMax] += 1
WHERE ID BETWEEN 2 IN 2


UPDATE [Boardgames]
SET CONCAT([Name], '', 'V2')
WHERE YearPublished >= 2020





...............................................................
DELETE
  FROM [Volunteers]
 WHERE [DepartmentId] = (
                            SELECT [Id]
                              FROM [VolunteersDepartments]
                             WHERE [DepartmentName] = 'Education program assistant'
                        )
 
---- Then we can safely delete the department
DELETE
  FROM [VolunteersDepartments]
 WHERE [DepartmentName] = 'Education program assistant'


--4

DELETE 
 FROM [Publishers]
 WHERE [AddressId] = ( 
                    SELECT [Id]
                    FROM [Addresses]
                    WHERE SUBSTRING([Town], 1,1) = 'L'
                 )

---- Then we can safely delete the department
DELETE 
  FROM [Addresses] 
WHERE SUBSTRING([Town], 1,1) = 'L'

--5
 SELECT [Name], Rating 
 FROM Boardgames
 ORDER BY YearPublished ASC, [Name] DESC

--6
 SELECT b.Id, b.[Name], b.YearPublished, c.[Name]
        FROM Boardgames AS b
        INNER JOIN Categories AS c
                ON [b].[CategoryId] = [c].[Id]
WHERE c.[Name] = 'Strategy Games' OR c.[Name] = 'Wargames'
ORDER BY YearPublished DESC


-- 7
SELECT c.Id, 
    CONCAT(c.FirstName, ' ', c.LastName) AS CreatorName, c.Email
 FROM Creators AS c
 LEFT JOIN CreatorsBoardgames AS cb
 ON c.Id = cb.CreatorId
LEFT JOIN Boardgames AS b
ON cb.BoardgameId = b.Id
 WHERE b.[Name] IS NULL
 ORDER BY CreatorName


-- 8
 SELECT TOP(5)
     b.[Name],
     b.Rating,
     c.[Name]
FROM Boardgames b
INNER JOIN Categories c
ON b.CategoryId = c.Id
INNER JOIN PlayersRanges pr
ON b.PlayersRangeId = pr.Id
WHERE (Rating > 7.00 AND b.[Name] LIKE '%a%') OR (Rating > 7.50 AND (PlayersMax <= 5 AND PlayersMin >= 2))
ORDER BY b.[Name],
b.Rating DESC



-- 9
SELECT CONCAT(c.FirstName, ' ', c.LastName)
        AS FullName, 
          c.Email, 
         b.Rating 
         FROM
(
          CONCAT(c.FirstName, ' ', c.LastName),
            c.Email, 
           b.Rating,
        DENSE_RANK() OVER(PARTITION BY CONCAT(FirstName, ' ', c.LastName) ORDER BY [Rating] DESC) AS Rank
       FROM Creators 
    AS c
INNER JOIN CreatorsBoardgames
    ON c.Id = cb.CreatorId 
INNER JOIN Boardgames 
AS b
    ON cb.BoardgameId = b.Id
WHERE Email LIKE '%.com' 
 ) 
     AS [RankingSubquery]
        Rank = 1                    
ORDER BY FullName




-- 10
SELECT c.LastName,
       CEILING(AVG(Rating)) AS AverageRating,
       p.[Name] AS PublisherName
       FROM Creators AS c
LEFT JOIN CreatorsBoardgames AS cb
ON c.Id = cb.CreatorId
LEFT JOIN Boardgames AS b
ON cb.BoardgameId = b.Id
LEFT JOIN Publishers AS p
ON b.PublisherId = p.Id
WHERE p.[Name] = 'Stonemaier Games'
GROUP BY c.LastName, p.[Name]

ORDER BY (AVG(Rating) DESC



-- 11
CREATE FUNCTION [udf_CreatorWithBoardgames] (@name NVARCHAR(30))
    RETURNS INT
          BEGIN
       RETURN (
                    SELECT
                          COUNT(*)
                     FROM [Boardgames]
                       AS [b]
                LEFT JOIN [CreatorsBoardgames]
                       AS [cb]
                       ON [b].[Id] = [cb].[BoardgameId]
                LEFT JOIN [Creators]
                       AS [c]
                       ON [cb].[CreatorId] = [c].[Id]
                WHERE c.[FirstName] = @name
             )
         END




-- 12
CREATE PROCEDURE [usp_SearchByCategory] (@category VARCHAR(50))
              AS
           BEGIN
                       SELECT [b].[Name] AS Name, 
                                b.YearPublished,
                                b.Rating,
                                c.[Name] AS CategoryName,
                                p.[Name] AS PublisherName,
                                 (CAST(pr.[PlayersMin] AS VARCHAR)) + ' people' AS MinPlayers,
                                CAST(pr.PlayersMax AS VARCHAR) + ' people' AS MaxPlayers                    
                         FROM [Boardgames]
                          AS [b]
                        INNER JOIN Categories
                         AS c
                        ON b.CategoryId = c.Id
                        INNER JOIN Publishers 
                        AS p
                        ON b.PublisherId = p.Id
                        INNER JOIN PlayersRanges
                           AS pr
                           ON b.PlayersRangeId = pr.Id
                   WHERE c.[Name] = @category
                   ORDER BY PublisherName, b.YearPublished DESC

             END

 
EXEC usp_SearchByCategory 'Pumpkinseed Sunfish'
