DROP TABLE IF EXISTS dbo.[Product_Subproduct_relation]
DROP TABLE IF EXISTS dbo.[Subproduct_RM_usage]
DROP TABLE IF EXISTS dbo.[Product_RM_usage]
DROP TABLE IF EXISTS dbo.[Raw_material_supplier_relation]
DROP TABLE IF EXISTS dbo.[Supplier]
alter table dbo.[Transaction] 
SET (SYSTEM_VERSIONING = OFF)
alter table dbo.[Transaction_details] 
SET (SYSTEM_VERSIONING = OFF)

DROP TABLE IF EXISTS dbo.Payment
DROP TABLE IF EXISTS dbo.[Transaction_details]
DROP TABLE IF EXISTS dbo.[Sub_Product]
DROP TABLE IF EXISTS dbo.[Raw_Material]
DROP TABLE IF EXISTS dbo.[Rawmaterial_Category]
DROP TABLE IF EXISTS dbo.[Measurement_unit]
DROP TABLE IF EXISTS dbo.[Transaction_History] 
DROP TABLE IF EXISTS dbo.[Transaction] 
DROP TABLE IF EXISTS dbo.[Product]
DROP TABLE IF EXISTS dbo.[Location]
DROP TABLE IF EXISTS dbo.[Member]
DROP TABLE IF EXISTS dbo.[Memeber_Category] 
DROP TABLE IF EXISTS dbo.[Product_Category] 


DROP TABLE IF EXISTS dbo.[Product_Category] 
CREATE TABLE dbo.[Product_Category] (
  [category_id]  INT IDENTITY(1,1),
  [Name] varchar(30) NOT NULL,
  [Description] varchar(400)  NULL,
  PRIMARY KEY ([category_id])
);

INSERT INTO dbo.Product_Category (name,[Description]) VALUES ('Toran','Bandhdi toran')

DROP TABLE IF EXISTS dbo.[Memeber_Category] 

CREATE TABLE dbo.[Memeber_Category] (
  [member_category_id] INT IDENTITY(1,1),
  [Name] varchar(30) NOT NULL,
  [Description] varchar(400) NULL,
  PRIMARY KEY ([member_category_id])
);

INSERT INTO dbo.[Memeber_Category] (name,[Description]) VALUES ('jeko moti','jeko moti')


DROP TABLE IF EXISTS dbo.[Member]
CREATE TABLE dbo.[Member] (
  [Member_id] INT IDENTITY(1,1),
  [F_Name] varchar(30) NOT NULL,
  [L_Name] varchar(30) NULL,
  [Contact_no] Varchar(10) NOT NULL,
  [Alternate_conatact_no] Varchar(10) NULL,
  [Address] VARCHAR(4000) NULL,
  [Aadhar] varchar(20)  NULL,
  [Deposit Amount] INT NOT NULL,
  [Status] BIT NOT NULL,
  [Created_at] DATETIME NOT NULL ,
  [Updated_at] DATETIME NOT NULL,
  [member_Category_id] INT NOT NULL,
  PRIMARY KEY ([Member_id]),
  CONSTRAINT [FK_Member.member_Category_id]
    FOREIGN KEY ([member_Category_id])
      REFERENCES [Memeber_Category]([member_category_id])
);

ALTER TABLE dbo.Member ADD CONSTRAINT DF_Member_Created_at  DEFAULT GETDATE() FOR Created_at 
ALTER TABLE dbo.Member ADD CONSTRAINT DF_Member_Updated_at  DEFAULT GETDATE() FOR Updated_at
ALTER TABLE dbo.Member ADD CONSTRAINT DF_Member_Status  DEFAULT 1 FOR [Status]

INSERT INTO dbo.Member
(
    F_Name,
    L_Name,
    Contact_no,
    Alternate_conatact_no,
    Address,
    AADHAR,
    [Deposit Amount],
    member_Category_id
)
VALUES
(   'xyz', -- F_Name - varchar(30)
    'Thakkar', -- L_Name - varchar(30)
    1234567890, -- Contact_no - int
    1234567890, -- Alternate_conatact_no - int
    'ngdkakl', -- Address - varchar(400)
    NULL, -- AADHAR - varchar(20)
    500, -- Deposit Amount - int
    1  -- member_Category_id - int
    )

DROP TABLE IF EXISTS dbo.[Location]
CREATE TABLE dbo.[Location] (
  [Location_id] INT IDENTITY(1,1),
  [Name] varchar(30) NOT NULL,
  [Rack] INT NOT NULL,
  PRIMARY KEY ([Location_id])
);

INSERT INTO dbo.[Location] VALUES ('A',1)

DROP TABLE IF EXISTS dbo.[Product]
CREATE TABLE dbo.[Product] (
  [Product_Id] INT IDENTITY(1,1),
  [Name] varchar(30) NOT NULL,
  [Description] varchar(400)  NULL,
  [SKU] INT NOT NULL,
  [Created_at] DATETIME NOT NULL,
  [Updated_at] DATETIME NOT NULL,
  [Active] BIT NOT NULL,
  [Category_id] INT NOT NULL,
  [Location_id] INT NOT NULL,
  [image_url] VARBINARY NULL,
  [Labor Rate] INT NOT NULL,
  PRIMARY KEY ([Product_Id]),
  CONSTRAINT [FK_Product.Category_id]
    FOREIGN KEY ([Category_id])
      REFERENCES [Product_Category]([category_id]),
  CONSTRAINT [FK_Product.Location_id]
    FOREIGN KEY ([Location_id])
      REFERENCES [Location]([Location_id])
);

ALTER TABLE dbo.[Product] ADD CONSTRAINT DF_Product_Created_at  DEFAULT GETDATE() FOR [Created_at] 
ALTER TABLE dbo.[Product] ADD CONSTRAINT DF_Product_Updated_at  DEFAULT GETDATE() FOR [Updated_at]
ALTER TABLE dbo.[Product] ADD CONSTRAINT DF_Product_Active  DEFAULT 1 FOR [Active]

INSERT INTO dbo.Product
(
    Name,
    Description,
    SKU,
    Active,
    Category_id,
    Location_id,
    image_url,
    [Labor Rate]
)
VALUES
(   'PT-1207 Toran', -- Name - varchar(30)
    NULL, -- Description - varchar(400)
    10, -- SKU - int
    1, -- Active - bit
    1, -- Category_id - int
    1, -- Location_id - int
    NULL, -- image_url - varbinary
    15  -- Labor Rate - int
    )

	--SELECT * FROM dbo.Product p
	--JOIN product_rm_usage r ON r.product_id =p.product_id
	--JOIN raw_material rm ON rm.rawmaterial_id=r.rawmaterial_id



/** Object:  Table [dbo].[Transaction]    Script Date: 1/12/2023 10:04:59 PM **/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Transaction](
	[Trx_id] [INT] IDENTITY(1,1) NOT NULL,
	[Member_id] [INT] NOT NULL,
	[Product_id] [INT] NULL,
	[subproduct_id] [INT] NULL,
	[Required_Qty] [INT] NOT NULL,
	[Total_Weight given] [DECIMAL](18, 2) NOT NULL,
	[Total_weight_recieved] [DECIMAL](18, 2) NULL,
	[Recieved_qty] [INT] NULL,
	[Order_date] [DATETIME] NOT NULL,
	[Return_date] [DATETIME] NOT NULL,
	[Actual_return_date] [DATETIME] NULL,
	[Is_completed] [BIT] NOT NULL,
	[Piece_Labor_Rate] [DECIMAL](18, 2) NOT NULL,
	[Actual_piece_labor rate] [DECIMAL](18, 2) NOT NULL,
	[Total_Actual_Amount] [DECIMAL](18, 2) NOT NULL,
	[ValidFrom] [DATETIME2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [DATETIME2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Trx_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[Transaction_History] )
)
GO

ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction.Member_id] FOREIGN KEY([Member_id])
REFERENCES [dbo].[Member] ([Member_id])
GO

ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction.Member_id]
GO

ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_Transaction.Product_id] FOREIGN KEY([Product_id])
REFERENCES [dbo].[Product] ([Product_Id])
GO

ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_Transaction.Product_id]
GO



INSERT INTO [dbo].[Transaction]
           ([Member_id]
           ,[Product_id]
           ,[subproduct_id]
           ,[Required_Qty]
           ,[Total_Weight given]
           ,[Total_weight_recieved]
           ,[Recieved_qty]
           ,[Order_date]
           ,[Return_date]
           ,[Actual_return_date]
           ,[Is_completed]
           ,[Piece_Labor_Rate]
           ,[Actual_piece_labor rate]
           ,[Total_Actual_Amount])
     VALUES
           (1,1,NULL,10,15,NULL,NULL,GETDATE(),GETDATE()+15,NULL,0,15,17,1500)
GO



--ALTER TABLE dbo.[Transaction_History] ADD CONSTRAINT DF_Transaction_History_Created_at  DEFAULT GETDATE() FOR [Created_at] 
--ALTER TABLE dbo.[Transaction_History] ADD CONSTRAINT DF_Transaction_History_Updated_at  DEFAULT GETDATE() FOR [Updated_at] 

DROP TABLE IF EXISTS dbo.[Measurement_unit]
CREATE TABLE dbo.[Measurement_unit] (
  [unit_id] INT IDENTITY(1,1),
  [unit_type] varchar(30) NOT NULL,
  PRIMARY KEY ([unit_id])
);

INSERT INTO dbo.Measurement_unit
(
    unit_type
)
VALUES
('kg' -- unit_type - varchar(30)
    ),('Piece')

DROP TABLE IF EXISTS dbo.[Rawmaterial_Category]
CREATE TABLE dbo.[Rawmaterial_Category] (
  [category_id] INT IDENTITY(1,1),
  [Name] varchar(30) NOT NULL,
  [Description] varchar(400) NULL,
  PRIMARY KEY ([category_id])
);

INSERT INTO dbo.[Rawmaterial_Category] 
VALUES (
'default','default')

DROP TABLE IF EXISTS dbo.[Raw_Material]
CREATE TABLE dbo.[Raw_Material] (
  [Rawmaterial_Id] INT IDENTITY(1,1),
  [Name] varchar(30) NOT NULL,
  [Description] varchar(400) NULL,
  [SKU] decimal(18,2) NOT NULL,
  [unit_id] INT NOT NULL,
  [Created_at] DATETIME NOT NULL,
  [Updated_at] DATETIME NOT NULL,
  [Active] BIT NOT NULL,
  [Category_id] INT NOT NULL,
  [Location_id] INT NOT NULL,
  [image_url] VARBINARY  NULL,
  PRIMARY KEY ([Rawmaterial_Id]),
  CONSTRAINT [FK_Raw_Material.Rawmaterial_Id]
    FOREIGN KEY (unit_id)
      REFERENCES [Measurement_unit]([unit_id]),
  CONSTRAINT [FK_Raw_Material.Location_id]
    FOREIGN KEY ([Location_id])
      REFERENCES [Location]([Location_id]),
  CONSTRAINT [FK_Raw_Material.Category_id- Remove]
    FOREIGN KEY ([Category_id])
      REFERENCES [Rawmaterial_Category]([category_id])
);

ALTER TABLE dbo.[Raw_Material] ADD CONSTRAINT DF_Raw_material_Product_Created_at  DEFAULT GETDATE() FOR [Created_at] 
ALTER TABLE dbo.[Raw_Material] ADD CONSTRAINT DF_Raw_material_Product_Updated_at  DEFAULT GETDATE() FOR [Updated_at]
ALTER TABLE dbo.[Raw_Material] ADD CONSTRAINT DF_Raw_material_Product_Active DEFAULT 1 FOR Active



INSERT INTO dbo.Raw_Material
(
    Name,
    Description,
    SKU,
    unit_id,
    Active,
    Category_id,
    Location_id,
    image_url
)
VALUES
(   '30mm beads', -- Name - varchar(30)
    NULL, -- Description - varchar(400)
    5000, -- SKU - decimal(18, 2)
    1, -- unit_id - int
    1, -- Active - bit
    1, -- Category_id - int
    1, -- Location_id - int
    NULL  -- image_url - varbinary
    ),( '8mm beads', -- Name - varchar(30)
    NULL, -- Description - varchar(400)
    4000, -- SKU - decimal(18, 2)
    1, -- unit_id - int
    1, -- Active - bit
    1, -- Category_id - int
    1, -- Location_id - int
    NULL  -- image_url - varbinary
	),
	( 'steel patti', -- Name - varchar(30)
    NULL, -- Description - varchar(400)
    50, -- SKU - decimal(18, 2)
    2, -- unit_id - int
    1, -- Active - bit
    1, -- Category_id - int
    1, -- Location_id - int
    NULL  -- image_url - varbinary
	),('14 mm Fruitball', -- Name - varchar(30)
    NULL, -- Description - varchar(400)
    5058, -- SKU - decimal(18, 2)
    1, -- unit_id - int
    1, -- Active - bit
    1, -- Category_id - int
    1, -- Location_id - int
    NULL  -- image_url - varbinary
	)


	--SELECT * FROM dbo.Raw_Material

DROP TABLE IF EXISTS dbo.[Sub_Product]
CREATE TABLE dbo.[Sub_Product] (
  [SubProduct_Id] INT IDENTITY(1,1),
  [Name] varchar(30) NOT NULL,
  [Description] varchar(400) NULL,
  [SKU] INT NOT NULL,
  [Created_at] DATETIME NOT NULL,
  [Updated_at] DATETIME NOT NULL,
  [Active] BIT NOT NULL,
  [Location_id] INT NOT NULL,
  [image_url] VARBINARY NULL,
  [unit_id] INT NOT NULL,
  [Labour rate] INT NOT NULL,
  PRIMARY KEY ([SubProduct_Id])
);

ALTER TABLE dbo.[Sub_Product] ADD CONSTRAINT DF_Sub_Product_Created_at  DEFAULT GETDATE() FOR [Created_at] 
ALTER TABLE dbo.[Sub_Product] ADD CONSTRAINT DF_Sub_Product_Updated_at  DEFAULT GETDATE() FOR [Updated_at]
ALTER TABLE dbo.[Sub_Product] ADD CONSTRAINT DF_Sub_Product_Active DEFAULT 1 FOR Active

ALTER TABLE dbo.Sub_Product
ADD
CONSTRAINT [FK_Sub_Product.subproduct_id]
    FOREIGN KEY (unit_id)
      REFERENCES [Measurement_unit]([unit_id])

INSERT INTO dbo.Sub_Product
(
    Name,
    Description,
    SKU,
    Created_at,
    Updated_at,
    Location_id,
    image_url,
	[unit_id],
    [Labour rate]
)
VALUES
(   'Madhela Katha Small',        -- Name - varchar(30)
    NULL,      -- Description - varchar(400)
    0,         -- SKU - int
    GETDATE(), -- Created_at - datetime
    GETDATE(), -- Updated_at - datetime
    0,         -- Location_id - int
    NULL, 
	2,-- image_url - varbinary
    2          -- Labour rate - int
    )

DROP TABLE IF EXISTS dbo.[Transaction_details]
CREATE TABLE dbo.[Transaction_details] (
  [Trxdetails_id] INT IDENTITY(1,1),
  [Trx_id] INT NOT NULL,
  [Rawmaterial_id] INT NOT NULL,
  [subproduct_id] INT NOT NULL,
  [Required_qty] decimal(18,2) NOT NULL,
  [Given_qty] decimal(18,2) NOT NULL,
  [Is_pending] BIT NOT NULL,
  [ValidFrom] [DATETIME2](7) GENERATED ALWAYS AS ROW START NOT NULL,
  [ValidTo] [DATETIME2](7) GENERATED ALWAYS AS ROW END NOT NULL,
  PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo]),
  
  PRIMARY KEY ([Trxdetails_id]),
  CONSTRAINT [FK_Transaction_details.Trxdetails_id]
    FOREIGN KEY ([Trx_id])
      REFERENCES [Transaction]([Trx_id]),
  CONSTRAINT [FK_Transaction_details.Rawmaterial_id]
    FOREIGN KEY ([Rawmaterial_id])
      REFERENCES [Raw_Material]([Rawmaterial_Id]),
  CONSTRAINT [FK_Transaction_details.subproduct_id]
    FOREIGN KEY ([subproduct_id])
      REFERENCES [Sub_Product]([SubProduct_Id])
	  ) 
	  WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [dbo].[Transaction_details_history] )
)


INSERT INTO dbo.Transaction_details
(
    Trx_id,
    Rawmaterial_id,
    subproduct_id,
    Required_qty,
    Given_qty,
    Is_pending
)
VALUES
(   1,       -- Trx_id - int
    1,       -- Rawmaterial_id - int
    1,       -- subproduct_id - int
    1,    -- Required_qty - decimal(18, 2)
    50,    -- Given_qty - decimal(18, 2)
    0   -- Is_pending - bit
    )
	

DROP TABLE IF EXISTS dbo.Payment
CREATE TABLE dbo.[Payment] (
  [Payment_id] INT IDENTITY(1,1),
  [Member_id] INT NOT NULL,
  [Trx_id] INT NOT NULL,
  [Payment_date] INT NOT NULL,
  [Mode] INT NOT NULL,
  [created_at] varchar(20) NOT NULL,
  [updated_at] varchar(20) NOT NULL,
  PRIMARY KEY ([Payment_id]),
  CONSTRAINT [FK_Payment.Trx_id]
    FOREIGN KEY ([Trx_id])
      REFERENCES [Transaction]([Trx_id]),
  CONSTRAINT [FK_Payment.Member_id]
    FOREIGN KEY ([Member_id])
      REFERENCES [Member]([Member_id])
);

ALTER TABLE dbo.[Payment] ADD CONSTRAINT DF_Payment_Created_at  DEFAULT GETDATE() FOR [Created_at] 
ALTER TABLE dbo.[Payment] ADD CONSTRAINT DF_Payment_Updated_at  DEFAULT GETDATE() FOR [Updated_at]


DROP TABLE IF EXISTS dbo.[Supplier]
CREATE TABLE dbo.[Supplier] (
  [supplier_id] INT IDENTITY(1,1),
  [Name] varchar(30) NOT NULL,
  [Contact_Person] VARCHAR(30) NULL,
  [Description] varchar(400) NULL,
  [Contact] VARCHAR(10) NULL,
  [city] VARCHAR(20) NOT NULL,
  PRIMARY KEY ([supplier_id])
);

DROP TABLE IF EXISTS dbo.[Raw_material_supplier_relation]
CREATE TABLE dbo.[Raw_material_supplier_relation] (
  [RMS_id] INT IDENTITY(1,1),
  [supplier_id] INT NOT NULL,
  [Rawmaterial_Id] INT NOT NULL,
  PRIMARY KEY ([RMS_id]),
  CONSTRAINT [FK_Raw_material_supplier_relation.Rawmaterial_Id]
    FOREIGN KEY ([Rawmaterial_Id])
      REFERENCES [Raw_Material]([Rawmaterial_Id]),
  CONSTRAINT [FK_Raw_material_supplier_relation.supplier_id]
    FOREIGN KEY ([supplier_id])
      REFERENCES [Supplier]([supplier_id])
);

DROP TABLE IF EXISTS dbo.[Product_RM_usage]
CREATE TABLE dbo.[Product_RM_usage] (
  [PRM_id] INT IDENTITY(1,1),
  [Product_id] INT NOT NULL,
  [Rawmaterial_id] INT NOT NULL,
  [Required_qty] decimal(18,2) NOT NULL,
  PRIMARY KEY ([PRM_id]),
  CONSTRAINT [FK_Product_RM_usage.Product_id]
    FOREIGN KEY ([Product_id])
      REFERENCES [Product]([Product_Id]),
  CONSTRAINT [FK_Product_RM_usage.Rawmaterial_id]
    FOREIGN KEY ([Rawmaterial_id])
      REFERENCES [Raw_Material]([Rawmaterial_Id])
);

ALTER TABLE dbo.Product_RM_usage
ADD CONSTRAINT UQ_Product_RM_usage UNIQUE (Product_id,Rawmaterial_id)



INSERT INTO dbo.Product_RM_usage
(
    Product_id,
    Rawmaterial_id,
    Required_qty
)
VALUES
(   1,   -- Product_id - int
    1,   -- Rawmaterial_id - int
    0.05 -- Required_qty - decimal(18, 2)
    ),(  1,   -- Product_id - int
    2,   -- Rawmaterial_id - int
    10 -- Required_qty - decimal(18, 2)
    ),(   1,   -- Product_id - int
    3,   -- Rawmaterial_id - int
    0.10 -- Required_qty - decimal(18, 2)
    ),
	( 1,   -- Product_id - int
    4,   -- Rawmaterial_id - int
    1 -- Required_qty - decimal(18, 2)
    )

DROP TABLE IF EXISTS dbo.[Subproduct_RM_usage]
CREATE TABLE dbo.[Subproduct_RM_usage] (
  [SPRM_id] INT IDENTITY(1,1),
  [Subproduct_id] INT NOT NULL,
  [Rawmaterial_id] INT NOT NULL,
  [Required_qty] decimal(18,2) NOT NULL,
  PRIMARY KEY ([SPRM_id]),
  CONSTRAINT [FK_Subproduct_RM_usage.Subproduct_id]
    FOREIGN KEY ([Subproduct_id])
      REFERENCES [Sub_Product]([SubProduct_Id]),
  CONSTRAINT [FK_Subproduct_RM_usage.Rawmaterial_id]
    FOREIGN KEY ([Rawmaterial_id])
      REFERENCES [Raw_Material]([Rawmaterial_Id])
);

INSERT INTO dbo.Subproduct_RM_usage
(
    Subproduct_id,
    Rawmaterial_id,
    Required_qty
)
VALUES
(   1,   -- Subproduct_id - int
    1,   -- Rawmaterial_id - int
    0.5 -- Required_qty - decimal(18, 2)
    ),(1,2,10)


DROP TABLE IF EXISTS dbo.[Product_Subproduct_relation]
CREATE TABLE dbo.[Product_Subproduct_relation] (
  [PSR_id] INT IDENTITY(1,1),
  [Product_id] INT NOT NULL,
  [SubProduct_id] INT NOT NULL,
  [Required_qty] DECIMAL(18,2) NOT NULL,
  PRIMARY KEY ([PSR_id]),
  CONSTRAINT [FK_Product_Subproduct_relation.SubProduct_id]
    FOREIGN KEY ([SubProduct_id])
      REFERENCES [Sub_Product]([SubProduct_Id]),
  CONSTRAINT [FK_Product_Subproduct_relation.Product_id]
    FOREIGN KEY ([Product_id])
      REFERENCES [Product]([Product_Id])
);



ALTER TABLE dbo.Product_Subproduct_relation 
ADD CONSTRAINT UQ_Product_Subproduct_relation UNIQUE (Product_id,SubProduct_id)

INSERT INTO dbo.Product_Subproduct_relation
(
    Product_id,
    SubProduct_id,
    Required_qty
)
VALUES
(   1,   -- Product_id - int
    1,   -- SubProduct_id - int
    2 -- Required_qty - decimal(18, 2)
    )
    
    
     ALTER TABLE Transaction_details
ALTER COLUMN Rawmaterial_id INT NULL;

  ALTER TABLE Transaction_details
ALTER COLUMN subproduct_id INT NULL;

  ALTER TABLE [TRANSACTION]
ALTER COLUMN Product_id INT NULL;

  ALTER TABLE [TRANSACTION]
ALTER COLUMN subproduct_id INT NULL;

DROP TABLE IF EXISTS Menus

CREATE TABLE [dbo].[Menus](
	[MenuId] [int] IDENTITY(1,1) NOT NULL,
	[ParentMenuId] [int] NULL,
	[Name] [varchar](100) NOT NULL,
	[ImagePath] [varchar](100) NULL,
	[Controller] [varchar](50) NULL,
	[Action] [varchar](100) NULL,
	[IsActive] [bit] NOT NULL,
	[DispalyOrder] [int] NULL,
 CONSTRAINT [PK_Menu] PRIMARY KEY CLUSTERED 
(
	[MenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


insert into Menus(ParentMenuId,Name,ImagePath,Controller,Action,IsActive,DispalyOrder)
		   values 
		   (0,'Products',null,'Products','Index',1,1)
