USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_DeleteToken') 
	BEGIN
		DROP PROCEDURE sp_DeleteToken;
	END
GO

CREATE PROCEDURE sp_DeleteToken
(
	@pidUser INT
)
AS
BEGIN
	UPDATE [USER] SET Token = null WHERE Id = @pidUser
END