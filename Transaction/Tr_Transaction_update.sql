
CREATE OR ALTER TRIGGER  Tr_Transaction_update

ON [dbo].[Transaction] 
AFTER UPDATE
 AS
 IF (UPDATE(Is_completed))

BEGIN

UPDATE  P
SET SKU = SKU + COALESCE(i.Recieved_qty,0)
FROM 
dbo.Product P
JOIN inserted i 
ON i.product_id= p.product_id
WHERE i.is_completed=1
END;
