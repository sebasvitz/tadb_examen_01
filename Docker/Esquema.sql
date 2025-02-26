
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

-- Tabla Departamentos

CREATE TABLE departamentos (
    id SERIAL PRIMARY KEY,
    nom_departamento VARCHAR(50) NOT NULL
);

COMMENT ON TABLE departamentos is 'Almacena los departamentos de la empresa.';
COMMENT ON COLUMN departamentos.id is 'Id del departamento';
COMMENT ON COLUMN departamentos.nom_departamento IS 'Nombre del departamento.';

-- Tabla cargos

CREATE TABLE cargos (
    id SERIAL PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL,
    remuneracion_quincena FLOAT NOT NULL,
    id_departamento INT NOT NULL,
    CONSTRAINT fk_cargo_departamento FOREIGN KEY (id_departamento) REFERENCES departamentos(id)
);

COMMENT ON TABLE cargos IS 'Define los cargos dentro de los departamentos, incluyendo su remuneración.';
COMMENT ON COLUMN cargos.id is 'Id del cargo';
COMMENT ON COLUMN cargos.nombre_cargo IS 'Nombre del cargo.';
COMMENT ON COLUMN cargos.remuneracion_quincena IS 'Monto de remuneración quincenal.';
COMMENT ON COLUMN cargos.id_departamento IS 'Clave foránea que referencia al departamento al que pertenece el cargo.';


--Tabla equipos

CREATE TABLE equipos (
    id SERIAL PRIMARY KEY,
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
    id SERIAL PRIMARY KEY,
    nom_empleado VARCHAR(50) NOT NULL,
    id_equipo INT NOT NULL,
    id_cargo INT NOT NULL,
    CONSTRAINT fk_empleado_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id),
    CONSTRAINT fk_empleado_cargo FOREIGN KEY (id_cargo) REFERENCES cargos(id)
);

COMMENT ON TABLE empleados IS 'Almacena información de los empleados, sus equipos y cargos.';
COMMENT ON COLUMN empleados.nom_empleado IS 'Nombre del empleado.';
COMMENT ON COLUMN empleados.id IS 'Id de los empleados ';
COMMENT ON COLUMN empleados.id_equipo IS 'Clave foránea que referencia el equipo en el que trabaja el empleado.';
COMMENT ON COLUMN empleados.id_cargo IS 'Clave foránea que referencia el cargo del empleado.';

-- Tabla Pis

CREATE TABLE Pis (
    id SERIAL PRIMARY KEY,
    nom_PI VARCHAR(50) NOT NULL,
    num_pi INT NOT NULL
);
 
COMMENT ON TABLE Pis IS 'Almacena los Program Increments (PIs) en los que trabaja la empresa.';
COMMENT ON COLUMN Pis.nom_PI IS 'Nombre del Program Increment.';
COMMENT ON COLUMN Pis.id IS 'Id del Program Increment';
COMMENT ON COLUMN Pis.num_pi IS 'Número del Program Increment.';

 -- Tabla sprints

CREATE TABLE sprints (
    id SERIAL PRIMARY KEY,
    num_sprint INT NOT NULL,
    id_PI INT NOT NULL,
    CONSTRAINT fk_sprint_pi FOREIGN KEY (id_PI) REFERENCES Pis(id)
);

COMMENT ON TABLE sprints IS 'Almacena los sprints dentro de cada PI.';
COMMENT ON COLUMN sprints.id IS 'Id de los sprints';
COMMENT ON COLUMN sprints.num_sprint IS 'Número de sprint dentro del PI.';
COMMENT ON COLUMN sprints.id_PI IS 'Clave foránea que referencia el PI al que pertenece el sprint.';

-- Tabla asignacion equipos pi

CREATE TABLE asignacionEquipo_PI (
    id_equipo INT NOT NULL,
    id_pi INT NOT NULL,
    cantidad_equipo INT NOT NULL,
    PRIMARY KEY (id_equipo, id_pi),
    CONSTRAINT fk_asignacion_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id),
    CONSTRAINT fk_asignacion_pi FOREIGN KEY (id_pi) REFERENCES Pis(id)
);

COMMENT ON TABLE asignacionEquipo_PI IS 'Indica qué equipos están asignados a cada PI y cuántos miembros participan.';
COMMENT ON COLUMN asignacionEquipo_PI.id_equipo IS 'Clave foránea que referencia el equipo asignado.';
COMMENT ON COLUMN asignacionEquipo_PI.id_pi IS 'Clave foránea que referencia el PI al que está asignado el equipo.';
COMMENT ON COLUMN asignacionEquipo_PI.cantidad_equipo IS 'Cantidad de miembros del equipo asignados al PI.';

-- Tabla pagos quincena

CREATE TABLE pagosQuincenales (
    id SERIAL PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_sprint INT NOT NULL,
    CONSTRAINT fk_pago_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id),
    CONSTRAINT fk_pago_sprint FOREIGN KEY (id_sprint) REFERENCES sprints(id)
);
COMMENT ON TABLE pagosQuincenales IS 'Registra los pagos a los empleados en cada sprint.';
COMMENT ON COLUMN pagosQuincenales.id IS 'Id de los pagos de la quincena';
COMMENT ON COLUMN pagosQuincenales.id_empleado IS 'Clave foránea que referencia al empleado que recibe el pago.';
COMMENT ON COLUMN pagosQuincenales.id_sprint IS 'Clave foránea que referencia al sprint correspondiente al pago.';

-- Añadir datos en la tabla pagosQuincenales. 

INSERT INTO pagosQuincenales (id_empleado, id_sprint, monto)
SELECT 
    e.id AS id_empleado, 
    s.id AS id_sprint, 
    c.remuneracion_quincena AS monto
FROM empleados e
JOIN equipos eq ON e.id_equipo = eq.id
JOIN asignacionEquipo_PI a ON eq.id = a.id_equipo
JOIN pis p ON a.id_pi = p.id
JOIN sprints s ON p.id = s.id_pi
JOIN cargos c ON e.id_cargo = c.id
ORDER BY e.id, s.id;

----------------vistas--------------------------------



----procedimiento--------------




-- Se crea la tabla temporal antes de realizar el procedimiento
-- debido a que postgresql elimina las tablas temporales luego de finalizar procedimientos
-- con esto evitamos ese error.

CREATE TEMP TABLE nomina_temp (
    id_quincena INT,
    id_departamento INT,
    total_empleados_departamento INT,
    valor NUMERIC(10,2)
);




CREATE OR REPLACE PROCEDURE p_calcula_nomina_quincena(IN quincena_deseada INT)
LANGUAGE plpgsql
AS $$
BEGIN
   CREATE TEMP TABLE IF NOT EXISTS nomina_temp (
       id_quincena INT,
       id_departamento INT,
       total_empleados_departamento INT,
       valor NUMERIC(10,2)
   ) ON COMMIT DROP;

   -- Limpiar la tabla antes de insertar nuevos datos
   TRUNCATE TABLE nomina_temp;

   -- Insertar los datos en la tabla temporal
   INSERT INTO nomina_temp (id_quincena, id_departamento, total_empleados_departamento, valor)
   SELECT
       s.id AS id_quincena,
       d.id AS id_departamento,
       COUNT(e.id) AS total_empleados_departamento,
       SUM(pq.monto) AS valor
   FROM pagosQuincenales pq
   JOIN empleados e ON pq.id_empleado = e.id
   JOIN cargos c ON e.id_cargo = c.id
   JOIN departamentos d ON c.id_departamento = d.id
   JOIN sprints s ON pq.id_sprint = s.id
   WHERE s.id = quincena_deseada
   GROUP BY s.id, d.id;

   RAISE NOTICE 'Cálculo de nómina completado para la quincena %', quincena_deseada;
END $$;


-- llamamos el procedimiento y le damos el id de la quincena que queremos consultar

CALL p_calcula_nomina_quincena(10);


-- revisamos el resultado de la consulta

SELECT * FROM nomina_temp;


-- ahora creamos una tabla normal para poder exportar los datos
-- (ya que de una temporal no podemos) 
CREATE TABLE IF NOT EXISTS nomina_export AS 
SELECT * FROM nomina_temp;

-- Revisamos que tenga los mismos datos de la tabla temporal y exportamos
SELECT * FROM nomina_export;

-- eliminamos la tabla
DROP TABLE nomina_export;


-----------------------funciones----------------------------

-- f_calcula_costo_departamento_quincena-------------

CREATE OR REPLACE FUNCTION f_calcula_costo_departamento_quincena(
    p_quincena INT,
    p_departamento INT
) RETURNS NUMERIC(10,2) 
LANGUAGE plpgsql
AS $$
DECLARE 
    v_total NUMERIC(10,2);
BEGIN
    -- Calcular la suma de los salarios de todos los empleados del departamento en la quincena dada
    SELECT COALESCE(SUM(pq.monto), 0) 
    INTO v_total
    FROM pagosQuincenales pq
    JOIN empleados e ON pq.id_empleado = e.id
    JOIN equipos eq ON e.id_equipo = eq.id
    JOIN departamentos d ON eq.id_departamento = d.id
    WHERE pq.id_sprint = p_quincena
      AND d.id = p_departamento;

    RETURN v_total;
END $$;

------como usarla-----

SELECT f_calcula_costo_departamento_quincena(4, 1);

----para validar-----

SELECT SUM(pq.monto) AS total_pagado
FROM pagosQuincenales pq
JOIN empleados e ON pq.id_empleado = e.id
JOIN equipos eq ON e.id_equipo = eq.id
WHERE pq.id_sprint = 4 -- Quincena
 AND eq.id_departamento = 1;


