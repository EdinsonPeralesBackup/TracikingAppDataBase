USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetDangerRoute') 
	BEGIN
		DROP PROCEDURE sp_GetDangerRoute;
	END
GO

CREATE PROCEDURE sp_GetDangerRoute
(
	@pTrackingRoute VARCHAR(10),
	@pPhoneUser VARCHAR(10)
)
AS
BEGIN

	UPDATE ALE SET CountVisit = CountVisit  + 1
	FROM ALERT ALE
	INNER JOIN ALERTXTRUSTED_CONTACTS ALEXTRU ON ALEXTRU.IdAlert = ALE.Id
	INNER JOIN TRUSTED_CONTACT TRU ON TRU.Id = ALEXTRU.IdTrusted_Contacts
	WHERE TRU.Phone = @pPhoneUser

	SELECT 
		POIN.Origin_latitud AS [LATITUD],
		POIN.Origin_longitude AS [LONGITUDE],
		POIN.[Timestamp] AS [TIME]
	FROM [ROUTE] ROUT
	INNER JOIN POINT POIN ON POIN.IdRoute = ROUT.Id AND POIN.IsValid = 'L'
	WHERE [State] = 'D' AND Tracking_id = @pTrackingRoute
END