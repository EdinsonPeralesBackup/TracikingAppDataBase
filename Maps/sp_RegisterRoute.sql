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
	@pRouteCalibrated INT,
	@idRoute INT OUTPUT,
	@message VARCHAR(250) OUTPUT
)
AS
BEGIN
	DECLARE @numberTracking VARCHAR(10)
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE [ROUTE] SET State = 'C' WHERE IdUser = @pidUser AND State <> 'F'

			INSERT INTO [ROUTE]
				(Distance_text, Distance, Duration_text, Duration, 
					Origin_address, Origin_latitud, Origin_longitude,
					Destination_address, Destination_latitud, Destination_longitude,
					IdUser, [Timestamp], [State], IdRoute_calibrated)
			VALUES
				(@pdistance_text, @pdistance, @pduration_text, @pduration,
					@porigin_address, @porigin_latitud, @porigin_longitude,
					@pdestination_address, @pdestination_latitud, @pdestination_longitude,
					@pidUser, @ptimestamp, 'S', (CASE @pRouteCalibrated
						WHEN 0 THEN NULL
						ELSE @pRouteCalibrated END))

			SET @idRoute = SCOPE_IDENTITY();

			SET @numberTracking = CONCAT('track-', RIGHT(CONCAT('000', @idRoute), 3))

			UPDATE [ROUTE] SET Tracking_id = @numberTracking WHERE Id = @idRoute

			INSERT INTO dbo.POINT (
				Distance_text,
				Distance,
				Duration_text,
				Duration,
				Origin_latitud,
				Origin_longitude,
				End_latitud,
				End_longitude,
				Html_instructions,
				[Timestamp],
				IsValid,
				IdRoute,
				Deviation
			)
			SELECT
				Step.value('(Distance/Text)[1]', 'VARCHAR(250)'),
				Step.value('(Distance/Value)[1]', 'DECIMAL(10,4)'),
				Step.value('(Duration/Text)[1]', 'VARCHAR(250)'),
				Step.value('(Duration/Value)[1]', 'DECIMAL(10,4)'),
				Step.value('(Start_location/Lat)[1]', 'DECIMAL(10,4)'),
				Step.value('(Start_location/Lng)[1]', 'DECIMAL(10,4)'),
				Step.value('(End_location/Lat)[1]', 'DECIMAL(10,4)'),
				Step.value('(End_location/Lng)[1]', 'DECIMAL(10,4)'),
				Step.value('(Html_instructions)[1]', 'VARCHAR(MAX)'),
				@ptimestamp,
				'D', --DEFAULT
				@idRoute,
				0
			FROM @pXMLPoint.nodes('/ArrayOfStep/Step') AS XTbl(Step);

			SET @message = 'Tracking started'

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @numberTracking = 'EX';
		SET @message = ERROR_MESSAGE();
		ROLLBACK TRANSACTION;
	END CATCH
END