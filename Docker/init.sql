--**********************************************************************************************+
--Creacion de tablas
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
    id_departamentos INT NOT NULL,
    nom_equipo VARCHAR(50) NOT NULL,
    CONSTRAINT fk_equipo_departamento FOREIGN KEY (id_departamentos) REFERENCES departamentos(id)
);

COMMENT ON TABLE equipos IS 'Almacena los equipos de trabajo y su relación con los departamentos.';
COMMENT ON COLUMN equipos.id IS 'Id de los equipos ';
COMMENT ON COLUMN equipos.id_departamentos IS 'Clave foránea que referencia al departamento al que pertenece el equipo.';
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
