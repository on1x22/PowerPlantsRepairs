--docker run -e 'ACCEPT_EULA=Y' -e 'MSSQL_SA_PASSWORD=strongPassword123' -p 1433:1433 -v D:/Data/MSSQL/22:/var/opt/mssql/data --name mssql22 -d mcr.microsoft.com/mssql/server:2022-latest

CREATE DATABASE PowerPlantsRepairs;

USE PowerPlantsRepairs;

CREATE TABLE TgkInfo
(
	TgkNumber INT PRIMARY KEY,
	INN BIGINT NOT NULL UNIQUE CHECK (INN BETWEEN 1 AND 9999999999),
	OGRN BIGINT NOT NULL UNIQUE CHECK (OGRN BETWEEN 1 AND 9999999999999)
);

CREATE TABLE RduInfo
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Address VARCHAR(50) NOT NULL,
	Director VARCHAR(50) NOT NULL,
	OduName VARCHAR(20) NOT NULL
);

CREATE TABLE PowerPlants
(
	Okpo BIGINT CHECK (Okpo BETWEEN 1 AND 99999999) PRIMARY KEY,
	Name NVARCHAR(50) NOT NULL,
	Type NVARCHAR(5) NOT NULL CHECK (Type IN (N'ÒÝÖ', N'ÃÒÒÝÖ', N'ÃÝÑ', N'ÃÐÝÑ', N'ÀÝÑ', N'ÃÀÝÑ', N'ÂÝÑ', N'ÑÝÑ')),
	City NVARCHAR(30) NOT NULL,
	TgkNumber INT NOT NULL,
	RduNumber INT NOT NULL,
	CONSTRAINT FK_PowerPlant_TgkInfo FOREIGN KEY (TgkNumber) REFERENCES TgkInfo(TgkNumber),
	CONSTRAINT FK_PowerPlant_RduInfo FOREIGN KEY (RduNumber) REFERENCES RduInfo(Id)
);

ALTER TABLE powerPlants
ALTER COLUMN Name NVARCHAR(50) NOT NULL

ALTER TABLE powerPlants
DROP CONSTRAINT CK__PowerPlant__Type__2739D489;

ALTER TABLE powerPlants
ALTER COLUMN Type NVARCHAR(5) NOT NULL

ALTER TABLE powerPlants
ALTER COLUMN City NVARCHAR(30) NOT NULL

ALTER TABLE powerPlants
ADD CHECK (Type IN (N'ÒÝÖ', N'ÃÒÒÝÖ', N'ÃÝÑ', N'ÃÐÝÑ', N'ÀÝÑ', N'ÃÀÝÑ', N'ÂÝÑ', N'ÑÝÑ'))

CREATE TABLE CableInfo
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	CableType NVARCHAR(15) NOT NULL UNIQUE,
	SechenieNom DECIMAL(5,2) NOT NULL,
	SechenieOsnChasti DECIMAL(5,2) NOT NULL,
	SechenieSerdechnika DECIMAL(5,2) NOT NULL,
	DiametrNaruzh DECIMAL(5,2) NOT NULL,
	R0 DECIMAL(5,4) NOT NULL,
	UsilieRazriva DECIMAL(10,2) NOT NULL,
	Weight DECIMAL(7,3) NOT NULL
);

ALTER TABLE CableInfo
ALTER COLUMN CableType NVARCHAR(15) NOT NULL

ALTER TABLE CableInfo
DROP CONSTRAINT UQ__CableInf__57437BF819084758;

ALTER TABLE CableInfo
ADD CONSTRAINT UQ__CableInf__57437BF819084758 UNIQUE (CableType)

CREATE TABLE LineInfo
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Name VARCHAR(50) NOT NULL,
	ParallelLines INT NOT NULL,
	LineType VARCHAR(3) NOT NULL CHECK (LineType IN ('ÂË', 'ÊË', 'ÊÂË')),
	CableId INT NOT NULL,
	BaseVoltage DECIMAL(5,2) NOT NULL,
	Length DECIMAL(7,3) NOT NULL,
	MaintenanceCompany INT NOT NULL CHECK (MaintenanceCompany BETWEEN 1 AND 9999999999)
	CONSTRAINT FK_LineInfo_CableInfo FOREIGN KEY (CableId) REFERENCES CableInfo(Id)
);

CREATE TABLE LineConectionInfo
(
	PlantOkpo BIGINT,
	LineId INT,
	CONSTRAINT PK_LineConnectionInfo_PlantOkpoLineId PRIMARY KEY CLUSTERED (PlantOkpo, LineId),
	CONSTRAINT FK_LineConnectionInfo_PowerPlant FOREIGN KEY (PlantOkpo) REFERENCES PowerPlants(Okpo),
	CONSTRAINT FK_LineConnectionInfo_LineInfo FOREIGN KEY (LineId) REFERENCES LineInfo(Id)
);

CREATE TABLE RepairInfo
(
	Id INT IDENTITY(1,1) PRIMARY KEY,
	Description VARCHAR(11) NOT NULL
);

ALTER TABLE RepairInfo
ALTER COLUMN Description NVARCHAR(11) NOT NULL

CREATE TABLE AuxiliaryEquipmentRepairs
(
	PlantOkpo BIGINT NOT NULL,
	Building VARCHAR(30) NOT NULL,
	Equipment VARCHAR(30) NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	RepairType INT NOT NULL,
	Cost MONEY NOT NULL,
	ContractorInn BIGINT NOT NULL CHECK (ContractorInn BETWEEN 1 AND 9999999999),
	Description VARCHAR(300) NULL,
	CHECK (EndDate >= StartDate),
	CONSTRAINT PK_AuxiliaryEquipmentRepairs PRIMARY KEY CLUSTERED (PlantOkpo, Building, Equipment, StartDate),
	CONSTRAINT FK_AuxiliaryEquipmentRepair_PowerPlant FOREIGN KEY (PlantOkpo) REFERENCES PowerPlants(Okpo),
	CONSTRAINT FK_AuxiliaryEquipmentRepair_RepairInfo FOREIGN KEY (RepairType) REFERENCES RepairInfo(Id),
	CONSTRAINT FK_AuxiliaryEquipmentRepair_ContractorInfo FOREIGN KEY (ContractorInn) REFERENCES ContractorInfo(Inn)
);

CREATE TABLE MainEquipment
(
	EquipmentType VARCHAR(30) PRIMARY KEY,
	Equipment VARCHAR(30) NOT NULL,
	NominalHeatingOutput DECIMAL(7,2) NULL CHECK (NominalHeatingOutput >= 0),
	NominalPower DECIMAL(6,2) NULL CHECK (NominalPower >= 0)
);

CREATE TABLE ContractorInfo
(
	Inn BIGINT NOT NULL PRIMARY KEY CHECK (Inn BETWEEN 1 AND 9999999999),
	Name NVARCHAR(40) NOT NULL,
	FoundingDate DATE NOT NULL,
	OrganisationForm NVARCHAR(3) NOT NULL CHECK (OrganisationForm IN ('ÏÀÎ', 'ÀÎ', 'ÎÎÎ')),
	Address NVARCHAR(60) NOT NULL
);

ALTER TABLE ContractorInfo
--ALTER COLUMN Name NVARCHAR(40) NOT NULL
--ALTER COLUMN Address NVARCHAR(60) NOT NULL
--ALTER COLUMN OrganisationForm NVARCHAR(3) NOT NULL
ADD CHECK (OrganisationForm IN (N'ÏÀÎ', N'ÀÎ', N'ÎÎÎ'))

ALTER TABLE ContractorInfo
DROP CONSTRAINT CK__Contracto__Organ__3A4CA8FD


CREATE TABLE MainEquipmentRepairs
(
	PlantOkpo BIGINT,
	EquipmentType VARCHAR(30) NOT NULL,
	StationNumber VARCHAR(5) NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	RepairType INT NOT NULL,
	Cost MONEY NOT NULL,
	ContractorInn BIGINT NOT NULL CHECK (ContractorInn BETWEEN 1 AND 9999999999),
	Description VARCHAR(300) NULL,
	CHECK (EndDate >= StartDate),
	CONSTRAINT PK_MainEquipmentRepairs PRIMARY KEY CLUSTERED (PlantOkpo, EquipmentType, StationNumber),
	CONSTRAINT FK_MainEquipmentRepairs_MainEquipment FOREIGN KEY (EquipmentType) REFERENCES MainEquipment(EquipmentType),
	CONSTRAINT FK_MainEquipmentRepairs_ContarctorInfo FOREIGN KEY (ContractorInn) REFERENCES ContractorInfo(Inn),
	CONSTRAINT FK_MainEquipmentRepairs_PowerPlant FOREIGN KEY (PlantOkpo) REFERENCES PowerPlants(Okpo),
	CONSTRAINT FK_MainEquipmentRepairs_RepairInfo FOREIGN KEY (RepairType) REFERENCES RepairInfo(Id)
);
