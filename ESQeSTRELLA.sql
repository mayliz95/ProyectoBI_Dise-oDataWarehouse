CREATE DATABASE ECUAVINOS_DW
USE ECUAVINOS_DW

DROP VIEW VIEWDimCliente
CREATE VIEW ViewDimCliente AS  
SELECT  CLIENTEID, NOMBRE, TIPO FROM SistVentasComerciantesEcuavinos.DBO.cliente

DROP VIEW VIEWDIMPRODUCTO
CREATE VIEW ViewDimProducto AS
select CONCAT(PSCE.PRODUCTOID,PSCE.AÑO) PRODUCTID, PSE.CODIGO, 
PSCE.DESCRIPCION,HSP.COSTOPORDOCENA,PSCE.PRECIOUNIDAD_DOCENA ,PSE.GRUPO
from SistVentasComerciantesEcuavinos.dbo.PRODUCTO PSCE,
SistemaProduccionEcuavinos.dbo.PRODUCTO PSE,
SistemaProduccionEcuavinos.DBO.HISTORIALPRODUCCION HSP
WHERE (PSCE.PRODUCTOID = CONCAT('P',PSE.CODIGO)) AND (HSP.AÑO = PSCE.AÑO) AND (HSP.CODIGO = PSE.CODIGO)

DROP VIEW VIEWDIMMercado
CREATE VIEW ViewDimMercado AS
select * from SistVentasComerciantesEcuavinos.dbo.MERCADO

drop table dbo.dimCliente
drop table dimProducto
drop table dimMercado
SELECT * INTO DimCliente FROM ViewDimCliente
SELECT * INTO DimProducto FROM ViewDimProducto
SELECT * INTO DimMercado FROM ViewDimMercado

set language 'us_english'

drop table dbo.DimDate


CREATE TABLE	[dbo].[DimDate]
	(	[DateKey] INT, 
		[Date] DATETIME primary key,		
		[FullDateUSA] CHAR(10),-- Date in MM-dd-yyyy format
		[DayOfMonth] VARCHAR(2), -- Field will hold day number of Month
		[DaySuffix] VARCHAR(4), -- Apply suffix as 1st, 2nd ,3rd etc
		[DayName] VARCHAR(9), -- Contains name of the day, Sunday, Monday 
		[DayOfWeekUSA] CHAR(1),-- First Day Sunday=1 and Saturday=7		
		[DayOfWeekInMonth] VARCHAR(2), --1st Monday or 2nd Monday in Month
		[DayOfWeekInYear] VARCHAR(2),
		[DayOfQuarter] VARCHAR(3),
		[DayOfYear] VARCHAR(3),
		[WeekOfMonth] VARCHAR(1),-- Week Number of Month 
		[WeekOfQuarter] VARCHAR(2), --Week Number of the Quarter
		[WeekOfYear] VARCHAR(2),--Week Number of the Year
		[Month] VARCHAR(2), --Number of the Month 1 to 12
		[MonthName] VARCHAR(9),--January, February etc
		[MonthOfQuarter] VARCHAR(2),-- Month Number belongs to Quarter
		[Quarter] CHAR(1),
		[QuarterName] VARCHAR(9),--First,Second..
		[Year] CHAR(4),-- Year value of Date stored in Row
		[YearName] CHAR(7), --CY 2012,CY 2013
		[MonthYear] CHAR(10), --Jan-2013,Feb-2013
		[MMYYYY] CHAR(6),
		[FirstDayOfMonth] DATE,
		[LastDayOfMonth] DATE,
		[FirstDayOfQuarter] DATE,
		[LastDayOfQuarter] DATE,
		[FirstDayOfYear] DATE,
		[LastDayOfYear] DATE,
		[IsHolidayUSA] BIT,-- Flag 1=National Holiday, 0-No National Holiday			
		[IsWeekday] BIT,-- 0=Week End ,1=Week Day	
		[IsHolidayEcuador] BIT Null,-- Flag 1=National Holiday, 0-No National Holiday
		[HolidayEcuador] VARCHAR(50) Null,--Name of Holiday in US			
		
	)
GO


/********************************************************************************************/
--Specify Start Date and End date here
--Value of Start Date Must be Less than Your End Date 

DECLARE @StartDate DATETIME = '01/01/2016' --Starting value of Date Range
DECLARE @EndDate DATETIME = '01/01/2018' --End Value of Date Range

--Temporary Variables To Hold the Values During Processing of Each Date of Year
DECLARE
	@DayOfWeekInMonth INT,
	@DayOfWeekInYear INT,
	@DayOfQuarter INT,
	@WeekOfMonth INT,
	@CurrentYear INT,
	@CurrentMonth INT,
	@CurrentQuarter INT

/*Table Data type to store the day of week count for the month and year*/
DECLARE @DayOfWeek TABLE (DOW INT, MonthCount INT, QuarterCount INT, YearCount INT)

INSERT INTO @DayOfWeek VALUES (1, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (2, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (3, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (4, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (5, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (6, 0, 0, 0)
INSERT INTO @DayOfWeek VALUES (7, 0, 0, 0)

--Extract and assign part of Values from Current Date to Variable

DECLARE @CurrentDate AS DATETIME = @StartDate
SET @CurrentMonth = DATEPART(MM, @CurrentDate)
SET @CurrentYear = DATEPART(YY, @CurrentDate)
SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)

/********************************************************************************************/
--Proceed only if Start Date(Current date ) is less than End date you specified above

WHILE @CurrentDate < @EndDate
BEGIN
 
/*Begin day of week logic*/

         /*Check for Change in Month of the Current date if Month changed then 
          Change variable value*/
	IF @CurrentMonth != DATEPART(MM, @CurrentDate) 
	BEGIN
		UPDATE @DayOfWeek
		SET MonthCount = 0
		SET @CurrentMonth = DATEPART(MM, @CurrentDate)
	END

        /* Check for Change in Quarter of the Current date if Quarter changed then change 
         Variable value*/

	IF @CurrentQuarter != DATEPART(QQ, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET QuarterCount = 0
		SET @CurrentQuarter = DATEPART(QQ, @CurrentDate)
	END
       
        /* Check for Change in Year of the Current date if Year changed then change 
         Variable value*/
	

	IF @CurrentYear != DATEPART(YY, @CurrentDate)
	BEGIN
		UPDATE @DayOfWeek
		SET YearCount = 0
		SET @CurrentYear = DATEPART(YY, @CurrentDate)
	END
	
        -- Set values in table data type created above from variables 

	UPDATE @DayOfWeek
	SET 
		MonthCount = MonthCount + 1,
		QuarterCount = QuarterCount + 1,
		YearCount = YearCount + 1
	WHERE DOW = DATEPART(DW, @CurrentDate)

	SELECT
		@DayOfWeekInMonth = MonthCount,
		@DayOfQuarter = QuarterCount,
		@DayOfWeekInYear = YearCount
	FROM @DayOfWeek
	WHERE DOW = DATEPART(DW, @CurrentDate)
	
/*End day of week logic*/


/* Populate Your Dimension Table with values*/
	
	INSERT INTO [dbo].[DimDate]
	SELECT
		
		CONVERT (char(8),@CurrentDate,112) as DateKey,
		@CurrentDate AS Date,		
		CONVERT (char(10),@CurrentDate,101) as FullDateUSA,
		DATEPART(DD, @CurrentDate) AS DayOfMonth,
		--Apply Suffix values like 1st, 2nd 3rd etc..
		CASE 
			WHEN DATEPART(DD,@CurrentDate) IN (11,12,13) THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 1 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'st'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 2 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'nd'
			WHEN RIGHT(DATEPART(DD,@CurrentDate),1) = 3 THEN CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'rd'
			ELSE CAST(DATEPART(DD,@CurrentDate) AS VARCHAR) + 'th' 
			END AS DaySuffix,
		
		DATENAME(DW, @CurrentDate) AS DayName,
		DATEPART(DW, @CurrentDate) AS DayOfWeekUSA,		
		
		@DayOfWeekInMonth AS DayOfWeekInMonth,
		@DayOfWeekInYear AS DayOfWeekInYear,
		@DayOfQuarter AS DayOfQuarter,
		DATEPART(DY, @CurrentDate) AS DayOfYear,
		DATEPART(WW, @CurrentDate) + 1 - DATEPART(WW, CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)) + '/1/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS WeekOfMonth,
		(DATEDIFF(DD, DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0), @CurrentDate) / 7) + 1 AS WeekOfQuarter,
		DATEPART(WW, @CurrentDate) AS WeekOfYear,
		DATEPART(MM, @CurrentDate) AS Month,
		DATENAME(MM, @CurrentDate) AS MonthName,
		CASE
			WHEN DATEPART(MM, @CurrentDate) IN (1, 4, 7, 10) THEN 1
			WHEN DATEPART(MM, @CurrentDate) IN (2, 5, 8, 11) THEN 2
			WHEN DATEPART(MM, @CurrentDate) IN (3, 6, 9, 12) THEN 3
			END AS MonthOfQuarter,
		DATEPART(QQ, @CurrentDate) AS Quarter,
		CASE DATEPART(QQ, @CurrentDate)
			WHEN 1 THEN 'First'
			WHEN 2 THEN 'Second'
			WHEN 3 THEN 'Third'
			WHEN 4 THEN 'Fourth'
			END AS QuarterName,
		DATEPART(YEAR, @CurrentDate) AS Year,
		'CY ' + CONVERT(VARCHAR, DATEPART(YEAR, @CurrentDate)) AS YearName,
		LEFT(DATENAME(MM, @CurrentDate), 3) + '-' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MonthYear,
		RIGHT('0' + CONVERT(VARCHAR, DATEPART(MM, @CurrentDate)),2) + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate)) AS MMYYYY,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, @CurrentDate) - 1), @CurrentDate))) AS FirstDayOfMonth,
		CONVERT(DATETIME, CONVERT(DATE, DATEADD(DD, - (DATEPART(DD, (DATEADD(MM, 1, @CurrentDate)))), DATEADD(MM, 1, @CurrentDate)))) AS LastDayOfMonth,
		DATEADD(QQ, DATEDIFF(QQ, 0, @CurrentDate), 0) AS FirstDayOfQuarter,
		DATEADD(QQ, DATEDIFF(QQ, -1, @CurrentDate), -1) AS LastDayOfQuarter,
		CONVERT(DATETIME, '01/01/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS FirstDayOfYear,
		CONVERT(DATETIME, '12/31/' + CONVERT(VARCHAR, DATEPART(YY, @CurrentDate))) AS LastDayOfYear,
		NULL AS IsHolidayUSA,
		CASE DATEPART(DW, @CurrentDate)
			WHEN 1 THEN 0
			WHEN 2 THEN 1
			WHEN 3 THEN 1
			WHEN 4 THEN 1
			WHEN 5 THEN 1
			WHEN 6 THEN 1
			WHEN 7 THEN 0
			END AS IsWeekday,
		NULL AS HolidayEcuador, null

	SET @CurrentDate = DATEADD(DD, 1, @CurrentDate)
END

	/*Batalla del Pichincha*/
	UPDATE [dbo].[DimDate]
		SET HolidayEcuador = 'Batalla del Pichincha'
	WHERE
		[Month] = 5 
		AND [DayOfMonth] = 24

	/*Independencia del Ecuador*/
	UPDATE [dbo].[DimDate]
		SET HolidayEcuador = 'Independencia de Ecuador'
	WHERE
		[Month] = 8 
		AND [DayOfMonth] = 10

	/*Independencia de Guayaquil*/
	UPDATE [dbo].[DimDate]
		SET HolidayEcuador = 'Independencia de Guayaquil'
	WHERE
		[Month] = 9 
		AND [DayOfMonth] = 9

	/*Dia de los Difuntos*/
	UPDATE [dbo].[DimDate]
		SET HolidayEcuador = 'Dia de los Difuntos'
	WHERE
		[Month] = 11
		AND [DayOfMonth] = 2

	UPDATE [dbo].[DimDate] 
	SET IsHolidayEcuador = CASE WHEN HolidayEcuador IS NULL THEN 0 WHEN HolidayEcuador IS NOT NULL THEN 1 END 

-- FactVinos --
----cantidad de ventas unitarias (x docena), ventas en dolares, costo, utilidad (ventas en dolares - costo)

CREATE VIEW ViewFactVentaProductos AS
select concat(PSCE.PRODUCTOID, PSCE.AÑO) PRODUCTID, C.CLIENTEID, M.MERCADOID, OE.FECHA, 
sum(ODSCE.CANTIDAD_DOCENA) CANTIDAD,
sum(ODSCE.CANTIDAD_DOCENA * PSCE.PRECIOUNIDAD_DOCENA) TOTALMONTOVENTAS,
sum(HSPE.COSTOPORDOCENA * ODSCE.CANTIDAD_DOCENA) COSTOPRODUCCION, 
(sum(ODSCE.CANTIDAD_DOCENA * PSCE.PRECIOUNIDAD_DOCENA) - SUM(HSPE.COSTOPORDOCENA * ODSCE.CANTIDAD_DOCENA)) UTILIDAD
from SistVentasComerciantesEcuavinos.dbo.ORDENDETALLE ODSCE, 
SistVentasComerciantesEcuavinos.dbo.PRODUCTO PSCE, 
SistemaProduccionEcuavinos.dbo.HISTORIALPRODUCCION HSPE, SistVentasComerciantesEcuavinos.dbo.CLIENTE C,
SistVentasComerciantesEcuavinos.DBO.MERCADO M,
SistVentasComerciantesEcuavinos.DBO.ORDENENCABEZADO OE
WHERE C.CLIENTEID = OE.CLIENTEID AND M.MERCADOID= OE.MERCADOID 
AND ODSCE.ORDENID = OE.ORDENID AND ODSCE.PRODUCTOID = PSCE.PRODUCTOID AND PSCE.AÑO = HSPE.AÑO 
AND ODSCE.PRODUCTOID = CONCAT('P',HSPE.CODIGO) AND PSCE.AÑO = ODSCE.AÑO_PRODUC
group by C.CLIENTEID, M.MERCADOID, OE.FECHA, PSCE.PRECIOUNIDAD_DOCENA, HSPE.COSTOPORDOCENA, PSCE.DESCRIPCION, PSCE.AÑO, PSCE.PRODUCTOID

select * into FactVentaProductos from ViewFactVentaProductos

ALTER TABLE DimCliente ADD CONSTRAINT PK_DimCliente PRIMARY KEY CLUSTERED (ClienteID);  
ALTER TABLE DimMercado ADD CONSTRAINT PK_DimMercado PRIMARY KEY CLUSTERED (MercadoID);  
ALTER TABLE DimProducto ADD CONSTRAINT PK_DimProducto PRIMARY KEY CLUSTERED (ProductID);  
ALTER TABLE FactVentaProductos ADD CONSTRAINT PK_FactVentaProductos PRIMARY KEY CLUSTERED (ProductID, clienteid, mercadoid, fecha);  

ALTER TABLE FactVentaProductos ADD CONSTRAINT FK_Producto FOREIGN KEY (ProductID) REFERENCES DimProducto(ProductID);
ALTER TABLE FactVentaProductos ADD CONSTRAINT FK_Cliente FOREIGN KEY (ClienteID) REFERENCES DimCliente(ClienteID);
ALTER TABLE FactVentaProductos ADD CONSTRAINT FK_MErcado FOREIGN KEY (MErcadoID) REFERENCES DimMercado(MercadoID);
ALTER TABLE FactVentaProductos ADD CONSTRAINT FK_Date FOREIGN KEY (fecha) REFERENCES DimDate(Date);



 /* Pruebas --------------------------------------------------
select DimProducto.GRUPO, SUM(VENTASDOLARES) from FactVentaProductos, DimProducto 
where DimProducto.PRODUCTID= FactVentaProductos.PRODUCTID 
group by DimProducto.GRUPO

SELECT * FROM SistVentasComerciantesEcuavinos.DBO.ORDENENCABEZADO
SELECT * FROM SistVentasComerciantesEcuavinos.DBO.ORDENDETALLE
SELECT * FROM DimDate
select * from SistVentasComerciantesEcuavinos.dbo.PRODUCTO PSCE
select * from SistemaProduccionEcuavinos.dbo.HISTORIALPRODUCCION

select PSCE.PRODUCTOID ,PSCE.DESCRIPCION , PSCE.AÑO , sum(ODSCE.CANTIDAD_DOCENA) VENTASUNITARIAS,
PSCE.PRECIOUNIDAD_DOCENA, sum(ODSCE.CANTIDAD_DOCENA * PSCE.PRECIOUNIDAD_DOCENA) VENTASDOLARES, 
HSPE.COSTOPORDOCENA, (sum(ODSCE.CANTIDAD_DOCENA * PSCE.PRECIOUNIDAD_DOCENA) - SUM(HSPE.COSTOPORDOCENA * ODSCE.CANTIDAD_DOCENA)) UTILIDAD
from SistVentasComerciantesEcuavinos.dbo.ORDENDETALLE ODSCE 
join SistVentasComerciantesEcuavinos.dbo.PRODUCTO PSCE  on (ODSCE.PRODUCTOID = PSCE.PRODUCTOID) and (ODSCE.AÑO_PRODUC = PSCE.AÑO)
join SistemaProduccionEcuavinos.dbo.HISTORIALPRODUCCION HSPE on (CONCAT('P',HSPE.CODIGO) = ODSCE.PRODUCTOID) and (HSPE.AÑO = PSCE.AÑO)
group by PSCE.PRECIOUNIDAD_DOCENA, HSPE.COSTOPORDOCENA, PSCE.DESCRIPCION, PSCE.AÑO, PSCE.PRODUCTOID
order by PSCE.PRODUCTOID*/
