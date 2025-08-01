USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_UpdateConfidenceContact') 
	BEGIN
		DROP PROCEDURE sp_UpdateConfidenceContact;
	END
GO

CREATE PROCEDURE sp_UpdateConfidenceContact
(
	@pid INT,
	@pname VARCHAR(100),
	@plastName VARCHAR(200),
	@pphone VARCHAR(10),
	@pidUserUpdate INT,
	@pdateUpdate DATETIME
)
AS
BEGIN
	DECLARE 
		@idUpdateTrustedContact INT = 0, 
		@message VARCHAR(MAX) = 'Trusted contact has not been updated correctly'
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE TRUSTED_CONTACT SET
					[Name] = @pname,
					Lastname = @plastName,
					Phone = @pphone,
					UpdateBy = @pidUserUpdate,
					UpdateAt = @pdateUpdate
			WHERE Id = @pid

			SET @idUpdateTrustedContact = @@ROWCOUNT;

			IF(@idUpdateTrustedContact > 0)
			BEGIN
				SET @message = 'Confidence contact updated successfully.';
			END

			SELECT
				@message AS [MESSAGE],
				@pid AS [CONTACT_ID],
				TRUS_CONT.[Name] AS [NAME],
				TRUS_CONT.Lastname AS [LASTNAME],
				TRUS_CONT.Phone AS [PHONE],
				TRUS_CONT.[State] AS [STATUS]
			FROM TRUSTED_CONTACT TRUS_CONT
			WHERE Id = @pid
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @pid = 0;
		SET @message = ERROR_MESSAGE();
	END CATCH
END