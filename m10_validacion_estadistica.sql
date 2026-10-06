-- poner en uso la base de datos
USE Ventas_Tech_DB;
GO

-- =========================================================================================================================
-- parte 1
-- =========================================================================================================================

-- borrar la tabla si ya existe
DROP TABLE IF EXISTS ventas_semana;

-- crear la tabla del caso guiado 
CREATE TABLE ventas_semana(
    id_registro         INT             IDENTITY(1,1) PRIMARY KEY,
    sucursal            VARCHAR(20)     NOT NULL,
    dia                 TINYINT         NOT NULL,   -- 1 a 5 (días laborales)
    venta               DECIMAL(10,2)   NOT NULL
);

-- cargar las ventas diarias (usd)
INSERT INTO ventas_semana (sucursal, dia, venta) VALUES
    ('Norte', 1,  500.00),
    ('Norte', 2,  510.00),
    ('Norte', 3,  490.00),
    ('Norte', 4,  505.00),
    ('Norte', 5,  495.00),
    ('Sur',   1,  100.00),
    ('Sur',   2,  900.00),
    ('Sur',   3,   50.00),
    ('Sur',   4, 1200.00),
    ('Sur',   5,  250.00);

-- calcular media, rango y desviación estándar muestral por sucursal
SELECT
    sucursal                            AS sucursal,
    AVG(venta)                          AS media,
    MAX(venta) - MIN(venta)             AS rango,
    CAST(STDEV(venta) AS DECIMAL(10,2)) AS desvio_muestral
FROM ventas_semana
GROUP BY sucursal;

-- =========================================================================================================================
-- parte 2
-- =========================================================================================================================

-- agregar total_venta a la tabla ventas como columna calculada. (cantidad * precio_unitario) para usar el mismo nombre que el enunciado
IF COL_LENGTH('ventas', 'total_venta') IS NULL
    ALTER TABLE ventas ADD total_venta AS (cantidad * precio_unitario);
GO
-- en sql server percentile_cont es una función de ventana, por eso lleva over () y se usa distinct para devolver una sola fila

-- a) ----------------------------------------------------------------------------------------------------------------------

-- ticket promedio: media vs. mediana y diferencia entre ambas
WITH estadisticos AS (
    SELECT DISTINCT
        COUNT(*)                                                        OVER ()     AS cantidad_ventas,
        AVG(total_venta)                                                OVER ()     AS media,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_venta)        OVER ()     AS mediana
    FROM ventas
)
SELECT
    cantidad_ventas                                 AS cantidad_ventas,
    ROUND(media, 2)                                 AS media,
    mediana                                         AS mediana,
    CAST(media - mediana AS DECIMAL(10,2))          AS diferencia,
    ROUND((media - mediana) / mediana * 100, 2)     AS media_sobre_mediana_pct
FROM estadisticos;

-- b) ----------------------------------------------------------------------------------------------------------------------

-- q1, q3, iqr y límites inferior y superior
WITH q AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_venta)       OVER ()     AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_venta)       OVER ()     AS q3
    FROM ventas
)
SELECT
    q1                                  AS q1,
    q3                                  AS q3,
    q3 - q1                             AS iqr,
    q1 - 1.5 * (q3 - q1)                AS limite_inferior,
    q3 + 1.5 * (q3 - q1)                AS limite_superior
FROM q;

-- cantidad de outliers
WITH q AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_venta)       OVER ()     AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_venta)       OVER ()     AS q3
    FROM ventas
)
SELECT
    COUNT(*)                            AS cantidad_outliers
FROM ventas AS v
CROSS JOIN q
WHERE v.total_venta < q.q1 - 1.5 * (q.q3 - q.q1)
   OR v.total_venta > q.q3 + 1.5 * (q.q3 - q.q1);

-- registros outliers y sus valores
WITH q AS (
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_venta)       OVER ()     AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_venta)       OVER ()     AS q3
    FROM ventas
)
SELECT
    v.id_venta                          AS id_venta,
    v.fecha_venta                       AS fecha_venta,
    v.id_cliente                        AS id_cliente,
    v.id_producto                       AS id_producto,
    v.cantidad                          AS cantidad,
    v.precio_unitario                   AS precio_unitario,
    v.total_venta                       AS total_venta
FROM ventas AS v
CROSS JOIN q
WHERE v.total_venta < q.q1 - 1.5 * (q.q3 - q.q1)
   OR v.total_venta > q.q3 + 1.5 * (q.q3 - q.q1)
ORDER BY v.total_venta DESC;

-- c) ----------------------------------------------------------------------------------------------------------------------

-- facturación por categoría y participación sobre el total
SELECT
    cat.nombre_categoria                                                AS categoria,
    COUNT(*)                                                            AS cantidad_ventas,
    SUM(v.total_venta)                                                  AS facturacion,
    ROUND(SUM(v.total_venta) * 100.0 / SUM(SUM(v.total_venta)) OVER (), 2) AS participacion_pct
FROM ventas             AS v
INNER JOIN productos    AS p    ON v.id_producto    = p.id_producto
INNER JOIN categorias   AS cat  ON p.id_categoria   = cat.id_categoria
GROUP BY cat.nombre_categoria
ORDER BY facturacion DESC;

