CREATE TABLE [dbo].[Products]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Name] NVARCHAR(50) NOT NULL, 
    [Categoryid] INT NOT NULL, 
    [Price] MONEY NOT NULL,
	CONSTRAINT FK_ProductCategory FOREIGN KEY (Categoryid)
		REFERENCES Categories(Id)
)
