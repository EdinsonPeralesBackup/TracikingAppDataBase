USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_UpdateRouteArrival') 
	BEGIN
		DROP PROCEDURE sp_UpdateRouteArrival;
	END
GO

CREATE PROCEDURE sp_UpdateRouteArrival
(
	@pIdTracking INT,
	@pIdUser INT,
	@message VARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @isRoutValid INT

			SELECT @isRoutValid = COUNT(Id) FROM [ROUTE] WHERE Id = @pIdTracking AND IdUser = @pIdUser AND [STATE] = 'S'

			IF(@isRoutValid != 0)
				BEGIN
					SET @message = 'The trip does not belong to the user.';
				END
			ELSE
				BEGIN
					UPDATE [ROUTE] SET [STATE] = 'F' WHERE Id = @pIdTracking AND IdUser = @pIdUser
					SET @message = '"Arrival confirmed.';
				END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @message = ERROR_MESSAGE();
	END CATCH
END