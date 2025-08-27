USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_ArriveRoute') 
	BEGIN
		DROP PROCEDURE sp_ArriveRoute;
	END
GO

CREATE PROCEDURE sp_ArriveRoute
(
	@ptrackingID INT,
	@puserId INT,
	@plongitude DECIMAL(10, 4),
	@platitude DECIMAL(10, 4),
	@message VARCHAR(250) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			UPDATE [ROUTE] SET [STATE] = 'F' WHERE Id = @ptrackingID AND IdUser = @puserId AND [STATE] <> 'F'

			SET @message = 'Tracking started'

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @message = ERROR_MESSAGE();
		ROLLBACK TRANSACTION;
	END CATCH
END