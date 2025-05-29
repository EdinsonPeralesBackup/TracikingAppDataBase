USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_ResetPassword') 
	BEGIN
		DROP PROCEDURE sp_ResetPassword;
	END
GO

CREATE PROCEDURE sp_ResetPassword
(
	@presetCode VARCHAR(6),
	@pnewPassword VARCHAR(MAX),
	@pidUser INT,
	@message VARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @idCode INT
			SELECT @idCode = Id FROM CODE_RESET WHERE Code = @presetCode AND IdUser = @pidUser AND [State] = 1 
			IF(@idCode <> 0)
			BEGIN
				UPDATE CODE_RESET SET [State] = 0 WHERE Id = @idCode
				UPDATE [USER] SET [Password] = @pnewPassword WHERE Id = @pidUser
				SET @message = 'Password updated successfully.';
			END
			ELSE
			BEGIN
				SET @message = 'Update password failed.';
			END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @message = '';
	END CATCH
END