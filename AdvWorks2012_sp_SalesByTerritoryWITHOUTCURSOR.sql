									
									/************ EXEC STATEMENT @ BOTTOM ************/

USE AdventureWorks2012
GO

ALTER PROC sp_SalesByTerritoryWITHOUTCURSOR
	@year as date
AS
	BEGIN
			SELECT   MAX(st.TerritoryID) [Territory_ID], st.Name [Territory_Name]
			, COUNT(soh.SalesOrderID) [Count_of_Sales], ROUND(SUM(soh.TotalDue), 2) [Total_Sales], LEFT(@year, 4) [Fiscal_Year]

			FROM  [Sales].[SalesOrderHeader] soh
			INNER JOIN [Sales].[SalesTerritory] st
			ON soh.TerritoryID = st.TerritoryID

			WHERE soh.OrderDate = @year AND soh.TerritoryID = st.TerritoryID  
			GROUP BY st.Name
			ORDER BY st.Name;
	END

--EXEC sp_SalesByTerritoryWITHOUTCURSOR @year = '2008' 