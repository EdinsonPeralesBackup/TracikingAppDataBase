CREATE FUNCTION dbo.fn_EvaluarPuntoEnLinea (
    @LatA FLOAT,
    @LonA FLOAT,
    @LatB FLOAT,
    @LonB FLOAT,
    @LatP FLOAT,
    @LonP FLOAT
)
RETURNS DECIMAL(10, 4)
AS
BEGIN
    DECLARE @geoA GEOGRAPHY = GEOGRAPHY::Point(@LatA, @LonA, 4326);
    DECLARE @geoB GEOGRAPHY = GEOGRAPHY::Point(@LatB, @LonB, 4326);
    DECLARE @geoP GEOGRAPHY = GEOGRAPHY::Point(@LatP, @LonP, 4326);

    DECLARE @line GEOGRAPHY = @geoA.STUnion(@geoB).STConvexHull();

    DECLARE @desviacion FLOAT = @geoP.STDistance(@line);

    RETURN @desviacion;
END;
GO
