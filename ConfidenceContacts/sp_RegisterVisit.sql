USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterVisit') 
	BEGIN
		DROP PROCEDURE sp_RegisterVisit;
	END
GO

CREATE PROCEDURE sp_RegisterVisit
(
	@pTrackingId VARCHAR(10),
	@msj CHAR(2) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			DECLARE @idAlert INT, @idRoute INT;

			SELECT @idRoute = Id FROM [ROUTE] WHERE Tracking_id = @pTrackingId

			UPDATE ALERT SET CountVisit = CountVisit + 1

			SET @msj = 'OK'

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
			SET @msj = 'EX'
	END CATCH
END