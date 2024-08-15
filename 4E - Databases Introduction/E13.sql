CREATE DATABASE Movies
Go 

USE [Movies]
GO

Create TABLE [Directors]
(
    Id INT PRIMARY KEY,
    DirectorName NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(100)
);

INSERT INTO [Directors] 
VALUES
	(1, 'DirectorName1', 'doing something1'),
	(2, 'DirectorName2', 'doing something2'),
	(3, 'DirectorName3', 'doing something3'),
	(4, 'DirectorName4', null),
	(5, 'DirectorName5', 'doing something5')

CREATE TABLE [Genres]
(
    Id INT PRIMARY KEY,
    GenreName NVARCHAR(30) NOT NULL,
    Notes NVARCHAR(100)
)
 

INSERT INTO [Genres] 
VALUES
	(1, 'GenreName1', 'making something1'),
	(2, 'GenreName2', null),
	(3, 'GenreName3', 'making something3'),
	(4, 'GenreName4', 'making something4'),
	(5, 'GenreName5', 'making something5')


CREATE TABLE [Categories]
(
    Id INT PRIMARY KEY,
    CategoryName NVARCHAR(40) NOT NULL,
    Notes NVARCHAR(100)
);

INSERT INTO [Categories] 
VALUES
	(1, 'CategoryName1', 'choosing something1'),
	(2, 'CategoryName2', 'choosign something2'),
	(3, 'CategoryName3', null),
	(4, 'CategoryName4', 'choosing something4'),
	(5, 'CategoryName5', 'choosing something5')


CREATE TABLE [Movies]
(
    Id INT PRIMARY KEY,
    Title NVARCHAR(80) NOT NULL,
    DirectorId INT FOREIGN KEY REFERENCES [Directors](Id) NOT NULL,
    CopyrightYear DATE NOT NULL,
    Length INT NOT NULL,
    GenreId INT FOREIGN KEY REFERENCES [Genres](Id) NOT NULL,
    CategoryId INT FOREIGN KEY REFERENCES [Categories](Id) NOT NULL,
    Rating DECIMAL (2,1) NOT NULL,
    Notes NVARCHAR(100)
);


INSERT INTO [Movies]
VALUES
	(1, 'Title1', 5, '08-28-2016', 124, 2, 3, 9.1, 'choosing something1'),
	(2, 'Title2', 4, '12-9-2007', 96, 3, 4, 7.3, 'choosign something2'),
	(3, 'Title3', 3, '8-28-2016', 153, 4, 5, 4.3, null),
	(4, 'Title4', 2, '3-02-2004', 87, 5, 1, 10.9, 'choosing something4'),
	(5, 'Title5', 1, '02-1-2013', 110, 1, 2, 8.7, 'choosing something5')


...........................................................................



CREATE DATABASE Movies

USE [Movies]
GO

Create TABLE [Directors]
(
    Id INT PRIMARY KEY,
    DirectorName NVARCHAR(50) NOT NULL,
    Notes NVARCHAR(100)
)

INSERT INTO [Directors] VALUES
	(1, 'DirectorName1', 'doing something1'),
	(2, 'DirectorName2', 'doing something2'),
	(3, 'DirectorName3', 'doing something3'),
	(4, 'DirectorName4', null),
	(5, 'DirectorName5', 'doing something5');

CREATE TABLE [Genres]
(
    Id INT PRIMARY KEY,
    GenreName NVARCHAR(30) NOT NULL,
    Notes NVARCHAR(100)
)
 

INSERT INTO [Genres] VALUES
	(1, 'GenreName1', 'making something1'),
	(2, 'GenreName2', null),
	(3, 'GenreName3', 'making something3'),
	(4, 'GenreName4', 'making something4'),
	(5, 'GenreName5', 'making something5')


CREATE TABLE [Categories]
(
    Id INT PRIMARY KEY,
    CategoryName NVARCHAR(40) NOT NULL,
    Notes NVARCHAR(100)
)

INSERT INTO [Categories] VALUES
	(1, 'CategoryName1', 'choosing something1'),
	(2, 'CategoryName2', 'choosing something2'),
	(3, 'CategoryName3', null),
	(4, 'CategoryName4', 'choosing something4'),
	(5, 'CategoryName5', 'choosing something5')


CREATE TABLE [Movies]
(
    Id INT PRIMARY KEY,
    Title NVARCHAR(80) NOT NULL,
    DirectorId INT FOREIGN KEY REFERENCES [Directors](Id) NOT NULL,
    CopyrightYear DATE NOT NULL,
    Length INT NOT NULL,
    GenreId INT FOREIGN KEY REFERENCES [Genres](Id) NOT NULL,
    CategoryId INT FOREIGN KEY REFERENCES [Categories](Id) NOT NULL,
    Rating DECIMAL (3,1) NOT NULL,
    Notes NVARCHAR(100)
)

INSERT INTO [Movies] VALUES
	(1, 'Title1', 5, '08-28-2016', 124, 2, 3, 9.1, 'choosing something1'),
	(2, 'Title2', 4, '12-9-2007', 96, 3, 4, 7.3, 'choosign something2'),
	(3, 'Title3', 3, '8-28-2016', 153, 4, 5, 4.3, null),
	(4, 'Title4', 2, '3-02-2004', 87, 5, 1, 10.9, 'choosing something4'),
	(5, 'Title5', 1, '02-1-2013', 110, 1, 2, 8.7, 'choosing something5');
























