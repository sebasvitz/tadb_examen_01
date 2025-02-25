
----------------------------------CONSULTAS ---------------------------------------------

-- Añadir datos en la tabla pagosQuincenales. 

INSERT INTO pagosQuincenales (id_empleado, id_sprint, monto)
SELECT 
    e.id AS id_empleado, 
    s.id AS id_sprint, 
    c.remuneracion_quincena AS monto
FROM empleados e
JOIN equipos eq ON e.id_equipo = eq.id
JOIN asignacionEquipo_PI a ON eq.id = a.id_equipo
JOIN Pis p ON a.id_pi = p.id
JOIN sprints s ON p.id = s.id_pi
JOIN cargos c ON e.id_cargo = c.id
ORDER BY e.id, s.id;

---Calcular la nómina para cada quincena, especificando cuanto se pagó a cuantas personas de cuáles cargos.

SELECT 
    pq.id AS id_quincena,  
    c.nombre_cargo,
    COUNT(e.id) AS total_empleados, 
    SUM(c.remuneracion_quincena) AS total_pagado
FROM pagosQuincenales pq
JOIN empleados e ON pq.id_empleado = e.id
JOIN cargos c ON e.id_cargo = c.id
JOIN sprints s ON pq.id_sprint = s.id  
JOIN Pis p ON s.id_pi = p.id  
GROUP BY pq.id, c.nombre_cargo
ORDER BY pq.id, total_pagado DESC;

---cantidad de empleados en cada departamento

SELECT d.nom_departamento, COUNT(e.id) AS total_empleados
FROM empleados e
JOIN cargos c ON e.id_cargo = c.id
JOIN departamentos d ON c.id_departamento = d.id
GROUP BY d.nom_departamento;

--totalice para cada cargo, cuantas personas se contrataron y cuanto fue el total que se le pagó durante todo el proyecto.

SELECT 
    c.nombre_cargo,
    COUNT(DISTINCT e.id) AS total_personas_contratadas,
    SUM(c.remuneracion_quincena * sub.quincenas_trabajadas) AS total_pagado
FROM empleados e
JOIN cargos c ON e.id_cargo = c.id
JOIN (
    SELECT pq.id_empleado, COUNT(DISTINCT pq.id) AS quincenas_trabajadas
    FROM pagosQuincenales pq
    GROUP BY pq.id_empleado
) AS sub ON e.id = sub.id_empleado
GROUP BY c.nombre_cargo
ORDER BY total_pagado DESC;

