
-- 15. Hotel Database
 
CREATE DATABASE [Hotel]
GO
 
USE [Hotel]
GO
 
CREATE TABLE Employees
(
    Id INT IDENTITY PRIMARY KEY
    , FirstName VARCHAR(50) NOT NULL
    , LastName VARCHAR(50) NOT NULL
    , Title NVARCHAR(30) NOT NULL
    , Notes NVARCHAR(MAX)
)
 
INSERT INTO [Employees]
VALUES
    ('Gosho', 'Petkanov', 'Shefche', NULL),
    ('Milko', 'Dimitrichkov', 'Debilche', NULL),
    ('Bate', 'Toni', 'SoftUniTO', 'Pichaga :D')
 
CREATE TABLE Customers
(
    Id INT IDENTITY(1,1) 
    , AccountNumber NVARCHAR(20) NOT NULL PRIMARY KEY
    , FirstName VARCHAR(50) NOT NULL
    , LastName VARCHAR(50) NOT NULL
    , PhoneNumber INT NOT NULL
    , EmergencyName VARCHAR(50) NOT NULL
    , EmergencyPhone INT NOT NULL
    , Notes NVARCHAR(MAX)
)
 
INSERT INTO [Customers]
VALUES
    ('ahdahdahdha', 'Gosho', 'Petkov', 2313, 'Grisho', 13719478, NULL),
    ('jdkljgoru', 'Ivan', 'Draganov', 14141, 'Petko', 123214515, NULL),
    ('tewtwr', 'Petkan', 'Ivanov', 25255, 'Zayo', 1423, NULL)
 
CREATE TABLE RoomStatus
(
    RoomStatus VARCHAR(50) NOT NULL PRIMARY KEY
    , Notes NVARCHAR(MAX)
)
 
INSERT INTO [RoomStatus]
VALUES
    ('Occupied', NULL),
    ('Free', NULL),
    ('Reserved', NULL)
 
CREATE TABLE RoomTypes
(
    RoomType VARCHAR(50) NOT NULL PRIMARY KEY
    , Notes NVARCHAR(MAX)
)
 
INSERT INTO [RoomTypes]
VALUES
    ('Double', NULL),
    ('Single', NULL),
    ('Apartment', NULL)
 
CREATE TABLE BedTypes
(
    BedType VARCHAR(50) NOT NULL PRIMARY KEY
    , Notes NVARCHAR(MAX)
)
 
INSERT INTO [BedTypes]
VALUES
    ('King Size', NULL),
    ('Single Bed', NULL),
    ('Double Bed', NULL)
 
CREATE TABLE Rooms
(
    RoomNumber INT NOT NULL PRIMARY KEY IDENTITY
    , RoomType VARCHAR(50) FOREIGN KEY REFERENCES [RoomTypes](RoomType) NOT NULL
    , BedType VARCHAR(50) FOREIGN KEY REFERENCES [BedTypes](BedType) NOT NULL
    , Rate INT NOT NULL
    , RoomStatus VARCHAR(50) FOREIGN KEY REFERENCES [RoomStatus](RoomStatus) NOT NULL
    , Notes NVARCHAR(MAX)
)
 
INSERT INTO [Rooms]
VALUES
    ('Double', 'King Size', 5, 'Free', NULL),
    ('Single', 'Single Bed', 2, 'Reserved', NULL),
    ('Apartment', 'Double Bed', 7, 'Occupied', NULL)
 
CREATE TABLE Payments
(
    Id INT IDENTITY PRIMARY KEY NOT NULL
    , EmployeeId INT FOREIGN KEY REFERENCES [Employees](Id) NOT NULL
    , PaymentDate DATE NOT NULL
    , AccountNumber NVARCHAR(20) FOREIGN KEY REFERENCES [Customers](AccountNumber) NOT NULL
    , FirstDateOccupied DATE NOT NULL
    , LastDateOccupied DATE NOT NULL
    , TotalDays INT NOT NULL
    , AmountCharged DECIMAL(18,2) NOT NULL
    , TaxRate DECIMAL(18,2) NOT NULL
    , TaxAmount DECIMAL(18,2) NOT NULL
    , PaymentTotal DECIMAL(18,2) NOT NULL
    , Notes NVARCHAR(MAX)
)
 
INSERT INTO [Payments]
VALUES
    (1, '2023-01-01', 'ahdahdahdha', '2023-01-02', '2023-01-05', 4, 100.0, 20.0, 50.0, 1000.0, NULL),
    (2, '2023-01-01', 'jdkljgoru', '2023-01-02', '2023-01-05', 4, 100.0, 20.0, 50.0, 1000.0, NULL),
    (3, '2023-01-01', 'tewtwr', '2023-01-02', '2023-01-05', 4, 100.0, 20.0, 50.0, 1000.0, NULL)
 
CREATE TABLE Occupancies(
    Id INT IDENTITY PRIMARY KEY NOT NULL
    , EmployeeId INT FOREIGN KEY REFERENCES [Employees](Id) NOT NULL
    , DateOccupied DATE NOT NULL
    , AccountNumber NVARCHAR(20) FOREIGN KEY REFERENCES [Customers](AccountNumber) NOT NULL
    , RoomNumber INT FOREIGN KEY REFERENCES [Rooms](RoomNumber) NOT NULL
    , RateApplied DECIMAL(18,2) NOT NULL
    , PhoneCharge DECIMAL(18,2) NOT NULL
    , Notes NVARCHAR(MAX)
)
 
INSERT INTO [Occupancies]
VALUES
(1,'2023-01-01', 'ahdahdahdha', 1, 20.0, 10.0, NULL),
(2,'2023-01-01', 'jdkljgoru', 2, 20.0, 10.0, NULL),
(3,'2023-01-01', 'tewtwr', 3, 20.0, 10.0, NULL)



.....................................................................





​
CREATE TABLE [Employees]
(
	 [Id] [INT] IDENTITY (1,1) NOT NULL
	,[FirstName] [NVARCHAR](150) NOT NULL
	,[LastName] [NVARCHAR](150) NOT NULL
	,[Title] [NVARCHAR](100) NOT NULL
	,[Notes] [NVARCHAR](MAX)
	,CONSTRAINT PK_EmployeesId PRIMARY KEY(Id)
);
​
INSERT INTO [Employees] (FirstName, LastName, Title)
VALUES
	 ('Niki', 'Germanov', 'Front Office Manager')
	,('Anton', 'Galabov', 'Housekeeping Manager')
	,('Jones', 'Jamison', 'Restaurant Manager')
​
--Customers (AccountNumber, FirstName, LastName, PhoneNumber, EmergencyName, EmergencyNumber, Notes)
​
CREATE TABLE [Customers]
(
	 [AccountNumber] [INT] IDENTITY (1,1) NOT NULL
	,[FirstName] [NVARCHAR](150) NOT NULL
	,[LastName] [NVARCHAR](150) NOT NULL
	,[PhoneNumber] [NVARCHAR](15) NOT NULL
	,[EmergencyName] [NVARCHAR](150) NOT NULL
	,[EmergencyPhone] [NVARCHAR](15) NOT NULL
	,[Notes] [NVARCHAR](MAX)
	,CONSTRAINT PK_CustomersId PRIMARY KEY(AccountNumber)
);
​
INSERT INTO Customers(FirstName, LastName, PhoneNumber, EmergencyName, EmergencyPhone)
VALUES
	 ('sadsad', 'asdsda', '0895463786', 'asdsad', '0896155233')
	,('dfdf', 'asdsad', '0896433675', 'asdad', '0896542596')
	,('Nisadsadki', 'asdsad', '0896488244', 'sadsad', '9811023532')
​
--RoomStatus (RoomStatus, Notes)
​
CREATE TABLE [RoomStatus]
(
	 RoomStatus [NVARCHAR](100) NOT NULL
	,Notes [NVARCHAR](MAX)
);
​
INSERT INTO [RoomStatus] (RoomStatus)
VALUES
	('Available')
   ,('Unavailable')
   ,('OOO - Out of Order')
​
CREATE TABLE [RoomTypes]
(
	 RoomType [NVARCHAR](100) NOT NULL
	,Notes [NVARCHAR](MAX)
);
​
INSERT INTO [RoomTypes](RoomType)
VALUES
	('Single')
   ,('Double')
   ,('Suite')
​
CREATE TABLE [BedTypes](
	 BedType [NVARCHAR](50) NOT NULL
	,Notes [NVARCHAR](MAX)
);
​
INSERT INTO BedTypes (BedType)
VALUES
	 ('Double')
	,('Single')
	,('KingSize')
​
CREATE TABLE [Rooms]
(
	 RoomNumber [INT] IDENTITY (1,1) NOT NULL
	,RoomType [NVARCHAR](100) NOT NULL
	,BedType [NVARCHAR](50) NOT NULL
	,Rate [SMALLINT] NOT NULL
	,RoomStatus [NVARCHAR](100) NOT NULL
	,Notes [NVARCHAR](MAX)
	,CONSTRAINT PK_RoomsNumbers PRIMARY KEY(RoomNumber)
);
​
INSERT INTO [Rooms] (RoomType, BedType, Rate, RoomStatus)
VALUES
	 ('Single', 'Single', 8, 'Available')
	,('Double', 'Double', 9, 'Unavaliable')
	,('Suite', 'KingSize', 10, 'Unavaliable')
​
CREATE TABLE [Payments]
(
	 Id [INT] IDENTITY (1,1) NOT NULL
	,EmployeeId [INT] NOT NULL --FK
	,PaymentDate [DATETIME2] NOT NULL
	,AccountNumber [INT] NOT NULL --FK
	,FirstDateOccupied [DATETIME2] NOT NULL
	,LastDateOccupied [DATETIME2] NOT NULL
	,TotalDays [INT] NOT NULL
	,AmountCharged [DEC](15,2) NOT NULL
	,TaxRate [DEC](15,2) NOT NULL
	,TaxAmount [DEC](15,2) NOT NULL
	,PaymentTotal [DEC](15,2) NOT NULL
	,Notes [NVARCHAR](MAX)
	,CONSTRAINT PK_PaymentsId PRIMARY KEY(Id)
	,CONSTRAINT FK_EmployeeId FOREIGN KEY(EmployeeId) REFERENCES Employees(Id)
	,CONSTRAINT FK_AccountNumber FOREIGN KEY(AccountNumber) REFERENCES Customers(AccountNumber)
);
​
INSERT INTO Payments (EmployeeId, PaymentDate, AccountNumber, FirstDateOccupied, LastDateOccupied, TotalDays, AmountCharged, TaxRate, TaxAmount, PaymentTotal)
VALUES
	 (1, GETDATE(), 1, '2023-02-02', '2023-02-07', 5, 100.50, 20, 23, 150)
	,(2, GETDATE(), 2, '2023-02-02', '2023-02-07', 5, 200.60, 20, 23, 250)
	,(3, GETDATE(), 3, '2023-02-02', '2023-02-07', 5, 300.70, 20, 23, 350)
​
CREATE TABLE [Occupancies]
(
	 Id [INT] IDENTITY (1,1) NOT NULL
	,EmployeeId [INT] NOT NULL --FK
	,DateOccupied [DATETIME2] NOT NULL
	,AccountNumber [INT] NOT NULL --FK
	,RoomNumber [INT] NOT NULL --FK
	,RateApplied [SMALLINT] NOT NULL
	,PhoneCharge [DEC](15,2)
	,Notes [NVARCHAR](MAX)
	,CONSTRAINT PK_OccupanciesId PRIMARY KEY(Id)
	,CONSTRAINT FK_EmployeeId2 FOREIGN KEY(EmployeeId) REFERENCES Employees(Id)
	,CONSTRAINT FK_AccountNumber2 FOREIGN KEY(AccountNumber) REFERENCES Customers(AccountNumber)
	,CONSTRAINT FK_RoomNumber FOREIGN KEY(RoomNumber) REFERENCES Rooms(RoomNumber)
);
​
INSERT INTO [Occupancies] (EmployeeId, DateOccupied, AccountNumber, RoomNumber, RateApplied)
VALUES
	 (1, GETDATE(), 1, 1, 5)
	,(2, GETDATE(), 2, 2, 7)
	,(3, GETDATE(), 3, 3, 10)