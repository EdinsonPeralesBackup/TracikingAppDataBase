USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetPointOfRoute') 
	BEGIN
		DROP PROCEDURE sp_GetPointOfRoute;
	END
GO

CREATE PROCEDURE sp_GetPointOfRoute
(
	@pTrackingId INT
)
AS
BEGIN

	SELECT 
		Origin_latitud AS [ORIGIN_LATITUD],
		Origin_longitude AS [ORIGIN_LONGITUDE],
		End_latitud AS [END_LATITUD],
		End_longitude AS [END_LONGITUDE]
	FROM POINT WHERE IdRoute = @pTrackingId  AND IsValid = 'D'
END