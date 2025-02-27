
----- Natalia Urrego Rodriguez- 000365937

---------------------------CONSULTAS ------------------------------------------------
---------------------------CTE----------------------------------------------------
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
    
    
    -------------------------------------- WF-------------------------------------------------
    ---------------------------------------------------------------------------------------
    ----------------------------------------------------------------------------------------
    
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
 
 