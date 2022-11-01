CREATE DATABASE cArDorm
GO
USE cArDorm
GO

CREATE TABLE [MsCustomer](
	CustomerID CHAR(5) PRIMARY KEY CHECK
		(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(255) NOT NULL CHECK
		(CustomerName LIKE '___%'),
	CustomerGender VARCHAR(10) NOT NULL CHECK
		(CustomerGender IN ('Female','Male')),
	CustomerEmail VARCHAR(255) NOT NULL CHECK
		(CustomerEmail LIKE '%@gmail.com' OR 
		 CustomerEmail LIKE '%@yahoo.com'),
	CustomerAddress VARCHAR(255) NOT NULL,
	CustomerPhoneNumber VARCHAR(15) NOT NULL
)

CREATE TABLE [MsStaff](
	StaffID CHAR(5) PRIMARY KEY CHECK
		(StaffID LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(255) NOT NULL,
	StaffGender VARCHAR(10) NOT NULL CHECK
		(StaffGender IN ('Female','Male')),
	StaffEmail VARCHAR(255) NOT NULL CHECK
		(StaffEmail LIKE '%@gmail.com' OR 
		 StaffEmail LIKE '%@yahoo.com'),
	StaffAddress VARCHAR(255) NOT NULL,
	StaffPhoneNumber VARCHAR(15) NOT NULL,
	StaffSalary INT NOT NULL CHECK
		(StaffSalary BETWEEN 5000000 AND 10000000)
)

CREATE TABLE [MsVendor](
	VendorID CHAR(5) PRIMARY KEY CHECK
		(VendorID LIKE 'VE[0-9][0-9][0-9]'),
	VendorName VARCHAR(255) NOT NULL,
	VendorEmail VARCHAR(255) NOT NULL CHECK
		(VendorEmail LIKE '%@gmail.com' OR 
		 VendorEmail LIKE '%@yahoo.com'),
	VendorAddress VARCHAR(255) NOT NULL,
	VendorPhoneNumber VARCHAR(15) NOT NULL,
)

CREATE TABLE [MsCarBrand](
	CarBrandID CHAR(5) PRIMARY KEY CHECK
		(CarBrandID LIKE 'CB[0-9][0-9][0-9]'),
	CarBrandName VARCHAR(255) NOT NULL
)

CREATE TABLE [MsCar](
	CarID CHAR(5) PRIMARY KEY CHECK
		(CarID LIKE 'CA[0-9][0-9][0-9]'),
	CarBrandID CHAR(5) FOREIGN KEY REFERENCES MsCarBrand(CarBrandID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CarName VARCHAR(255),
	Price INT NOT NULL,
	Stock INT NOT NULL
)

CREATE TABLE [PurchaseHeader](
	PurchaseID CHAR(5) PRIMARY KEY CHECK
		(PurchaseID LIKE 'PU[0-9][0-9][0-9]'),
	StaffID CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	VendorID CHAR(5) FOREIGN KEY REFERENCES MsVendor(VendorID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PurchaseDate DATE NOT NULL CHECK(PurchaseDate <= GETDATE())
)

CREATE TABLE [PurchaseDetail](
	PurchaseID CHAR(5) FOREIGN KEY REFERENCES PurchaseHeader(PurchaseID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CarID CHAR(5) FOREIGN KEY REFERENCES MsCar(CarID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY(PurchaseID, CarID)
)

CREATE TABLE [TransactionHeader](
	TransactionID CHAR(5) PRIMARY KEY CHECK
		(TransactionID LIKE 'TR[0-9][0-9][0-9]'),
	StaffID CHAR(5) FOREIGN KEY REFERENCES MsStaff(StaffID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CustomerID CHAR(5) FOREIGN KEY REFERENCES MsCustomer(CustomerID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TransactionDate DATE NOT NULL CHECK(TransactionDate <= GETDATE())
)

CREATE TABLE [TransactionDetail](
	TransactionID CHAR(5) FOREIGN KEY REFERENCES TransactionHeader(TransactionID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CarID CHAR(5) FOREIGN KEY REFERENCES MsCar(CarID)
		ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY(TransactionID, CarID)
)