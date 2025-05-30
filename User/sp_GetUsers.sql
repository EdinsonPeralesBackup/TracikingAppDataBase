USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetUsers') 
	BEGIN
		DROP PROCEDURE sp_GetUsers;
	END
GO

CREATE PROCEDURE sp_GetUsers
(
	@ppage INT,
	@plimit INT,
	@total INT OUTPUT
)
AS
BEGIN
	
	SELECT @total = COUNT(*) FROM [USER]

	SELECT 
		USR.Id AS [ID],
		USR_PROF.[Name] AS [NAME],
		USR_PROF.LastName AS [LASTNAME],
		USR.Phone AS [PHONE],
		USR.[State] AS [STATE]
	FROM [USER] USR
	INNER JOIN USER_PROFILE USR_PROF ON USR_PROF.IdUser = USR.Id
	ORDER BY USR.Id
	OFFSET (@ppage - 1) * @plimit ROWS
	FETCH NEXT @plimit ROWS ONLY;
END