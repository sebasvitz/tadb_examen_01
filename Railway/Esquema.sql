-- Sebastián Villa Vargas 000505962

-------------------------- Creación de Usuario con los permisos minimos ----------------
CREATE USER 'user1'@'%' IDENTIFIED BY 'c0ntr4señ4';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON nomina_db.* TO 'user1'@'%';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'user1'@'%';




-- Creación de tablas --




-- Tabla Departamentos
CREATE TABLE departamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_departamento VARCHAR(50) NOT NULL
);

-- Tabla Cargos
CREATE TABLE cargos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cargo VARCHAR(50) NOT NULL,
    remuneracion_quincena FLOAT NOT NULL,
    id_departamento INT NOT NULL,
    CONSTRAINT fk_cargo_departamento FOREIGN KEY (id_departamento) REFERENCES departamentos(id)
);

-- Tabla Equipos
CREATE TABLE equipos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_departamentos INT NOT NULL,
    nom_equipo VARCHAR(50) NOT NULL,
    CONSTRAINT fk_equipo_departamento FOREIGN KEY (id_departamento) REFERENCES departamentos(id)
);

-- Tabla Empleados
CREATE TABLE empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_empleado VARCHAR(50) NOT NULL,
    id_equipo INT NOT NULL,
    id_cargo INT NOT NULL,
    CONSTRAINT fk_empleado_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id),
    CONSTRAINT fk_empleado_cargo FOREIGN KEY (id_cargo) REFERENCES cargos(id)
);

-- Tabla Pis
CREATE TABLE Pis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom_PI VARCHAR(50) NOT NULL,
    num_pi INT NOT NULL
);

-- Tabla Sprints
CREATE TABLE sprints (
    id INT AUTO_INCREMENT PRIMARY KEY,
    num_sprint INT NOT NULL,
    id_PI INT NOT NULL,
    CONSTRAINT fk_sprint_pi FOREIGN KEY (id_PI) REFERENCES Pis(id)
);

-- Tabla AsignacionEquipo_PI
CREATE TABLE asignacionEquipo_PI (
    id_equipo INT NOT NULL,
    id_pi INT NOT NULL,
    cantidad_equipo INT NOT NULL,
    PRIMARY KEY (id_equipo, id_pi),
    CONSTRAINT fk_asignacion_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id),
    CONSTRAINT fk_asignacion_pi FOREIGN KEY (id_pi) REFERENCES Pis(id)
);

-- Tabla PagosQuincenales
CREATE TABLE pagosQuincenales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_empleado INT NOT NULL,
    id_sprint INT NOT NULL,
    CONSTRAINT fk_pago_empleado FOREIGN KEY (id_empleado) REFERENCES empleados(id),
    CONSTRAINT fk_pago_sprint FOREIGN KEY (id_sprint) REFERENCES sprints(id)
);