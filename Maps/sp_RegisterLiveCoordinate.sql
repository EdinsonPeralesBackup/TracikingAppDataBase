USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterLiveCoordinate') 
	BEGIN
		DROP PROCEDURE sp_RegisterLiveCoordinate;
	END
GO

CREATE PROCEDURE sp_RegisterLiveCoordinate
(
	@pidTracking VARCHAR(100),
	@platitud DECIMAL(10, 4),
	@plongitute DECIMAL(10, 4),
	@ptimestamp DATETIME,
	@status VARCHAR(250) OUTPUT,
	@deviation DECIMAL(10, 4) OUTPUT,
	@lastLatitud DECIMAL(10, 4) OUTPUT,
	@lastLongitute DECIMAL(10, 4) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			DECLARE 
				@routeOriginLatitud DECIMAL(10, 4),
				@routeOriginLongitude DECIMAL(10, 4),
				@routeEndLatitud DECIMAL(10, 4),
				@routeEndLongitude DECIMAL(10, 4),
				@calculusDeviatio DECIMAL(10, 4),
				@calculusDeviatioFinal DECIMAL(10, 4) = 0

			DECLARE cursor_points CURSOR FOR
			(SELECT 
				Origin_latitud, Origin_longitude, 
				End_latitud, End_longitude
			FROM POINT
			WHERE IdRoute = @pidTracking AND IsValid = 'D')

			OPEN cursor_points;

			FETCH NEXT FROM cursor_points INTO @routeOriginLatitud, @routeOriginLongitude, @routeEndLatitud, @routeEndLongitude;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @calculusDeviatio = dbo.fn_EvaluarPuntoEnLinea(
											@routeOriginLatitud, @routeOriginLongitude, 
											@routeEndLatitud, @routeEndLongitude,
											@platitud, @plongitute)
				
				IF(@calculusDeviatio < @calculusDeviatioFinal)
				BEGIN
					SET @calculusDeviatioFinal = @calculusDeviatio
				END

				FETCH NEXT FROM cursor_points INTO @routeOriginLatitud, @routeOriginLongitude, @routeEndLatitud, @routeEndLongitude;
			END

			CLOSE cursor_points;
			DEALLOCATE cursor_points;

			INSERT INTO dbo.POINT (
				Origin_latitud,
				Origin_longitude,
				[Timestamp],
				IsValid,
				IdRoute,
				Deviation
			) VALUES(
				@platitud,
				@plongitute,
				@ptimestamp,
				'S',
				@pidTracking,
				@calculusDeviatioFinal
			)

			SET @deviation = @calculusDeviatioFinal
			SET @lastLatitud = 0
			SET @lastLongitute = 0
			SET @status = 'ON_ROUTE'
			IF(@deviation >= 20)
			BEGIN
				SET @status = 'OFF_ROUTE'
				SELECT TOP 1
					@lastLatitud = Origin_latitud,
					@lastLongitute = Origin_longitude
				FROM POINT WHERE IdRoute = @pidTracking
				ORDER BY Id DESC
			END

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @deviation = 0
		SET @status = 'OFF_ROUTE';
		ROLLBACK TRANSACTION;
	END CATCH
END