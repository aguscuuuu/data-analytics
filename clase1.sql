/* Crear Base de Datos de Prueba */

CREATE DATABASE DBprueba;

-- Poner en uso la base de datos

USE DBprueba; 

/* Escenario: Registro de Cursos (Tabla NO Normalizada)
Supongamos que recibes esta tabla plana: */ 

/* Tabla Desnormalizada (Mala práctica) */

CREATE TABLE DatosCrudos (
	Estudiante VARCHAR(100),
	Email VARCHAR(100),
	Curso VARCHAR(100),
	Instructor VARCHAR(100),
	Oficina_Instructor VARCHAR(50)
);

/* Insertamos registros */

INSERT INTO DatosCrudos VALUES 
('Carlos Perez', 'carlos@mail.com', 'SQL Básico', 'Dra. Martinez', 'Oficina A1'),
('Carlos Perez', 'carlos@mail.com', 'Python', 'Ing. Garcia', 'Oficina B2'),
('Maria Gomez', 'maria@mail.com', 'SQL Básico', 'Dra. Martinez', 'Oficina A1');

--- Ver Tabla

SELECT *
FROM DatosCrudos

/* Paso 1: Crear Tablas Maestras (Estudiantes e Instructores) */

-- Tabla Estudiantes (Evita repetir emails y nombres)

CREATE TABLE Estudiantes (
    EstudianteID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100),
    Email VARCHAR(100) UNIQUE 
);

-- Tabla Instructores (Evita repetir oficinas y nombres)
-- Aquí resolvemos la 3NF: La oficina depende del instructor, no del alumno.

CREATE TABLE Instructores (
    InstructorID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100),
    Oficina VARCHAR(50)
);

-- Tabla Cursos (Asignamos instructor al curso)

CREATE TABLE Cursos (
    CursoID INT PRIMARY KEY IDENTITY(1,1),
    NombreCurso VARCHAR(100),
    InstructorID INT FOREIGN KEY REFERENCES Instructores(InstructorID)
);

/* Paso 2: Crear la Tabla de Relación (Inscripciones)
Esta tabla conecta todo sin duplicar textos, usando solo IDs (Foreign Keys). */

CREATE TABLE Inscripciones (
    InscripcionID INT PRIMARY KEY IDENTITY(1,1),
    EstudianteID INT FOREIGN KEY REFERENCES Estudiantes(EstudianteID),
    CursoID INT FOREIGN KEY REFERENCES Cursos(CursoID),
    FechaInscripcion DATETIME DEFAULT GETDATE()
);

/*¡Genial! Ya tenemos toda la estructura normalizada (3NF). 
Lo que nos falta ahora es poblar: 
Estudiantes → Instructores → Cursos → Inscripciones, tomando los datos desde DatosCrudos. */

-- 1) Cargar Estudiantes (dim)

INSERT INTO Estudiantes (Nombre, Email)
SELECT DISTINCT
    Estudiante,
    Email
FROM DatosCrudos;

-- 2) Cargar Instructores (dim)

INSERT INTO Instructores (Nombre, Oficina)
SELECT DISTINCT
    Instructor,
    Oficina_Instructor
FROM DatosCrudos;

-- 3) Cargar Cursos (dimensión con FK a Instructores)

INSERT INTO Cursos (NombreCurso, InstructorID)
SELECT DISTINCT
    dc.Curso,
    i.InstructorID
FROM DatosCrudos dc
JOIN Instructores i
    ON i.Nombre = dc.Instructor
   AND i.Oficina = dc.Oficina_Instructor;

-- 4) Cargar Inscripciones (tabla puente con FKs)

INSERT INTO Inscripciones (EstudianteID, CursoID)
SELECT
    e.EstudianteID,
    c.CursoID
FROM DatosCrudos dc
JOIN Estudiantes e
    ON e.Email = dc.Email
   AND e.Nombre = dc.Estudiante
JOIN Cursos c
    ON c.NombreCurso = dc.Curso;

-- Verificacion :

SELECT * FROM DatosCrudos;
SELECT * FROM Estudiantes;
SELECT * FROM Instructores;
SELECT * FROM Cursos;
SELECT * FROM Inscripciones; 



