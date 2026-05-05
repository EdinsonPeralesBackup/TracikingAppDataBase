USE [alf1ery_tracking]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_FinishDangerRoute]
(
	@pTrackingId VARCHAR(10),
	@pIdUser INT,
	@finish VARCHAR(100) OUTPUT
)
AS
BEGIN

	IF (SUBSTRING(@pTrackingId, LEN(@pTrackingId), 1) <> 'T')
	BEGIN
		SET @finish = 'INCORRECT SYNTAX'
	END
	ELSE
	BEGIN
		DECLARE @countAlter INT

		UPDATE [ROUTE] 
			SET [State] = 'F' 
		WHERE 
			Tracking_id = CONCAT('track-', SUBSTRING(@pTrackingId, 1, LEN(@pTrackingId) - 1))
			AND [State] = 'D'
			AND IdUser = @pIdUser

		SET @countAlter = @@ROWCOUNT

		IF(@countAlter <> 0)
		BEGIN
			SET @finish = 'FINISH'
		END
		ELSE
		BEGIN
			SET @finish = 'NOT FOUND'
		END

	END
END