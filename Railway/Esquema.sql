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

--------------------- Creacion de vistas ----------------------------------------

CREATE VIEW v_total_empleados_por_sprint AS
SELECT 
    s.id AS id_sprint,
    s.num_sprint,
    s.id_PI,
    COUNT(DISTINCT e.id) AS total_empleados
FROM sprints s
JOIN asignacionEquipo_PI a ON s.id_PI = a.id_pi
JOIN empleados e ON a.id_equipo = e.id_equipo
GROUP BY s.id, s.num_sprint, s.id_PI;



CREATE VIEW v_nomina_por_sprint AS
SELECT 
    p.id_quincena,
    p.id_sprint,
    s.num_sprint,
    s.id_PI,
    SUM(p.valor) AS total_pagado
FROM pagoQuincena p
JOIN sprints s ON p.id_sprint = s.id
GROUP BY p.id_quincena, p.id_sprint, s.num_sprint, s.id_PI;

CREATE VIEW v_detalle_empleados_y_cargos AS
SELECT 
    e.id AS id_empleado,
    e.nom_empleado,
    c.nombre_cargo,
    c.remuneracion_quincena,
    d.nom_departamento,
    eq.nom_equipo
FROM empleados e
JOIN cargos c ON e.id_cargo = c.id
JOIN equipos eq ON e.id_equipo = eq.id
JOIN departamentos d ON eq.id_departamento = d.id;


CREATE VIEW v_resumen_costos_por_quincena AS
SELECT 
    p.id_quincena,
    s.id AS id_sprint,
    s.num_sprint,
    s.id_PI,
    SUM(p.valor) AS total_pagado
FROM pagoQuincena p
JOIN sprints s ON p.id_sprint = s.id
GROUP BY p.id_quincena, s.id, s.num_sprint, s.id_PI;

CREATE VIEW v_distribucion_equipos_en_PIs AS
SELECT 
    a.id_pi,
    p.nom_PI,
    e.id AS id_equipo,
    e.nom_equipo,
    a.cantidad_equipo AS total_miembros
FROM asignacionEquipo_PI a
JOIN Pis p ON a.id_pi = p.id
JOIN equipos e ON a.id_equipo = e.id;

------------------------------- Creacion de Procedimientos --------------------------------------------------
CREATE PROCEDURE p_calcula_nomina_quincena(IN quincena_deseada INT)
BEGIN
   -- Crear la tabla temporal (se eliminará al cerrar la sesión)
   CREATE TEMPORARY TABLE IF NOT EXISTS nomina_temp (
       id_quincena INT,
       id_departamento INT,
       total_empleados_departamento INT,
       valor DECIMAL(10,2)
   );
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
END;


-- Para usar el procedimiento
CALL p_calcula_nomina_quincena(10);
-- Para ver los resultados
SELECT * FROM nomina_temp;


---------------------------------- Creacion de Funciones ---------------------------------------------------------
-- f_calcula_costo_departamento_quincena


CREATE FUNCTION f_calcula_costo_departamento_quincena(
   p_quincena INT,
   p_departamento INT
) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
   DECLARE v_total DECIMAL(10,2);
   -- Calcular la suma de los salarios de todos los empleados del departamento en la quincena dada
   SELECT IFNULL(SUM(pq.monto), 0)
   INTO v_total
   FROM pagosQuincenales pq
   JOIN empleados e ON pq.id_empleado = e.id
   JOIN equipos eq ON e.id_equipo = eq.id
   JOIN departamentos d ON eq.id_departamento = d.id
   WHERE pq.id_sprint = p_quincena
     AND d.id = p_departamento;
   RETURN v_total;


   -- Para usar la funcion
   SELECT f_calcula_costo_departamento_quincena(6, 2);
   -- para verificar
   
SELECT SUM(pq.monto) AS total_pagado
FROM pagosQuincenales pq
JOIN empleados e ON pq.id_empleado = e.id
JOIN equipos eq ON e.id_equipo = eq.id
WHERE pq.id_sprint = 5 -- Quincena
 AND eq.id_departamento = 2;




