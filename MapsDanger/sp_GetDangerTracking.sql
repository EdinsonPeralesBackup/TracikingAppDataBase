USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetDangerTracking') 
	BEGIN
		DROP PROCEDURE sp_GetDangerTracking;
	END
GO

CREATE PROCEDURE sp_GetDangerTracking
(
	@ptimestamp DATETIME
)
AS
BEGIN

	UPDATE ROUTE SET [State] = 'L' WHERE @ptimestamp > Timestamp_Danger

	SELECT
		ROUT.Id AS [ID_ROUTE],
		ROUT.Tracking_id AS [TRACKING],
		TRUS.Name AS [NAME],
		TRUS.Phone AS [PHONE],
		ROUT.Origin_latitud AS [LATITUDE],
		ROUT.Origin_longitude AS [LONGITUD]
	FROM [ROUTE] ROUT
	INNER JOIN TRUSTED_CONTACT TRUS ON TRUS.IdUser = ROUT.IdUser
	WHERE ROUT.State = 'D'
END