USE [Projects]
GO

/****** Object:  StoredProcedure [dbo].[usp_GeneralReward_Insert_OfferDetails] ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_GeneralReward_Insert_OfferDetails]
(
    @Offer_Category            VARCHAR(255),
    @Offer_Type                VARCHAR(255),
    @Offer_Mode                VARCHAR(100),
    @Offer_By                  VARCHAR(255)    = NULL,

    @Merchant_Id                VARCHAR(150),
    @Source_Unique_Id           VARCHAR(150),

    @Cashback_Amount            DECIMAL(18,4)   = NULL,
    @Cashback_Percentage        DECIMAL(18,4)   = NULL,
    @Discount_Amount            DECIMAL(18,4)   = NULL,
    @Discount_Percentage        DECIMAL(18,4)   = NULL,
    @Minimum_Purchase_value     DECIMAL(18,4)   = NULL,
    @Upto_Amount                DECIMAL(18,4)   = NULL,
    @Buy_cnt                    DECIMAL(18,4)   = NULL,
    @Get_cnt                    DECIMAL(18,4)   = NULL,
    @Freebie_Product_Name       VARCHAR(255)    = NULL,

    @Offer_Validity_From_Date   DATETIME,
    @Offer_Validity_To_Date     DATETIME,

    @Template_Type               VARCHAR(255)   = NULL,
    @Event_Type                  VARCHAR(255)   = NULL,
    @Language                    VARCHAR(255)   = NULL,
    @Communication_Message       NVARCHAR(MAX)  = NULL,
    @Offer_Banner                VARCHAR(255)   = NULL,
    @Additional_Info_1           VARCHAR(1000)  = NULL,
    @Additional_Info_2           VARCHAR(1000)  = NULL,
    @Additional_Info_3           VARCHAR(1000)  = NULL,

    @OfferId                     VARCHAR(255)    OUTPUT,
    @ResultMessage               VARCHAR(500)    OUTPUT
)
AS
BEGIN

    -- setting variables
    DECLARE @ObjectName             VARCHAR(100)  = (SELECT OBJECT_NAME(@@PROCID))
    DECLARE @StepId                 INT           = 0
    DECLARE @StepDesc               VARCHAR(100)
    DECLARE @ErrorMsg               VARCHAR(500)
    DECLARE @DatePrefix             VARCHAR(8)    = CONVERT(VARCHAR(8), GETDATE(), 112) -- YYYYMMDD for offer id
    DECLARE @NextSeq                INT
    DECLARE @NewOfferId             VARCHAR(255)
    DECLARE @Today                  DATE          = CAST(GETDATE() AS DATE)
    DECLARE @BusinessLegalName      VARCHAR(500)
    DECLARE @BusinessDisplayName    VARCHAR(500)
    DECLARE @BusinessCategory       VARCHAR(500)
    DECLARE @UserName               VARCHAR(50)     = SUSER_SNAME()
    DECLARE @MachineName            VARCHAR(50)     = HOST_NAME()

    SET @OfferId       = NULL
    SET @ResultMessage = NULL

    BEGIN TRY

        -- log that the proc started, helps with debugging later
        SET @StepId = @StepId + 1
        SET @StepDesc = 'VALIDATING INPUT DETAILS BEFORE OFFER CREATION'

        INSERT INTO dbo.GeneralReward_adtSQLAuditLog
            (ObjectName, StepID, StepDesc, RunDttm, ErrorDescription, UserName, MachineName)
        VALUES
            (@ObjectName, @StepId, @StepDesc, GETDATE(), NULL, @UserName, @MachineName)

        -- check category exists and is active
        IF NOT EXISTS (
                        SELECT 1 FROM dbo.GeneralReward_OfferCategoryMaster
                        WHERE OfferCategory = @Offer_Category AND IsActive = 1
                       )
        BEGIN
            SET @ErrorMsg = 'Invalid Offer Category: ' + ISNULL(@Offer_Category,'(null)')
            GOTO ValidationFailed
        END

        -- check type exists and is active
        IF NOT EXISTS (
                        SELECT 1 FROM dbo.GeneralReward_OfferTypeMaster
                        WHERE OfferType = @Offer_Type AND IsActive = 1
                        )
        BEGIN
            SET @ErrorMsg = 'Invalid Offer Type: ' + ISNULL(@Offer_Type,'(null)')
            GOTO ValidationFailed
        END

        -- checking mode exists and is active
        IF NOT EXISTS (
                        SELECT 1 FROM dbo.GeneralReward_OfferModeMaster
                        WHERE OfferMode = @Offer_Mode AND IsActive = 1
                        )
        BEGIN
            SET @ErrorMsg = 'Invalid Offer Mode: ' + ISNULL(@Offer_Mode,'(null)')
            GOTO ValidationFailed
        END

        -- check merchant + source id combo is real
        IF NOT EXISTS (
                        SELECT 1 FROM dbo.GeneralReward_MerchantData
                        WHERE Merchant_Id = @Merchant_Id
                          AND Source_Unique_Id = @Source_Unique_Id
                        )
        BEGIN
            SET @ErrorMsg = 'Invalid Merchant_Id / Source_Unique_Id combination.'
            GOTO ValidationFailed
        END

        -- pulling merchant business info to snapshot onto the offer row
        SELECT TOP 1
            @BusinessLegalName   = BusinessLegalName,
            @BusinessDisplayName = BusinessDisplayName,
            @BusinessCategory    = BusinessCategory
        FROM dbo.GeneralReward_MerchantData
        WHERE Merchant_Id = @Merchant_Id
          AND Source_Unique_Id = @Source_Unique_Id

        -- start date has to be in the future, not today or earlier
        IF CAST(@Offer_Validity_From_Date AS DATE) <= @Today
        BEGIN
            SET @ErrorMsg = 'Offer Start Date must be a future date (greater than today).'
            GOTO ValidationFailed
        END

        -- end date can't be before start date
        IF @Offer_Validity_To_Date < @Offer_Validity_From_Date
        BEGIN
            SET @ErrorMsg = 'Offer End Date cannot be earlier than Offer Start Date.'
            GOTO ValidationFailed
        END

        -- no overlapping offers for the same merchant
        -- two ranges overlap when start1 <= end2 AND start2 <= end1
        IF EXISTS (
                    SELECT *
                    FROM dbo.GeneralAndTripleReward_OfferDetails WITH(NOLOCK)
                    WHERE Merchant_Id = @Merchant_Id
                      AND @Offer_Validity_From_Date <= Offer_Validity_To_Date
                      AND Offer_Validity_From_Date  <= @Offer_Validity_To_Date
                    )
        BEGIN
            SET @ErrorMsg = 'An offer already exists for this Merchant within the given date range.'
            GOTO ValidationFailed
        END

        -- all checks passed, now do the actual insert
        BEGIN TRANSACTION

            SET @StepId = @StepId + 1
            SET @StepDesc = 'Offer Insertion Started into table - GeneralAndTripleReward_OfferDetails'

            INSERT INTO dbo.GeneralReward_adtSQLAuditLog
            (ObjectName, StepID, StepDesc, RunDttm, ErrorDescription, UserName, MachineName)
            VALUES
            (@ObjectName, @StepId, @StepDesc, GETDATE(), NULL, @UserName, @MachineName)

            -- build offer id like OFF-20260802000001, sequence resets each day
            SELECT @NextSeq = ISNULL(MAX(CAST(RIGHT(Offer_Id, 6) AS INT)), 0) + 1
            FROM dbo.GeneralAndTripleReward_OfferDetails WITH (UPDLOCK, HOLDLOCK)
            WHERE Offer_Id LIKE 'OFF-' + @DatePrefix + '%'

            SET @NewOfferId = 'OFF-' + @DatePrefix + RIGHT('000000' + CONVERT(VARCHAR(6), @NextSeq), 6)

            INSERT INTO dbo.GeneralAndTripleReward_OfferDetails
            (
                Offer_Category, 
                Offer_By, 
                Offer_Type, 
                Offer_Mode,
                Cashback_Amount, 
                Cashback_Percentage, 
                Discount_Amount, 
                Discount_Percentage,
                Minimum_Purchase_value, 
                Upto_Amount, 
                Buy_cnt, 
                Get_cnt,
                Offer_Validity_From_Date, 
                Offer_Validity_To_Date, 
                Merchant_Id,                            -- This is the merchant identifier
                Source_Unique_Id,                       
                Business_Legal_Name, 
                Business_Display_Name, 
                Business_Category,
                Offer_Id, 
                createdDate,
                Freebie_Product_Name, 
                Template_Type, 
                Event_Type, 
                Language,
                Communication_Message, 
                Offer_Banner,
                Additional_Info_1, 
                Additional_Info_2, 
                Additional_Info_3
            )
            VALUES
            (
                @Offer_Category, 
                @Offer_By, 
                @Offer_Type, 
                @Offer_Mode,
                @Cashback_Amount, 
                @Cashback_Percentage, 
                @Discount_Amount, 
                @Discount_Percentage,
                @Minimum_Purchase_value, 
                @Upto_Amount, 
                @Buy_cnt, 
                @Get_cnt,
                @Offer_Validity_From_Date, 
                @Offer_Validity_To_Date, 
                @Merchant_Id, 
                @Source_Unique_Id,
                @BusinessLegalName, 
                @BusinessDisplayName, 
                @BusinessCategory,
                @NewOfferId, 
                GETDATE(),
                @Freebie_Product_Name, 
                @Template_Type, 
                @Event_Type, 
                @Language,
                @Communication_Message, 
                @Offer_Banner,
                @Additional_Info_1, 
                @Additional_Info_2, 
                @Additional_Info_3
            )

            SET @OfferId       = @NewOfferId
            SET @ResultMessage = @NewOfferId + ' - offer created successfully'

            -- log success
            SET @StepId = @StepId + 1

            INSERT INTO dbo.GeneralReward_adtSQLAuditLog
                (ObjectName, StepID, StepDesc, RunDttm, ErrorDescription, UserName, MachineName)
            VALUES
                (@ObjectName, @StepId, @ResultMessage, GETDATE(), NULL, @UserName, @MachineName)

        COMMIT TRANSACTION

            SELECT @NewOfferId AS OfferId, @ResultMessage AS Message
            RETURN 0


        -- jump target for any validation failure above
        ValidationFailed:
            SET @ResultMessage = @ErrorMsg
            SET @StepId = @StepId + 1

            INSERT INTO dbo.GeneralReward_adtSQLAuditLog
                (ObjectName, StepID, StepDesc, RunDttm, ErrorDescription, UserName, MachineName)
            VALUES
                (@ObjectName, @StepId, 'VALIDATION_ERROR', GETDATE(), @ErrorMsg, @UserName, @MachineName)

            SELECT NULL AS OfferId, @ResultMessage AS Message
            RETURN 1

    END TRY
    BEGIN CATCH
        -- only real unexpected sql errors land here, not validation failures
        IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION

        DECLARE @SysErrorMsg VARCHAR(500) = ERROR_MESSAGE()
        DECLARE @ErrorLine   INT = ERROR_LINE()

        SET @ResultMessage = 'An unexpected error occurred while creating the offer. Please contact support.'
        SET @StepId = @StepId + 1

        INSERT INTO dbo.GeneralReward_adtSQLAuditLog
            (ObjectName, StepID, StepDesc, RunDttm, ErrorDescription, UserName, MachineName)
        VALUES
            (@ObjectName, @StepId, 'ERROR', GETDATE(),
             'Line ' + CONVERT(VARCHAR(10), @ErrorLine) + ': ' + @SysErrorMsg,
             @UserName, @MachineName)

        SELECT NULL AS OfferId, @ResultMessage AS Message
        RETURN -1

    END CATCH
END
GO


