-- Crear base de datos  
CREATE DATABASE Ventas_Tech_DB;
GO

-- Poner en uso la base de datos 
USE Ventas_Tech_DB;

-- Eliminar las tablas si ya existen (orden inverso de dependencias)
DROP TABLE IF EXISTS ventas; 
DROP TABLE IF EXISTS productos; 
DROP TABLE IF EXISTS clientes; 
DROP TABLE IF EXISTS categorias; 
DROP TABLE IF EXISTS regiones;

-- Crear las tablas
CREATE TABLE regiones(
    id_region           INT             PRIMARY KEY,
    nombre_region       VARCHAR(50)     NOT NULL
);

CREATE TABLE categorias(
    id_categoria        INT             PRIMARY KEY,
    nombre_categoria    VARCHAR(50)     NOT NULL,
    descripcion         VARCHAR(200)
);

CREATE TABLE clientes(
    id_cliente          INT             PRIMARY KEY,
    nombre              VARCHAR(100)    NOT NULL, 
    email               VARCHAR(100)    UNIQUE, 
    ciudad              VARCHAR(50),
    id_region           INT             FOREIGN KEY REFERENCES regiones(id_region),
    segmento            VARCHAR(20)     NOT NULL,
    fecha_registro      DATE            NOT NULL
);

CREATE TABLE productos(
    id_producto         INT             PRIMARY KEY,
    nombre_producto     VARCHAR(100)    NOT NULL,
    id_categoria        INT             FOREIGN KEY REFERENCES categorias(id_categoria),
    precio              DECIMAL(10,2)   NOT NULL,   
    stock               INT             DEFAULT 0, 
    activo              TINYINT         DEFAULT 1 
);

CREATE TABLE ventas(
    id_venta            INT             PRIMARY KEY,
    id_cliente          INT             FOREIGN KEY REFERENCES clientes(id_cliente), 
    id_producto         INT             FOREIGN KEY REFERENCES productos(id_producto),
    cantidad            INT             NOT NULL,
    precio_unitario     DECIMAL(10,2)   NOT NULL,
    fecha_venta         DATE            NOT NULL
);

-- Cargar los datos en el orden correcto (primero las tablas sin dependencias)
INSERT INTO regiones        VALUES (1, 'Centro');
INSERT INTO regiones        VALUES (2, 'Norte');
INSERT INTO regiones        VALUES (3, 'Cuyo');
INSERT INTO regiones        VALUES (4, 'Litoral');
INSERT INTO regiones        VALUES (5, 'Patagonia');

INSERT INTO categorias      VALUES (1, 'Computación',       'Laptops, PCs y monitores');
INSERT INTO categorias      VALUES (2, 'Accesorios',        'Periféricos y complementos');
INSERT INTO categorias      VALUES (3, 'Audio',             'Auriculares y parlantes');
INSERT INTO categorias      VALUES (4, 'Almacenamiento',    'Discos y memorias');
INSERT INTO categorias      VALUES (5, 'Redes',             'Routers y conectividad');

INSERT INTO clientes        VALUES (1, 'María López',       'maria@mail.com',   'Buenos Aires', 1, 'Corporativo', '2024-01-05');
INSERT INTO clientes        VALUES (2, 'Carlos Ruiz',       'carlos@mail.com',  'Córdoba',      1, 'Retail',      '2024-01-10');
INSERT INTO clientes        VALUES (3, 'Ana Gómez',         'ana@mail.com',     'Rosario',      4, 'Mayorista',   '2024-02-01');
INSERT INTO clientes        VALUES (4, 'Pedro Sanz',        'pedro@mail.com',   'Mendoza',      3, 'Retail',      '2024-02-15');
INSERT INTO clientes        VALUES (5, 'Laura Torres',      'laura@mail.com',   'Tucumán',      2, 'Corporativo', '2024-03-01');
INSERT INTO clientes        VALUES (6, 'Diego Herrera',     'diego@mail.com',   'Neuquén',      5, 'Retail',      '2024-04-12');
INSERT INTO clientes        VALUES (7, 'Sofía Molina',      'sofia@mail.com',   'Salta',        2, 'Mayorista',   '2024-05-20');
INSERT INTO clientes        VALUES (8, 'Martín Vega',       'martin@mail.com',  'La Plata',     1, 'Corporativo', '2024-06-02');

INSERT INTO productos       VALUES (1,  'Laptop Pro 15',        1,  1200.00,    15,     1);
INSERT INTO productos       VALUES (2,  'Mouse Inalámbrico',    2,    28.00,    80,     1);
INSERT INTO productos       VALUES (3,  'Monitor 4K 27"',       1,   450.00,    12,     1);
INSERT INTO productos       VALUES (4,  'Auriculares BT Pro',   3,   120.00,    35,     1);
INSERT INTO productos       VALUES (5,  'SSD Externo 1TB',      4,   130.00,    18,     1);
INSERT INTO productos       VALUES (6,  'Teclado Mecánico',     2,    95.00,    40,     1);
INSERT INTO productos       VALUES (7,  'Notebook Air 13',      1,   890.00,    10,     1);
INSERT INTO productos       VALUES (8,  'Router WiFi 6',        5,    75.00,    25,     1);
INSERT INTO productos       VALUES (9,  'Parlante Bluetooth',   3,    60.00,    22,     1);
INSERT INTO productos       VALUES (10, 'Pendrive 128GB',       4,    15.00,   100,     0);

-- Ventas de enero
INSERT INTO ventas          VALUES (11, 1, 1, 1, 1200.00, '2024-01-15');
INSERT INTO ventas          VALUES (12, 2, 2, 3,   28.00, '2024-01-18');
INSERT INTO ventas          VALUES (13, 1, 5, 1,  130.00, '2024-01-22');
INSERT INTO ventas          VALUES (14, 2, 6, 2,   95.00, '2024-01-28');

-- Ventas de febrero
INSERT INTO ventas          VALUES (15, 3, 1, 1, 1150.00, '2024-02-05');
INSERT INTO ventas          VALUES (16, 4, 3, 2,  450.00, '2024-02-20');
INSERT INTO ventas          VALUES (17, 1, 4, 3,  120.00, '2024-02-22');
INSERT INTO ventas          VALUES (18, 3, 7, 1,  890.00, '2024-02-25');
INSERT INTO ventas          VALUES (19, 2, 2, 6,   26.00, '2024-02-27');

-- Ventas de marzo
INSERT INTO ventas          VALUES (1,  1, 1, 2, 1200.00, '2024-03-05');
INSERT INTO ventas          VALUES (2,  2, 2, 5,   28.00, '2024-03-06');
INSERT INTO ventas          VALUES (3,  3, 3, 1,  450.00, '2024-03-07');
INSERT INTO ventas          VALUES (4,  1, 4, 2,  120.00, '2024-03-08');
INSERT INTO ventas          VALUES (5,  4, 5, 3,  130.00, '2024-03-10');
INSERT INTO ventas          VALUES (6,  2, 6, 4,   95.00, '2024-03-11');
INSERT INTO ventas          VALUES (7,  5, 1, 1, 1200.00, '2024-03-12');
INSERT INTO ventas          VALUES (8,  3, 2, 8,   28.00, '2024-03-13');
INSERT INTO ventas          VALUES (9,  4, 4, 1,  120.00, '2024-03-14');
INSERT INTO ventas          VALUES (10, 5, 3, 2,  450.00, '2024-03-15');
INSERT INTO ventas          VALUES (20, 3, 7, 2,
