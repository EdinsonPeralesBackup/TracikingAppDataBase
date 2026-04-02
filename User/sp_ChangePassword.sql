USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_ChangePassword') 
	BEGIN
		DROP PROCEDURE sp_ChangePassword;
	END
GO

CREATE PROCEDURE sp_ChangePassword
(
	@presetCode VARCHAR(6),
	@poldPassword VARCHAR(MAX),
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
				IF(@poldPassword != @pnewPassword)
				BEGIN
					UPDATE [USER] SET [Password] = @pnewPassword WHERE Id = @pidUser
					SET @message = 'Password updated successfully.';
				END
				ELSE
				BEGIN
					SET @message = 'Keys do not match.';
				END
				UPDATE CODE_RESET SET [State] = 0 WHERE IdUser = @pidUser
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