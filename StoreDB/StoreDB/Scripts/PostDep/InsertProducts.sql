IF NOT EXISTS (SELECT TOP 1 1 FROM Products)
BEGIN
    INSERT INTO [dbo].[Products] (Name, Categoryid, Price)
    VALUES ("Cheese", 3, 5.00),
		("Sausage", 2, 10.50),
		("Rice", 4, 3.10)
END
GO
