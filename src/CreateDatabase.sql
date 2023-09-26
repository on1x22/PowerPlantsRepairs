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

CREATE TABLE Lines
(
	Id INT IDENTITY(1, 1) PRIMARY KEY,
	Name NVARCHAR(50) NOT NULL,
	PlantOkpo BIGINT NOT NULL,
	ParallelLines INT NOT NULL,
	LineType NVARCHAR(3) NOT NULL CHECK (LineType IN ('ÂË', 'ÊË', 'ÊÂË')),
	CableId INT NOT NULL,
	BaseVoltage DECIMAL(5,2) NOT NULL,
	Length DECIMAL(7,3) NOT NULL,
	MaintenanceCompany BIGINT NOT NULL CHECK (MaintenanceCompany BETWEEN 1 AND 9999999999)
	CONSTRAINT FK_LineInfo_CableInfo FOREIGN KEY (CableId) REFERENCES CableInfo(Id),
	CONSTRAINT FK_LineConnectionInfo_PowerPlant FOREIGN KEY (PlantOkpo) REFERENCES PowerPlants(Okpo)
);

CREATE TABLE LineTypeInfo
(
	Type NVARCHAR(3) UNIQUE
);

CREATE TABLE VoltageInfo
(
	BaseVoltage DECIMAL(5,2) NOT NULL
);

CREATE TABLE Lines
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

CREATE TABLE AuxiliaryEquipmentRepairs
(
	PlantOkpo BIGINT NOT NULL,
	Building NVARCHAR(30) NOT NULL,
	Equipment NVARCHAR(30) NOT NULL,
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
	EquipmentType NVARCHAR(30) NOT NULL PRIMARY KEY,
	Equipment NVARCHAR(30) NOT NULL,
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

CREATE TABLE MainEquipmentRepairs
(
	PlantOkpo BIGINT NOT NULL,
	EquipmentType NVARCHAR(30) NOT NULL,
	StationNumber NVARCHAR(5) NOT NULL,
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL,
	RepairType INT NOT NULL,
	Cost MONEY NOT NULL,
	ContractorInn BIGINT NOT NULL CHECK (ContractorInn BETWEEN 1 AND 9999999999),
	Description NVARCHAR(300) NULL,
	CHECK (EndDate >= StartDate),
	CONSTRAINT PK_MainEquipmentRepairs PRIMARY KEY CLUSTERED (PlantOkpo, EquipmentType, StationNumber),
	CONSTRAINT FK_MainEquipmentRepairs_MainEquipment FOREIGN KEY (EquipmentType) REFERENCES MainEquipment(EquipmentType),
	CONSTRAINT FK_MainEquipmentRepairs_ContarctorInfo FOREIGN KEY (ContractorInn) REFERENCES ContractorInfo(Inn),
	CONSTRAINT FK_MainEquipmentRepairs_PowerPlant FOREIGN KEY (PlantOkpo) REFERENCES PowerPlants(Okpo),
	CONSTRAINT FK_MainEquipmentRepairs_RepairInfo FOREIGN KEY (RepairType) REFERENCES RepairInfo(Id)
);

CREATE TABLE StationNumbers
(
	StationNumber NVARCHAR(5) UNIQUE
);

CREATE TABLE Buildings
(
	Building NVARCHAR(30) UNIQUE
);

CREATE TABLE AuxilaryEquipment
(
	Equipment NVARCHAR(30) NOT NULL 
);