DECLARE @contact_no VARCHAR(10) = '1234567890'

DECLARE @member_id INT
SELECT @member_id = Member_id FROM dbo.Member WHERE Contact_no = @contact_no



SELECT t.Trx_id,p.Name,sp.Name,t.[Total_Weight given],t.Required_Qty,t.Total_weight_recieved,t.Recieved_qty,t.Order_date,t.Return_date,t.Actual_return_date,
t.Is_completed,t.Piece_Labor_Rate,t.[Actual_piece_labor rate],[Actual_piece_labor rate]*Required_Qty AS transaction_amount
FROM dbo.[Transaction] t
LEFT JOIN dbo.Member m ON m.Member_id=t.Member_id
LEFT JOIN dbo.Product p ON p.Product_Id = t.Product_id
LEFT JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=t.subproduct_id
WHERE m.Member_id=@member_id
