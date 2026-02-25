USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterAlert') 
	BEGIN
		DROP PROCEDURE sp_RegisterAlert;
	END
GO

CREATE PROCEDURE sp_RegisterAlert
(
	@pidUser INT,
	@ptrackingId VARCHAR(10),
	@platitude DECIMAL(10, 4),
	@plongitude DECIMAL(10, 4),
	@ptimestamp DATE,
	@msj CHAR(2) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			DECLARE @idAlert INT, @idRoute INT;

			SELECT @idRoute = Id FROM [ROUTE] WHERE Tracking_id = @ptrackingId

			INSERT INTO ALERT(Latitude, Longitude, [Timestamp], IdRoute, CountVisit) 
				VALUES(@platitude, @plongitude, @ptimestamp, @idRoute, 0)

			SET @idAlert = SCOPE_IDENTITY();

			INSERT INTO ALERTXTRUSTED_CONTACTS(IdAlert, IdTrusted_Contacts)
				SELECT @idAlert, Id FROM TRUSTED_CONTACT WHERE IdUser = @pidUser AND State = 1

			SET @msj = 'OK'

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
			SET @msj = 'EX'
	END CATCH
END