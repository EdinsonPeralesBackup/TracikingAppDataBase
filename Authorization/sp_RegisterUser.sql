USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterUser') 
	BEGIN
		DROP PROCEDURE sp_RegisterUser;
	END
GO

CREATE PROCEDURE sp_RegisterUser
(
	@pname VARCHAR(10),
	@plastName VARCHAR(20),
	@pbirthday DATE,
	@ppassword VARCHAR(MAX),
	@pphonenumber VARCHAR(20),
	@idUser INT OUTPUT,
	@message VARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			DECLARE @UserPhone INT

			SELECT @UserPhone = COUNT(Id) FROM [USER] WHERE Phone = @pphonenumber

			IF(@UserPhone != 0)
				BEGIN
					SET @idUser = 0;
					SET @message = 'Phone number already exists.';
				END
			ELSE
				BEGIN
					DECLARE @idNewUser INT = 0
					INSERT INTO [USER](Phone, Password, IdRole) 
						VALUES(@pphonenumber, @ppassword, 2)

					SET @idNewUser = SCOPE_IDENTITY();
					
					INSERT INTO [USER_PROFILE](Name, LastName, Birthday, State, IdUser) VALUES(@pname, @plastName, @pbirthday, 1, @idNewUser)

					SET @idUser = @idNewUser;
					SET @message = 'User registered successfully.';
				END
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @idUser = 0;
		SET @message = ERROR_MESSAGE();
	END CATCH
END