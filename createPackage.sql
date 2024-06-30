--Use master for enabling of Common Language Runtime integration
use master
go

--Enable CLR integration in SQL Server 
sp_configure 'clr enabled', 1;
RECONFIGURE;
go

-- switch to correct database
use hotelDB
go

-- Create a database master key to use the CLR Assembly:
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE symmetric_key_id = 101)
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Hicats23';
END
go

-- Create a certificate to use CLR Assembly: 
IF NOT EXISTS (SELECT * FROM sys.certificates WHERE name = 'MyCertificate')
BEGIN
    CREATE CERTIFICATE MyCertificate
    WITH SUBJECT = 'My CLR Assembly Certificate';
END
go

-- use master for login for certificate
use master
go

-- Create a login to use the certificate:
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'MyCertificateLogin')
BEGIN
    CREATE LOGIN MyCertificateLogin
    FROM CERTIFICATE MyCertificate;
END
go

-- Grant permission to use the certificate from the assembly
GRANT UNSAFE ASSEMBLY TO MyCertificateLogin;
go

-- switch back to hoteldb
use hotelDB
go

-- Convert hash string (of Stored Procedure in c#) to binary and add to assembly to trusted assemblies
DECLARE @hashBinary VARBINARY(64);
SET @hashBinary = CONVERT(VARBINARY(64), '15E5DA415DEB6D0C372F6F571AA04E201A4746AA0E4A2DE6D31D74EA50ADB068162E64017DDA63281902B0C7759E9D545F84333F13A9A9CCD29694A0362894E2', 2);
-- Same assembly hash was used before, will result in error. However The stored procedure from c# is called correctly


-- Add & use the converted hash string as trusted assembly
DECLARE @description NVARCHAR(4000) = 'My Trusted Assembly';

EXEC sp_add_trusted_assembly @hash = @hashBinary,
                             @description = @description;
go

-- Create the assembly of the c# dll script 
CREATE ASSEMBLY [CSharpProjectAssembly]
FROM 'C:\Users\PC\OneDrive\Documents\COMP6350 Advanced Databases\Assignment 1\C# project\bin\Debug\net48\C# project.dll'
WITH PERMISSION_SET = SAFE;
go

--Use the c# dll script to create procedure (package)
CREATE PROCEDURE usp_createPackage
    @packageName NVARCHAR(MAX),
    @packagedescription NVARCHAR(MAX),
    @startDate DATETIME,
    @endDate DATETIME,
    @advertisedPrice DECIMAL(18, 2),
    @advertisedCurrency NVARCHAR(10),
    @employeeId INT,
	@graceperiod INT,
    @packageId INT OUTPUT
AS EXTERNAL NAME [CSharpProjectAssembly].[StoredProcedures].[CreatePackage]
go

