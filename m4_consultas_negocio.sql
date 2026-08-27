-- Poner en uso la base de datos 
USE Ventas_Tech_DB;

-- Visualizar la base de ventas entera 
SELECT * FROM ventas;

-- CONSULTA 1 | Resumen ejecutivo mensual
SELECT
    MONTH(fecha_venta)                          AS mes,
    SUM(precio_unitario * cantidad)             AS total_facturado,
    COUNT(*)                                    AS cantidad_pedidos,
    SUM(precio_unitario * cantidad) / COUNT(*)  AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- CONSULTA 2 | Top 5 de productos que más facturaron 
SELECT TOP 5
    id_producto                     AS id_producto,
    SUM(cantidad)                   AS unidades_vendidas, 
    SUM(precio_unitario * cantidad) AS total_facturado 
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC; 

-- CONSULTA 3 | Clientes recurrentes 
SELECT 
    id_cliente                      AS id_cliente,
    COUNT(*)                        AS pedidos_realizados,
    SUM(precio_unitario * cantidad) AS total_gastado 
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY pedidos_realizados DESC;

-- CONSULTA 4 | Meses por encima / por debajo del promedio 
SELECT
    MONTH(fecha_venta)                  AS mes,
    SUM(precio_unitario * cantidad)     AS total_facturado,
    CASE
        WHEN SUM(precio_unitario * cantidad) >= (
                SELECT AVG(total_mes)
                FROM (
                    SELECT SUM(precio_unitario * cantidad) AS total_mes
                    FROM ventas
                    GROUP BY MONTH(fecha_venta)
                ) AS meses
            ) THEN
                'Por encima'
        ELSE
                'Por debajo'
    END                                 AS comparacion
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- BLOQUE DE CIERRE

-- 1) El mes 3 facturó $6.444, con 10 pedidos y un ticket promedio de $644,40.
-- 2) El producto 1 concentra el 55,9% de la facturación total ($3.600 de $6.444) con apenas 3 unidades vendidas, mientras que el producto 2 vendió 13 unidades pero solo facturó $364.
-- 3) No hay un cliente más recurrente que el otro, ya que todos realizaron 2 pedidos en el mes. 