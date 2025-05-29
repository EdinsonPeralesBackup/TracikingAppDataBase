USE TrackingBD;
GO
IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RegisterCodeReset') 
	BEGIN
		DROP PROCEDURE sp_RegisterCodeReset;
	END
GO

CREATE PROCEDURE sp_RegisterCodeReset
(
	@pcode VARCHAR(6),
	@pidUser INT,
	@message VARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO CODE_RESET(Code, State, IdUser) 
				VALUES(@pcode, 1, @pidUser)
			SET @message = 'Code verified successfully.';
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @message = '';
		ROLLBACK TRANSACTION;
	END CATCH
END