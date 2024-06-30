use hotelDB
go

-- Drop the test procedure if it exists
IF OBJECT_ID('usp_testCreatePackage', 'P') IS NOT NULL
    DROP PROCEDURE usp_testCreatePackage;
go

-- Create the test procedure
CREATE PROCEDURE usp_testCreatePackage
AS
BEGIN
-- Iniatisation of counters and declare of variable
    DECLARE @TestCount INT = 0;
    DECLARE @PassCount INT = 0;
    DECLARE @FailCount INT = 0;
	DECLARE @packageId INT;

	-- Display start message for tests
    PRINT 'Starting tests for usp_createPackage...';

    -- Test 1: Valid input employee ID (If called, should be pass) 
    BEGIN TRY
        SET @TestCount += 1;
        PRINT 'Test 1: Valid input parameters';
        EXEC usp_createPackage
            @packageName = 'Valid Package',
            @packageDescription = 'This is a valid package',
            @startDate = '2024-01-01',
            @endDate = '2024-12-31',
            @advertisedPrice = 150.00,
            @advertisedCurrency = 'USD',
            @employeeId = 100,
			@gracePeriod = 10,
            @packageId = @packageId OUTPUT;

			-- Use a IF ELSE statement to confirm wether passed or failed test (If called, should be pass)
        IF @packageId IS NOT NULL
        BEGIN
            PRINT 'Test 1 Passed';
            SET @PassCount += 1;
        END
        ELSE
        BEGIN
            PRINT 'Test 1 Failed';
            SET @FailCount += 1;
        END
    END TRY

    BEGIN CATCH
        PRINT 'Test 1 Failed: ' + ERROR_MESSAGE();
        SET @FailCount += 1;
    END CATCH

    -- Test 2: Invalid employee ID (If usp_createpackage called correctly, should be failure)
    BEGIN TRY
        SET @TestCount += 1;
        PRINT 'Test 2: Invalid employee ID';
        EXEC usp_createPackage
            @packageName = 'Invalid Employee Package',
            @packageDescription = 'This package has an invalid employee ID',
            @startDate = '2024-01-01',
            @endDate = '2024-12-31',
            @advertisedPrice = 10.00,
            @advertisedCurrency = 'USD',
            @employeeId = 9999, --Known invalid employee ID
			@gracePeriod = 10,
            @packageId = @packageId OUTPUT;

			-- Use a IF ELSE statement to confirm wether passed or failed test (If usp_createpackage called correctly, should be failure)
        PRINT 'Test 2 Failed: Expected error not thrown';
        SET @FailCount += 1;
    END TRY
    BEGIN CATCH
        PRINT 'Test 2 Passed: ' + ERROR_MESSAGE();
        SET @PassCount += 1;
    END CATCH

	--Print final statements
    PRINT 'Tests completed. Total: ' + CAST(@TestCount AS NVARCHAR) +
          ', Passed: ' + CAST(@PassCount AS NVARCHAR) +
          ', Failed: ' + CAST(@FailCount AS NVARCHAR);
END;
GO

-- Print the test create package stored procedure
exec dbo.usp_testCreatePackage 
go