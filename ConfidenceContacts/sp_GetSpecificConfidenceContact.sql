USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetSpecificConfidenceContact') 
	BEGIN
		DROP PROCEDURE sp_GetSpecificConfidenceContact;
	END
GO

CREATE PROCEDURE sp_GetSpecificConfidenceContact
(
	@pidTrustedContact INT
)
AS
BEGIN

	SELECT
		TRUS_CONT.Id AS [CONTACT_ID],
		TRUS_CONT.[Name] AS [NAME],
		TRUS_CONT.Lastname AS [LASTNAME],
		TRUS_CONT.Phone AS [PHONE],
		TRUS_CONT.[State] AS [STATUS]
	FROM [TRUSTED_CONTACT] TRUS_CONT
	WHERE TRUS_CONT.Id = @pidTrustedContact

END