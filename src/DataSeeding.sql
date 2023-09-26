CREATE PROCEDURE InsertLines 
@Quantity INT
AS
DECLARE @LineType NVARCHAR(3),
		@StartObject NVARCHAR(50), 
		@EndObject NVARCHAR(50), 
		@LineName NVARCHAR(107),
		@LinesCount INT,
		@CableTypeId INT,
		@BaseVoltage DECIMAL(5,2),
		@Length DECIMAL(7,3),
		@MaintenanceCompany BIGINT,
		@PlantOkpo BIGINT,
		@Iteration INT

SET @Iteration = 1;

WHILE @Iteration <= @Quantity
BEGIN	
	SET @LineType = (SELECT TOP 1 Type 
						FROM LineTypeInfo
						ORDER BY NEWID());

	SELECT TOP 1 @StartObject = Name, 
				 @PlantOkpo = Okpo
				 FROM PowerPlants
				 ORDER BY NEWID();

	SET @EndObject = (SELECT TOP 1 Name 
						FROM PowerPlants
						ORDER BY NEWID());

	SET @LineName = CONCAT(@Linetype, ' ', @StartObject, ' - ', @EndObject);

	SET @LinesCount = (SELECT ABS(CHECKSUM(NewId()) % 3) + 1);

	SET @CableTypeId = (SELECT TOP 1 Id 
						FROM CableInfo
						ORDER BY NEWID());

	SET @BaseVoltage = (SELECT TOP 1 BaseVoltage
						FROM VoltageInfo
						ORDER BY NEWID());

	SET @Length = (SELECT ABS(CHECKSUM(NewId())) % 100);

	SET @MaintenanceCompany = (SELECT CAST(ABS(CHECKSUM(NewId())) AS bigint));

	INSERT INTO Lines VALUES
	(@LineName, @LinesCount, @LineType, @CableTypeId, @BaseVoltage, @Length, @MaintenanceCompany, @PlantOkpo);
	
	SET @Iteration = @Iteration + 1;
END
GO

CREATE PROCEDURE GetNewDate
@NewDate DATE OUTPUT
AS
	DECLARE @FromDate DATE = '1990-01-01';
	DECLARE @ToDate DATE = '2035-12-31';

    SET @NewDate = (SELECT DATEADD(DAY, RAND(CHECKSUM(NEWID()))*(1+DATEDIFF(DAY, @FromDate, @ToDate)), @FromDate));
GO

CREATE PROCEDURE InsertMainEquipmentRepairs
@Quantity INT
AS
DECLARE @PlantOkpo BIGINT, 
		@EquipmentType NVARCHAR(30),
		@StationNumber NVARCHAR(5),
		@StartDate DATE,
		@EndDate DATE,
		@RepairType INT,
		@Cost MONEY,
		@ContractorInn BIGINT,
		@Iteration INT

SET @Iteration = 1;

WHILE @Iteration <= @Quantity
BEGIN
	SET @PlantOkpo = (SELECT TOP 1 OKPO 
						FROM PowerPlants
						ORDER BY NEWID());

	SET @EquipmentType = (SELECT TOP 1 EquipmentType 
							FROM MainEquipment
							ORDER BY NEWID());

	SET @StationNumber = (SELECT TOP 1 StationNumber 
							FROM StationNumbers
							ORDER BY NEWID());
	
	DECLARE @FirstDate DATE;
	DECLARE @SecondDate DATE;

	EXEC GetNewDate @FirstDate OUTPUT;
	EXEC GetNewDate @SecondDate OUTPUT;

	IF @SecondDate >= @FirstDate
	BEGIN
		SET @StartDate = @FirstDate;
		SET @EndDate = @SecondDate;
	END
	ELSE
	BEGIN
		SET @StartDate = @SecondDate;
		SET @EndDate = @FirstDate;
	END

	SET @RepairType = (SELECT TOP 1 Id 
						FROM RepairInfo
						ORDER BY NEWID());

	SET @Cost = ABS(CHECKSUM(NEWID())) % 1000000;
		
	SET @ContractorInn = (SELECT TOP 1 Inn 
							FROM ContractorInfo
							ORDER BY NEWID());

	INSERT INTO MainEquipmentRepairs (PlantOkpo, EquipmentType, StationNumber, StartDate, EndDate, RepairType, Cost, ContractorInn) VALUES
	(@PlantOkpo, @EquipmentType, @StationNumber, @StartDate, @EndDate, @RepairType, @Cost, @ContractorInn);

	SET @Iteration = @Iteration + 1;
END
GO


CREATE PROCEDURE InsertAuxilaryEquipmentRepairs
@Quantity INT
AS
DECLARE @PlantOkpo BIGINT, 
		@Building NVARCHAR(30),
		@Equipment NVARCHAR(30),
		@StartDate DATE,
		@EndDate DATE,
		@RepairType INT,
		@Cost MONEY,
		@ContractorInn BIGINT,
		@Iteration INT

SET @Iteration = 1;

WHILE @Iteration <= @Quantity
BEGIN
	SET @PlantOkpo = (SELECT TOP 1 OKPO 
						FROM PowerPlants
						ORDER BY NEWID());

	SET @Building = (SELECT TOP 1 Building
							FROM Buildings
							ORDER BY NEWID());

	SET @Equipment = (SELECT TOP 1 Equipment 
							FROM AuxilaryEquipment
							ORDER BY NEWID());
	
	DECLARE @FirstDate DATE;
	DECLARE @SecondDate DATE;

	EXEC GetNewDate @FirstDate OUTPUT;
	EXEC GetNewDate @SecondDate OUTPUT;

	IF @SecondDate >= @FirstDate
	BEGIN
		SET @StartDate = @FirstDate;
		SET @EndDate = @SecondDate;
	END
	ELSE
	BEGIN
		SET @StartDate = @SecondDate;
		SET @EndDate = @FirstDate;
	END

	SET @RepairType = (SELECT TOP 1 Id 
						FROM RepairInfo
						ORDER BY NEWID());

	SET @Cost = ABS(CHECKSUM(NEWID())) % 1000000;
		
	SET @ContractorInn = (SELECT TOP 1 Inn 
							FROM ContractorInfo
							ORDER BY NEWID());

	INSERT INTO AuxiliaryEquipmentRepairs (PlantOkpo, Building, Equipment, StartDate, EndDate, RepairType, Cost, ContractorInn) VALUES
	(@PlantOkpo, @Building, @Equipment, @StartDate, @EndDate, @RepairType, @Cost, @ContractorInn);

	SET @Iteration = @Iteration + 1;
END
GO