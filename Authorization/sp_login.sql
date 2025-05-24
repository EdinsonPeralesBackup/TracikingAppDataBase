USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_login') 
	BEGIN
		DROP PROCEDURE sp_login;
	END
GO

CREATE PROCEDURE sp_login
(
	@pphone VARCHAR(10),
	@pclave VARCHAR(MAX)
)
AS
BEGIN
	SELECT 
		USU.Id AS [ID],
		USU.Phone AS [PHONE],
		USER_PRO.[Name] AS [NAME],
		USER_PRO.LastName AS [LAST_NAME],
		USER_PRO.Birthday AS [BIRTHDAY],
		ROL.Id AS [ID_ROLE],
		ROL.[Name] AS [ROLE]
	FROM [USER] USU
	LEFT JOIN [ROLE] ROL ON ROL.Id = USU.IdRole
	LEFT JOIN [USER_PROFILE] USER_PRO ON USER_PRO.IdUser = USU.Id
	WHERE 
		USU.Phone = @pphone 
		AND USU.Password = @pclave 
		AND USER_PRO.[State] = 1
END