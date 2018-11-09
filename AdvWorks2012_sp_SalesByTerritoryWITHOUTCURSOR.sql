									
									/************ EXEC STATEMENT @ BOTTOM ************/

USE AdventureWorks2012
GO

CREATE PROC sp_SalesByTerritoryWITHOUTCURSOR
	@year as date
AS
	BEGIN
			SELECT   MAX(st.TerritoryID) as Territory_ID, st.Name as Territory_Name
			,ROUND(SUM(soh.TotalDue), 2) as Total_Sales, LEFT(@year, 4) as Fiscal_Year

			FROM  [Sales].[SalesOrderHeader] soh
			INNER JOIN [Sales].[SalesTerritory] st
			ON soh.TerritoryID = st.TerritoryID

			WHERE soh.OrderDate = @year AND soh.TerritoryID = st.TerritoryID  
			GROUP BY st.Name
			ORDER BY st.Name desc;
	END

--EXEC sp_SalesByTerritoryWITHOUTCURSOR @year = '2006' 