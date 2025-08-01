USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterRoute') 
	BEGIN
		DROP PROCEDURE sp_RegisterRoute;
	END
GO

CREATE PROCEDURE sp_RegisterRoute
(
	@pdistance_text VARCHAR(250),
	@pdistance DECIMAL(10, 4),
	@pduration_text VARCHAR(250),
	@pduration DECIMAL(10, 4),
	@porigin_address VARCHAR(MAX),
	@porigin_latitud DECIMAL(10, 4),
	@porigin_longitude DECIMAL(10, 4),
	@pdestination_address VARCHAR(MAX),
	@pdestination_latitud DECIMAL(10, 4),
	@pdestination_longitude DECIMAL(10, 4),
	@pidUser INT,
	@ptimestamp DATETIME,
	@pXMLPoint XML,
	@numberTracking VARCHAR(100) OUTPUT,
	@message VARCHAR(250) OUTPUT
)
AS
BEGIN
	DECLARE 
		@idNewRoute INT = 0
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO [ROUTE]
				(Distance_text, Distance, Duration_text, Duration, 
					Origin_address, Origin_latitud, Origin_longitude,
					Destination_address, Destination_latitud, Destination_longitude,
					IdUser, [Timestamp])
			VALUES
				(@pdistance_text, @pdistance, @pduration_text, @pduration,
					@porigin_address, @porigin_latitud, @porigin_longitude,
					@pdestination_address, @pdestination_latitud, @pdestination_longitude,
					@pidUser, @ptimestamp)

			SET @idNewRoute = SCOPE_IDENTITY();
			SET @numberTracking = CONCAT('track-', RIGHT(CONCAT('000', @idNewRoute), 3))

			UPDATE [ROUTE] SET Tracking_id = @numberTracking WHERE Id = @idNewRoute

			SET @message = 'Tracking started'

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @numberTracking = 'EX';
		SET @message = ERROR_MESSAGE();
		ROLLBACK TRANSACTION;
	END CATCH
END