# tadb_examen_01

# Estructura del proyecto: 

/tadb_examen_01
 ├── /RaiWay           <-- Configuración y archivos relacionados con RaiWay
 │   ├── .gitignore         <-- Ignorar archivos específicos de RaiWay
 │   ├── RaiWay.env    <-- Variables de entorno de RaiWay
 │   ├── schema.sql         <-- Estructura de la base de datos (si aplica)
 │   └── README.md          <-- Documentación específica de RaiWay
 ├── /docker-db             <-- Configuración y archivos relacionados con Docker y tu base de datos
 │   ├── .gitignore         <-- Ignorar archivos específicos de Docker
 │   ├── docker.env      <-- Variables de entorno de Docker
 │   ├── docker-compose.yml <-- Composición del contenedor
 │   ├── Dockerfile         <-- Dockerfile para la imagen
 │   ├── init.sql           <-- Archivo para inicializar la base de datos (si aplica)
 │   └── README.md          <-- Documentación específica de Docker
 ├── .gitignore             <-- Ignorar archivos generales en el proyecto (por ejemplo, dependencias globales)
 ├── README.md              <-- Documentación general del repositorio
 └── .gitignore             <-- Archivo general para ignorar configuraciones comunes

## Tecnologías Utilizadas

- **Docker**: Para crear contenedores y ejecutar la base de datos de forma aislada.
- **Railway**: Para manejar la base de datos en la nube.
- **Dbeaver**: Para acceder a ambas bases de datos.

## Requisitos

- Tener **Docker** instalado (si se utiliza Docker para bases de datos locales).
- Tener una cuenta en **Railway** para la base de datos en la nube.
- (Opcional) Tener configurado un cliente como **DBeaver** para conectarse a la base de datos.
