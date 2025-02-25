
----------------------------------CONSULTAS ---------------------------------------------
-- CTM 

WITH CTE_Total_Pagos AS (
   SELECT
       e.id_cargo,
       COUNT(DISTINCT e.id) AS total_empleados,  -- Contamos empleados únicos
       SUM(pq.monto) AS total_pagado
   FROM empleados e
   JOIN pagosQuincenales pq ON e.id = pq.id_empleado
   GROUP BY e.id_cargo
)
SELECT
   c.id,
   c.nombre_cargo,
   cte.total_empleados,
   cte.total_pagado
FROM CTE_Total_Pagos cte
JOIN cargos c ON cte.id_cargo = c.id
ORDER BY c.id;


-- WF
SELECT 
    id_sprint AS quincena,
    SUM(monto) AS total_pagado,
    COALESCE(LAG(SUM(monto)) OVER (ORDER BY id_sprint), 0) AS pago_anterior,
    COALESCE(
        ((SUM(monto) - LAG(SUM(monto)) OVER (ORDER BY id_sprint)) / 
        NULLIF(LAG(SUM(monto)) OVER (ORDER BY id_sprint), 0)) * 100, 
    0) AS variacion_porcentual
FROM pagosQuincenales
GROUP BY id_sprint
ORDER BY id_sprint;
