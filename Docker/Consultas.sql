
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



