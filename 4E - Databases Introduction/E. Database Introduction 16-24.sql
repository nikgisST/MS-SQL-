
--16)Create SoftUni Database

CREATE DATABASE SoftUni

USE [SoftUni]

CREATE TABLE [Towns]
(
	[Id] INT IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Addresses]
(
	[Id] INT IDENTITY NOT NULL,
	[AddressText] NVARCHAR(50) NOT NULL,
	[TownId] INT NOT NULL
)

CREATE TABLE [Departments]
(
	[Id] INT IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)


CREATE TABLE [Employees]
(
	[Id] INT IDENTITY NOT NULL,
	[FirstName] NVARCHAR(50) NOT NULL,
	[MiddleName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[JobTitle] NVARCHAR(50) NOT NULL,
	[DepartmentId] INT NOT NULL,
	[HireDate] DATE NOT NULL,
	[Salary] DECIMAL(6, 2) NOT NULL,
	[AddressId] INT
)

ALTER TABLE [Towns]
	ADD CONSTRAINT PK_Towns
	PRIMARY KEY (Id)

ALTER TABLE [Addresses]
	ADD CONSTRAINT PK_Addresses
	PRIMARY KEY (Id)

ALTER TABLE [Addresses]
	ADD CONSTRAINT FK_Addresses
	FOREIGN KEY (TownId) REFERENCES [Towns](Id) 

ALTER TABLE [Departments]
	ADD CONSTRAINT PK_Departments
	PRIMARY KEY (Id)

ALTER TABLE [Employees]
	ADD CONSTRAINT PK_Employees
	PRIMARY KEY (Id)

ALTER TABLE [Employees]
	ADD CONSTRAINT FK_Employees
	FOREIGN KEY (DepartmentId) REFERENCES [Departments](Id)

ALTER TABLE [Employees]
	ADD CONSTRAINT FK_Employees_Address
	FOREIGN KEY (AddressId) REFERENCES [Addresses](Id)

.........................................................



--16)Create SoftUni Database vtori variant


CREATE DATABASE SoftUni

USE SoftUni

CREATE TABLE Towns
(
	Id INT IDENTITY(1,1),
	[Name] NVARCHAR(50) NOT NULL
);

CREATE TABLE Addresses
(
	Id INT IDENTITY(1,1),
	AddressText NVARCHAR(50) NOT NULL,
	TownId INT NOT NULL     -- TownId INT FOREIGN KEY REFERENCES Towns(Id) NOT NULL
);  

CREATE TABLE Departments
(
	Id INT IDENTITY(1,1),
	[Name] NVARCHAR(50) NOT NULL
)


CREATE TABLE Employees
(
	Id INT IDENTITY(1,1),
	FirstName NVARCHAR(50) NOT NULL,
	MiddleName NVARCHAR(50),
	LastName NVARCHAR(50) NOT NULL,
	JobTitle NVARCHAR(20) NOT NULL,
	DepartmentId INT NOT NULL,     -- DepartmentId INT FOREIGN KEY REFERENCES Departments(Id)
	HireDate DATE,
	Salary DECIMAL(5, 2) NOT NULL,
	AddressId INT NOT NULL          -- AddressID INT FOREIGN KEY REFERENCES Addresses(Id)
)

ALTER TABLE Towns
	ADD CONSTRAINT PK_Towns
	PRIMARY KEY (Id)

ALTER TABLE Addresses
	ADD CONSTRAINT PK_Addresses
	PRIMARY KEY (Id)

ALTER TABLE Addresses
	ADD CONSTRAINT FK_Addresses
	FOREIGN KEY (TownId) REFERENCES [Towns](Id)        -- ADD  FOREIGN KEY (TownId) REFERENCES [Towns](Id) 


ALTER TABLE Departments
	ADD CONSTRAINT PK_Departments
	PRIMARY KEY (Id)

ALTER TABLE Employees
	ADD CONSTRAINT PK_Employees
	PRIMARY KEY (Id)

ALTER TABLE Employees
	ADD CONSTRAINT FK_Employees
	FOREIGN KEY (DepartmentId) REFERENCES [Departments](Id)     -- ADD  FOREIGN KEY (DepartmentId) REFERENCES [Departments](Id) 

ALTER TABLE Employees
	ADD CONSTRAINT FK_Employees_Address
	FOREIGN KEY (AddressId) REFERENCES [Addresses](Id)   -- ADD  FOREIGN KEY (AddressId) REFERENCES [Addresses](Id) 




.........................................................





--17)Backup Database

USE [master]

BACKUP DATABASE [SoftUni]
	TO DISK = N'C:\Program Files\Microsoft SQL Server\Backup\SoftUniDB.bak' 

GO

DROP DATABASE [SoftUni]

GO

RESTORE DATABASE [SoftUni] 
	FROM DISK = N'C:\Program Files\Microsoft SQL Server\Backup\SoftUniDB.bak'




.....................................................

 



--18)Basic Insert

USE [SoftUni]

INSERT INTO [Towns] VALUES
	('Sofia'),
	('Plovdiv'),
	('Varna'),
	('Burgas')

INSERT INTO [Departments] VALUES
	('Engineering'),
	('Sales'),
	('Marketing'),
	('Software Development'),
	('Quality Assurance')

INSERT INTO [Addresses] VALUES
	('Default entry', 1)

INSERT INTO [Employees] VALUES
	('Ivan', 'Ivanov', 'Ivanov', '.NET Developer',4,'2013-02-01',3500.00,1),
	('Petar','Petrov','Petrov','Senior Engineer',1,'2004-03-02',4000.00,1),
	('Maria', 'Petrova', 'Ivanova', 'Intern',5, '2016-08-28', 525.25,1),
	('Georgi','Teziev','Ivanov','CEO',2,'2007-12-09',3000.00,1),
	('Peter','Pan','Pan','Intern',3,'2016-08-28',599.88,1)


...................................................




--18)Basic Insert - VTORI VARIANT

USE [SoftUni]

INSERT INTO Towns VALUES(
	'Sofia',
	'Plovdiv',
	'Varna',
	'Burgas'
);

INSERT INTO Departments VALUES(
	'Engineering',
	'Sales',
	'Marketing',
	'Software Development',
	'Quality Assurance'
);

INSERT INTO Employees VALUES(
	'Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '02-1-2013', 3500.00,
	'Petar','Petrov','Petrov','Senior Engineer', 1, '3-02-2004', 4000.00,
	'Maria', 'Petrova', 'Ivanova', 'Intern', 5, '8-28-2016', 525.25,
	'Georgi','Teziev','Ivanov','CEO', 2, '12-9-2007', 3000.00,
	'Peter','Pan','Pan','Intern', 3,' 08-28-2016', 599.88
);


......................................................





--19)Basic Select All Fields

SELECT * FROM [Towns]

SELECT * FROM [Departments]

SELECT * FROM [Employees]



................................



--20)Basic Select All Fields and Order Them

SELECT * FROM [Towns]	
	ORDER BY [Name]   -- asc == alphabetically

SELECT * FROM [Departments]	
	ORDER BY [Name]    -- asc == alphabetically

SELECT * FROM [Employees]
	ORDER BY [Salary] DESC



..................................

 


--21)Basic Select Some Fields

SELECT [Name] FROM [Towns]
	ORDER BY [Name]

SELECT [Name] FROM [Departments]	
	ORDER BY [Name]

SELECT [FirstName], [LastName], [JobTitle], [Salary] FROM [Employees]
	ORDER BY [Salary] DESC



....................................



--22)Increase Employees Salary

UPDATE [Employees]
	SET [Salary] *= 1.1

SELECT [Salary] FROM [Employees]



..........................................................




--23)Decrease Tax Rate

USE [Hotel]

UPDATE [Payments]
	SET [TaxRate] -= 0.03

SELECT [Taxrate] FROM [Payments]




.................................................



--24)Delete All Records

DELETE [Occupancies]
