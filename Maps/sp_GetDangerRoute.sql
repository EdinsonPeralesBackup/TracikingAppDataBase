USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetDangerRoute') 
	BEGIN
		DROP PROCEDURE sp_GetDangerRoute;
	END
GO

CREATE PROCEDURE sp_GetDangerRoute
(
	@pTrackingRoute VARCHAR(10)
)
AS
BEGIN

	SELECT 
		POIN.Origin_latitud AS [LATITUD],
		POIN.Origin_longitude AS [LONGITUDE],
		POIN.[Timestamp] AS [TIME]
	FROM [ROUTE] ROUT
	INNER JOIN POINT POIN ON POIN.IdRoute = ROUT.Id AND POIN.IsValid = 'L'
	WHERE [State] = 'D' AND Tracking_id = @pTrackingRoute
END