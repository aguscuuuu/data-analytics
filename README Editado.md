# RetailPro – Proyecto de Data Analytics

Proyecto de análisis de datos para **RetailPro**, un comercio de productos tecnológicos. El objetivo es modelar la información de ventas en una base de datos relacional, responder preguntas de negocio con SQL y construir un pipeline ETL y un dashboard en Power BI para el seguimiento de indicadores comerciales.

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `sql-checkpoint/ventas_tech_db.sql` | Creación de la base `Ventas_Tech_DB`: tablas (`regiones`, `categorias`, `clientes`, `productos`, `ventas`) y carga de datos. |
| `m4_consultas_negocio.sql` | Consultas de negocio: resumen ejecutivo mensual, top 5 de productos por facturación, clientes recurrentes y meses por encima/debajo del promedio. |
| `m5_consultas_joins.sql` | Consultas con JOINs: vista base del proyecto, clientes sin ventas, productos sin ventas y consolidado por canal/trimestre 2024. |
| `Pipeline_ETL_Dataset.xlsx` | Dataset de origen para el pipeline ETL. |
| `Pipeline_ETL_Cuenca_Agustin.pbix` | Pipeline ETL en Power BI (Power Query). |
| `Cuenca_Agustin_Checkpoint2.pbix` | Checkpoint 2 del proyecto en Power BI. |
| `dashboard.pbix` | Dashboard final de ventas. |
| `m7_boceto_dashboard.png` | Boceto del diseño del dashboard. |
| `new-theme.json` | Tema personalizado de Power BI. |

## Modelo de datos

```
regiones ──< clientes ──< ventas >── productos >── categorias
```

- **regiones**: regiones geográficas (Centro, Norte, Cuyo, Litoral, Patagonia).
- **categorias**: categorías de productos.
- **clientes**: datos del cliente, segmento, ciudad y región.
- **productos**: catálogo con precio, stock y estado.
- **ventas**: transacciones (cliente, producto, cantidad, precio unitario, fecha).

## Preguntas de negocio que responde

| Pregunta | Script |
|---|---|
| ¿Cómo evoluciona la facturación, la cantidad de pedidos y el ticket promedio mes a mes? | `m4_consultas_negocio.sql` (Consulta 1) |
| ¿Qué 5 productos generan más facturación? | `m4_consultas_negocio.sql` (Consulta 2) |
| ¿Qué clientes compran más de una vez y cuánto gastan? | `m4_consultas_negocio.sql` (Consulta 3) |
| ¿Qué meses están por encima o por debajo del promedio de facturación? | `m4_consultas_negocio.sql` (Consulta 4) |
| ¿Cuál es la vista integrada de ventas con cliente, región, producto y categoría? | `m5_consultas_joins.sql` (Consulta 1) |
| ¿Qué clientes registrados todavía no compraron? | `m5_consultas_joins.sql` (Consulta 2) |
| ¿Qué productos del catálogo no registran ventas? | `m5_consultas_joins.sql` (Consulta 3) |
| ¿Cuántas ventas hubo y cuánto se facturó por canal en cada trimestre de 2024? | `m5_consultas_joins.sql` (Consulta 4) |

## Herramientas utilizadas

- **SQL Server** (T-SQL) y **SQL Server Management Studio (SSMS)** o Azure Data Studio.
- **Microsoft Power BI Desktop** (Power Query para ETL, modelado y visualización).
- **Microsoft Excel** como fuente de datos.
- **Git / GitHub** para control de versiones.

## Cómo ejecutar los scripts SQL

Requisitos: una instancia de SQL Server (Express o Developer alcanza) y un cliente como SSMS o Azure Data Studio.

1. **Crear la base y cargar los datos**
   Abrir `sql-checkpoint/ventas_tech_db.sql` y ejecutarlo completo (F5). Crea la base `Ventas_Tech_DB`, sus tablas y carga los registros.
   > Si la base ya existe, eliminala antes (`DROP DATABASE Ventas_Tech_DB;`) o comentá la línea `CREATE DATABASE`.

2. **Consultas de negocio**
   Abrir `m4_consultas_negocio.sql` y ejecutar cada consulta por separado (seleccionar el bloque y F5).

3. **Consultas con JOINs**
   Abrir `m5_consultas_joins.sql` y ejecutar cada consulta de la misma forma.

Desde la línea de comandos también se puede usar `sqlcmd`:

```bash
sqlcmd -S localhost -E -i sql-checkpoint/ventas_tech_db.sql
sqlcmd -S localhost -E -i m4_consultas_negocio.sql
sqlcmd -S localhost -E -i m5_consultas_joins.sql
```

(`-E` usa autenticación de Windows; para autenticación SQL reemplazar por `-U usuario -P contraseña`.)

## Dashboard en Power BI

Abrir `dashboard.pbix` con Power BI Desktop. Para aplicar el tema personalizado: *Vista → Temas → Buscar temas* y seleccionar `new-theme.json`.

## Autor

Agustín Cuenca
