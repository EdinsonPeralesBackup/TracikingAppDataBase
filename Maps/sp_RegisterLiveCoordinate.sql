USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterLiveCoordinate') 
	BEGIN
		DROP PROCEDURE sp_RegisterLiveCoordinate;
	END
GO

CREATE PROCEDURE sp_RegisterLiveCoordinate
(
	@pidTracking INT,
	@platitud DECIMAL(10, 4),
	@plongitute DECIMAL(10, 4),
	@ptimestamp DATETIME,
	@status VARCHAR(250) OUTPUT,
	@cancelable BIT OUTPUT,
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
				@calculusDeviatioFinal DECIMAL(10, 4) = 0,
				@calculusDeviationFinalPoint DECIMAL(10, 4)

			DECLARE cursor_points CURSOR FOR
			(SELECT 
				Origin_latitud, Origin_longitude, 
				End_latitud, End_longitude
			FROM POINT
			WHERE IdRoute = @pidTracking AND IsValid = 'D')

			CREATE TABLE #desviationsTemp (
				valores DECIMAL(10, 4)
			)

			OPEN cursor_points;

			FETCH NEXT FROM cursor_points INTO @routeOriginLatitud, @routeOriginLongitude, @routeEndLatitud, @routeEndLongitude;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @calculusDeviatio = dbo.fn_EvaluarPuntoEnLinea(
											@routeOriginLatitud, @routeOriginLongitude, 
											@routeEndLatitud, @routeEndLongitude,
											@platitud, @plongitute)
				
				INSERT INTO #desviationsTemp VALUES (@calculusDeviatio);

				--PRINT('++++++++++++++++++++')
				--PRINT(@calculusDeviatio)
				--PRINT('++++++++++++++++++++')
				--IF(@calculusDeviatio < @calculusDeviatioFinal OR @calculusDeviatioFinal = 0)
				--BEGIN
				--	SET @calculusDeviatioFinal = @calculusDeviatio
				--END

				FETCH NEXT FROM cursor_points INTO @routeOriginLatitud, @routeOriginLongitude, @routeEndLatitud, @routeEndLongitude;
			END

			CLOSE cursor_points;
			DEALLOCATE cursor_points;

			SELECT TOP 1 
				@calculusDeviatioFinal = valores
			FROM #desviationsTemp 
			ORDER BY valores ASC

			IF OBJECT_ID('tempdb..#desviationsTemp') IS NOT NULL
				DROP TABLE #desviationsTemp;

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
				'L', --LIVE 
				@pidTracking,
				@calculusDeviatioFinal
			)

			SET @deviation = @calculusDeviatioFinal
			SET @lastLatitud = 0
			SET @lastLongitute = 0
			SET @status = 'ON_ROUTE'
			IF(@deviation >= 75)
			BEGIN
				SET @status = 'OFF_ROUTE'
				SELECT TOP 1
					@lastLatitud = Origin_latitud,
					@lastLongitute = Origin_longitude
				FROM POINT WHERE IdRoute = @pidTracking
				ORDER BY Id DESC
			END

			IF(@status = 'ON_ROUTE')
			BEGIN				
				DECLARE @endLatitud DECIMAL(10, 4), @endLongitude DECIMAL(10, 4)

				SELECT 
					@endLatitud = End_latitud, 
					@endLongitude = End_longitude
				FROM POINT
				WHERE IdRoute = @pidTracking AND IsValid = 'D' 
				ORDER BY ID DESC;

				DECLARE @p1 geography = geography::Point(@platitud, @plongitute, 4326);
				DECLARE @p2 geography = geography::Point(@endLatitud, @endLongitude, 4326);


				--SET @calculusDeviationFinalPoint = SQRT(POWER((@platitud - @endLatitud), 2) + POWER((@plongitute - @endLongitude), 2))
				SET @calculusDeviationFinalPoint = @p1.STDistance(@p2) 

				IF(@calculusDeviationFinalPoint <= 80)
				BEGIN
					SET @cancelable = 0
				END
				ELSE
				BEGIN
					SET @cancelable = 1
				END

			END

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @deviation = 0
		SET @status = 'OFF_ROUTE';
		ROLLBACK TRANSACTION;
	END CATCH
END