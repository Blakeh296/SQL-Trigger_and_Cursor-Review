
													/************ EXEC STATEMENT @ BOTTOM ************/

USE AdventureWorks2012
GO

CREATE PROC sp_SalesByTerritoryByYear
	@year DATE
AS
BEGIN
SET NOCOUNT ON;  

DECLARE @territory_ID int, @territory_Name nvarchar(50),  
    @message varchar(80), @sales nvarchar(50);  

PRINT '-------- Sales By Territory Report FOR YEAR: '+CAST(left(@year, 4) as varchar(100))+' --------';  

DECLARE salesTerritory_cursor CURSOR FOR   
SELECT [TerritoryID], [Name]  
FROM   [Sales].[SalesTerritory]
ORDER BY [Name];  

OPEN salesTerritory_cursor  

FETCH NEXT FROM salesTerritory_cursor   
INTO @territory_ID, @territory_Name  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '  
    SELECT @message = '----- Sales By Territory: ' +   
        @territory_Name  

    PRINT @message  

    -- Declare an inner cursor based     
    -- on territory_ID from the outer cursor.  

    DECLARE sales_cursor CURSOR FOR   
    SELECT SUM(soh.TotalDue) as 'Total_Sales'  
    FROM [Sales].[SalesOrderHeader] soh
	INNER JOIN [Sales].[SalesTerritory] st
	ON soh.TerritoryID = st.TerritoryID
    WHERE soh.OrderDate = @year AND soh.TerritoryID = @territory_ID   -- Variable value from the outer cursor  
	GROUP BY st.TerritoryID;

    OPEN sales_cursor  
    FETCH NEXT FROM sales_cursor INTO @sales 

    IF @@FETCH_STATUS <> 0   
        PRINT '         <<None>>'       

    IF @@FETCH_STATUS = 0  
    BEGIN  

        SELECT @message = '         ' + @sales  
        PRINT @message  
        FETCH NEXT FROM sales_cursor INTO @sales  
        END  

    CLOSE sales_cursor  
    DEALLOCATE sales_cursor  
        -- Get the next vendor.  
    FETCH NEXT FROM salesTerritory_cursor   
    INTO @territory_ID, @territory_Name  
END   
CLOSE salesTerritory_cursor;  
DEALLOCATE salesTerritory_cursor; 
END

--EXEC sp_SalesByTerritoryByYear @year = '2006'
