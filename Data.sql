CREATE DATABASE QuanLyQuanCafe
GO
USE QuanLyQuanCafe
GO
-- Food
-- Table
-- FoodCatelogy
-- Account
-- Bill
-- BillInfo

CREATE TABLE TableFood
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Bàn chưa có tên',
	status NVARCHAR(100) NOT NULL DEFAULT N'Trống', -- Trống || Có người

)
GO

CREATE TABLE Account
(
	UserName NVARCHAR(100) PRIMARY KEY ,
	DisplayName NVARCHAR(100) NOT NULL DEFAULT N'Kter' ,
	PassWord NVARCHAR(1000) NOT NULL DEFAULT 0,
	Type INT NOT NULL DEFAULT 0 --1: admin && 0: staff
)
GO

CREATE TABLE FoodCategory
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chưa Đặt Tên'
)
GO

CREATE TABLE Food
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	name NVARCHAR(100) NOT NULL DEFAULT N'Chưa Đặt Tên',
	idCategory INT NOT NULL,
	price FLOAT NOT NULL DEFAULT 0
	
	FOREIGN KEY (idCategory) REFERENCES dbo.FoodCategory(id)
)
GO

CREATE TABLE Bill
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	DateCheckIn DATE NOT NULL DEFAULT GETDATE(),
	DateCheckOut DATE,
	idTable INT NOT NULL,
	status INT NOT NULL DEFAULT 0 -- 1: da thanh toan && 0: chua thanh toan

	FOREIGN KEY (idTable) REFERENCES dbo.TableFood(id)
)
GO

CREATE TABLE BillInfo
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	idBill INT NOT NULL,
	idFood INT NOT NULL,
	count INT NOT NULL DEFAULT 0

	FOREIGN KEY (idBill) REFERENCES dbo.Bill(id),
	FOREIGN KEY (idFood) REFERENCES dbo.Food(id)
)
GO

INSERT INTO dbo.Account
	(UserName,
	DisplayName,
	PassWord,
	Type
	)
VALUES (N'K9', -- UserName - nvarchar(100)
		N'RongK9', -- DisplayName - nvarchar(100)
		N'1', -- PassWord - nvarchar(1000)
		1 -- Tyoe - int
		)

INSERT INTO dbo.Account
	(UserName,
	DisplayName,
	PassWord,
	Type
	)
VALUES (N'staff', -- UserName - nvarchar(100)
		N'staff', -- DisplayName - nvarchar(100)
		N'1', -- PassWord - nvarchar(1000)
		0 -- Tyoe - int
		)
GO

CREATE PROC USP_GetAccountByUserNAme
@userName NVARCHAR(100)
AS
BEGIN 
	SELECT *FROM dbo.Account WHERE UserNAme = @userName
END
GO

EXEC dbo.USP_GetAccountByUserNAme @userName = N'K9' -- navarchar(100)

GO
CREATE PROC USP_Login
@userName NVARCHAR(100),@passWord NVARCHAR(100)
AS 
BEGIN
	SELECT *FROM dbo.Account WHERE UserName = @userName AND PassWord = @passWord
END
GO
-- thêm bàn
DECLARE @i INT = 0

WHILE @i <= 10
BEGIN 
	INSERT dbo.TableFood ( name) VALUES(N' Bàn ' + CAST(@i AS nvarchar(100)))
	SET @i = @i + 1
END
GO 

CREATE PROC USP_GetTableList
AS SELECT * FROM dbo.TableFood
GO	

UPDATE dbo.TableFood SET status = N'Có Người' WHERE id = 6
EXEC dbo.USP_GetTableList
GO
-- thêm category 
INSERT dbo.FoodCategory
	(name)
VALUES (N' Hải sản '-- name - nvarchar(100)
	)

INSERT dbo.FoodCategory
	(name)
VALUES (N' Nông sản ')

INSERT dbo.FoodCategory
	(name)
VALUES (N' Lâm sản ')

INSERT dbo.FoodCategory
	(name)
VALUES (N' Sản sản ')

INSERT dbo.FoodCategory
	(name)
VALUES (N' Nước ')

-- thêm món ăn
INSERT dbo.Food
	(name,idCategory,price)
VaLUES(N'Mực một nắng nướng sa tế', -- name - nvarchar(100)
		1, -- icategory - int
		120000)
INSERT dbo.Food
	(name,idCategory,price)
VaLUES(N'Nghêu hấp xã',1,50000)
INSERT dbo.Food
	(name,idCategory,price)
VaLUES(N'Dú dê nướng sữa ',2,60000)
INSERT dbo.Food
	(name,idCategory,price)
VaLUES(N'Heo rừng nướng muối ớt ',3,75000)
INSERT dbo.Food
	(name,idCategory,price)
VaLUES(N'Cơm chiên mushi',4,999)
INSERT dbo.Food
	(name,idCategory,price)
VaLUES(N'7 Up',5,15000)
INSERT dbo.Food
	(name,idCategory,price)
VaLUES(N'Cafe',5,15000)

--thêm bill

INSERT dbo.Bill
(
	DateCheckIn,
	DateCheckOut,
	idTable,
	status
)
VALUES ( GETDATE(), -- DateCheckIn - Date
		NULL, -- DateCheckOut - Date
		1,-- idTable - int 
		0 -- status - int
		)
INSERT dbo.Bill
(
	DateCheckIn,
	DateCheckOut,
	idTable,
	status
)
VALUES ( GETDATE(),
		NULL,
		2,
		0
		)
INSERT dbo.Bill
(
	DateCheckIn,
	DateCheckOut,
	idTable,
	status
)
VALUES ( GETDATE(),
		GETDATE(),
		3,
		1
		)

-- thêm bill info

INSERT dbo.BillInfo
		(idBill, idFood, count)
VALUES (4, -- idBill - int 
		8,-- idFool - int
		2 -- count - int
		)
INSERT dbo.BillInfo
		( idBill, idFood, count)
VALUES (4, -- idBill - int 
		10,-- idFool - int
		4 -- count - int
		)
INSERT dbo.BillInfo
		( idBill, idFood, count)
VALUES (4, -- idBill - int 
		12,-- idFool - int
		1 -- count - int
		)
INSERT dbo.BillInfo
		( idBill, idFood, count)
VALUES (5, -- idBill - int 
		8,-- idFool - int
		2 -- count - int
		)
INSERT dbo.BillInfo
		( idBill, idFood, count)
VALUES (5, -- idBill - int 
		13,-- idFool - int
		2 -- count - int
		)
INSERT dbo.BillInfo
		( idBill, idFood, count)
VALUES (6, -- idBill - int 
		12,-- idFool - int
		2 -- count - int	
		)
GO

CREATE PROC USP_InsertBill
@idTable INT
AS
BEGIN
	INSERT dbo.Bill
		(DateCheckIn,
		 DateCheckOut,
		 idTable,
		 status,
		 discount
		)
	VALUES ( GETDATE(),
			NULL,
			@idTable,
			0,
			0
			)	
END
GO

CREATE PROC USP_InsertBillInfo
@idBill INT , @idFood INT , @count INT
AS
BEGIN
	INSERT dbo.BillInfo
	(idBill , idFood,count)
	VALUES(@idBill,
			@idFood,
			@count
			)
END
GO

CREATE PROC USP_InsertBillInfo
@idBill INT , @idFood INT , @count INT
AS
BEGIN

	DECLARE @isExitsBillInfo int
	DECLARE @foodCount INT =1 
	SELECT @isExitsBillInfo = id,@foodCount = b.count 
	FROM dbo.BillInfo AS b 
	WHERE idBill=@idBill AND idFood = @idFood
	IF(@isExitsBillInfo > 0)
	BEGIN 
		DECLARE @newCount INT = @FoodCount + @count
		if(@newCount >0)
			UPDATE dbo.BillInfo SET count =@foodCount +@count WHERE idFood = @idFood
		else
			DELETE dbo.BillInfo WHERE idBill =@idBill AND idFood = @idFood
	END
	ELSE
	BEGIN
		INSERT dbo.BillInfo
	(	idBill,idFood,count)
		VALUES (@idBill,
			@idFood,
			@count
			)
	END
END
GO

CREATE TRIGGER UTG_UpdateBillInfo
ON dbo.BillInfo FOR INSERT ,UPDATE 
AS
BEGIN
	DECLARE @idBill INT
	SELECT @idBill = idBill FROM inserted
	DECLARE @idTable INT
	SELECT @idTable = idTable From dbo.Bill WHERE id = @idBill AND status = 0
	UPDATE	dbo.TableFood SET status = N'Có người ' WHERE id = @idTable
END
GO

ALTER TABLE dbo.Bill
ADD discount INT 

UPDATE dbo.Bill SET discount = 0



DECLARE @idBillNew INT = 20
SELECT id FROM dbo.BillInfo WHERE idBill = @idBillNew

DECLARE @idBillOld INT = 10

UPDATE dbo.BillInfo SET idBill = @idBillOld WHERE id IN (SELECT id FROM dbo.BillInfo WHERE idBill = @idBillNew)

SELECT f.name , bi.count, f.price , f.price*bi.count AS totalPrice FROM dbo.BillInfo AS bi,dbo.Bill AS b, dbo.Food AS f 
WhERE bi.idBill = b.id AND bi.idFood = f.id AND b.status = 0 AND b.idTable = 5

DELETE dbo.BillInfo
DELETE dbo.Bill

SELECT * FROM dbo.TableFood 
SELECT * FROM dbo.Bill
SELECT * FROM dbo.BillInfo
SELECT * FROM dbo.Food
SELECT * FROM dbo.FoodCategory

SELECT MAX(id) FROM dbo.BIll

