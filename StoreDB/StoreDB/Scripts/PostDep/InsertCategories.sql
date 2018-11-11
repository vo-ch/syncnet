IF NOT EXISTS (SELECT TOP 1 1 FROM Categories)
BEGIN
    INSERT INTO [dbo].[Categories] (Id, Name)
    VALUES (1, "Beverages"),
		(2, "Meat/Poultry"),
		(3, "Dairy"),
		(4, "Grains")
END
GO
