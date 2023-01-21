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
,@Piece_Labor_Rate INT
,@Actual_piece_labor_rate decimal(18,2)
,@Return_date DATETIME


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


DECLARE @scope int
SELECT @scope = SCOPE_IDENTITY()

/*
INSERT the Grid value of sp_getproduct_rm_sub.sql INTO Transaction_details with scope_identity
*/


--DROP TABLE IF EXISTS #product_rm_sub

--CREATE  TABLE #product_rm_sub (
--Rawmaterial_Id int,
--subproduct_id int,
--Required_qty INT)

--INSERT INTO #product_rm_sub
--(
--    Rawmaterial_Id,
--    subproduct_id,
--    Required_qty
--)
--SELECT  R.Rawmaterial_Id AS Rawmaterial_Id, NULL AS subproduct_id,PR.Required_qty*@Required_qty FROM
-- dbo.Product p
-- JOIN dbo.Product_RM_usage PR ON p.Product_Id = PR.Product_id
-- JOIN dbo.Raw_Material r ON r.Rawmaterial_Id=pr.Rawmaterial_id
--WHERE P.Product_id =@product_id
--UNION
--SELECT NULL AS Rawmaterial_Id, sp.SubProduct_Id AS subproduct_id,PSR.Required_qty*@Required_qty FROM
-- dbo.Product p
-- JOIN dbo.Product_Subproduct_relation PSR ON p.Product_Id = PSR.Product_id
-- JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=PSR.SubProduct_id
--WHERE P.Product_id =@product_id




--INSERT INTO dbo.Transaction_details
--(
--    Trx_id,
--    Rawmaterial_id,
--    subproduct_id,
--    Required_qty,
--    Is_pending
--)
--SELECT @scope,Rawmaterial_Id,subproduct_id,Required_qty,0
--FROM #product_rm_sub

