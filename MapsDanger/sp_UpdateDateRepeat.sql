USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_UpdateDateRepeat') 
	BEGIN
		DROP PROCEDURE sp_UpdateDateRepeat;
	END
GO

CREATE PROCEDURE sp_UpdateDateRepeat
(
	@ptimestamp DATETIME
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			UPDATE ROUTE SET Timestamp_DangerRepeat = DATEADD(minute, 2, @ptimestamp)
			WHERE STATE = 'D'

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
	END CATCH
END