USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'usp_EditUserInfo') 
	BEGIN
		DROP PROCEDURE usp_EditUserInfo;
	END
GO

CREATE PROCEDURE usp_EditUserInfo
(
	@pId INT,
	@pname VARCHAR(200),
	@plastName VARCHAR(300),
	@pbirthday DATE,
	@pphoneNumber VARCHAR(10),
	@pavatarImg VARCHAR(MAX),
	@message VARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			UPDATE USER_PROFILE SET 
				[Name] = @pname,
				LastName = @plastName,
				Birthday = @pbirthday,
				Avatar = @pavatarImg
			WHERE IdUser = @pId

			UPDATE [USER] SET 
				Phone = @pphoneNumber
			WHERE Id = @pId
			SET @message = 'User updated successfully.';
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		SET @message = 'User update failed';
		ROLLBACK TRANSACTION
	END CATCH
END