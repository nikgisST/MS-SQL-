-- 1) Create Database
CREATE DATABASE Minions

USE [Minions];

-- 2) Create Tables
CREATE TABLE [dbo].[Minions](
    Id INT,
    [Name] VARCHAR(100),
	Age INT
)

CREATE TABLE Towns (
    Id INT,                   -- или може: Id INT PRIMARY KEY Identity ==>(може да се добави, номерира от 1) без текста NOT NULL, защото той е по default
	[Name] VARCHAR(100)       -- VARCHAR() - default 1, VARCHAR(MAX)
)

ALTER TABLE Minions
ALTER COLUMN Id INT NOT NULL;

ALTER TABLE Minions
ADD CONSTRAINT PK_Id PRIMARY KEY (Id);

ALTER TABLE Towns
ALTER COLUMN Id INT NOT NULL;

ALTER TABLE Towns
ADD CONSTRAINT PKT_Id PRIMARY KEY (Id);


-- 3) New Colunm with new constrait - foreign key
ALTER TABLE Minions
ADD [TownId] INT FOREIGN KEY REFERENCES Towns(Id)


-- 4) Insert records in all tables
INSERT INTO Towns
    (Id, [Name])
VALUES 
    (1, 'Sofia'),
    (2, 'Plovdiv'),
    (3, 'Varna')

INSERT INTO Minions
    (Id, [Name], Age, TownId)
VALUES
    (1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2)               -- ALT+SHIFT+дърпам с мишката

SELECT * FROM [Minions]

--INSERT INTO Minions
   -- (Id, [Name], TownId)
--VALUES
    --(4, 'Kevin', 1)


-- 5) Truncate a table
TRUNCATE TABLE [Minions]

-- 6) Drop all tables
DROP TABLE Minions
DROP TABLE [dbo].[Towns]

-- 7) Create Table People
CREATE TABLE [People]
(
    Id INT PRIMARY KEY IDENTITY,    -- no more than 2^31-1 people == INT
    [Name] NVARCHAR(200) NOT NULL,  -- no more than 200 Unicode characters (not null)
    Picture VARBINARY(MAX),         -- size up to 2 MB == 2,000,000 Bytes
CHECK (DATALENGTH (Picture) <= 2000000),  
    Height DECIMAL(3, 2),
    [Weight] DECIMAL(5, 2),
    Gender CHAR(1) NOT NULL,
CHECK (Gender = 'm' OR Gender = 'f'),
    Birthdate DATE NOT NULL,
    Biography NVARCHAR(MAX)
)


-- ALTER Table People
-- ADD CONSTRAINT CHK_Gender CHECK (Gender = 'f' OR Gender = 'm');

INSERT INTO [People] VALUES
		('Gosho', NULL, 1.88, 100.20, 'm', '2002-01-29', 'No bio'),
		('Pesho', NULL, 1.89, 101.20, 'm', '2003-01-29', 'No bio'),
		('Jorko', NULL, 1.56, 60.20, 'm', '2004-01-29', 'No bio'),
		('Gichka', NULL, 1.33, 99.20, 'f', '2005-01-29', 'No bio'),
		('Ganka', NULL, 1.55, 120.20, 'f', '2006-01-29', 'No bio')

-- 8) Create Table Users
CREATE TABLE Users
(
    Id BIGINT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(MAX),    --size up to 900 KB = 900 000 bytes
	LastLoginTime DATETIME2,
	IsDeleted BIT
);

INSERT INTO Users 
VALUES ('Nikoleta', '1234567', 1, '10-20-2021', 0),
       ('Nikoleta2', '1234567', null, '11-20-2021', 0),
	   ('Nikoleta3', '1234567', 0, '12-20-2021', 0),
       ('Nikoleta4', '1234567', 1000000, '9-20-2021', 0),
	   ('Nikoleta6', '1234567', 25, '08-20-2021', 0);



--9)Change Primary Key

SELECT name
FROM   sys.key_constraints
WHERE  [type] = 'PK'
       AND [parent_object_id] = Object_id('dbo.Users');

ALTER TABLE [Users]
	DROP CONSTRAINT PK__Users__3214EC070E8D984B

ALTER TABLE [Users]
	ADD CONSTRAINT PK_Users
	PRIMARY KEY ([Id], [UserName])

.....................................

--9)Change Primary Key - vtori variant
 
ALTER TABLE [Users]
	DROP CONSTRAINT PK__Users__3214EC070E8D984B;
ALTER TABLE [Users]
	ADD CONSTRAINT PK_Username
	PRIMARY KEY ([Id], [UserName]);

................................


10) Add Check Constraint

ALTER TABLE [Users] 
    ADD CONSTRAINT CHK_PasswordMinLen 
    CHECK (LEN([Password]) >= 5);


-- + additinal: change column varchar len sql:
-- ALTER TABLE [Users] ALTER COLUMN [Username] VARCHAR(100);

.............................


+KUM ZADACHA 8:
[Password] VARCHAR(26) NOT NULL CHECK(LEN([Password]) >= 5),  

+ KUM ZADACHA 8:
ProfilePicture VARBINARY(MAX) CHECK(LEN(ProfilePicture) >= 900000),

+ KUM ZADACHA 8: 
IsDeleted BIT NOT NULL


............................



--11)Set Default Value of a Field

ALTER TABLE [Users] 
	ADD CONSTRAINT DF_LastLoginTime
	DEFAULT GETDATE() FOR [LastLoginTime];  -- syntax SQL Server !!!

INSERT INTO Users ([Username], [Password], IsDeleted)
VALUES 
    ('Ivan2', '1234567', 0)

SELECT * FROM Users

-- veche v kolona LastLoginTime e izpisana tekushtata data i chat)


.................................................




--12)Set Unique Field

ALTER TABLE [Users] DROP CONSTRAINT PK_Username;

ALTER TABLE [Users] ADD CONSTRAINT PK__Id PRIMARY KEY ([Id]);

-- ALTER TABLE [Users] ADD UNIQUE (ID);

ALTER TABLE [Users] ADD CONSTRAIT UC_Username UNIQUE (Username);

ALTER TABLE [Users] ADD CONSTRAINT CHK_UsernameLen CHECK(LEN([Username]) >= 3);


....................................................











