CREATE DATABASE SistemaProduccionEcuavinos

DROP TABLE PRODUCTO

CREATE TABLE PRODUCTO (
    CODIGO VARCHAR(5) NOT NULL PRIMARY KEY,
    DESCRIPCION VARCHAR(30),
    GRUPO VARCHAR(10)   
);

DROP TABLE HISTORIALPRODUCCION

CREATE TABLE HISTORIALPRODUCCION (
    CODIGO VARCHAR(5) NOT NULL,
    DESCRIPCION VARCHAR(30),
    A�O INTEGER NOT NULL,   
	VOLUMENDEPRODUCCION INTEGER,
	COSTOPORDOCENA DECIMAL(5,2),
	CONSTRAINT FK_PROD_HISTORIAL FOREIGN KEY (CODIGO) REFERENCES PRODUCTO (CODIGO),  
);

ALTER TABLE HISTORIALPRODUCCION ADD CONSTRAINT PK_HISTORIALPRODUCCION PRIMARY KEY (CODIGO,A�O)


----------------------- BASE DE SISTEMA DE VENTAS COMERCIANTES -------------------------------
DROP DATABASE SistVentasComerciantesEcuavinos
CREATE DATABASE SistVentasComerciantesEcuavinos

CREATE TABLE CLIENTE (
    CLIENTEID VARCHAR(5) NOT NULL PRIMARY KEY,
    NOMBRE VARCHAR(30),
    DIRECCION VARCHAR(50),
	CODIGOPOSTAL VARCHAR(10),
	TIPO VARCHAR (30)
);

CREATE TABLE PRODUCTO (
    PRODUCTOID VARCHAR(6) NOT NULL,
	A�O INTEGER  NOT NULL,
    DESCRIPCION VARCHAR(30),
    PRECIOUNIDAD_DOCENA DECIMAL(5,2)	
);

ALTER TABLE PRODUCTO ADD CONSTRAINT PK_PRODUCTO PRIMARY KEY (PRODUCTOID,A�O)

DROP TABLE MERCADO
CREATE TABLE MERCADO(
    MERCADOID INTEGER NOT NULL PRIMARY KEY,
    NOMBRE VARCHAR(20)
);

CREATE TABLE ORDENENCABEZADO(
	ORDENID VARCHAR(5) NOT NULL PRIMARY KEY,
    CLIENTEID VARCHAR(5),
    FECHA DATETIME,
	DIRECCIONENTREGA VARCHAR(30),
	MERCADOID INTEGER,	
	CONSTRAINT FK_ENCABEZADO_MERCADO FOREIGN KEY(MERCADOID) REFERENCES MERCADO(MERCADOID),
	CONSTRAINT FK_ENCABEZADO_CLIENTE FOREIGN KEY(CLIENTEID) REFERENCES CLIENTE(CLIENTEID),
);

CREATE TABLE ORDENDETALLE(
	ORDDETID INT NOT NULL PRIMARY KEY,
    ORDENID VARCHAR(5),
    PRODUCTOID VARCHAR(6),
	A�O_PRODUC INTEGER,
    CANTIDAD_DOCENA INTEGER,		
	CONSTRAINT FK_ENCABEZADO_DETALLE FOREIGN KEY(ORDENID) REFERENCES ORDENENCABEZADO(ORDENID)
);

ALTER TABLE ORDENDETALLE ADD CONSTRAINT FK_ORDENDETALLE_PRODUCTO 
FOREIGN KEY(PRODUCTOID,A�O_PRODUC) REFERENCES PRODUCTO(PRODUCTOID,A�O)

INSERT INTO PRODUCTO VALUES ('12765', 'McDonell Pinot Noir', 'Red')
INSERT INTO PRODUCTO VALUES ('12766', 'Mornington Pinot Noir', 'Red')
INSERT INTO PRODUCTO VALUES ('12767', 'Downunder Pinot Noir', 'Red')
INSERT INTO PRODUCTO VALUES ('12821', 'Mornington Merlot', 'Red')
INSERT INTO PRODUCTO VALUES ('14821', 'Downunder Merlot', 'Red')
INSERT INTO PRODUCTO VALUES ('14823', 'Mornington Pinot Grigio', 'White')
INSERT INTO PRODUCTO VALUES ('14827', 'Downunder Pinot Grigio', 'White')
INSERT INTO PRODUCTO VALUES ('14829', 'McDonell Pinot Grigio', 'White')
INSERT INTO PRODUCTO VALUES ('13821', 'McDonell Merlot', 'Red')

select * from PRODUCTO

delete HISTORIALPRODUCCION
INSERT INTO HISTORIALPRODUCCION VALUES ('12765', 'McDonell Pinot Noir', 2013, 600, 120)
INSERT INTO HISTORIALPRODUCCION VALUES ('12765', 'McDonell Pinot Noir', 2012, 580, 110)
INSERT INTO HISTORIALPRODUCCION VALUES ('12765', 'McDonell Pinot Noir', 2011, 510, 90)
INSERT INTO HISTORIALPRODUCCION VALUES ('14823', 'Mornington Pinot Grigio', 2013, 400, 70)
INSERT INTO HISTORIALPRODUCCION VALUES ('14823', 'Mornington Pinot Grigio', 2012, 250, 65)
INSERT INTO HISTORIALPRODUCCION VALUES ('12821', 'Mornington Merlot', 2013, 550, 100)
INSERT INTO HISTORIALPRODUCCION VALUES ('12821', 'Mornington Merlot', 2012, 400, 100)
INSERT INTO HISTORIALPRODUCCION VALUES ('12767', 'Downunder Pinot Noir', 2013, 780, 80)
INSERT INTO HISTORIALPRODUCCION VALUES ('12767', 'Downunder Pinot Noir', 2012, 690, 85)
INSERT INTO HISTORIALPRODUCCION VALUES ('14827', 'Downunder Pinot Grigio', 2013, 440, 70)
INSERT INTO HISTORIALPRODUCCION VALUES ('12766', 'Mornington Pinot Noir', 2012, 300, 80)
INSERT INTO HISTORIALPRODUCCION VALUES ('12766', 'Mornington Pinot Noir', 2013, 320, 95)
INSERT INTO HISTORIALPRODUCCION VALUES ('14829', 'McDonell Pinot Grigio', 2012, 500, 110)
INSERT INTO HISTORIALPRODUCCION VALUES ('14829', 'McDonell Pinot Grigio', 2013, 220, 125)
INSERT INTO HISTORIALPRODUCCION VALUES ('13821', 'McDonell Merlot', 2012, 400, 75)
INSERT INTO HISTORIALPRODUCCION VALUES ('13821', 'McDonell Merlot', 2013, 540, 85)
INSERT INTO HISTORIALPRODUCCION VALUES ('14821', 'Downunder Merlot', 2013, 300, 95)
INSERT INTO HISTORIALPRODUCCION VALUES ('14827', 'Downunder Pinot Grigio', 2011, 350, 105)

select * from HISTORIALPRODUCCION
select distinct PRODUCTO.CODIGO, PRODUCTO.DESCRIPCION from HISTORIALPRODUCCION join PRODUCTO on (HISTORIALPRODUCCION.CODIGO = PRODUCTO.CODIGO)

INSERT INTO CLIENTE VALUES ('C478W', 'Prestige Wines', 'Lygon St., Carlton, Melb.', '3053', 'Wholesale')
INSERT INTO CLIENTE VALUES ('C567R', 'Acme Wine Imports', 'High St, Fullham, London','SW6', 'Retail')	
INSERT INTO CLIENTE VALUES ('C121R', 'Oz Wines', 'Little St., Richmond, Melb.','3121', 'Retail')
INSERT INTO CLIENTE VALUES ('C479W', 'The Wine Club', 'Po Box 184, Nth. Melbourne', '3051', 'Wholesale')
INSERT INTO CLIENTE VALUES ('C128R', 'London Wines', 'The Strand, London', 'EC4', 'Retail')
INSERT INTO CLIENTE VALUES ('C342W', 'International Wines', 'PO Box 324, Paris', '75008', 'Wholesale')

INSERT INTO CLIENTE VALUES ('C542W', 'The Wines', 'PO Box 325, Paris', '75003', 'Wholesale')
INSERT INTO CLIENTE VALUES ('C352W', 'Best Wines', '999 Park Avenue, New York', '4831', 'Wholesale')
INSERT INTO CLIENTE VALUES ('C145W', 'Love Wines', 'Jos� Toribio Medina 94, Chile', 'L456', 'Wholesale')
INSERT INTO CLIENTE VALUES ('C576W', 'Ecuador Wines', '6 de diciembre, Quito', 'N506', 'Wholesale')

select * from cliente

INSERT INTO PRODUCTO VALUES ('P12766',2013,'Mornington Pinot Noir', 180)
INSERT INTO PRODUCTO VALUES ('P12766',2012, 'Mornington Pinot Noir', 150)
INSERT INTO PRODUCTO VALUES ('P14823',2013, 'Mornington Pinot Grigio', 140)
INSERT INTO PRODUCTO VALUES ('P14823',2012,'Mornington Pinot Grigio', 120)
INSERT INTO PRODUCTO VALUES ('P12767',2013, 'Downunder Pinot Noir', 125)
INSERT INTO PRODUCTO VALUES ('P12767',2012, 'Downunder Pinot Noir', 115)

INSERT INTO PRODUCTO VALUES ('P12765', 2013, 'McDonell Pinot Noir', 200)
INSERT INTO PRODUCTO VALUES ('P12765', 2012,'McDonell Pinot Noir', 180)
INSERT INTO PRODUCTO VALUES ('P12765', 2011, 'McDonell Pinot Noir', 140)
INSERT INTO PRODUCTO VALUES ('P12821', 2013, 'Mornington Merlot', 150)
INSERT INTO PRODUCTO VALUES ('P12821', 2012,'Mornington Merlot', 160)
INSERT INTO PRODUCTO VALUES ('P14827', 2013,'Downunder Pinot Grigio', 135)
INSERT INTO PRODUCTO VALUES ('P14829', 2012,'McDonell Pinot Grigio', 190)
INSERT INTO PRODUCTO VALUES ('P14829', 2013,'McDonell Pinot Grigio', 210)
INSERT INTO PRODUCTO VALUES ('P13821', 2012,'McDonell Merlot', 115)
INSERT INTO PRODUCTO VALUES ('P13821', 2013,'McDonell Merlot', 140)
INSERT INTO PRODUCTO VALUES ('P14821', 2013,'Downunder Merlot', 165)
INSERT INTO PRODUCTO VALUES ('P14827', 2011,'Downunder Pinot Grigio', 170)

select * from PRODUCTO

INSERT INTO MERCADO VALUES (1, 'QUITO')
INSERT INTO MERCADO VALUES (2, 'ECUADOR')
INSERT INTO MERCADO VALUES (3, 'INTERNACIONAL')

SELECT * FROM MERCADO
delete ORDENENCABEZADO
INSERT INTO ORDENENCABEZADO VALUES ('S135', 'C478W', '2017-02-12', 'Av. Am�rica E11-257', 1)
INSERT INTO ORDENENCABEZADO VALUES ('S140', 'C128R', '2017-02-15', 'Fleet Street', 3)
INSERT INTO ORDENENCABEZADO VALUES ('S168', 'C479W', '2017-02-16', 'AV. Teodoro Gomez', 2)

INSERT INTO ORDENENCABEZADO VALUES ('S171', 'C121R', '2017-03-01', 'Reina Victoria', 1)
INSERT INTO ORDENENCABEZADO VALUES ('S173', 'C145W', '2017-05-17', 'Av. Tobias Mena', 2)
INSERT INTO ORDENENCABEZADO VALUES ('S174', 'C145W', '2017-05-21', 'Av. Tobias Mena', 2)
INSERT INTO ORDENENCABEZADO VALUES ('S145', 'C342W', '2017-01-28', 'Park Avenue', 3)
INSERT INTO ORDENENCABEZADO VALUES ('S182', 'C352W', '2017-02-02', 'Av. Colon', 1)
INSERT INTO ORDENENCABEZADO VALUES ('S183', 'C352W', '2017-02-12', 'Av. Colon', 1)
INSERT INTO ORDENENCABEZADO VALUES ('S184', 'C352W', '2017-04-12', 'Av. Colon', 1)
INSERT INTO ORDENENCABEZADO VALUES ('S185', 'C542W', '2017-11-22', 'Lucila Benalcazar 1-136', 2)
INSERT INTO ORDENENCABEZADO VALUES ('S194', 'C567R', '2017-10-25', 'Little St., Richmond', 3)
INSERT INTO ORDENENCABEZADO VALUES ('S195', 'C567R', '2017-11-25', 'Little St., Richmond', 3)
INSERT INTO ORDENENCABEZADO VALUES ('S199', 'C576W', '2017-06-12', 'Av. 12 de Octubre', 1)

SELECT * FROM ORDENENCABEZADO

delete ORDENDETALLE
INSERT INTO ORDENDETALLE VALUES (1,'S135', 'P12766', 2013, 25)
INSERT INTO ORDENDETALLE VALUES (2, 'S135', 'P12766', 2012, 30)
INSERT INTO ORDENDETALLE VALUES (3, 'S135', 'P14823', 2013, 30)
INSERT INTO ORDENDETALLE VALUES (4, 'S140', 'P12766', 2013, 25)
INSERT INTO ORDENDETALLE VALUES (5, 'S140', 'P12766', 2012, 65)
INSERT INTO ORDENDETALLE VALUES (6, 'S168', 'P12767', 2013, 50)
INSERT INTO ORDENDETALLE VALUES (7, 'S168', 'P12767', 2012, 40)
INSERT INTO ORDENDETALLE VALUES (8,'S171','P12765',2011, 34)
INSERT INTO ORDENDETALLE VALUES (9,'S173','P12765', 2012, 35)
INSERT INTO ORDENDETALLE VALUES (10,'S174','P12765', 2013, 40)
INSERT INTO ORDENDETALLE VALUES (11,'S145', 'P12821', 2012, 64)
INSERT INTO ORDENDETALLE VALUES (12,'S182', 'P12821', 2013, 52)
INSERT INTO ORDENDETALLE VALUES (13,'S183', 'P13821', 2012, 38)
INSERT INTO ORDENDETALLE VALUES (14,'S184', 'P13821',2013, 60)
INSERT INTO ORDENDETALLE VALUES (15,'S185', 'P14821', 2013, 76)
INSERT INTO ORDENDETALLE VALUES (16,'S194', 'P14823',2012, 15)
INSERT INTO ORDENDETALLE VALUES (17,'S195', 'P14823',2013 , 33)
INSERT INTO ORDENDETALLE VALUES (18,'S199', 'P14827', 2011, 45)
INSERT INTO ORDENDETALLE VALUES (19,'S173', 'P14827', 2013, 35)
INSERT INTO ORDENDETALLE VALUES (20,'S174', 'P14829', 2012, 40)
INSERT INTO ORDENDETALLE VALUES (21,'S145', 'P14829', 2013, 64)
INSERT INTO ORDENDETALLE VALUES (22,'S182', 'P12821', 2013, 52)
INSERT INTO ORDENDETALLE VALUES (23,'S183', 'P13821', 2012, 38)
INSERT INTO ORDENDETALLE VALUES (24,'S184', 'P13821',2013, 60)
INSERT INTO ORDENDETALLE VALUES (25,'S185', 'P14823', 2013, 76)
INSERT INTO ORDENDETALLE VALUES (26,'S194', 'P14829',2012, 15)
INSERT INTO ORDENDETALLE VALUES (27,'S195', 'P14821',2013 , 33)
INSERT INTO ORDENDETALLE VALUES (28,'S199', 'P14829', 2012, 45)
INSERT INTO ORDENDETALLE VALUES (29,'S135', 'P13821', 2012, 30)
INSERT INTO ORDENDETALLE VALUES (30,'S140', 'P12766', 2013, 25)
INSERT INTO ORDENDETALLE VALUES (31,'S168', 'P13821', 2013, 50)
INSERT INTO ORDENDETALLE VALUES (32,'S174', 'P14823', 2013, 40)
INSERT INTO ORDENDETALLE VALUES (33,'S145', 'P14829', 2012, 64)
INSERT INTO ORDENDETALLE VALUES (34,'S182', 'P14829', 2013, 52)
INSERT INTO ORDENDETALLE VALUES (35,'S199', 'P12821', 2012, 45)
INSERT INTO ORDENDETALLE VALUES (36,'S174', 'P12821', 2012, 40)
INSERT INTO ORDENDETALLE VALUES (37,'S184', 'P14821',2013, 60)
INSERT INTO ORDENDETALLE VALUES (38,'S199', 'P14827', 2013, 45)

SELECT * FROM ORDENDETALLE
select * from PRODUCTO