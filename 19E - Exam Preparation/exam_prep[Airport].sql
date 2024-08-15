-- 1) DDL

CREATE DATABASE Airport

USE Airport

CREATE TABLE Passengers (
	Id INT PRIMARY KEY IDENTITY,
	FullName VARCHAR(100) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL 
);

CREATE TABLE Pilots (
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) NOT NULL UNIQUE,
	LastName VARCHAR(30) NOT NULL UNIQUE,
	Age TINYINT NOT NULL,                                  -- NOT NULL CHECK(Age >= 21 AND Age <= 62),
	Rating FLOAT NULL,                                     -- NULL CHECK(Rating >= 0.0 AND Rating <= 10.0);         (Floating point)
	CONSTRAINT CHK_Age CHECK (Age BETWEEN 21 AND 62),
	CONSTRAINT CHK_Float CHECK (Rating BETWEEN 0.0 AND 10.0)
);

CREATE TABLE AircraftTypes (
	Id INT PRIMARY KEY IDENTITY,
	TypeName VARCHAR(30) NOT NULL UNIQUE,
)

CREATE TABLE Aircraft (
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT,                -- INT NULL
	Condition CHAR(1) NOT NULL,     -- CHAR == CHAR(1)
	TypeId INT NOT NULL FOREIGN KEY REFERENCES AircraftTypes(Id),
)

CREATE TABLE PilotsAircraft (
	AircraftId INT NOT NULL FOREIGN KEY REFERENCES Aircraft(Id),
	PilotId INT NOT NULL FOREIGN KEY REFERENCES Pilots(Id),
	PRIMARY KEY (AircraftId, PilotId)
	--CONSTRAINT PK_AircraftIdPilotId PRIMARY KEY (AircraftId, PilotId)
);

CREATE TABLE Airports (
	Id INT PRIMARY KEY IDENTITY,
	AirportName VARCHAR(70) NOT NULL UNIQUE,
	Country VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE FlightDestinations (
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT NOT NULL FOREIGN KEY REFERENCES Airports(Id),
	[Start] DATETIME NOT NULL,
	AircraftId INT NOT NULL FOREIGN KEY REFERENCES Aircraft(Id),
	PassengerId INT NOT NULL FOREIGN KEY REFERENCES Passengers(Id),
	TicketPrice DECIMAL(18, 2) NOT NULL DEFAULT 15                         -- Decimal
);

--> EXECUTE --> REFRESH --> DB Airport --> Database Diagrams --> десен клик --> New Database Diagram --> Yes --> Select all tables --> Add

.................................................................................................



-- Edit --> IntelliSense --> Refresh Local Cashe ( CTRL + SHIFT + R)

-- 2) Insert

INSERT INTO Passengers (FullName, Email)
	SELECT
			CONCAT(FirstName, ' ', LastName),         -- CONCAT_WS(' ', FirstName, LastName) AS FullName,
			FirstName + LastName + '@gmail.com'
		FROM Pilots
		WHERE Id BETWEEN 5 AND 15



.................................................................................................



-- 3) Update

UPDATE Aircraft
	SET Condition = 'A'
		WHERE Condition IN ('C', 'B')                                 -- WHERE (Condition = 'B' OR Condition = 'C')     WHERE Condition IN ('B', 'C')
			AND (FlightHours IS Null OR FlightHours <= 100)
			AND [Year] >= 2013;



................................................................................................




-- 4) Delete

DELETE FROM Passengers
	WHERE LEN(FullName) <= 10;



................................................................................................



-- Delete DB Airport --> Create a new DB --> попълваме в DB NAME: Airport --> OK --> Refresh --> CREATE TABLES пак --> Execute DATASET пак

-- 5) Aircraft

SELECT Manufacturer, 
       Model, 
	   FlightHours, 
	   Condition
	FROM Aircraft
	ORDER BY FlightHours DESC
   


................................................................................................


 
 -- 6) Pilots and Aircraft

SELECT p.FirstName, 
       p.LastName, 
	   a.Manufacturer, 
	   a.Model, 
	   a.FlightHours
	FROM Pilots 
	    AS p
		INNER JOIN PilotsAircraft 
		AS pa 
		ON p.Id = pa.PilotId
		LEFT JOIN Aircraft                                      -- INNER JOIN
		AS a 
		ON pa.AircraftId = a.Id
	WHERE a.FlightHours IS NOT NULL
		AND a.FlightHours < 304 -- more than 304 hours instead of up to 304
		--AND FlightHours > 304 -- !!! don't work in Judge
	ORDER BY a.FlightHours DESC, p.FirstName
       


................................................................................................


 
 -- 7) Top 20 Flight Destinations

SELECT TOP(20) 
         fd.Id
		 AS DestinstionId, 
		 fd.[Start], 
		 p.FullName, 
		 a.AirportName, 
		 fd.TicketPrice
	FROM FlightDestinations 
	    AS fd
		LEFT JOIN Passengers            -- INNER JOIN
		AS p 
		ON fd.PassengerId = p.Id
		LEFT JOIN Airports              -- INNER JOIN
		AS a 
		ON fd.AirportId = a.Id
	WHERE DAY([fd.Start]) % 2 = 0                                              -- WHERE DATEPART(DAY, fd.[Start]) % 2 == 0
	ORDER BY fd.TicketPrice DESC, a.AirportName;
       
-- помощно: SELECT DATEPART(DAY, [START]) FROM FlightDestinations


................................................................................................


 

 -- 8) Number of Flights for Each Aircraft

SELECT
		a.Id 
		AS AircraftId,
		a.Manufacturer,
		a.FlightHours,
		COUNT(*) 
		AS FlightDestinationsCount,                       -- COUNT(fd.Id)
		ROUND(AVG(fd.TicketPrice), 2) 
		AS AvgPrice
	FROM Aircraft
	    AS a
		LEFT JOIN FlightDestinations                      -- INNER JOIN
		AS fd 
		ON fd.AircraftId = a.Id
	GROUP BY a.Id, a.Manufacturer, a.FlightHours
	HAVING COUNT(*) >= 2                                  -- COUNT(fd.Id)
	ORDER BY FlightDestinationsCount DESC, AircraftId




................................................................................................




-- 9) Regular Passengers

SELECT p.FullName,
		COUNT(DISTINCT a.Id)                -- може и без Distinct навсякъде
		AS CountOfAircraft,
		SUM(fd.TicketPrice) 
		AS TotalPayed
	FROM Passengers 
	AS p
		INNER JOIN FlightDestinations
		AS fd 
		ON p.Id = fd.PassengerId
		INNER JOIN Aircraft
		AS a 
		ON fd.AircraftId = a.Id
	WHERE p.FullName LIKE '_a%'            -- WHERE SUBSTRING(p.FuillName, 2, 1 = 'a')
	GROUP BY p.FullName, p.Id              -- може и без p.Id
	HAVING COUNT(DISTINCT a.Id) > 1
	ORDER BY p.FullName




................................................................................................





-- 10) Full Info for Flight Destinations

SELECT ap.AirportName, 
     fd.[Start] 
     AS DayTime, 
	 fd.TicketPrice, 
	 p.FullName, 
	 a.Manufacturer, 
	 a.Model
	FROM FlightDestinations 
	AS fd
		LEFT JOIN Passengers                  -- INNER JOIN
		AS p
		 ON fd.PassengerId = p.Id
		LEFT JOIN Aircraft                -- INNER JOIN
		AS a
		 ON fd.AircraftId = a.Id
		LEFT JOIN Airports                  -- INNER JOIN
		AS ap
		 ON fd.AirportId = ap.Id
	WHERE DATEPART(HOUR, fd.[Start]) BETWEEN 6 AND 20   -- WHERE CAST(fd.[Start] AS TIME) BETWEEN '06:00' AND '20:00'
		AND fd.TicketPrice > 2500
	ORDER BY a.Model ASC


-- помощно: SELECT DATEPART(HOUR, [START]) FROM FlightDestinations ORDER BY 1


-- SELECT CAST(CONCAT(DATEPART(HOUR, [START]), ':', DATEPART(MINUTE, [Start])) AS TIME) FROM FlightDestinations ORDER BY 1


-- SELECT CAST([START] AS TIME) FROM FlightDestinations ORDER BY 1



................................................................................................



GO

-- 11) Find all Destinations by Email Address

CREATE OR ALTER FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT
AS
BEGIN
	DECLARE @DestinationsCount INT;
	SET @DestinationsCount = (
		SELECT COUNT(*)                         -- COUNT(fd.[Id]
			FROM Passengers 
			    AS p
				RIGHT JOIN FlightDestinations   -- INNER JOIN
				AS fd 
				ON p.Id = fd.PassengerId
			WHERE p.Email = @email
			GROUP BY p.Email                    -- GROUP BY p.Id
	);

    IF @DestinationsCount IS NULL
	   SET @DestinationsCount = 0;

	RETURN @DestinationsCount;                 -- ако не напишем IF проверката горе, трябва да е така накрая: RETURN ISNULL(@DestinationsCount, 0)
END
 
GO
 
SELECT dbo.udf_FlightDestinationsByEmail ('PierretteDunmuir@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')
SELECT dbo.udf_FlightDestinationsByEmail('Montacute@gmail.com')

GO





CREATE FUNCTION udf_FlightDestinationsByEmail(@email VARCHAR(50))
RETURNS INT AS
BEGIN
	RETURN ISNULL (
		(SELECT COUNT(fd.Id)                      
			FROM Passengers 
			    AS p
				INNER JOIN FlightDestinations 
				AS fd 
				ON p.Id = fd.PassengerId
			WHERE p.Email = @email
			GROUP BY p.Id), 0
	);
END

................................................................................................





-- 12) Full Info for Airports

CREATE PROCEDURE usp_SearchByAirportName(@airportName VARCHAR(70))
AS
    BEGIN
	SELECT
			a.AirportName,
			p.FullName,
			CASE
				WHEN fd.TicketPrice <= 400 THEN 'Low'
				WHEN fd.TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'      -- WHEN fd.TicketPrice <= 1500 THEN 'Medium'
				ELSE 'High'
			END 
			   AS LevelOfTickerPrice,
			ac.Manufacturer,
			ac.Condition,
			t.TypeName
		FROM Airports 
		    AS a
			LEFT JOIN FlightDestinations             -- INNER JOIN
			AS fd 
			ON a.Id = fd.AirportId
			LEFT JOIN Passengers                     -- INNER JOIN
			AS p 
			ON fd.PassengerId = p.Id
			LEFT JOIN Aircraft                       -- INNER JOIN
			AS ac 
			ON fd.AircraftId = ac.Id
			LEFT JOIN AircraftTypes                  -- INNER JOIN
			AS t 
			ON ac.TypeId = t.Id
WHERE a.AirportName = @airportName
ORDER BY ac.Manufacturer, p.FullName
END;


GO
 
EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'


