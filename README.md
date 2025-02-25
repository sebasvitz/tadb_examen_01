# tadb_examen_01

# Integrantes:
Natalia Urrego 000365937
Sebastián Villa 000505962

# Estructura del proyecto: 
## Resumen del Dominio del Problema

Este proyecto consiste en el desarrollo de una aplicación empresarial utilizando metodologías ágiles (5 PIs de 5 sprints cada uno, sprints de 2 semanas, para un total de 50 semanas) para la gestión de empleados y el cálculo de costos.

### Fases del Proyecto (PIS)

| PI No. | Actividad                |
| :----- | :----------------------- |
| 1      | Planificación y Análisis |
| 2      | Diseño y Prototipado     |
| 3      | Desarrollo               |
| 4      | Pruebas y Optimización   |
| 5      | Despliegue y Operación   |

### Equipos por Departamento y PI

| Departamento                    | PI 1 | PI 2 | PI 3 | PI 4 | PI 5 |
| :------------------------------ | :--- | :--- | :--- | :--- | :--- |
| Gestión y Dirección             | 1    | 1    | 1    | 1    | 1    |
| Experiencia de Usuario y Diseño | 0    | 1    | 1    | 0    | 0    |
| Arquitectura y Datos            | 0    | 1    | 1    | 1    | 0    |
| Seguridad y Calidad             | 0    | 1    | 1    | 2    | 1    |
| Desarrollo                      | 0    | 0    | 2    | 5    | 1    |
| Operación                       | 0    | 0    | 0    | 0    | 1    |

### Estructura de Cargos y Remuneración (Por Quincena)

| Departamento                    | Cargo                       | Remuneración (USD) |
| :------------------------------ | :-------------------------- | :----------------- |
| Gestión y Dirección             | Director de Proyecto        | 2750               |
|                                 | Líder Técnico               | 2250               |
|                                 | Líder Financiero            | 2150               |
| Experiencia de Usuario y Diseño | Arquitecto UX               | 2000               |
|                                 | Diseñador UI                | 1650               |
|                                 | Investigador UX             | 1800               |
|                                 | Diseñador de Interacción    | 1650               |
| Arquitectura y Datos            | Arquitecto de Soluciones    | 2500               |
|                                 | Arquitecto de Datos         | 2250               |
|                                 | Ingeniero de Datos          | 2000               |
|                                 | Especialista APIs           | 2000               |
| Seguridad y Calidad             | Arquitecto de Seguridad     | 2500               |
|                                 | Analista de Seguridad       | 2000               |
|                                 | Ingeniero Pruebas Seguridad | 1750               |
| Desarrollo                      | Líder Equipo (Máster)       | 1800               |
|                                 | Desarrollador Senior        | 2300               |
|                                 | Desarrollador Junior        | 1600               |
|                                 | Analista de Calidad         | 1500               |
| Operación                       | Arquitecto DevOps           | 2500               |
|                                 | Ingeniero SRE               | 1900               |
|                                 | Analista Mesa de Ayuda      | 1200               |

### Reglas de Negocio

*   Un empleado solo puede tener un cargo y participar en un equipo durante todo el proyecto.
*   La cantidad de equipos por tipo en cada PI indica la cantidad de empleados por cargo necesarios.
*   Múltiples equipos por departamento en un PI pueden indicar duraciones de contrato diferentes.

### Duración de Contrato para Equipos de Desarrollo

| Equipo       | PI 1 | PI 2 | PI 3 | PI 4 | PI 5 | Total PIs |
| :----------- | :--- | :--- | :--- | :--- | :--- | :-------- |
| Desarrollo 1 | NO   | NO   | SI   | SI   | SI   | 3         |
| Desarrollo 2 | NO   | NO   | SI   | SI   | NO   | 2         |
| Desarrollo 3 | NO   | NO   | NO   | SI   | NO   | 1         |
| Desarrollo 4 | NO   | NO   | NO   | SI   | NO   | 1         |
| Desarrollo 5 | NO   | NO   | NO   | SI   | NO   | 1         |
| **TOTAL**    | 0    | 0    | 2    | 5    | 1    |           |


## Tecnologías Utilizadas

- **Docker**: Para crear la base de datos en un contenedor.
- **Railway**: Para crear la base de datos en la nube.
- **Dbeaver**: Para acceder a ambas bases de datos.

## Requisitos

- Tener **Docker** instalado.
- Tener una cuenta en **Railway** para la base de datos en la nube.
- configurar un cliente como **DBeaver** para conectarse a la base de datos.
  
