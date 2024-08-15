-- 1) One-to-one relationship        INT FOREIGN KEY REFERENCES [Passports]([PassportID]) UNIQUE NOT NULL

CREATE DATABASE [EntityRelationsDemo2023]

GO

USE [EntityRelationsDemo2023]

GO

-- Problem 01 
CREATE TABLE [Passports]
(
    [PassportID] INT PRIMARY KEY IDENTITY(101,1),              -- REAL DB VARCHAR(256); - GUID == extern_id   -- PRIMARY KEY by default is NOT NULL, но foreign key e nullable   
    [PassportNumber] VARCHAR(8) NOT NULL,                                          -- CHAR(8)               
)


CREATE TABLE [Persons]
(
    [PersonID] INT PRIMARY KEY IDENTITY(1,1),              -- Default, ако недопиша нишо след думата започва да номерира от 1 и е през 1
    [FirstName] VARCHAR(50) NOT NULL,                                                  -- всичко може да приема null by default, затова постоянно трябва да се изписва NOT NULL, когато е нужно
    [Salary] DECIMAL(8, 2) NOT NULL,                                                   -- никога не използваме вградения тип MONEY  -- DECIMAL(n,f) - 1) n - total digits (before and after floating point)
    [PassportID] INT FOREIGN KEY REFERENCES [Passports]([PassportID]) UNIQUE NOT NULL    -- foreign key типа данни == primary key типа данни       -- 2) f - digits after floating point
)                                                                                        -- foreign key по default може да има NULL, но не е мн логично

INSERT INTO [Passports]([PassportNumber])
    VALUES
          ('N34FG21B'),
          ('K65LO4R7'),
          ('ZE657QP2')

          SELECT * FROM [Passports]


INSERT INTO [Persons]([FirstName], [Salary], [PassportID])
    VALUES 
          ('Roberto', 43300.00, 102),
          ('Tom', 56100.00, 103),
          ('Yana', 60300.00, 101)

          SELECT * FROM [Persons]


-- ALTER променя структурата на таблицата - имена на колони, constraint
-- update променя стоиности на колоната (реда)

ALTER TABLE [Passports]
ADD UNIQUE ([PassportNumber])

-- decimal е по-точен от float, затова винаги използваме него

ALTER TABLE [Passports]
ADD CHECK (LEN([PassportNumber]) = 8)

-- двата atler могат да се групират и използват наведнъж

ALTER TABLE [Passports]
ADD UNIQUE ([PassportNumber])
ADD CHECK (LEN([PassportNumber]) = 8)

-- Composite PK -> {PK1, PK2}: {1, 1}, {1,2}, {2,1}, {2,2} НЕ МОЖЕ пак да се повтори {1, 1} -търси се уникална комбинация и от двата

-- UNIQUE се използва логически, за да не може да се свържат два паспорта към един човек
-- Ако FK не го направим да е уникален, то връзката ше стане 1 към много, а не 1 към 1


-- ЕДИНИЧНИ И ДВОЙНИ КАВИЧКИ:
-- Single quetes are for strings literals + data literals are also strings
-- Double quotes are for Database Identifiers



-- 2) One-to-Many Relationship (Many-To-One)

CREATE TABLE [Manufacturers]
(
    [ManufacturerID] INT PRIMARY KEY IDENTITY,
    [Name] VARCHAR(50) NOT NULL,
    [EstablishedOn] DATETIME2 NOT NULL                    -- [EstablishedOn] DATETIME2 - МОЖЕ да го използваме и като текст
)


CREATE TABLE [Models]
(
    [ModelID] INT PRIMARY KEY IDENTITY(101, 1),
    [Name] VARCHAR(50) NOT NULL,
    [ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers]([ManufacturerID]) NOT NULL
)

INSERT INTO [Manufacturers]([Name], [EstablishedOn])
    VALUES
          ('BMW', '07/03/1916'),
          ('Tesla', '01/01/2003'),
          ('Lada', '01/05/1966')


SELECT * FROM [Manufacturers]

INSERT INTO [Models]([Name], [ManufacturerID])
    VALUES
          ('X1', 1),
          ('i6', 1),
          ('Model S', 2),
          ('Model X', 2),
          ('Model 3', 2),
          ('Nova', 3)

SELECT * FROM [Models]        -- всяка една таблица се нарича Entity


-- 3) Many-To-Many Relationship
-- contain a mapping table

CREATE TABLE [Students]
(
    [StudentID] INT PRIMARY KEY IDENTITY(1, 1),
    [Name] NVARCHAR(50) NOT NULL
)


CREATE TABLE [Exams]
(
    [ExamID] INT PRIMARY KEY IDENTITY(101, 1),
    [Name] NVARCHAR(100) NOT NULL
)


CREATE TABLE [StudentsExams]
(
    [StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]) NOT NULL,
    [ExamID] INT FOREIGN KEY REFERENCES [Exams]([ExamID]),                    -- понеже в мапинг таблицата и двете са праймъри кий, нот ноу е по дефаулт и може да се изпусне
    -- other columns may appear                                               -- винаги мапинг таблиците имат поне 2 форейн кия и те двата образуват общо един праймъри кий, КОИТО Е КОМПОЗИТЕН
    PRIMARY KEY ([StudentID], [ExamID])
)

INSERT INTO [Students]([Name])
    VALUES
          ('Mila'),
          ('Toni'),
          ('Ron')


INSERT INTO [Exams]([Name])
    VALUES
          ('SpringMVC'),
          ('Neo4j'),
          ('Oracle 11g')

INSERT INTO [StudentsExams]([StudentID], [ExamID])
    VALUES
          (1, 101),
          (1, 102),
          (2, 101)      

          SELECT * FROM [StudentsExams]



-- 4) Self-Referencing

CREATE TABLE [Teachers]
(
    [TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
    [Name] NVARCHAR(50) NOT NULL,
    [ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID])
)

INSERT INTO [Teachers]([Name], [ManagerID])
    VALUES
          ('John', NULL),
          ('Maya', 106),
          ('Silvia', 106),
          ('Ted', 105),
          ('Mark', 101),
          ('Greta', 101)

SELECT * FROM [Teachers]


-- 6) UNIVERSITY DATABSE - E/R DIAGRAMS

CREATE DATABASE [UniversityDatabase2023]

GO

USE [UniversityDatabase2023]

GO

CREATE TABLE [Majors]
(
    [MajorID] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL
)


CREATE TABLE [Subjects]
(
    [SubjectID] INT PRIMARY KEY IDENTITY,
    [SubjectName] NVARCHAR(100) NOT NULL
)


CREATE TABLE [Students]
(
    [StudentID] INT PRIMARY KEY IDENTITY,
    [StudentNumber] VARCHAR(20) NOT NULL,
    [StudentName] NVARCHAR(50) NOT NULL,
    [MajorID] INT FOREIGN KEY REFERENCES [Majors]([MajorID]) NOT NULL
)

CREATE TABLE [Agenda]
(
    [StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]),
    [SubjectID] INT FOREIGN KEY REFERENCES [Subjects]([SubjectID]),
    PRIMARY KEY ([StudentID], [SubjectID])
)


CREATE TABLE [Payments]
(
    [PaymentID] INT PRIMARY KEY IDENTITY,              -- int real example we would use GUID
    [PaymentDate] DATETIME2 NOT NULL,
    [PaymentAmount] DECIMAL(8, 2) NOT NULL,
    [StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]) NOT NULL
)


ALTER TABLE [Students]
ADD UNIQUE ([StudentNumber])

INSERT INTO [Majors]
    VALUES
          ('Pesho')

INSERT INTO [Students]([StudentName], [StudentNumber], [MajorID])
    VALUES 
          ('Tosho', '941220005', 1)

INSERT INTO [Subjects]
    VALUES
          ('Programming with SQL')

INSERT INTO [Agenda]
    VALUES
          (1, 1)

SELECT * FROM [Agenda]




-- 9) *Peaks in Rila

GO

USE [Geography]

GO

SELECT * FROM [Peaks]

SELECT * FROM [Mountains] WHERE [MountainRange] = 'Rila'

--  ==> id e s nomer 17

SELECT * FROM [Peaks] WHERE [MountainId] = 17

-- gornite bqha pomoshtni

SELECT * 
    FROM [Peaks]
    AS [p]
LEFT JOIN [Mountains]
    AS [m]
    ON [p].[MountainId] = [m].[Id]


-- sledvatelno stava:

SELECT [m].[MountainRange], 
       [p]. [PeakName], 
       [p].[Elevation]
    FROM [Peaks]            -- Peak table is the left one because it is announced first and Mountains is the right one because it is announced second
    AS [p]
LEFT JOIN [Mountains]
    AS [m]
    ON [p].[MountainId] = [m].[Id]
WHERE [m].[MountainRange] = 'Rila'
ORDER BY [p].[Elevation] DESC


-- 5) Online Store Database

CREATE TABLE [ItemTypes]
(
    [ItemTypeID] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Items]
(
    [ItemID] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL,
    [ItemTypeID] INT FOREIGN KEY REFERENCES [ItemTypes]([ItemTypeID]) NOT NULL
)


CREATE TABLE [Cities]
(
    [CityID] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE [Customers]
(
    [CustomerID] INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(50) NOT NULL,
    [Birthday] DATETIME2,                      -- DATE
    [CityID] INT FOREIGN KEY REFERENCES [Cities]([CityID]) NOT NULL
)


CREATE TABLE [Orders]
(
    [OrderID] INT PRIMARY KEY IDENTITY,
    [CustomerID] INT FOREIGN KEY REFERENCES [Customers]([CustomerID]) NOT NULL
)


CREATE TABLE [OrderItems]
(
    [OrderID] INT FOREIGN KEY REFERENCES [Orders]([OrderID]) NOT NULL,
    [ItemID] INT FOREIGN KEY REFERENCES [Items]([ItemID]) NOT NULL,
    PRIMARY KEY ([OrderID], [ItemID])
)