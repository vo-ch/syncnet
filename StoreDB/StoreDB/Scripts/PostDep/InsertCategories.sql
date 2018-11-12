IF NOT EXISTS (SELECT TOP 1 1 FROM Categories)
BEGIN
    INSERT INTO [dbo].[Categories] (Id, Name)
    VALUES (1, N'Beverages'),
		(2, N'Meat/Poultry'),
		(3, N'Dairy'),
		(4, N'Grains')
END
GO
