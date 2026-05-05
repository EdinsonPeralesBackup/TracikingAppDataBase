USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterAlert') 
	BEGIN
		DROP PROCEDURE sp_RegisterAlert;
	END
GO

CREATE PROCEDURE sp_RegisterAlert
(
	@pidRoute INT,
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

			DECLARE @countAlert INT = 0;

			SELECT 
				@countAlert = COUNT(Id) 
			FROM ALERT WHERE IdRoute = @pidRoute

			IF (COALESCE(@countAlert, 0) = 0)
			BEGIN
				DECLARE @idAlert INT, @idUser INT;

				SELECT @idUser = IdUser FROM [ROUTE] WHERE Id = @pidRoute

				INSERT INTO ALERT(Latitude, Longitude, [Timestamp], IdRoute, CountVisit) 
					VALUES(@platitude, @plongitude, @ptimestamp, @pidRoute, 0)

				SET @idAlert = SCOPE_IDENTITY();

				INSERT INTO ALERTXTRUSTED_CONTACTS(IdAlert, IdTrusted_Contacts)
					SELECT @idAlert, Id FROM TRUSTED_CONTACT WHERE IdUser = @idUser AND State = 1

				SET @msj = 'OK'
				END
			ELSE
			BEGIN
				SET @msj = 'E1'
			END

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
			SET @msj = 'EX'
	END CATCH
END