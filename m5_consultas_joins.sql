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
SELECT
    c.id_cliente                        AS id_cliente,
    c.nombre                            AS nombre_cliente,
    c.email                             AS email,
    c.ciudad                            AS ciudad,
    r.nombre_region                     AS region,
    c.segmento                          AS segmento_cliente,
    c.fecha_registro                    AS fecha_registro
FROM clientes           AS c
LEFT JOIN ventas        AS v    ON c.id_cliente     = v.id_cliente
INNER JOIN regiones     AS r    ON c.id_region      = r.id_region
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;

-- Consulta 3 | Productos sin ventas 
SELECT 
    p.id_producto           AS id_producto,
    p.nombre_producto       AS nombre_producto,
    cat.nombre_categoria    AS categoria, 
    p.precio                AS precio,
    p.stock                 AS stock,
    p.activo                AS activo
FROM productos              AS p
LEFT JOIN ventas        AS v        ON p.id_producto        = v.id_producto
INNER JOIN categorias   AS cat      ON p.id_categoria       = cat.id_categoria
WHERE v.id_venta IS NULL
ORDER BY p.precio DESC;

-- Consulta 4 | Consolidado por canal: cantidad de ventas y total facturado por trimestre de 2024
SELECT
    'Primer trimestre'                      AS origen,
    COUNT(*)                                AS cantidad_ventas,
    SUM(v.precio_unitario * v.cantidad)     AS total_facturado
FROM ventas     AS v
WHERE v.fecha_venta BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY YEAR(v.fecha_venta)

UNION ALL

SELECT
    'Segundo trimestre'                     AS origen,
    COUNT(*)                                AS cantidad_ventas,
    SUM(v.precio_unitario * v.cantidad)     AS total_facturado
FROM ventas     AS v
WHERE v.fecha_venta BETWEEN '2024-04-01' AND '2024-06-30'
GROUP BY YEAR(v.fecha_venta);