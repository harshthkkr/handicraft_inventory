create or alter proc GetMemberCategory  
AS  
BEGIN  
select * from Memeber_Category  
END
GO
create or alter  proc GetAllMemberList  
AS  
BEGIN  
select * , [Deposit Amount] as Deposit_Amount from Member where Status = 1  
END  
Go
create or alter  proc SaveMembers  
@id int,  
@fname varchar(30),  
@lname varchar(30),  
@contactno varchar(10),  
@alternatecontactno varchar(10),  
@address varchar(4000),  
@aadhar varchar(20),  
@depositeamt int,  
@membercategpryid int  
AS  
BEGIN  
if ISNULL(@id,0) = 0  
BEGIN  
Insert into Member(F_Name,L_Name,Contact_no,Alternate_conatact_no,Address,Aadhar,[Deposit Amount],Status,Created_at,Updated_at,member_Category_id)  
values (@fname,@lname,@contactno,@alternatecontactno,@address,@aadhar,@depositeamt,1,GETDATE(),GETDATE(),@membercategpryid)  
END  
else  
BEGIN  
update Member set F_Name = @fname,L_Name = @lname,Contact_no=@contactno,Alternate_conatact_no=@alternatecontactno,Address=@address,Aadhar=@aadhar,[Deposit Amount]=@depositeamt,Updated_at=GETDATE(),member_Category_id=@membercategpryid where Member_id= @id 
END  
select ''  
END
Go
create or alter  proc DeleteMembers    
@id int    
As    
Begin    
update Member set Status= 0 where Member_id = @id    
select ''    
END
Go
create or alter   proc BindCategory  
AS   
BEGIN  
Select * from Product_Category  
END  
GO
create or alter  proc BindLocation  
AS   
BEGIN  
Select * from Location  
END  
GO
create or alter  proc sp_RawMaterials  
AS  
BEGIN  
select * from Raw_Material where Active = 1  
END  
Go
create or alter  proc sp_subproduct  
As  
begin  
select * from Sub_Product where Active = 1  
END
GO
create or alter  proc sp_Products  
as   
begin  
select * from product where Active = 1  
END  
GO
create or alter  proc sp_ProductSubProductRelation  
@Productid int  
AS   
Begin  
Select * from Product_Subproduct_relation where Product_id =@Productid  
END
GO
create or alter    proc Sp_SaveProducts      
@productid int,      
@Name varchar(400),      
@Description varchar(400),      
@SKU int,      
@Categoryid int,      
@locationid int,      
@labourrate int      
      
AS       
BEGIN      
if isnull(@productid,0) = 0      
BEGIN      
Insert into Product (Name , Description , SKU, Created_at,Updated_at,Active,Category_id,Location_id,[Labor Rate])      
values       
(@Name,@Description,@SKU,GETDATE(),GETDATE(),1,@Categoryid,@locationid,@labourrate)      
set @productid = SCOPE_IDENTITY();      
END      
ELSE      
BEGIN      
Update Product set Name=@Name,Description=@Description,SKU=@SKU,Updated_at=GETDATE(),Category_id=@Categoryid,Location_id=@locationid,[Labor Rate]=@labourrate      
where Product_Id = @productid      
END    
SELECT CAST(@productid AS VARCHAR(50)) + '|' AS [Message]        
  DECLARE @ErrorMessage NVARCHAR(2048);          
  DECLARE @ErrorSeverity INT;          
  DECLARE @ErrorState INT;            
  DECLARE @ERROR_LINE INT;          
  SELECT @ErrorMessage = ERROR_MESSAGE()          
   ,@ErrorSeverity = ERROR_SEVERITY()          
   ,@ErrorState = ERROR_STATE()          
   ,@ERROR_LINE=ERROR_LINE();     
 SELECT '0|'+@ErrorMessage          
  RAISERROR (          
    @ErrorMessage          
    ,@ErrorSeverity          
    ,@ErrorState          
    );          
END
GO
create or alter   proc Sp_SaveProductsRmRelations    
@pmrid int,        
@Productid int,        
@RMId int,        
@RequiredQty decimal        
    
AS         
BEGIN        
if isnull(@pmrid,0) = 0        
BEGIN        
Insert into Product_RM_usage(Product_id , Rawmaterial_id , Required_qty)        
values         
(@Productid,@RMId,@RequiredQty)        
set @pmrid = SCOPE_IDENTITY();        
END        
ELSE        
BEGIN        
Update Product_RM_usage set Product_id=@Productid,Rawmaterial_id=@RMId,Required_qty=@RequiredQty    
where PRM_id = @pmrid        
END        
select @pmrid        
END    
GO
  create  or alter  proc Sp_SaveSubProductsRmRelations      
@PSR_id int,          
@Productid int,          
@SubProduct_id int,          
@RequiredQty decimal          
      
AS           
BEGIN          
if isnull(@PSR_id,0) = 0          
BEGIN          
Insert into Product_Subproduct_relation(Product_id , SubProduct_id , Required_qty)          
values           
(@Productid,@SubProduct_id,@RequiredQty)          
set @PSR_id = SCOPE_IDENTITY();          
END          
ELSE          
BEGIN          
Update Product_Subproduct_relation set Product_id=@Productid,SubProduct_id=@SubProduct_id,Required_qty=@RequiredQty      
where PSR_id = @PSR_id          
END          
select @PSR_id          
END 
GO
  create  or alter proc DeleteProducts  
@id int  
as   
BEGIN  
Update Product set Active = 0 where Product_Id = @id  
select ''  
END 
GO
create or alter  proc DeleteProductsRmRelation    
@id int    
as     
BEGIN    
delete from Product_RM_usage where PRM_id = @id    
select ''    
END 
Go
  
create  or alter proc DeleteProductsSubproductRelation    
@id int    
as     
BEGIN    
delete from Product_Subproduct_relation where PSR_id = @id    
select ''    
END 
GO
CREATE  or alter proc sp_ProductRmRelation    
@Productid int    
AS     
Begin    
Select PM.*, M.unit_type from Product_RM_usage pm  
INNER JOIN Raw_Material rm ON RM.Rawmaterial_Id = PM.Rawmaterial_id  
INNER JOIN Measurement_unit M on M.unit_id = rm.unit_id  
where Product_id = @Productid    
END 
GO
create  or alter proc unittyppe  
AS  
BEGIN  
Select * from Measurement_unit  
END  
GO
  
create or alter  proc GetRawMaterialList  
as  
Begin  
select * from Raw_Material where Active = 1  
End
GO
create or alter  proc SaveRawMaterial  
@id int,  
@name varchar(30),  
@description varchar(400),  
@sku int,  
@unitid int,  
@categoryid int,  
@Location_id int  
AS  
BEGIN  
if isnull(@id,0) = 0  
Begin  
Insert into Raw_Material(Name,Description,SKU,unit_id,Created_at,Updated_at,Active,Category_id,Location_id)  
values  
(@name,@description,@sku,@unitid,GETDATE(),GETDATE(),1,@categoryid,@Location_id)  
END  
ELSE  
update Raw_Material set Name = @name , Description = @description,SKU = @sku , unit_id = @unitid , Updated_at = GETDATE(),Category_id = @categoryid , Location_id = @Location_id where Rawmaterial_Id = @id  
select ''  
END  
 Go
 create  or alter  proc DeketeRawMaterial  
@id int  
As  
Begin  
update Raw_Material set Active = 0 where Rawmaterial_Id = @id  
select ''  
END
GO
create  or alter  proc sp_ReadSubProduct  
AS  
BEGIN  
Select *,[Labour rate] as Labour_rate from Sub_Product where Active = 1  
END  
GO
create  or alter    proc Sp_SavesubProducts        
@subproductid int,        
@Name varchar(400),        
@Description varchar(400),        
@SKU int,        
@locationid int,        
@labourrate int,        
@unitid int        
AS         
BEGIN        
if isnull(@subproductid,0) = 0        
BEGIN        
Insert into Sub_Product (Name , Description , SKU, Created_at,Updated_at,Active,Location_id,unit_id,[Labour rate])        
values         
(@Name,@Description,@SKU,GETDATE(),GETDATE(),1,@locationid,@unitid,@labourrate)        
set @subproductid = SCOPE_IDENTITY();        
END        
ELSE        
BEGIN        
Update Sub_Product set Name=@Name,Description=@Description,SKU=@SKU,Updated_at=GETDATE(),Location_id=@locationid,[Labour rate]=@labourrate,unit_id = @unitid        
where SubProduct_Id = @subproductid        
END      
SELECT CAST(@subproductid AS VARCHAR(50)) + '|' AS [Message]          
  DECLARE @ErrorMessage NVARCHAR(2048);            
  DECLARE @ErrorSeverity INT;            
  DECLARE @ErrorState INT;              
  DECLARE @ERROR_LINE INT;            
  SELECT @ErrorMessage = ERROR_MESSAGE()            
   ,@ErrorSeverity = ERROR_SEVERITY()            
   ,@ErrorState = ERROR_STATE()            
   ,@ERROR_LINE=ERROR_LINE();       
 SELECT '0|'+@ErrorMessage            
  RAISERROR (            
    @ErrorMessage            
    ,@ErrorSeverity            
    ,@ErrorState            
    );            
END  
GO
CREATE   or alter   proc sp_SubProductRmRelation  
@SubProductid int  
AS  
Begin    
 Select PM.*, M.unit_type from Subproduct_RM_usage pm    
 INNER JOIN Raw_Material rm ON RM.Rawmaterial_Id = PM.Rawmaterial_id    
 INNER JOIN Measurement_unit M on M.unit_id = rm.unit_id    
 where Subproduct_id = @SubProductid  
END   
GO
create   or alter  proc Sp_SaveSubProductsRmRelationsForSubProducts      
@spmrid int,          
@SubProductid int,          
@RMId int,          
@RequiredQty decimal          
AS           
BEGIN          
if isnull(@spmrid,0) = 0          
BEGIN          
Insert into Subproduct_RM_usage(Subproduct_id , Rawmaterial_id , Required_qty)          
values           
(@SubProductid,@RMId,@RequiredQty)          
set @spmrid = SCOPE_IDENTITY();          
END          
ELSE          
BEGIN          
Update Subproduct_RM_usage set Subproduct_id=@SubProductid,Rawmaterial_id=@RMId,Required_qty=@RequiredQty      
where SPRM_id = @spmrid          
END          
select ''          
END      
Go
create   or alter proc DeleteSubProductRmUsage      
@id int      
as       
BEGIN      
delete from Subproduct_RM_usage where SPRM_id = @id      
select ''      
END 
Go
create   or alter proc DeletSubProduct  
@id int  
AS  
BEGIN  
update Sub_Product set Active = 0 where SubProduct_Id = @id  
select ''  
END  
Go
create   or alter proc GetAllActiveMembers  
as  
Begin   
select * , [Deposit Amount] as Deposit_Amount , F_Name +' '+ L_Name as FullName from Member where Status = 1  
END
Go
create  or alter   proc BindTranById  
@id int  
as   
Begin  
Select *,Required_Qty as Required_Qty,[Total_Weight given] as Total_Weight_given , [Actual_piece_labor rate] as Actual_piece_labor_rate from [Transaction] where Trx_id = @id  
END
GO
create   or alter  proc GetMemberDropdown    
@id int    
as    
Begin    
if isnull(@id,0) = 0    
BEGIN    
Select [Deposit Amount] as Deposit_Amount , *,F_Name +' '+ L_Name as FullName from Member     
END    
ELSE    
BEGIN    
Select [Deposit Amount] as Deposit_Amount , *,F_Name +' '+ L_Name as FullName from Member where Member_id = @id    
END    
END    
GO
CREATE  or alter  PROC GetProductList    
AS    
BEGIN    
select *,[Labor Rate] as Labor_Rate from Product where Active = 1    
END
Go
create   or alter PROC GetProductListAsPerProductId    
@id int  
AS    
BEGIN    
select *,[Labor Rate] as Labor_Rate from Product where Active = 1  and Product_Id = @id  
END
Go
Create   or alter PROC GetSubProductList  
AS  
BEGIN  
select *,[Labour rate] as Labour_rate  from Sub_Product where Active = 1  
END
Go
CREATE  or alter  proc GetTranDetailsOnMembers        
 @contact_no VARCHAR(10) ,  
 @productid int,  
 @subproductid int  
AS        
BEGIN        
        
      
  DECLARE @member_id INT        
SELECT @member_id = Member_id FROM dbo.Member WHERE Contact_no = @contact_no        
  SELECT t.Trx_id,T.Member_id,p.Name AS productname,sp.Name as subproductname,t.Required_Qty,t.[Total_Weight given] as Total_Weight_given,        
t.Total_weight_recieved,t.Recieved_qty,t.Order_date,t.Return_date,t.Actual_return_date,t.Is_completed        
FROM dbo.[Transaction] t        
inner JOIN dbo.Member m ON m.Member_id=t.member_id    
inner join dbo.Transaction_details TD on td.Trx_id = T.Trx_id  
inner JOIN dbo.Product p ON p.Product_Id=t.Product_id        
inner JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=isnull(t.subproduct_id,td.subproduct_id)        
WHERE m.Member_id=@member_id or T.Product_id =   @productid or td.subproduct_id =@subproductid  
        
        
        
--SELECT t.Trx_id,p.Name as productname ,sp.Name as subproductname,t.[Total_Weight given],t.Required_Qty,t.Total_weight_recieved,t.Recieved_qty,t.Order_date,t.Return_date,t.Actual_return_date,        
--t.Is_completed,t.Piece_Labor_Rate,t.[Actual_piece_labor rate] as Actual_piece_labor_rate,[Actual_piece_labor rate]*Required_Qty AS transaction_amount        
--FROM dbo.[Transaction] t        
--LEFT JOIN dbo.Member m ON m.Member_id=t.Member_id        
--LEFT JOIN dbo.Product p ON p.Product_Id = t.Product_id        
--LEFT JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=t.subproduct_id        
--WHERE m.Member_id=@member_id        
END  
Go
--CREATE   PROC sp_getproduct_rm         
----declare        
--@product_id INT,          
--@Qty int       
--AS           
        
CREATE  or alter  PROC sp_getproduct_rm        
--declare  
@product_id INT,          
@Qty int,  
@id int   
AS  
BEGIN          
  if @id = 0  
  BEGIN  
  SELECT distinct p.Name AS product_name,'Rawmaterial' AS type,r.Name AS Material,PR.Required_qty*@Qty as Totalqty,mu.unit_type , 0.00 as Given_qty FROM          
Product P        
 JOIN dbo.Product_RM_usage PR ON p.Product_Id = PR.Product_id          
 JOIN dbo.Raw_Material r ON r.Rawmaterial_Id=pr.Rawmaterial_id          
 JOIN dbo.Measurement_unit mu ON mu.unit_id=r.unit_id          
 left join [Transaction] T on T.Product_id = P.Product_Id        
 left join Transaction_details TD on td.Trx_id = T.Trx_id  
WHERE P.Product_id =@product_id          
UNION          
SELECT distinct p.Name AS product_name,'Subproduct' AS type,sp.Name AS Material,psr.Required_qty*@Qty as Totalqty,mu.unit_type,0.00 as Given_qty  FROM          
 Product p          
 JOIN dbo.Product_Subproduct_relation PSR ON p.Product_Id = PSR.Product_id          
 JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=PSR.SubProduct_id          
  JOIN dbo.Measurement_unit mu ON mu.unit_id=sp.unit_id          
   left join [Transaction] T on T.Product_id = P.Product_Id        
   left join Transaction_details TD on td.Trx_id = T.Trx_id     
WHERE P.Product_id =@product_id          
          
  END  
  else  
  BEGIN  
SELECT distinct p.Name AS product_name,'Rawmaterial' AS type,r.Name AS Material,PR.Required_qty*@Qty as Totalqty,mu.unit_type , TD.Given_qty as Given_qty FROM          
Product P        
 JOIN dbo.Product_RM_usage PR ON p.Product_Id = PR.Product_id          
 JOIN dbo.Raw_Material r ON r.Rawmaterial_Id=pr.Rawmaterial_id          
 JOIN dbo.Measurement_unit mu ON mu.unit_id=r.unit_id          
 inner join [Transaction] T on T.Product_id = P.Product_Id        
 inner join Transaction_details TD on td.Trx_id = T.Trx_id  
WHERE P.Product_id =@product_id          
UNION          
SELECT distinct p.Name AS product_name,'Subproduct' AS type,sp.Name AS Material,psr.Required_qty*@Qty as Totalqty,mu.unit_type,TD.Given_qty as Given_qty  FROM          
 Product p          
 JOIN dbo.Product_Subproduct_relation PSR ON p.Product_Id = PSR.Product_id          
 JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=PSR.SubProduct_id          
  JOIN dbo.Measurement_unit mu ON mu.unit_id=sp.unit_id          
   inner join [Transaction] T on T.Product_id = P.Product_Id        
   inner join Transaction_details TD on td.Trx_id = T.Trx_id     
WHERE P.Product_id =@product_id          
     END     
END 
Go
CREATE  or alter  PROC sp_getsubproduct_rm (@subproduct_id INT,@Qty int)    
AS     
  
    
--DECLARE  @subproduct_id INT =1  
--,@Qty INT =11  
    
BEGIN    
  
    
SELECT distinct p.Name AS product_name,'Subproduct' AS type,R.Name AS Material,psr.Required_qty*@Qty as Totalqty,mu.unit_type,ISNULL(TD.Given_qty,0) as Given_qty  FROM        
 Sub_Product p        
        
 JOIN dbo.Subproduct_RM_usage PSR ON p.SubProduct_Id = PSR.SubProduct_id    
  JOIN dbo.Raw_Material r ON r.Rawmaterial_Id=PSR.Rawmaterial_id    
      
  JOIN dbo.Measurement_unit mu ON mu.unit_id=p.unit_id        
   right join [Transaction] T on T.Product_id = P.SubProduct_Id      
   right join Transaction_details TD on td.subproduct_id = psr.Subproduct_id   
WHERE P.SubProduct_Id = @subproduct_id        
END
  Go
  CREATE   or alter   proc sp_saveTransaction       
@trxid int,      
@member_id int,      
@product_id INT,      
@subproduct_id INT,      
@reqqty decimal,            
@totalwtgiven decimal,            
@orderdate datetime,            
@returndate datetime,            
@pclbrrate decimal,            
@Actlpclbrrate decimal,      
@totalactAmount decimal      
            
AS             
BEGIN            
if isnull(@trxid,0) = 0            
BEGIN            
INSERT INTO dbo.[Transaction]      
(      
    Member_id,      
    Product_id,      
    subproduct_id,      
    Required_Qty,      
    [Total_Weight given],      
    Order_date,      
    Return_date,      
    Is_completed,      
    Piece_Labor_Rate,      
    [Actual_piece_labor rate],      
    Total_Actual_Amount      
)      
values (@member_id,@product_id,@subproduct_id,@reqqty,@totalwtgiven,@orderdate,@returndate,0,@pclbrrate,@Actlpclbrrate,@totalactAmount)      
set @trxid = SCOPE_IDENTITY();            
END            
ELSE            
BEGIN            
Update dbo.[Transaction] set       
 Member_id = @member_id,      
    Product_id = @product_id,      
    subproduct_id = @subproduct_id,      
    Required_Qty = @reqqty,      
    [Total_Weight given] = @totalwtgiven,      
    Order_date = @orderdate,      
    Return_date = @returndate,      
    Piece_Labor_Rate = @pclbrrate,      
    [Actual_piece_labor rate] = @Actlpclbrrate,      
    Total_Actual_Amount = @totalactAmount      
where Trx_id = @trxid            
END     
 delete from Transaction_details where Trx_id = @trxid  
SELECT CAST(@trxid AS VARCHAR(50)) + '|' AS [Message]              
  DECLARE @ErrorMessage NVARCHAR(2048);                
  DECLARE @ErrorSeverity INT;                
  DECLARE @ErrorState INT;                  
  DECLARE @ERROR_LINE INT;                
  SELECT @ErrorMessage = ERROR_MESSAGE()                
   ,@ErrorSeverity = ERROR_SEVERITY()                
   ,@ErrorState = ERROR_STATE()                
   ,@ERROR_LINE=ERROR_LINE();           
 SELECT '0|'+@ErrorMessage                
  RAISERROR (                
    @ErrorMessage                
    ,@ErrorSeverity                
    ,@ErrorState                
    );                
END  
Go
CREATE  or alter proc sp_saveTransactionDetails           
@ID INT ,          
@headerid int,          
@productname varchar(250) = '',            
@type varchar(100) = '',            
@material varchar(250) ='',            
@ttlqty int ,          
@unittype varchar(10) = '',          
@Gqty int ,          
@pending bit,          
@reqQty int          
                  
AS                   
BEGIN              
          
declare @Productid int,@materialid int,@subproductid int          
select @materialid = Rawmaterial_Id from Raw_Material where Name = @material          
          
if @type = 'Rawmaterial'          
Begin          
select @materialid = Rawmaterial_Id from Raw_Material where Name = @material        
--select @Productid = Product_Id from Product where Name = @productname          
 select @subproductid = null         
End          
else          
begin          
select @subproductid = SubProduct_Id from Sub_Product where Name = @material         
set @materialid = null         
End          
      
             
INSERT INTO dbo.[Transaction_details]            
(            
    Trx_id,            
    Rawmaterial_id,            
    subproduct_id,            
    Required_Qty,            
    Given_qty,            
    Is_pending           
)            
values (@headerid,@materialid,@subproductid,@reqQty,@Gqty,@pending)            
        
         
                 
select @ID = SCOPE_IDENTITY()          
SELECT CAST(@ID AS VARCHAR(50)) + '|' AS [Message]                    
  DECLARE @ErrorMessage NVARCHAR(2048);                      
  DECLARE @ErrorSeverity INT;                      
  DECLARE @ErrorState INT;                        
  DECLARE @ERROR_LINE INT;                      
  SELECT @ErrorMessage = ERROR_MESSAGE()                      
   ,@ErrorSeverity = ERROR_SEVERITY()                      
   ,@ErrorState = ERROR_STATE()                      
   ,@ERROR_LINE=ERROR_LINE();                 
 SELECT '0|'+@ErrorMessage                      
  RAISERROR (                      
    @ErrorMessage                      
    ,@ErrorSeverity                      
    ,@ErrorState                      
    );                      
END 
GO
CREATE  or alter proc GetTransactionDetailsBasedOnMembers      
 @trxid int  
 As      
 BEGIN      
      
      
--SELECT t.Trx_id,p.Name AS product,sp.Name as subproduct,t.Required_Qty,t.[Total_Weight given],      
--t.Total_weight_recieved,t.Recieved_qty,t.Order_date,t.Return_date,t.Actual_return_date,t.Is_completed      
--FROM dbo.[Transaction] t      
--LEFT JOIN dbo.Member m ON m.Member_id=t.member_id      
--LEFT JOIN dbo.Product p ON p.Product_Id=t.Product_id      
--LEFT JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=t.subproduct_id      
--WHERE m.Member_id=1      
       
      
      
SELECT td.Trxdetails_id,isnull(r.Name,'') as Material,isnull(sp.Name,'') as subproduct_name,td.Required_qty AS Totalqty,td.Given_qty,td.Is_pending FROM dbo.Transaction_details td      
LEFT JOIN dbo.[Transaction] t ON t.Trx_id=td.Trx_id      
LEFT JOIN dbo.Member m ON m.Member_id=t.member_id      
LEFT JOIN dbo.Raw_Material r ON r.Rawmaterial_Id=td.Rawmaterial_id      
LEFT JOIN dbo.Sub_Product sp ON sp.SubProduct_Id=td.subproduct_id      
WHERE t.Trx_id= @trxid    
      
END      
  GO 
  create  or alter  proc UpdateTransacation  
@trxid int,  
@totalwtrecievded decimal,  
@recievedqty int,  
@actualreturndate datetime,  
@iscomplete bit  
as  
BEGIN  
Update dbo.[Transaction] set         
 Total_weight_recieved = @totalwtrecievded,  
 Recieved_qty = @recievedqty,  
 Actual_return_date = @actualreturndate,  
 Is_completed = @iscomplete  
where Trx_id = @trxid        
select ''  
END  
GO
create  or alter  proc UpdateTransacationDetails  
@trxdetailid int,  
@givenqty decimal  
as  
BEGIN  
Update dbo.[Transaction_details] set         
Given_qty = @givenqty  
where Trxdetails_id = @trxdetailid  
select ''  
END  
 GO
 
  
  
  

 