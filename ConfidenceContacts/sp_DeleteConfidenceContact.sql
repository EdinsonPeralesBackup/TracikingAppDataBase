USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_DeleteConfidenceContact') 
	BEGIN
		DROP PROCEDURE sp_DeleteConfidenceContact;
	END
GO

CREATE PROCEDURE sp_DeleteConfidenceContact
(
	@pid INT,
	@message VARCHAR(MAX) OUTPUT
)
AS
BEGIN
	DECLARE 
		@idDeleteTrustedContact INT
	SET @message = ''
	BEGIN TRY
		BEGIN TRANSACTION
			DELETE TRUSTED_CONTACT WHERE Id = @pid

			SET @message = 'Confidence contact deleted successfully.';
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @message = 'Trusted contact has not been deleted correctly';
	END CATCH
END