--Product id int
--Required_qty
--Total Weigth given
--Return date
--Actual_piece_labor_rate

DECLARE 
@contact_no VARCHAR(10)
,@member_id int,@product_id INT,@subproduct_id INT,
@Required_qty int
,@Total_Weight_given decimal (18,2)
,@Total_weight_recieved decimal (18,2),
@Piece_Labor_Rate INT,
@Actual_piece_labor_rate decimal(18,2)
,@Return_date datetime

SELECT @member_id=Member_id FROM dbo.Member WHERE Contact_no = @contact_no

IF (@product_id IS NOT NULL)
BEGIN
SELECT @Piece_Labor_Rate = [Labor Rate] FROM dbo.Product WHERE Product_Id = @product_id
END

IF (@subproduct_id IS NOT NULL)
BEGIN
SELECT @Piece_Labor_Rate = [Labour Rate] FROM dbo.Sub_Product WHERE SubProduct_Id = @subproduct_id
END

INSERT INTO dbo.[Transaction]
(
    Member_id,
    Product_id,
    subproduct_id,
    Required_Qty,
    [Total_Weight given],
    Total_weight_recieved,
    Recieved_qty,
    Order_date,
    Return_date,
    Actual_return_date,
    Is_completed,
    Piece_Labor_Rate,
    [Actual_piece_labor rate],
    Total_Actual_Amount
)

SELECT @member_id,@product_id,@subproduct_id,
@Required_qty,
@Total_Weight_given,
NULL,
GETDATE(),
@Return_date,
NULL,
0,
@Piece_Labor_Rate,
@Actual_piece_labor_rate


SELECT SCOPE_IDENTITY()


EXEC sp_getproduct_rm @product_id=1,@qty=10

