USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_DangerRoute') 
	BEGIN
		DROP PROCEDURE sp_DangerRoute;
	END
GO

CREATE PROCEDURE sp_DangerRoute
(
	@prouteId INT,
	@ptimestampDanger DATETIME,
	@msj CHAR(2) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			UPDATE [ROUTE] SET [STATE] = 'D', Timestamp_Danger = DATEADD(hour, 3, @ptimestampDanger) WHERE Id = @prouteId AND [STATE] = 'S'

			SET @msj = 'OK'

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @msj = 'EX';
		ROLLBACK TRANSACTION;
	END CATCH
END