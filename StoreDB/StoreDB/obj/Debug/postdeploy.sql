/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
USE [$(DatabaseName)];

IF NOT EXISTS (SELECT TOP 1 1 FROM Categories)
BEGIN
    INSERT INTO [dbo].[Categories] (Id, Name)
    VALUES (1, "Beverages"),
		(2, "Meat/Poultry"),
		(3, "Dairy"),
		(4, "Grains")
END
GO

IF NOT EXISTS (SELECT TOP 1 1 FROM Products)
BEGIN
    INSERT INTO [dbo].[Products] (Name, Categoryid, Price)
    VALUES ("Cheese", 3, 5.00),
		("Sausage", 2, 10.50),
		("Rice", 4, 3.10)
END
GO

GO
