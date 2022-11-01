use cArDorm

--1
SELECT
	 'Mrs. ' + CustomerName AS CustomerName,
	 UPPER(CustomerGender) AS CustomerGender,
	 COUNT(TransactionID) AS [Total Transaction]
FROM 
	MsCustomer mc join TransactionHeader th ON
	mc.CustomerID = th.CustomerID
WHERE 
	CustomerName LIKE '% %' AND
	CustomerGender = 'Female'
GROUP BY
	CustomerName,
	CustomerGender


--2
SELECT
	mc.CarID,
	CarName,
	CarBrandName,
	Price,
	CAST(SUM(Quantity) AS varchar) + ' Car(s)' AS [Total of Car That Has Been Sold]
FROM
	MsCar mc join TransactionDetail td ON
	mc.CarID = td.CarID join MsCarBrand mcb ON
	mcb.CarBrandID = mc.CarBrandID
WHERE
	Price > 300000000 AND
	CAST(RIGHT(mc.CarID, 3) AS INT)%2 = 1
GROUP BY
	mc.CarID,
	CarName,
	CarBrandName,
	Price
HAVING
	COUNT(TransactionID) > 1


--3
SELECT
	REPLACE(ms.StaffID, 'ST', 'Staff') AS StaffId,
	StaffName,
	COUNT(DISTINCT(th.TransactionID)) AS [Total Transaction Handled], 
	MAX(td.Quantity) AS [Maximum Quantity in One Transaction]
FROM
	MsStaff ms join transactionHeader th ON
	ms.StaffID = th.StaffID join TransactionDetail td ON
	td.TransactionID = th.TransactionID
WHERE
	DATENAME(month, TransactionDate) = 'April' AND
	StaffName LIKE '% %'
GROUP BY
	ms.StaffID,
	StaffName
HAVING
	COUNT(th.TransactionID)  > 1
ORDER BY
	MAX(td.Quantity) DESC


--4
SELECT
	CustomerName,
	LEFT(CustomerGender, 1) AS CustomerGender,
	COUNT(DISTINCT(th.TransactionID)) AS [Total Purchase], 
	SUM(td.Quantity) AS [Total of Car That Has Been Purchased]
FROM 
	MsCustomer mc join transactionHeader th ON
	mc.CustomerID = th.CustomerID join TransactionDetail td ON
	td.TransactionID = th.TransactionID
WHERE
	CustomerEmail LIKE '%@gmail.com'
GROUP BY
	CustomerName,
	CustomerGender
HAVING
	SUM(td.Quantity) > 2


--5 
SELECT 
	REPLACE(VendorName, 'PT', 'Perseroan Trebatas') AS VendorName,
	VendorPhoneNumber,
	CAST(RIGHT(ph.PurchaseID, 3) AS INT) AS [Purchase ID Number],
	Quantity
FROM
	MsVendor mv join PurchaseHeader ph ON
	mv.VendorID = ph.VendorID join PurchaseDetail pd ON
	pd.PurchaseID = ph.PurchaseID,
	(
		SELECT
			AVG(Quantity) AS AvgQuantity
		FROM
			MsVendor mv join PurchaseHeader ph ON
			mv.VendorID = ph.VendorID join PurchaseDetail pd ON
			pd.PurchaseID = ph.PurchaseID	
		WHERE
			VendorName LIKE '%[a]%'
	) AS Alias
WHERE
	Quantity > Alias.AvgQuantity

--6
SELECT
	UPPER(CarBrandName + ' ' + CarName) AS [Name],
	'Rp. ' + CAST(Price AS VARCHAR) AS [Price],
	CAST(Stock AS VARCHAR) + ' Stock(s) ' AS [Stock]
FROM
	MsCar mc JOIN MsCarBrand mcb ON mc.CarBrandID = mcb.CarBrandID,
	(
		SELECT
			AVG(CAST(Price AS bigint)) AS AVGPrice
		FROM
			MsCar mc JOIN MsCarBrand mcb ON mc.CarBrandID = mcb.CarBrandID
	) AS Alias
WHERE
	CarName LIKE '%[e]%' AND
	Price > Alias.AVGPrice

--7
SELECT
	RIGHT(mc.CarID,3) AS [Car ID Number],
	mc.CarName,
	UPPER(msc.CarBrandName) AS [Brand],
	'Rp. ' + CAST(mc.Price AS VARCHAR) AS [Price],
	SUM(Quantity) AS [Total of Car That Has Been Sold]
FROM
	TransactionHeader th JOIN TransactionDetail td ON 
	th.TransactionID = td.TransactionID JOIN MsCar mc ON 
	td.CarID = mc.CarID JOIN MsCarBrand msc ON 
	mc.CarBrandID = msc.CarBrandID,
	(
		SELECT
			AVG(x.CarSold) AS AvgCarSold
		FROM
		(
			SELECT
				CarName,
				CarBrandName,
				SUM(Quantity) AS CarSold
			FROM
				TransactionHeader th JOIN TransactionDetail td ON 
				th.TransactionID = td.TransactionID JOIN MsCar mc ON 
				td.CarID = mc.CarID JOIN MsCarBrand msc ON 
				mc.CarBrandID = msc.CarBrandID
			GROUP BY
				CarName,
				CarBrandName
		)x
	)y
WHERE
	Price > 200000000 AND
	CarName LIKE '%[o]%'
GROUP BY
	mc.CarID,
	CarName,
	CarBrandName,
	Price,
	y.AvgCarSold
HAVING
	SUM(Quantity) > y.AvgCarSold

--8
SELECT
	SUBSTRING(ms.StaffName, 1, (CHARINDEX(' ', ms.StaffName )-1)) AS [First Name],
	RIGHT(ms.StaffName, (CHARINDEX(' ', REVERSE(ms.StaffName))-1)) AS [Last Name],
	SUM(Quantity) AS [Total of Car That Has Been Sold]
FROM
	MsStaff ms JOIN TransactionHeader th ON
	th.StaffID = ms.StaffID JOIN TransactionDetail td ON
	td.TransactionID = th.TransactionID,
	(
		SELECT
			AVG(x.CarSold) AS AvgCarSold
		FROM
		(
			SELECT
				StaffName,
				SUM(Quantity) AS CarSold
			FROM
				MsStaff ms JOIN TransactionHeader th ON
				th.StaffID = ms.StaffID JOIN TransactionDetail td ON
				td.TransactionID = th.TransactionID
			GROUP BY
				StaffName
		)x
	)y
WHERE 
	StaffName LIKE '% %'
GROUP BY
	StaffName,
	y.AvgCarSold
HAVING
	SUM(Quantity) > y.AvgCarSold

--9
CREATE VIEW Vendor_Transaction_Handled_and_Minimum_View AS
SELECT
	REPLACE(mv.VendorID, 'VE', 'Vendor ') AS [Vendor ID],
	VendorName,
	COUNT(DISTINCT(ph.PurchaseID)) AS [Total Transaction Handled],
	MIN(pd.Quantity) AS [Minimum Purchases in One Transaction]
FROM
	MsVendor mv JOIN PurchaseHeader ph ON
	ph.VendorID = mv.VendorID JOIN PurchaseDetail pd ON
	pd.PurchaseID = ph.PurchaseID
WHERE
	DATENAME(MONTH, PurchaseDate) = 'May' AND
	VendorName LIKE '%a%'
GROUP BY
	mv.VendorID,
	VendorName

SELECT * FROM Vendor_Transaction_Handled_and_Minimum_View

--10
CREATE VIEW Staff_Total_Purchase_and_Max_Car_Purchase_View AS
SELECT
	ms.StaffID,
	StaffName,
	UPPER(StaffEmail) as [StaffEmail],
	COUNT(DISTINCT(ph.PurchaseID)) AS [Total Purchase],
	MAX(pd.Quantity) AS [Maximum of Car That Has Been Purchased in One Purchase]
FROM
	MsStaff ms JOIN PurchaseHeader ph ON
	ph.StaffID = ms.StaffID JOIN PurchaseDetail pd ON
	pd.PurchaseID = ph.PurchaseID
WHERE
	StaffEmail LIKE '%@yahoo.com' AND
	StaffGender = 'Female'
GROUP BY
	ms.StaffID,
	StaffName,
	StaffEmail

SELECT * FROM Staff_Total_Purchase_and_Max_Car_Purchase_View