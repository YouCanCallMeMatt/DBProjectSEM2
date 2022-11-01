--> Wahyu Guntur bought  2 "MASDAH 3" from Aurora Melani at 17th December 2021

BEGIN TRAN

	-- FIND THE FOLLOWING CUSTOMER, STAFF, AND CAR ID FROM ITS NAME
	SELECT CustomerID FROM MsCustomer WHERE CustomerName = 'Wahyu Guntur'
	SELECT CarID FROM MsCar WHERE CarName = 'MASDAH 3'
	SELECT StaffID FROM MsStaff WHERE StaffName = 'Aurora Melani'

	-- INSERT THE TRANSACTION TO THE DATABASE ACCORDING TO THE DATA FOUND
	INSERT INTO TransactionHeader VALUES
	('TR016', 'ST001', 'CU001', '2021-12-17')

	INSERT INTO TransactionDetail VALUES
	('TR016','CA005', 2)

	-- UPDATE THE CAR STOCK IN THE WAREHOUSE, SUBTRACTING THE STOCK AVAILABLE
	UPDATE MsCar
	SET Stock = Stock - 2
	WHERE CarName = 'MASDAH 3'

	-- CHECK THE TRANSACTION
	SELECT * FROM TransactionHeader WHERE TransactionID = 'TR016'
	SELECT * FROM TransactionDetail WHERE TransactionID = 'TR016'
	SELECT * FROM MsCar WHERE CarName = 'MASDAH 3'

ROLLBACK


--> Aurora Melani bought 3 INNAVO from PT Jati Makmur at 23rd December 2021

BEGIN TRAN

	-- FIND THE FOLLOWING VENDOR, STAFF, AND CAR ID FROM ITS NAME
	SELECT StaffID FROM MsStaff WHERE StaffName = 'Aurora Melani'
	SELECT CarID FROM MsCar WHERE CarName = 'INNAVO'
	SELECT VendorID FROM MsVendor WHERE VendorName = 'PT Jati Makmur'

	-- INSERT THE PURCHASE TO THE DATABASE ACCORDING TO THE DATA FOUND
	INSERT INTO PurchaseHeader (PurchaseID, StaffID, VendorID, PurchaseDate) VALUES
	('PU016', 'ST001', 'VE012', '2021-12-12');

	INSERT INTO PurchaseDetail VALUES
	('PU016', 'CA001', 3);

	-- UPDATE THE CAR STOCK IN THE WAREHOUSE, ADDING THE STOCK AVAILABLE
	UPDATE MsCar
	SET Stock = Stock + 3
	WHERE CarName = 'INNAVO'

	-- CHECK THE PURCHASE
	SELECT * FROM PurchaseHeader WHERE PurchaseID = 'PU016'
	SELECT * FROM PurchaseDetail WHERE PurchaseID = 'PU016'
	SELECT * FROM MsCar WHERE CarName = 'INNAVO'

ROLLBACK