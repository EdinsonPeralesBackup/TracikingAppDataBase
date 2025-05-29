USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_ValidToken') 
	BEGIN
		DROP PROCEDURE sp_ValidToken;
	END
GO

CREATE PROCEDURE sp_ValidToken
(
	@ptoken VARCHAR(MAX),
	@count BIT OUTPUT
)
AS
BEGIN
	IF EXISTS (SELECT 1 FROM [USER] WHERE Token = @ptoken)
        SET @count = 1;
    ELSE
        SET @count = 0;
END