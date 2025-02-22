--Creacion de tablas

-- Tabla Departamentos

CREATE TABLE departamentos (
    id SERIAL PRIMARY KEY,
    nom_departamento VARCHAR(50) NOT NULL
);

-- Tabla cargos

CREATE TABLE cargos (
    id SERIAL PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL,
    remuneracion_quincena FLOAT NOT NULL,
    id_departamento INT NOT NULL,
    CONSTRAINT fk_cargo_departamento FOREIGN KEY (id_departamento) REFERENCES departamentos(id)
);

--Tabla equipos

CREATE TABLE equipos (
    id SERIAL PRIMARY KEY,
    id_departamentos INT NOT NULL,
    nom_equipo VARCHAR(50) NOT NULL,
    CONSTRAINT fk_equipo_departamento FOREIGN KEY (id_departamentos) REFERENCES departamentos(id)
);

-- Tabla empleados

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nom_empleado VARCHAR(50) NOT NULL,
    id_equipo INT NOT NULL,
    id_cargo INT NOT NULL,
    CONSTRAINT fk_empleado_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id),
    CONSTRAINT fk_empleado_cargo FOREIGN KEY (id_cargo) REFERENCES cargos(id)
);

-- Tabla Pis

CREATE TABLE Pis (
    id SERIAL PRIMARY KEY,
    nom_PI VARCHAR(50) NOT NULL,
    num_pi INT NOT NULL
);
 
 -- Tabla sprints

CREATE TABLE sprints (
    id SERIAL PRIMARY KEY,
    num_sprint INT NOT NULL,
    id_PI INT NOT NULL,
    CONSTRAINT fk_sprint_pi FOREIGN KEY (id_PI) REFERENCES Pis(id)
);

-- Tabla asignacion equipos pi

CREATE TABLE asignacionEquipo_PI (
    id_equipo INT NOT NULL,
    id_pi INT NOT NULL,
    cantidad_equipo INT NOT NULL,
    PRIMARY KEY (id_equipo, id_pi),
    CONSTRAINT fk_asignacion_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id),
    CONSTRAINT fk_asignacion_pi FOREIGN KEY (id_pi) REFERENCES Pis(id)
);

-- Tabla pagos quincena

CREATE TABLE pagosQuincenales (
    id SERIAL PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_sprint INT NOT NULL,
    CONSTRAINT fk_pago_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id),
    CONSTRAINT fk_pago_sprint FOREIGN KEY (id_sprint) REFERENCES sprints(id)
);
