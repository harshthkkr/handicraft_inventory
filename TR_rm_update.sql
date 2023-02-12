CREATE OR ALTER TRIGGER  Rm_update

ON Transaction_details 
AFTER INSERT
 AS

BEGIN

UPDATE Raw_Material
SET SKU = SKU - i.given_qty 
FROM inserted i
WHERE Raw_Material.Rawmaterial_Id = i.Rawmaterial_Id ;

UPDATE dbo.Sub_Product
SET SKU = SKU - i.given_qty 
FROM inserted i
WHERE Sub_Product.SubProduct_Id = i.SubProduct_Id ;

END;
