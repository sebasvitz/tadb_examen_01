
-----Natalia Urrego Rodriguez- 000365937

------------------------abastecimiento------------------------

----- crear imagen y contenedor con PostgresSQL
 Descargar la imagen de PostgreSQL
docker pull postgres:latest

docker run --name examen01_container -e POSTGRES_PASSWORD=Examen01 -d -p 5432:5432 postgres:latest

# Verificar si el contenedor está corriendo
docker ps

# Ingresar al contenedor
docker exec -it examen01_container psql -U postgres

# Crear la base de datos
CREATE DATABASE examen01_db;

# Conectarse a la base de datos
\c examen01_db;

# Crear el usuario con contraseña encriptada
CREATE USER examen01_usr WITH ENCRYPTED PASSWORD 'Examen01';

--------------------------privilegios------------------------------

# Otorgar privilegios al usuario sobre la base de datos
GRANT CONNECT ON DATABASE examen01_db TO examen01_usr;
GRANT TEMP ON DATABASE examen01_db TO examen01_usr;

# Otorgar permisos dentro del esquema público
GRANT USAGE ON SCHEMA public TO examen01_usr;
GRANT CREATE ON SCHEMA public TO examen01_usr;

# Otorgar privilegios sobre objetos existentes
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO examen01_usr;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO examen01_usr;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO examen01_usr;
GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA public TO examen01_usr;

# Otorgar privilegios sobre futuros objetos
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT ALL ON TABLES TO examen01_usr;
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT ALL ON SEQUENCES TO examen01_usr;
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT ALL ON FUNCTIONS TO examen01_usr;
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT ALL ON PROCEDURES TO examen01_usr;


--**********************************************************************************************+
---------------------------------Creacion de tablas--------------------------------------
--**************************************************************************************

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
			---------------   CREACION DE LAS TABLAS   -----------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Tabla Departamentos

CREATE TABLE departamentos (
    id INT PRIMARY KEY,
    nom_departamento VARCHAR(50) NOT NULL
);

COMMENT ON TABLE departamentos is 'Almacena los departamentos de la empresa.';
COMMENT ON COLUMN departamentos.id is 'Id del departamento';
COMMENT ON COLUMN departamentos.nom_departamento IS 'Nombre del departamento.';


-- Tabla Pis

CREATE TABLE Pis (
    id INT PRIMARY KEY,
    nom_PI VARCHAR(50) NOT NULL

);
 
COMMENT ON TABLE Pis IS 'Almacena los Program Increments en los que trabaja la empresa.';
COMMENT ON COLUMN Pis.nom_PI IS 'Nombre del Program Increment.';
COMMENT ON COLUMN Pis.id IS 'Id del Program Increment';


-- Tabla sprints

CREATE TABLE sprints (
    id INT PRIMARY KEY,
    id_PI INT NOT NULL,
    CONSTRAINT fk_sprint_pi FOREIGN KEY (id_PI) REFERENCES Pis(id)
);

COMMENT ON TABLE sprints IS 'Almacena los sprints dentro de cada PI.';
COMMENT ON COLUMN sprints.id IS 'Id de los sprints';
COMMENT ON COLUMN sprints.id_PI IS 'Clave foránea que referencia el PI al que pertenece el sprint.';

-- Tabla cargos

CREATE TABLE cargos (
    id INT PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL,
    remuneracion_quincena FLOAT NOT NULL,
    id_departamento INT NOT NULL,
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id)
);

COMMENT ON TABLE cargos IS 'Define los cargos dentro de los departamentos, incluyendo su remuneración.';
COMMENT ON COLUMN cargos.id is 'Id del cargo';
COMMENT ON COLUMN cargos.nombre_cargo IS 'Nombre del cargo.';
COMMENT ON COLUMN cargos.remuneracion_quincena IS 'Monto de remuneración quincenal.';
COMMENT ON COLUMN cargos.id_departamento IS 'Clave foránea que referencia al departamento al que pertenece el cargo.';


--Tabla equipos

CREATE TABLE equipos (
    id INT PRIMARY KEY,
    id_departamento INT NOT NULL,
    nom_equipo VARCHAR(50) NOT NULL,
    CONSTRAINT fk_equipo_departamento FOREIGN KEY (id_departamento) REFERENCES departamentos(id)
);

COMMENT ON TABLE equipos IS 'Almacena los equipos de trabajo y su relación con los departamentos.';
COMMENT ON COLUMN equipos.id IS 'Id de los equipos ';
COMMENT ON COLUMN equipos.id_departamento IS 'Clave foránea que referencia al departamento al que pertenece el equipo.';
COMMENT ON COLUMN equipos.nom_equipo IS 'Nombre del equipo.';

-- Tabla empleados

CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nom_empleado VARCHAR(50) NOT NULL,
    id_equipo INT NOT NULL,
    id_cargo INT NOT NULL,
    cantidad_pi_trabajados int not NULL,
    FOREIGN KEY (id_cargo) REFERENCES cargos(id),
    FOREIGN KEY (id_equipo) REFERENCES equipos(id)
);

COMMENT ON TABLE empleados IS 'Almacena información de los empleados, sus equipos y cargos.';
COMMENT ON COLUMN empleados.nom_empleado IS 'Nombre del empleado.';
COMMENT ON COLUMN empleados.id IS 'Id de los empleados ';
COMMENT ON COLUMN empleados.id_equipo IS 'Clave foránea que referencia el equipo en el que trabaja el empleado.';
COMMENT ON COLUMN empleados.id_cargo IS 'Clave foránea que referencia el cargo del empleado.';
COMMENT ON COLUMN empleados.cantidad_pi_trabajados IS 'cantidad de pi trabajados';




-- Tabla asignacion equipos pi

CREATE TABLE asignacionEquipo_PI (
    id_equipo INT NOT NULL,
    id_pi INT NOT NULL,
    PRIMARY KEY (id_equipo, id_pi),
    CONSTRAINT fk_asignacion_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id),
    CONSTRAINT fk_asignacion_pi FOREIGN KEY (id_pi) REFERENCES Pis(id)
);

COMMENT ON TABLE asignacionEquipo_PI IS 'Indica qué equipos están asignados a cada PI y cuántos miembros participan.';
COMMENT ON COLUMN asignacionEquipo_PI.id_equipo IS 'Clave foránea que referencia el equipo asignado.';
COMMENT ON COLUMN asignacionEquipo_PI.id_pi IS 'Clave foránea que referencia el PI al que está asignado el equipo.';


-- Tabla pagos quincena

CREATE TABLE pagosQuincenales (
    id INT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_sprint INT NOT NULL,
  	valor_pagado int not null,
    FOREIGN KEY (id_empleado) REFERENCES empleados(id),
    FOREIGN KEY (id_sprint) REFERENCES sprints(id)
);
COMMENT ON TABLE pagosQuincenales IS 'Registra los pagos a los empleados en cada sprint.';
COMMENT ON COLUMN pagosQuincenales.id IS 'Id de los pagos de la quincena';
COMMENT ON COLUMN pagosQuincenales.id_empleado IS 'Clave foránea que referencia al empleado que recibe el pago.';
COMMENT ON COLUMN pagosQuincenales.id_sprint IS 'Clave foránea que referencia al sprint correspondiente al pago.';





------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
				--------------- INSERCION DE DATOS ---------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------

INSERT INTO departamentos (id, nom_departamento) VALUES
(1, 'Gestión y Dirección'),
(2, 'Experiencia de Usuario y Diseño'),
(3, 'Arquitectura y Datos'),
(4, 'Seguridad y Calidad'),
(5, 'Desarrollo'),
(6, 'Operación');


INSERT INTO Pis (id, nom_PI) VALUES
(1, 'Planificación y Análisis'),
(2, 'Diseño y Prototipado'),
(3, 'Desarrollo'),
(4, 'Pruebas y Optimización'),
(5, 'Despliegue y Operación');


INSERT INTO sprints (id, id_PI) VALUES
(1, 1), (2, 1), (3, 1), (4, 1), (5, 1),
(6, 2), (7, 2), (8, 2), (9, 2), (10, 2),
(11, 3), (12, 3), (13, 3), (14, 3), (15, 3),
(16, 4), (17, 4), (18, 4), (19, 4), (20, 4),
(21, 5), (22, 5), (23, 5), (24, 5), (25, 5);


INSERT INTO cargos (id, nombre_cargo, remuneracion_quincena, id_departamento) VALUES
-- Gestión y Dirección
(1, 'Director de Proyecto', 2750, 1),
(2, 'Líder Técnico', 2250, 1),
(3, 'Líder Financiero', 2150, 1),

-- Experiencia de Usuario y Diseño
(4, 'Arquitecto UX', 2000, 2),
(5, 'Diseñador UI', 1650, 2),
(6, 'Investigador UX', 1800, 2),
(7, 'Diseñador de Interacción', 1650, 2),

-- Arquitectura y Datos
(8, 'Arquitecto de Soluciones', 2500, 3),
(9, 'Arquitecto de Datos', 2250, 3),
(10, 'Ingeniero de Datos', 2000, 3),
(11, 'Especialista APIs', 2000, 3),

-- Seguridad y Calidad
(12, 'Arquitecto de Seguridad', 2500, 4),
(13, 'Analista de Seguridad', 2000, 4),
(14, 'Ingeniero Pruebas Seguridad', 1750, 4),

-- Desarrollo
(15, 'Líder Equipo (Máster)', 1800, 5),
(16, 'Desarrollador Senior', 2300, 5),
(17, 'Desarrollador Junior', 1600, 5),
(18, 'Analista de Calidad', 1500, 5),

-- Operación
(19, 'Arquitecto DevOps', 2500, 6),
(20, 'Ingeniero SRE', 1900, 6),
(21, 'Analista Mesa de Ayuda', 1200, 6);


INSERT INTO equipos (id, id_departamento, nom_equipo) VALUES
-- Gestión y Dirección
(1, 1, 'Gestión y Dirección 1'),

-- Experiencia de Usuario y Diseño
(2, 2, 'Experiencia de Usuario y Diseño 1'),

-- Arquitectura y Datos
(3, 3, 'Arquitectura y Datos 1'),

-- Seguridad y Calidad
(4, 4, 'Seguridad y Calidad 1'),
(5, 4, 'Seguridad y Calidad 2'),

-- Desarrollo
(6, 5, 'Desarrollo 1'),
(7, 5, 'Desarrollo 2'),
(8, 5, 'Desarrollo 3'),
(9, 5, 'Desarrollo 4'),
(10, 5, 'Desarrollo 5'),

-- Operación
(11, 6, 'Operación 1');



INSERT INTO asignacionEquipo_PI (id_equipo, id_pi) VALUES
-- Gestión y Dirección
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),

-- Experiencia de Usuario y Diseño
(2, 2), (2, 3),

-- Arquitectura y Datos
(3, 2), (3, 3), (3, 4),

-- Seguridad y Calidad
(4, 2), (4, 3), (4, 4), (4, 5),
(5, 4),

-- Desarrollo
(6, 3), (6, 4), (6, 5),
(7, 3), (7, 4),
(8, 4),
(9, 4),
(10, 4),

-- Operación
(11, 5);


INSERT INTO empleados (id, nom_empleado, id_equipo, id_cargo, cantidad_pi_trabajados) VALUES
-- Gestión y Dirección (Equipo 1)
(1, 'Juan Pérez', 1, 1, 5),  -- Director de Proyecto
(2, 'Ana Gómez', 1, 2, 5),   -- Líder Técnico
(3, 'Carlos López', 1, 3, 5), -- Líder Financiero

-- Experiencia de Usuario y Diseño (Equipo 2)
(4, 'María Rodríguez', 2, 4, 2),  -- Arquitecto UX
(5, 'Luisa Martínez', 2, 5, 2),   -- Diseñador UI
(6, 'Pedro Sánchez', 2, 6, 2),    -- Investigador UX
(7, 'Laura Ramírez', 2, 7, 2),    -- Diseñador de Interacción

-- Arquitectura y Datos (Equipo 3)
(8, 'Sofía Torres', 3, 8, 3),  -- Arquitecto de Soluciones
(9, 'Diego Herrera', 3, 9, 3), -- Arquitecto de Datos
(10, 'Andrés Castro', 3, 10, 3), -- Ingeniero de Datos
(11, 'Camila Rojas', 3, 11, 3),  -- Especialista APIs

-- Seguridad y Calidad (Equipo 4)
(12, 'Jorge Mendoza', 4, 12, 4), -- Arquitecto de Seguridad
(13, 'Laura Gómez', 4, 13, 4),   -- Analista de Seguridad
(14, 'Carlos Ramírez', 4, 14, 4), -- Ingeniero Pruebas Seguridad

-- Seguridad y Calidad (Equipo 5)
(15, 'Ana López', 5, 12, 4), -- Arquitecto de Seguridad
(16, 'Pedro Martínez', 5, 13, 4), -- Analista de Seguridad
(17, 'Luisa Sánchez', 5, 14, 4), -- Ingeniero Pruebas Seguridad

-- Desarrollo (Equipo 6)
(18, 'María Herrera', 6, 15, 3), -- Líder Equipo (Máster)
(19, 'Diego Castro', 6, 16, 3),  -- Desarrollador Senior
(20, 'Sofía Rojas', 6, 17, 3),   -- Desarrollador Junior
(21, 'Andrés Mendoza', 6, 18, 3), -- Analista de Calidad

-- Desarrollo (Equipo 7)
(22, 'Camila Pérez', 7, 15, 2), -- Líder Equipo (Máster)
(23, 'Jorge Gómez', 7, 16, 2),  -- Desarrollador Senior
(24, 'Laura Martínez', 7, 17, 2), -- Desarrollador Junior
(25, 'Carlos Sánchez', 7, 18, 2), -- Analista de Calidad

-- Desarrollo (Equipo 8)
(26, 'Ana Ramírez', 8, 15, 1), -- Líder Equipo (Máster)
(27, 'Pedro Herrera', 8, 16, 1), -- Desarrollador Senior
(28, 'Luisa Castro', 8, 17, 1), -- Desarrollador Junior
(29, 'María Rojas', 8, 18, 1),  -- Analista de Calidad

-- Desarrollo (Equipo 9)
(30, 'Diego Mendoza', 9, 15, 1), -- Líder Equipo (Máster)
(31, 'Sofía Pérez', 9, 16, 1),  -- Desarrollador Senior
(32, 'Andrés Gómez', 9, 17, 1), -- Desarrollador Junior
(33, 'Camila Martínez', 9, 18, 1), -- Analista de Calidad

-- Desarrollo (Equipo 10)
(34, 'Jorge Sánchez', 10, 15, 1), -- Líder Equipo (Máster)
(35, 'Laura Ramírez', 10, 16, 1), -- Desarrollador Senior
(36, 'Carlos Herrera', 10, 17, 1), -- Desarrollador Junior
(37, 'Ana Castro', 10, 18, 1),  -- Analista de Calidad

-- Operación (Equipo 11)
(38, 'Pedro Rojas', 11, 19, 1), -- Arquitecto DevOps
(39, 'Luisa Mendoza', 11, 20, 1), -- Ingeniero SRE
(40, 'María Pérez', 11, 21, 1);  -- Analista Mesa de Ayuda


-- Inserción de pagos quincenales verificando el cargo y la remuneración del empleado
INSERT INTO pagosQuincenales (id, id_empleado, id_sprint, valor_pagado)
SELECT 
    ROW_NUMBER() OVER (ORDER BY e.id) AS id, -- Genera un ID único para cada pago
    e.id AS id_empleado,                    -- ID del empleado
    s.id AS id_sprint,                      -- ID del sprint (asignamos un sprint por empleado)
    c.remuneracion_quincena AS valor_pagado -- Valor pagado basado en la remuneración quincenal del cargo
FROM 
    empleados e
JOIN 
    cargos c ON e.id_cargo = c.id           -- Unimos con la tabla de cargos para obtener la remuneración
JOIN 
    sprints s ON s.id_PI BETWEEN 1 and 5   
WHERE 
    s.id BETWEEN 1 AND 25                    -- Limitamos a los primeros 5 sprints del PI 1
ORDER BY 
    e.id, s.id;
    
    
    
 -------------------------------------------------------------------------------------------------------
 ----------------------------- CONSULTAS -------------------------------------------------------------------------
 ------------------------------------------------------------------------------------------------------
 
CREATE OR REPLACE VIEW resumen_cargos AS
WITH CTE_Resumen AS (
    SELECT
        c.id AS id_cargo,
        c.nombre_cargo AS cargo,
        COUNT(e.id) AS cantidad_personas,
        SUM(c.remuneracion_quincena * e.cantidad_pi_trabajados * 2) AS total_pagado
    FROM
        cargos c
    LEFT JOIN
        empleados e ON c.id = e.id_cargo
    GROUP BY
        c.id, c.nombre_cargo
)
SELECT
    cargo,
    cantidad_personas,
    total_pagado
FROM
    CTE_Resumen;
    
    
    ---------------------------------------------------------------------------------------
    
CREATE OR REPLACE VIEW resumen_pagos_quincenales AS
WITH CTE_PagosSprint AS (
    SELECT
        s.id AS id_sprint,
        SUM(c.remuneracion_quincena) AS total_pagado_sprint
    FROM
        sprints s
    JOIN
        asignacionEquipo_PI aep ON s.id_PI = aep.id_pi
    JOIN
        equipos eq ON aep.id_equipo = eq.id
    JOIN
        empleados e ON eq.id = e.id_equipo
    JOIN
        cargos c ON e.id_cargo = c.id
    GROUP BY
        s.id
),
CTE_Variacion AS (
    SELECT
        id_sprint,
        total_pagado_sprint,
        LAG(total_pagado_sprint::INT, 1) OVER (ORDER BY id_sprint) AS total_pagado_sprint_anterior,
        COALESCE(
            ROUND(
                ((total_pagado_sprint::INT - LAG(total_pagado_sprint::INT, 1) OVER (ORDER BY id_sprint)) / LAG(total_pagado_sprint::INT, 1) OVER (ORDER BY id_sprint)) * 100,
                2
            ),
            0
        ) AS variacion_porcentual
    FROM
        CTE_PagosSprint
)
SELECT
    id_sprint AS sprint,
    total_pagado_sprint AS total_pagado,
    variacion_porcentual
FROM
    CTE_Variacion
ORDER BY
    id_sprint;
 
 
 
 
 -------------------------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------------
		 --------------------  Tabla Nomina  ------------------------------------
 -------------------------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------------
 
 
 CREATE TABLE nomina (
    id_quincena INT NOT NULL,               -- ID de la quincena (sprint)
    id_departamento INT NOT NULL,           -- ID del departamento
    total_empleados_departamento INT,       -- Total de empleados en el departamento
    valor NUMERIC(10, 2),                   -- Valor total pagado en la quincena
    PRIMARY KEY (id_quincena, id_departamento)  -- Clave primaria compuesta
);

COMMENT ON TABLE nomina IS 'Almacena el resumen de pagos por quincena y departamento.';
COMMENT ON COLUMN nomina.id_quincena IS 'ID de la quincena (sprint).';
COMMENT ON COLUMN nomina.id_departamento IS 'ID del departamento.';
COMMENT ON COLUMN nomina.total_empleados_departamento IS 'Total de empleados en el departamento para la quincena.';
COMMENT ON COLUMN nomina.valor IS 'Valor total pagado en la quincena para el departamento.';
 
 -------------------------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------------
		 --------------------  FUNCIONES Y PROCEDIMIENTOS  ------------------------------------
 -------------------------------------------------------------------------------------------------
 -------------------------------------------------------------------------------------------------
 
 CREATE OR REPLACE FUNCTION f_calcula_costo_departamento_quincenal(
    p_quincena INT,  -- Número de la quincena (sprint)
    p_departamento_id INT  -- Código del departamento
)
RETURNS NUMERIC AS
$$
DECLARE
    total_pagado NUMERIC;
BEGIN
    -- Calcula el total pagado en la quincena para el departamento especificado
    SELECT
        SUM(c.remuneracion_quincena)
    INTO
        total_pagado
    FROM
        empleados e
    JOIN
        cargos c ON e.id_cargo = c.id
    JOIN
        departamentos d ON c.id_departamento = d.id
    JOIN
        asignacionEquipo_PI aep ON e.id_equipo = aep.id_equipo
    JOIN
        sprints s ON aep.id_pi = s.id_PI
    WHERE
        s.id = p_quincena  -- Filtra por la quincena (sprint)
        AND d.id = p_departamento_id;  -- Filtra por el departamento

    -- Si no hay registros, devuelve 0
    IF total_pagado IS NULL THEN
        RETURN 0;
    ELSE
        RETURN total_pagado;
    END IF;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION f_calcula_total_empleados_departamento_quincena(
    p_quincena INT,  -- Número de la quincena (sprint)
    p_departamento_id INT  -- ID del departamento
)
RETURNS INT AS
$$
DECLARE
    total_empleados INT;
BEGIN
    -- Calcula el total de empleados en el departamento para la quincena especificada
    SELECT
        COUNT(DISTINCT e.id)
    INTO
        total_empleados
    FROM
        empleados e
    JOIN
        cargos c ON e.id_cargo = c.id
    JOIN
        departamentos d ON c.id_departamento = d.id
    JOIN
        asignacionEquipo_PI aep ON e.id_equipo = aep.id_equipo
    JOIN
        sprints s ON aep.id_pi = s.id_PI
    WHERE
        s.id = p_quincena  -- Filtra por la quincena (sprint)
        AND d.id = p_departamento_id;  -- Filtra por el departamento

    -- Si no hay registros, devuelve 0
    IF total_empleados IS NULL THEN
        RETURN 0;
    ELSE
        RETURN total_empleados;
    END IF;
END;
$$
LANGUAGE plpgsql;






--Procedimiento


CREATE OR REPLACE PROCEDURE p_calcula_nomina_quincenal(
    p_quincena INT  -- Número de la quincena (sprint)
)
AS
$$
DECLARE
    departamento RECORD;
    total_empleados INT;
    total_pagado NUMERIC(10, 2);
BEGIN
    -- Borra los registros existentes para la quincena especificada
    DELETE FROM nomina WHERE id_quincena = p_quincena;

    -- Recorre todos los departamentos
    FOR departamento IN SELECT id FROM departamentos LOOP
        -- Calcula el total de empleados en el departamento para la quincena
        total_empleados := f_calcula_total_empleados_departamento_quincena(p_quincena, departamento.id);

        -- Calcula el total pagado en el departamento para la quincena
        total_pagado := f_calcula_costo_departamento_quincenal(p_quincena, departamento.id);

        -- Inserta los datos en la tabla NOMINA
        INSERT INTO nomina (id_quincena, id_departamento, total_empleados_departamento, valor)
        VALUES (p_quincena, departamento.id, total_empleados, total_pagado);
    END LOOP;
END;
$$
LANGUAGE plpgsql;




--Llamadas al procedimiento
CALL p_calcula_nomina_quincenal(1);
CALL p_calcula_nomina_quincenal(2);
CALL p_calcula_nomina_quincenal(3);
CALL p_calcula_nomina_quincenal(4);
CALL p_calcula_nomina_quincenal(5);
CALL p_calcula_nomina_quincenal(6);
CALL p_calcula_nomina_quincenal(7);
CALL p_calcula_nomina_quincenal(8);
CALL p_calcula_nomina_quincenal(9);
CALL p_calcula_nomina_quincenal(10);
CALL p_calcula_nomina_quincenal(11);
CALL p_calcula_nomina_quincenal(12);
CALL p_calcula_nomina_quincenal(13);
CALL p_calcula_nomina_quincenal(14);
CALL p_calcula_nomina_quincenal(15);
CALL p_calcula_nomina_quincenal(16);
CALL p_calcula_nomina_quincenal(17);
CALL p_calcula_nomina_quincenal(18);
CALL p_calcula_nomina_quincenal(19);
CALL p_calcula_nomina_quincenal(20);
CALL p_calcula_nomina_quincenal(21);
CALL p_calcula_nomina_quincenal(22);
CALL p_calcula_nomina_quincenal(23);
CALL p_calcula_nomina_quincenal(24);
CALL p_calcula_nomina_quincenal(25);
 