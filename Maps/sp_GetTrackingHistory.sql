USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetTrackingHistory') 
	BEGIN
		DROP PROCEDURE sp_GetTrackingHistory;
	END
GO

CREATE PROCEDURE sp_GetTrackingHistory
(
	@pIdUser INT,
	@pEsRutaActual BIT
)
AS
BEGIN

	SELECT
		ROUT.Id AS [ID_ROUTE],
		ROUT.Origin_address AS [ORIGEN],
		ROUT.Origin_latitud AS [ORIGIN_LATITUD],
		ROUT.Origin_longitude AS [ORIGIN_LONGITUD],
		ROUT.Destination_address AS [DESTINATION],
		ROUT.Destination_latitud AS [DESTINATION_LATITUD],
		ROUT.Destination_longitude AS [DESTINATION_LONGITUDE],
		ROUT.Timestamp AS [TIME]
	FROM [ROUTE] ROUT 
	WHERE (ROUT.State = 'S' OR @pEsRutaActual = 0)
END