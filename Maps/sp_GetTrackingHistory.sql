USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetTrackingHistory') 
	BEGIN
		DROP PROCEDURE sp_GetTrackingHistory;
	END
GO

CREATE PROCEDURE sp_GetTrackingHistory
(
	@pRouteId INT
)
AS
BEGIN

	SELECT
		POIN.Origin_latitud AS [LATITUD],
		POIN.Origin_longitude AS [LONGITUDE],
		POIN.[Timestamp] AS [TIMESTAMP]
	FROM [POINT] POIN
	WHERE POIN.IdRoute = @pRouteId AND POIN.[IsValid] = 'L'

END