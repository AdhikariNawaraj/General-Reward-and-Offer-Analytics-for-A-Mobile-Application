DECLARE @OfferId VARCHAR(255), @ResultMessage VARCHAR(500);

-- Merchant 1: M100001/SRC100001
EXEC dbo.usp_GeneralReward_Insert_OfferDetails
    @Offer_Category = 'General',
    @Offer_Type = 'Cashback',
    @Offer_Mode = 'Flat',
    @Offer_By = 'Amount',
    @Merchant_Id = 'M100001',
    @Source_Unique_Id = 'SRC100001',
    @Cashback_Amount = 11.5000,
    @Cashback_Percentage = NULL,
    @Discount_Amount = NULL,
    @Discount_Percentage = NULL,
    @Minimum_Purchase_value = 110.0000,
    @Upto_Amount = NULL,
    @Buy_cnt = NULL,
    @Get_cnt = NULL,
    @Freebie_Product_Name = NULL,
    @Offer_Validity_From_Date = '2026-08-14',
    @Offer_Validity_To_Date = '2026-08-18',
    @Template_Type = 'Email',
    @Event_Type = 'Summer Sale',
    @Language = 'English',
    @Communication_Message = N'Enjoy our special Cashback offer starting 2026-08-12',
    @Offer_Banner = 'Banner-1-1',
    @Additional_Info_1 = 'Merchant M100001 campaign',
    @Additional_Info_2 = 'Source SRC100001',
    @Additional_Info_3 = 'Offer slot 1',
    @OfferId = @OfferId OUTPUT,
    @ResultMessage = @ResultMessage OUTPUT;
PRINT @ResultMessage;

DECLARE @OfferId VARCHAR(255), @ResultMessage VARCHAR(500);
EXEC dbo.usp_GeneralReward_Insert_OfferDetails
    @Offer_Category = 'Triple Rewards',
    @Offer_Type = 'Discount',
    @Offer_Mode = 'Up To',
    @Offer_By = 'Percentage',
    @Merchant_Id = 'M100001',
    @Source_Unique_Id = 'SRC100001',
    @Cashback_Amount = NULL,
    @Cashback_Percentage = NULL,
    @Discount_Amount = NULL,
    @Discount_Percentage = 5.6000,
    @Minimum_Purchase_value = 120.0000,
    @Upto_Amount = 49.0000,
    @Buy_cnt = NULL,
    @Get_cnt = NULL,
    @Freebie_Product_Name = NULL,
    @Offer_Validity_From_Date = '2026-08-20',
    @Offer_Validity_To_Date = '2026-08-26',
    @Template_Type = 'Email',
    @Event_Type = 'Festive Offer',
    @Language = 'English',
    @Communication_Message = N'Enjoy our special Discount offer starting 2026-08-20',
    @Offer_Banner = 'Banner-1-2',
    @Additional_Info_1 = 'Merchant M100001 campaign',
    @Additional_Info_2 = 'Source SRC100001',
    @Additional_Info_3 = 'Offer slot 2',
    @OfferId = @OfferId OUTPUT,
    @ResultMessage = @ResultMessage OUTPUT;
PRINT @ResultMessage;

DECLARE @OfferId VARCHAR(255), @ResultMessage VARCHAR(500);
EXEC dbo.usp_GeneralReward_Insert_OfferDetails
    @Offer_Category = 'General',
    @Offer_Type = 'Freebie',
    @Offer_Mode = 'Freebie Gift',
    @Offer_By = 'Amount',
    @Merchant_Id = 'M100001',
    @Source_Unique_Id = 'SRC100001',
    @Cashback_Amount = NULL,
    @Cashback_Percentage = NULL,
    @Discount_Amount = NULL,
    @Discount_Percentage = NULL,
    @Minimum_Purchase_value = 130.0000,
    @Upto_Amount = NULL,
    @Buy_cnt = NULL,
    @Get_cnt = NULL,
    @Freebie_Product_Name = 'Freebie Item 1-3',
    @Offer_Validity_From_Date = '2026-08-28',
    @Offer_Validity_To_Date = '2026-09-03',
    @Template_Type = 'Email',
    @Event_Type = 'Summer Sale',
    @Language = 'English',
    @Communication_Message = N'Enjoy our special Freebie offer starting 2026-08-28',
    @Offer_Banner = 'Banner-1-3',
    @Additional_Info_1 = 'Merchant M100001 campaign',
    @Additional_Info_2 = 'Source SRC100001',
    @Additional_Info_3 = 'Offer slot 3',
    @OfferId = @OfferId OUTPUT,
    @ResultMessage = @ResultMessage OUTPUT;
PRINT @ResultMessage;


SELECT * FROM dbo.GeneralAndTripleReward_OfferDetails
SELECT * FROM dbo.GeneralReward_adtSQLAuditLog