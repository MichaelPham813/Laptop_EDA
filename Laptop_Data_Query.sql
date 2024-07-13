/*
	Laptop Data
	Use: Aggregate, subquery, and basic SQL knowledge
*/



--Default value
SELECT *
FROM
	LaptopData

--Global Value
SELECT
	COUNT(DISTINCT Company) AS Number_Of_Company
	,COUNT(*) AS Number_Of_Laptop
	,SUM(Price) AS Total_Value
FROM
	LaptopData


--Total product price in every company
SELECT
	Company
	,COUNT(*) AS total_products
	,SUM(Price) AS total_product_price
FROM
	LaptopData
GROUP BY
	Company
ORDER BY
	3

--Percentage of Intel, AMD , Samsung CPU

--Default variable
DECLARE @Total_row INT
SET @Total_row = (SELECT COUNT(*) FROM LaptopData)

SELECT
	TypeName
	,ROUND(CONVERT(float,COUNT(CASE WHEN Cpu LIKE 'Intel%' THEN 1 END)) / @Total_row * 100,2) AS Intel_Cpu_percentage
	,ROUND(CONVERT(float,COUNT(CASE WHEN Cpu LIKE 'AMD%' THEN 1 END)) / @Total_row * 100,2) AS AMD_Cpu_percentage
	,ROUND(CONVERT(float,COUNT(CASE WHEN Cpu LIKE 'Samsung%' THEN 1 END)) / @Total_row * 100,2) AS Samsung_Cpu_percentage
FROM
	LaptopData
GROUP BY
	TypeName

---Prefer Gpu in different type of laptop
SELECT
    TypeName
	,COUNT(CASE WHEN Gpu LIKE 'Intel%' THEN 1 END) AS Intel_Gpu_Total
	,COUNT(CASE WHEN Gpu LIKE 'AMD%' THEN 1 END) AS AMD_Gpu_Total
	,COUNT(CASE WHEN Gpu LIKE 'Nvidia%' THEN 1 END) AS Nvidia_Gpu_Total
FROM
	LaptopData
GROUP BY
	TypeName


---Check the most perferable OpSys in company
SELECT
	Company
	,OpSys
	,COUNT(*) AS Total_Use
FROM
	LaptopData
GROUP BY
	Company
	,OpSys
HAVING
	COUNT(*) = (
				SELECT 
					MAX(Preferred_OS)
				FROM 
					(
					SELECT 
						Company
						,OpSys
						,COUNT(*) AS Preferred_OS
					FROM 
						LaptopData
					GROUP BY
						Company
						,OpSys
					) AS SubQuery
				WHERE
					Company = LaptopData.Company
				)
ORDER BY
	1
