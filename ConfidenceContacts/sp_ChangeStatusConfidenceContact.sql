USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_ChangeStatusConfidenceContact') 
	BEGIN
		DROP PROCEDURE sp_ChangeStatusConfidenceContact;
	END
GO

CREATE PROCEDURE sp_ChangeStatusConfidenceContact
(
	@pid INT
)
AS
BEGIN
	DECLARE @newState BIT, @message VARCHAR(MAX), @idChangeStateTrustedContact INT
	SET @message = 'The trusted contact´s status has not been changed correctly'
	BEGIN TRY
		BEGIN TRANSACTION

			SELECT @newState = [State] FROM TRUSTED_CONTACT WHERE Id = @pid

			SET @newState = 
			(CASE @newState
				WHEN 1 THEN 0
				WHEN 0 THEN 1
				END)


			UPDATE TRUSTED_CONTACT 
				SET [State] = @newState 
			WHERE Id = @pid

			SET @idChangeStateTrustedContact = @@ROWCOUNT;

			IF(@idChangeStateTrustedContact > 0)
			BEGIN
				SET @message = 'The trusted contact status has been successfully changed.';
			END

			SELECT 
				@message AS [MESSAGE],
				@pid AS [CONTACT_ID],
				@newState AS [IS_ACTIVE]
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @message = ERROR_MESSAGE();
		ROLLBACK TRANSACTION;
	END CATCH
END