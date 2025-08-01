USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterConfidenceContact') 
	BEGIN
		DROP PROCEDURE sp_RegisterConfidenceContact;
	END
GO

CREATE PROCEDURE sp_RegisterConfidenceContact
(
	@pname VARCHAR(100),
	@plastName VARCHAR(200),
	@pphone VARCHAR(10),
	@pidUser INT,
	@pidUserCreate INT,
	@pdateCreate DATETIME
)
AS
BEGIN
	DECLARE 
		@idNewTrustedContact INT = 0, 
		@message VARCHAR(MAX) = 'Trusted contact has not been added correctly'
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO TRUSTED_CONTACT([name], Lastname, Phone, [State], IdUser, CreatedBy, CreateAt)
			VALUES(@pname, @plastName, @pphone, 1, @pidUser, @pidUserCreate, @pdateCreate)

			SET @idNewTrustedContact = SCOPE_IDENTITY();

			IF(@idNewTrustedContact IS NOT NULL)
			BEGIN
				SET @message = 'Confidence contact added successfully.';
			END

			SELECT
				@message AS [MESSAGE],
				@idNewTrustedContact AS [CONTACT_ID],
				TRUS_CONT.[Name] AS [NAME],
				TRUS_CONT.Lastname AS [LASTNAME],
				TRUS_CONT.Phone AS [PHONE],
				TRUS_CONT.[State] AS [STATUS]
			FROM TRUSTED_CONTACT TRUS_CONT
			WHERE Id = @idNewTrustedContact
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @idNewTrustedContact = 0;
		SET @message = ERROR_MESSAGE();
	END CATCH
END