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
	@pphone VARCHAR(6),
	@message VARCHAR(500) OUTPUT
)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			DECLARE @IdUsuario INT;

			SELECT @IdUsuario = Id FROM [USER] WHERE Phone = @pphone

			INSERT INTO CODE_RESET(Code, State, IdUser) 
				VALUES(@pcode, 1, @IdUsuario)
			SET @message = 'Code registed successfully.';
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		SET @message = 'EX';
		ROLLBACK TRANSACTION;
	END CATCH
END