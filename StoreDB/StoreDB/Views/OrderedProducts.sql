CREATE VIEW [dbo].[OrderedProducts]
	AS SELECT p.Id, p.Name, COUNT(o.Id) AS Count 
	FROM [Products] as p
		LEFT JOIN Orders as o ON p.Id = o.ProductId
	GROUP BY p.Id, p.Name
