USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterToken') 
	BEGIN
		DROP PROCEDURE sp_RegisterToken;
	END
GO

CREATE PROCEDURE sp_RegisterToken
(
	@pToken VARCHAR(MAX),
	@pidUser INT
)
AS
BEGIN
	UPDATE [USER] SET Token = @pToken WHERE Id = @pidUser
END