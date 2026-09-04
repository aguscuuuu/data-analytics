-- Poner en uso la base de datos 
USE Ventas_Tech_DB;

-- Consulta 1 | Vista base del proyecto 
SELECT
    v.id_venta                          AS id_venta,
    v.fecha_venta                       AS fecha,
    v.id_cliente                        AS id_cliente,
    c.nombre                            AS nombre_cliente,
    c.segmento                          AS segmento_cliente,
    c.ciudad                            AS ciudad,
    r.nombre_region                     AS region,
    p.nombre_producto                   AS producto,
    cat.nombre_categoria                AS categoria,
    v.cantidad                          AS cantidad,
    v.precio_unitario                   AS precio_unitario,
    v.cantidad * v.precio_unitario      AS total_venta
FROM ventas             AS v
INNER JOIN clientes     AS c    ON v.id_cliente     = c.id_cliente
INNER JOIN productos    AS p    ON v.id_producto    = p.id_producto
INNER JOIN categorias   AS cat  ON p.id_categoria   = cat.id_categoria
INNER JOIN regiones     AS r    ON c.id_region      = r.id_region
ORDER BY v.fecha_venta, v.id_venta;

-- Consulta 2 | Clientes sin ventas 

-- Consulta 3 | Productos sin ventas 

-- Consulta 4 | Consolidado por canal 
