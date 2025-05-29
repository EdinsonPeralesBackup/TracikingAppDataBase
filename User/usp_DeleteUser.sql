USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'usp_DeleteUser') 
	BEGIN
		DROP PROCEDURE usp_DeleteUser;
	END
GO

CREATE PROCEDURE usp_DeleteUser
(
	@pIdUser INT,
	@msj VARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE [USER] 
				SET [State] = (
					CASE [State]
					WHEN 1 THEN 0
					ELSE 1 END
					) 
			WHERE Id = @pIdUser

			DECLARE @state BIT, @msjTemp VARCHAR(200)
			SELECT @state = [State] FROM [USER] WHERE Id = @pIdUser

			IF(@state = 0)
			BEGIN	
				SET @msjTemp = 'User deleted successfully.'
			END
			ELSE
			BEGIN
				SET @msjTemp = 'User successfully reset.';
			END

			SET @msj = @msjTemp
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @msj = ERROR_MESSAGE();
		ROLLBACK TRANSACTION
	END CATCH
END