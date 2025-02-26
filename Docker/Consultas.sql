
----- Natalia Urrego Rodriguez- 000365937

---------------------------CONSULTAS ------------------------------------------------

---CTM

WITH CTE_Pagos_Empleado AS (
    SELECT
        e.id_cargo,
        e.id AS empleado_id,
        SUM(pq.monto) AS total_pagado_empleado
    FROM pagosQuincenales pq
    JOIN empleados e ON pq.id_empleado = e.id
    GROUP BY e.id_cargo, e.id
)
SELECT
    c.id AS id_cargo,
    c.nombre_cargo,
    COUNT(CTE_Pagos_Empleado.empleado_id) AS total_empleados,
    SUM(CTE_Pagos_Empleado.total_pagado_empleado) AS total_pagado
FROM CTE_Pagos_Empleado
JOIN cargos c ON CTE_Pagos_Empleado.id_cargo = c.id
GROUP BY c.id, c.nombre_cargo
ORDER BY c.id;


---WF-----------------
SELECT 
    id_sprint AS quincena,
    SUM(monto) AS total_pagado,
    COALESCE(LAG(SUM(monto)) OVER (ORDER BY id_sprint), 0) AS pago_anterior,
    COALESCE(
        ((SUM(monto) - LAG(SUM(monto)) OVER (ORDER BY id_sprint)) * 100 / 
        NULLIF(LAG(SUM(monto)) OVER (ORDER BY id_sprint), 0)), 
    0) AS variacion_porcentual
FROM pagosQuincenales
GROUP BY id_sprint
ORDER BY id_sprint;



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
JOIN pis p ON s.id_pi = p.id  
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