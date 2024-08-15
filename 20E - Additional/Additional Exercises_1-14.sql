-- 1) Number of Users for Email Provider

SELECT [Email Provider],
	   COUNT(*)                   -- COUNT([Id])????
     AS [Number Of Users]
   FROM (
	     SELECT SUBSTRING([Email], (CHARINDEX('@', [Email]) + 1), (LEN([Email])))                -- SELECT SUBSTRING([Email], (CHARINDEX('@', [Email]) + 1), (LEN([Email]) - CHARINDEX('@', [Email])))
			   AS [Email Provider]
		     FROM [Users]
        )
	 AS [Subquery]
GROUP BY [Email Provider]
ORDER BY [Number Of Users] DESC,
	     [Email Provider] ASC



..............................................................................................................





-- 2) All Users in Games

SELECT [g].[Name]
        AS [Game],
       [gt].[Name]
	    AS [Game Type],
	   [u].[Username], 
	   [ug].[Level], 
	   [ug].[Cash], 
	   [c].[Name]
        AS [Character]
      FROM [UsersGames]
        AS [ug]
INNER JOIN [Games]                                           -- LEFT JOIN
        AS [g]
        ON [ug].[GameId] = [g].[Id]
INNER JOIN [GameTypes]                                       -- LEFT JOIN
		AS [gt] 
	    ON [g].[GameTypeId] = [gt].[Id]
INNER JOIN [Users]                                           -- LEFT JOIN
		AS [u] 
		ON [ug].[UserId] = [u].[Id]
INNER JOIN [Characters]                                      -- LEFT JOIN
		AS [c] 
		ON [ug].[CharacterId] = [c].[Id]
  ORDER BY [ug].[Level] DESC,
	       [u].[Username] ASC,
		   [g].[Name] ASC




..............................................................................................................




-- 3) Users in Games with Their Items

SELECT [u].[Username],
	   [g].[Name]
	    AS [Game],
	   COUNT([ugi].[ItemId]) 
	    AS [Items Count],
		SUM([i].[Price]) 
	    AS [Items Price]
      FROM [UserGameItems] 
        AS [ugi]
INNER JOIN [UsersGames]                                  -- LEFT JOIN
        AS [ug] 
	    ON [ugi].[UserGameId] = [ug].[Id]
INNER JOIN [Games]                                       -- LEFT JOIN
		AS [g] 
		ON [ug].[GameId] = [g].[Id]
INNER JOIN [Users]                                       -- LEFT JOIN
		AS [u] 
		ON [ug].[UserId] = [u].[Id]
INNER JOIN [Items]                                       -- LEFT JOIN
	    AS [i]
	    ON [ugi].[ItemId] = [i].[Id]
  GROUP BY [u].[Username], [g].[Name]
    HAVING COUNT([ugi].[ItemId]) >= 10
  ORDER BY [Items Count] DESC,
           [Items Price] DESC, 
	       [Username] ASC




..............................................................................................................




-- 4) User in Games with Their Statistics

SELECT [u].[Username], 
	   [g].[Name] 
	    AS [Game], 
	   MAX([ch].[Name]) 
	    AS [Character],
	   SUM([s].[Strength]) + MAX([bs].[Strength]) + MAX([chs].[Strength])
        AS [Strength],
	   SUM([s].[Defence]) + MAX([bs].[Defence]) + MAX([chs].[Defence])
	    AS [Defence],
	   SUM([s].[Speed]) + MAX([bs].[Speed]) + MAX([chs].[Speed])
	    AS [Speed],
	   SUM([s].[Mind]) + MAX([bs].[Mind]) + MAX([chs].[Mind])
	    AS [Mind],
	   SUM([s].[Luck]) + MAX([bs].[Luck]) + MAX([chs].[Luck])
	    AS [Luck]
      FROM [Users]
        AS [u]
INNER JOIN [UsersGames]                                                        -- LEFT JOIN
        AS [ug]
	    ON [u].[id] = [ug].[UserId]
INNER JOIN [Games]                                                        -- LEFT JOIN
        AS [g]
		ON [ug].[GameId] = [g].[Id]
INNER JOIN [GameTypes]                                                        -- LEFT JOIN
        AS [gt]
		ON [g].[GameTypeId] = [gt].[Id]
INNER JOIN [UserGameItems]                                                        -- LEFT JOIN
        AS [ugi]
	    ON [ug].[Id] = [ugi].[UserGameId]
INNER JOIN [Items]                                                        -- LEFT JOIN
        AS [i]
		ON [ugi].[ItemId] = [i].[Id]
INNER JOIN [Statistics]                                                        -- LEFT JOIN
        AS [s]
		ON [i].[StatisticId] = [s].[Id]
INNER JOIN [Statistics]                                                        -- LEFT JOIN
        AS [bs]
	    ON [gt].[BonusStatsId] = [bs].[Id]
INNER JOIN [Characters]                                                        -- LEFT JOIN
        AS [ch]
		ON [ug].[CharacterId] = [ch].[Id]
INNER JOIN [Statistics]                                                        -- LEFT JOIN
        AS [chs]
		ON [ch].[StatisticId] = [chs].[Id]
  GROUP BY [u].[Username],
           [g].[Name]
  ORDER BY [Strength] DESC,
           [Defence] DESC,
		   [Speed] DESC,
		   [Mind] DESC,
		   [Luck] DESC




..............................................................................................................




-- 5) All Items with Greater than Average Statistics

SELECT [i].[Name],
       [i].[Price],
	   [i].[MinLevel],
	   [s].[Strength],
	   [s].[Defence],
	   [s].[Speed],
	   [s].[Luck],
	   [s].[Mind]
  FROM [Items]
    AS [i]
INNER JOIN [Statistics]                            -- LEFT JOIN
        AS [s] 
ON [i].[StatisticId] = [s].[Id]
WHERE [s].[Mind] > (
	                SELECT
					      AVG([Mind])
				    FROM [Statistics]
				   )
  AND [s].[Luck] > (
	                SELECT
					      AVG([Luck])
						  FROM [Statistics])
  AND [s].[Speed] > (
	                 SELECT
					       AVG([Speed])
					 FROM [Statistics])
ORDER BY [Name] ASC




..............................................................................................................




-- 6) Display All Items about Forbidden Game Type

SELECT [i].[Name]
    AS [Item], 
	   [i].[Price],
	   [i].[MinLevel],
	   [gt].[Name]
	AS [Forbidden Game Type]
  FROM [Items]
	AS [i]
LEFT JOIN [GameTypeForbiddenItems]                      -- Find all items and information whether and what forbidden game types they have
       AS [gtfi]
	   ON [i].[Id] = [gtfi].[ItemId]                      -- Find all items and information whether and what forbidden game types they have
LEFT JOIN [GameTypes] 
       AS [gt]
	   ON [gtfi].[GameTypeId] = [gt].[Id]
ORDER BY [gt].[Name] DESC,
         [i].[Name]




..............................................................................................................




-- 7) Buy Items for User in Game

DECLARE @UserId INT = (SELECT [Id] FROM [Users] WHERE [Username] = 'Alex')
DECLARE @GameId INT = (SELECT [Id] FROM [Games] WHERE [Name] = 'Edinburgh')
DECLARE @UserGameId INT = (SELECT [Id] FROM [UsersGames] WHERE [UserId] = @userId AND [GameId] = @gameId)

DECLARE @Item1Id INT = (SELECT [Id] FROM Items WHERE Name = 'Blackguard')
DECLARE @Item2Id INT = (SELECT [Id] FROM Items WHERE Name = 'Bottomless Potion of Amplification')
DECLARE @Item3Id INT = (SELECT [Id] FROM Items WHERE Name = 'Eye of Etlich (Diablo III)')
DECLARE @Item4Id INT = (SELECT [Id] FROM Items WHERE Name = 'Gem of Efficacious Toxin')
DECLARE @Item5Id INT = (SELECT [Id] FROM Items WHERE Name = 'Golden Gorget of Leoric')
DECLARE @Item6Id INT = (SELECT [Id] FROM Items WHERE Name = 'Hellfire Amulet')

DECLARE @TotalCost MONEY = (
	SELECT SUM([Price])
		FROM [Items]
		WHERE [Id] IN (@Item1Id, @Item2Id, @Item3Id, @Item4Id, @Item5Id, @Item6Id)
                           )

UPDATE [UsersGames]
	SET [Cash] -= @TotalCost
	WHERE [Id] = @UserGameId

INSERT INTO [UserGameItems]
	VALUES
		(@Item1Id, @UserGameId),
		(@Item2Id, @UserGameId),
		(@Item3Id, @UserGameId),
		(@Item4Id, @UserGameId),
		(@Item5Id, @UserGameId),
		(@Item6Id, @UserGameId)

SELECT [u].[Username],
	   [g].[Name],
	   [ug].[Cash],
	   [i].[Name]
	    AS [Item Name]
      FROM [Users]
	    AS [u]
INNER JOIN [UsersGames]
        AS [ug] 
        ON [u].[Id] = [ug].[UserId]
INNER JOIN [Games]
        AS [g]
	    ON [ug].[GameId] = [g].[Id]
INNER JOIN [UserGameItems]
        AS [ugi]
		ON [ug].[Id] = [ugi].[UserGameId]
INNER JOIN [Items]
        AS [i]
		ON [ugi].[ItemId] = [i].[Id]
	 WHERE [g].[Id] = @GameId
ORDER BY [i].[Name]




..............................................................................................................................





-- 8) Peaks and Mountains

SELECT [p].[PeakName],
       [m].[MountainRange]
	AS [Mountain], 
	   [p].[Elevation]
     FROM [Peaks]
       AS [p]
INNER JOIN [Mountains]                                 -- LEFT JOIN
      AS [m]
      ON [p].[MountainId] = [m].[Id]
ORDER BY [p].[Elevation] DESC,
         [p].[PeakName]




..............................................................................................................................




-- 9) Peaks with Mountain, Country and Continent

SELECT [p].[PeakName],
       [m].[MountainRange]
	AS [Mountain],
	   [c].[CountryName],
	   [cc].[ContinentName]
	  FROM [Peaks]
	    AS [p]
INNER JOIN [Mountains]                                               -- When a mountain belongs to multiple countries, display them all          -- LEFT JOIN
        AS [m]
        ON [p].[MountainId] = [m].[Id]
INNER JOIN [MountainsCountries]                                      -- When a mountain belongs to multiple countries, display them all
       AS [mc]
	   ON [m].[Id] = [mc].[MountainId]
INNER JOIN [Countries]                                               -- When a mountain belongs to multiple countries, display them all          -- LEFT JOIN
       AS [c]
	   ON [mc].[CountryCode] = [c].[CountryCode]
INNER JOIN [Continents]                                              -- When a mountain belongs to multiple countries, display them all          -- LEFT JOIN
       AS [cc]
	   ON [c].[ContinentCode] = [cc].[ContinentCode]
ORDER BY [p].[PeakName],
         [c].[CountryName]




..............................................................................................................................





-- 10) Rivers by Country

SELECT [c].[CountryName],
	   [cc].[ContinentName],
	   COUNT([r].[RiverName])                                   -- COUNT([r].[Id])
    AS [RiversCount],
		CASE
			WHEN SUM([r].[Length]) IS NULL THEN 0
			ELSE SUM([r].[Length])
		END
	AS [TotalLength]
  FROM [Countries]
	AS [c]
LEFT JOIN [CountriesRivers]
	   AS [cr]
	   ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers]
	   AS [r]
	   ON [cr].[RiverId] = [r].[Id]
LEFT JOIN [Continents]
	   AS [cc]
	   ON [c].[ContinentCode] = [cc].[ContinentCode]
 GROUP BY [c].[CountryName],
          [cc].[ContinentName]
ORDER BY [RiversCount] DESC,
         [TotalLength] DESC,
		 [c].[CountryName]




..............................................................................................................................





-- 11) Count of Countries by Currency

SELECT [cur].[CurrencyCode],
	   [cur].[Description]
	AS [Currency],
	   COUNT([c].[CountryName])
	AS [NumberOfCountries]
	 FROM [Currencies]
	   AS [cur]
LEFT JOIN [Countries]
      AS [c]
      ON [cur].[CurrencyCode] = [c].[CurrencyCode]
GROUP BY [cur].[CurrencyCode],
	     [cur].[Description]
ORDER BY [NumberOfCountries] DESC,
	     [Currency]



SELECT [cur].[CurrencyCode],
	   [cur].[Description]
         AS [Currency],
	   COUNT([c].[CountryName])
	    AS [NumberOfCountries]
      FROM [Countries]
	    AS [c]
RIGHT JOIN [Currencies]
      AS [cur]
      ON [c].[CurrencyCode] = [cur].[CurrencyCode]
GROUP BY [cur].[CurrencyCode],
	     [cur].[Description]
ORDER BY [NumberOfCountries] DESC,
         [Currency]




..............................................................................................................................





-- 12) Population and Area by Continent

SELECT [ContinentName],
		   SUM(CAST([c].[AreaInSqKm] AS BIGINT))
		AS [CountriesArea],
		   SUM(CAST([c].[Population] AS BIGINT))
		AS [CountriesPopulation]
	  FROM [Countries] 
	    AS [c]
INNER JOIN [Continents]                                          -- LEFT JOIN
      AS [cc]
      ON [c].[ContinentCode] = [cc].[ContinentCode]
GROUP BY [cc].[ContinentName]
ORDER BY [CountriesPopulation] DESC





..............................................................................................................................





-- 13) Monasteries by Country

CREATE TABLE [Monasteries] (
	[Id] INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(MAX) NOT NULL,
	[CountryCode] CHAR(2) NOT NULL FOREIGN KEY REFERENCES [Countries]([CountryCode])
)

INSERT INTO Monasteries([Name], CountryCode)
	VALUES
('Rila Monastery “St. Ivan of Rila”', 'BG'), 
('Bachkovo Monastery “Virgin Mary”', 'BG'),
('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
('Kopan Monastery', 'NP'),
('Thrangu Tashi Yangtse Monastery', 'NP'),
('Shechen Tennyi Dargyeling Monastery', 'NP'),
('Benchen Monastery', 'NP'),
('Southern Shaolin Monastery', 'CN'),
('Dabei Monastery', 'CN'),
('Wa Sau Toi', 'CN'),
('Lhunshigyia Monastery', 'CN'),
('Rakya Monastery', 'CN'),
('Monasteries of Meteora', 'GR'),
('The Holy Monastery of Stavronikita', 'GR'),
('Taung Kalat Monastery', 'MM'),
('Pa-Auk Forest Monastery', 'MM'),
('Taktsang Palphug Monastery', 'BT'),
('Sümela Monastery', 'TR')

-- ALTER TABLE [Countries]
-- ADD [IsDeleted] BIT DEFAULT 0 NOT NULL                    (defaults to false)

UPDATE [Countries]
	SET [IsDeleted] = 1
	WHERE [CountryCode] IN (
		                     SELECT [cc].[CountryCode]
			                   FROM (
				                      SELECT [c].[CountryCode],
									         COUNT([cr].[RiverId])
										  AS [RiversCount]
					                    FROM [Countries]
										  AS [c]
						          INNER JOIN [CountriesRivers]                                      -- LEFT JOIN
								       AS [cr]
									   ON [c].[CountryCode] = [cr].[CountryCode]
				            	 GROUP BY [c].[CountryCode]
					         HAVING COUNT([cr].[RiverId]) > 3
			                       ) AS [cc]
	                       )

SELECT [m].[Name]
      AS [Monastery],
       [c].[CountryName]
      AS [Country]
	FROM [Monasteries]
	  AS [m]
INNER JOIN [Countries]
	  AS [c]
	  ON [m].[CountryCode] = [c].[CountryCode]
   WHERE [IsDeleted] = 0
ORDER BY [Monastery]




................................................................................................................





-- 14) Monasteries by Continents and Countries

UPDATE [Countries]
	SET [CountryName] = 'Burma'
  WHERE [CountryName ]= 'Myanmar'

INSERT INTO [Monasteries] ([Name], [CountryCode])
	 SELECT 'Hanga Abbey',
		    [CountryCode]
	   FROM [Countries]
	  WHERE [CountryName] = 'Tanzania'

INSERT INTO [Monasteries] ([Name], [CountryCode])
	 SELECT 'Myin-Tin-Daik',
		    [CountryCode]
	   FROM [Countries]
	  WHERE [CountryName] = 'Myanmar'

SELECT [cc].[ContinentName],
	   [c].[CountryName],
	   COUNT([m].[Id])
	  AS [MonasteriesCount]
	FROM [Continents]
	  AS [cc]
RIGHT JOIN [Countries]
	  AS [c]
	  ON [cc].[ContinentCode] = [c].[ContinentCode]
LEFT JOIN [Monasteries ]
	  AS [m]
	  ON [c].[CountryCode] = [m].[CountryCode]
   WHERE [c].[IsDeleted] = 0
GROUP BY [cc].[ContinentName],
	     [c].[CountryCode],
	     [c].[CountryName]
ORDER BY [MonasteriesCount] DESC,
	     [c].[CountryName]
