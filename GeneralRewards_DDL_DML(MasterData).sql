CREATE DATABASE Projects
GO

USE Projects
GO

-- TRANSACTIONAL TABLE - OfferDetails
DROP TABLE IF EXISTS [dbo].[GeneralAndTripleReward_OfferDetails]
CREATE TABLE [dbo].[GeneralAndTripleReward_OfferDetails]
(
	[OfferDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[Offer_Category] [varchar](255) NULL,
	[Offer_By] [varchar](255) NULL,
	[Offer_Type] [varchar](255) NULL,
	[Offer_Mode] [varchar](100) NULL,
	[Cashback_Amount] [decimal](18, 4) NULL,
	[Cashback_Percentage] [decimal](18, 4) NULL,
	[Discount_Amount] [decimal](18, 4) NULL,
	[Discount_Percentage] [decimal](18, 4) NULL,
	[Minimum_Purchase_value] [decimal](18, 4) NULL,
	[Upto_Amount] [decimal](18, 4) NULL,
	[Buy_cnt] [decimal](18, 4) NULL,
	[Get_cnt] [decimal](18, 4) NULL,
	[Offer_Validity_From_Date] [datetime] NULL,
	[Offer_Validity_To_Date] [datetime] NULL,
	[Merchant_Id] VARCHAR(150) NULL,
	[Source_Unique_Id] VARCHAR(150) NULL,
	[Business_Legal_Name] [varchar](500) NULL,
	[Business_Display_Name] [varchar](500) NULL,
	[Business_Category] [varchar](500) NULL,
	[Offer_Id] [varchar](255) NULL,
	[createdDate] [datetime] NULL,
	[Freebie_Product_Name] [varchar](255) NULL,
	[Template_Type] [varchar](255) NULL,
	[Event_Type] [varchar](255) NULL,
	[Language] [varchar](255) NULL,
	[Communication_Message] [nvarchar](max) NULL,
	[Offer_Banner] [varchar](255) NULL,
	[Additional_Info_1] [varchar](1000) NULL,
	[Additional_Info_2] [varchar](1000) NULL,
	[Additional_Info_3] [varchar](1000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

-- Audit table for all the procedures
DROP TABLE IF EXISTS [dbo].[GeneralReward_adtSQLAuditLog]
CREATE TABLE [dbo].[GeneralReward_adtSQLAuditLog]
(
	[SQLAuditLogID] [bigint] IDENTITY(1,1) NOT NULL,
	[ObjectName] [varchar](100) NULL,		
	[StepID] [int] NOT NULL,
	[StepDesc] [varchar](100) NULL,
	[RunDttm] [datetime] NOT NULL,
	[ErrorDescription] [varchar](500) NULL, 
	[UserName] [varchar](50) NULL,			
	[MachineName] [varchar](50) NULL,		
 CONSTRAINT [GeneralReward_PK_adtSQLAuditLog_SQLADTID] PRIMARY KEY CLUSTERED 
(
	[SQLAuditLogID] ASC
))
GO

-- Festival Master - If it is already created - you can rename it to this name
DROP TABLE IF EXISTS [dbo].[GeneralReward_FestivalMaster]
CREATE TABLE [dbo].[GeneralReward_FestivalMaster]
(
	[FestivalMasterId] [int] IDENTITY(1,1) NOT NULL,
	[Event] [varchar](50) NULL,
	[EventStartDate] [date] NULL,
	[EventEndDate] [date] NULL,
	[IsActive] [bit] NULL,
	[DeactivatedOn] [datetime] NULL
) ON [PRIMARY]
GO

-- Language Master table to store language information
DROP TABLE IF EXISTS [dbo].[GeneralReward_LanguageMaster]
CREATE TABLE [dbo].[GeneralReward_LanguageMaster]
(
	[LanguageMasterId] [int] IDENTITY(1,1) NOT NULL,
	[Language] [varchar](50) NULL,
	[IsActive] [bit] NULL,
	[DeactivatedOn] [datetime] NULL
) ON [PRIMARY]
GO

-- Mechant Data Master - Holds master information of Merchant
SELECT * FROM [dbo].[GeneralReward_MerchantData]

DROP TABLE IF EXISTS [dbo].[GeneralReward_MerchantData]
CREATE TABLE [dbo].[GeneralReward_MerchantData]
(
    [MerchantDataId]        BIGINT IDENTITY(1,1) NOT NULL,
    [Merchant_Id]           VARCHAR(150) NULL,
    [Source_Unique_Id]      VARCHAR(150) NULL,
    [BusinessLegalName]     VARCHAR(250) NULL,
    [BusinessDisplayName]   VARCHAR(250) NULL,
    [BusinessCategory]      VARCHAR(100) NULL,
    [Created_Date]          DATETIME NULL,
    [PageName]              VARCHAR(100) NULL
);
GO

-- Category Master
SELECT * FROM [dbo].[GeneralReward_OfferCategoryMaster]

DROP TABLE IF EXISTS [dbo].[GeneralReward_OfferCategoryMaster]
CREATE TABLE [dbo].[GeneralReward_OfferCategoryMaster]
(
	[OfferCategoryMasterId] [int] IDENTITY(1,1) NOT NULL,
	[OfferCategory] [varchar](50) NULL,
	IsActive BIT DEFAULT(1)
PRIMARY KEY CLUSTERED 
(
	[OfferCategoryMasterId] ASC
))
GO

-- Type Master
SELECT * FROM [dbo].[GeneralReward_OfferTypeMaster]

DROP TABLE IF EXISTS [dbo].[GeneralReward_OfferTypeMaster]
CREATE TABLE [dbo].[GeneralReward_OfferTypeMaster]
(
	[OfferTypeMasterId] [int] IDENTITY(1,1) NOT NULL,
	[OfferType] [varchar](50) NULL,
	IsActive BIT DEFAULT(1)
PRIMARY KEY CLUSTERED 
(
	[OfferTypeMasterId] ASC
))
GO

DROP TABLE IF EXISTS [dbo].[GeneralReward_OfferModeMaster]
-- Offer Mode Master
CREATE TABLE [dbo].[GeneralReward_OfferModeMaster]
(
	[OfferModeMasterId] [int] IDENTITY(1,1) NOT NULL,
	[OfferMode] [varchar](50) NULL,
	IsActive BIT DEFAULT(1)
PRIMARY KEY CLUSTERED 
(
	[OfferModeMasterId] ASC
))
GO

SET IDENTITY_INSERT [dbo].[GeneralReward_LanguageMaster] ON 
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (1, N'English', 1, NULL)
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (2, N'Hindi', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (3, N'Marathi', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (4, N'Gujarati', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (5, N'Kannada', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (6, N'Tamil', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (7, N'Telugu', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (8, N'Punjabi ', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (9, N'Oriya ', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
INSERT [dbo].[GeneralReward_LanguageMaster] ([LanguageMasterId], [Language], [IsActive], [DeactivatedOn]) VALUES (10, N'Bengali', 0, CAST(N'2021-11-05T12:04:13.387' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[GeneralReward_LanguageMaster] OFF
GO

INSERT INTO [dbo].[GeneralReward_MerchantData]
(
    Merchant_Id,
    Source_Unique_Id,
    BusinessLegalName,
    BusinessDisplayName,
    BusinessCategory,
    Created_Date,
    PageName
)
VALUES
('M100001','SRC100001','ABC Retail Private Limited','ABC Mart','Retail','2026-07-01 09:30:00','Merchant Registration'),
('M100002','SRC100002','Fresh Foods India Pvt Ltd','Fresh Foods','Grocery','2026-07-02 10:15:00','Merchant Registration'),
('M100003','SRC100003','TechZone Solutions LLP','TechZone','Electronics','2026-07-03 11:45:00','Merchant Profile'),
('M100004','SRC100004','Sunrise Medical Services Pvt Ltd','Sunrise Pharmacy','Healthcare','2026-07-04 14:20:00','Merchant Registration'),
('M100005','SRC100005','Global Fashion House Pvt Ltd','Global Fashion','Fashion','2026-07-05 16:10:00','Merchant Dashboard'),
('M100006','SRC100006','City Fuel Stations Limited','City Fuel','Fuel','2026-07-06 08:45:00','Merchant Registration'),
('M100007','SRC100007','Royal Dining Restaurants Pvt Ltd','Royal Dining','Restaurant','2026-07-07 13:25:00','Merchant Profile'),
('M100008','SRC100008','Book World Publications Pvt Ltd','Book World','Books & Stationery','2026-07-08 17:40:00','Merchant Dashboard'),
('M100009','SRC100009','Happy Travels India Limited','Happy Travels','Travel','2026-07-09 12:05:00','Merchant Registration'),
('M100010','SRC100010','Prime Fitness Wellness Pvt Ltd','Prime Fitness','Fitness','2026-07-10 15:55:00','Merchant Profile');
GO

SET IDENTITY_INSERT [dbo].[GeneralReward_OfferCategoryMaster] ON 
GO
INSERT [dbo].[GeneralReward_OfferCategoryMaster] ([OfferCategoryMasterId], [OfferCategory]) VALUES (1, N'General')
GO
INSERT [dbo].[GeneralReward_OfferCategoryMaster] ([OfferCategoryMasterId], [OfferCategory]) VALUES (2, N'Triple Rewards')
GO
SET IDENTITY_INSERT [dbo].[GeneralReward_OfferCategoryMaster] OFF
GO

SET IDENTITY_INSERT [dbo].[GeneralReward_OfferModeMaster] ON 
GO
INSERT [dbo].[GeneralReward_OfferModeMaster] ([OfferModeMasterId], [OfferMode]) VALUES (1, N'Flat')
GO
INSERT [dbo].[GeneralReward_OfferModeMaster] ([OfferModeMasterId], [OfferMode]) VALUES (2, N'Up To')
GO
INSERT [dbo].[GeneralReward_OfferModeMaster] ([OfferModeMasterId], [OfferMode]) VALUES (3, N'Freebie Gift')
GO
INSERT [dbo].[GeneralReward_OfferModeMaster] ([OfferModeMasterId], [OfferMode]) VALUES (4, N'Buy And Get')
GO
SET IDENTITY_INSERT [dbo].[GeneralReward_OfferModeMaster] OFF
GO

INSERT INTO [dbo].[GeneralReward_OfferTypeMaster] (OfferType) VALUES 
('Cashback'), ('Discount'), ('Freebie')
GO


SELECT TOP 2 * FROM dbo.GeneralAndTripleReward_OfferDetails
SELECT TOP 2 * FROM dbo.GeneralReward_adtSQLAuditLog
SELECT TOP 2 * FROM dbo.GeneralReward_FestivalMaster
SELECT TOP 2 * FROM dbo.GeneralReward_LanguageMaster
SELECT TOP 2 * FROM dbo.GeneralReward_MerchantData
SELECT TOP 2 * FROM dbo.GeneralReward_OfferCategoryMaster
SELECT TOP 2 * FROM dbo.GeneralReward_OfferModeMaster
SELECT TOP 2 * FROM dbo.GeneralReward_OfferTypeMaster