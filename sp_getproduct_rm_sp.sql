
CREATE OR ALTER PROC sp_getproduct_rm_sp (@product_id INT,@Qty int)
AS 

--DECLARE  @product_id INT =1
--,@Qty INT =10

BEGIN

DROP TABLE IF EXISTS #product_rm_sp

CREATE  TABLE #product_rm_sp (
product_name VARCHAR(30),
type VARCHAR(30),
Material VARCHAR(30),
Required_qty INT,
unit_type VARCHAR(30))

INSERT INTO #product_rm_sp
(
    product_name,
    type,
    Material,
    Required_qty
	,unit_type
)

SELECT p.Name AS product_name,'Rawmaterial' AS type,r.Name AS Material,PR.Required_qty*@Qty,mu.unit_type FROM
 dbo.Product p
 JOIN dbo.Product_RM_usage PR ON p.Product_Id = PR.Product_id
 JOIN dbo.Raw_Material r ON r.Rawmaterial_Id=pr.Rawmaterial_id
 JOIN dbo.Measurement_unit mu ON mu.unit_id=r.unit_id
WHERE P.Product_id =@product_id
UNION
SELECT p.Name AS product_name,'Subproduct' AS type,sp.Name AS Material,psr.Required_qty*@Qty,mu.unit_type  FROM
 dbo.Product p
 JOIN dbo.Product_Subproduct_relation PSR ON p.Product_Id = PSR.Product_id
 JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=PSR.SubProduct_id
  JOIN dbo.Measurement_unit mu ON mu.unit_id=sp.unit_id
WHERE P.Product_id =@product_id

SELECT * FROM #product_rm_sp

END

EXEC sp_getproduct_rm_sp @product_id=1,@qty=10
