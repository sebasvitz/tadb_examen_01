 README - Base de Datos en Docker y Conexión desde DBeaver

# Hecho por
Natalia Urrego 000365937

Este proyecto proporciona una configuración para ejecutar el proyecto en un contenedor de Docker y conectarse a ella utilizando *DBeaver*.

---

## Tabla de Contenidos## Tabla de Contenidos
- [README - Base de Datos en Docker y Conexión desde DBeaver](#readme---base-de-datos-en-docker-y-conexión-desde-dbeaver)
- [Hecho por](#hecho-por)
  - [Tabla de Contenidos## Tabla de Contenidos](#tabla-de-contenidos-tabla-de-contenidos)
  - [Requisitos](#requisitos)
  - [Configuración de la Base de Datos en Docker](#configuración-de-la-base-de-datos-en-docker)
    - [1. Crear un Archivo docker-compose.yml](#1-crear-un-archivo-docker-composeyml)
- [2. Iniciar el Contenedor](#2-iniciar-el-contenedor)
- [3. Verificar que el Contenedor Esté en Ejecución](#3-verificar-que-el-contenedor-esté-en-ejecución)
- [Conexión desde DBeaver](#conexión-desde-dbeaver)
  - [Método 1: Conexión con Credenciales](#método-1-conexión-con-credenciales)
  - [Método 2: Conexión con URL JDBC](#método-2-conexión-con-url-jdbc)
- [Notas Adicionales](#notas-adicionales)

---

## Requisitos

Antes de comenzar, asegúrate de tener instalado lo siguiente:

- [Docker](https://www.docker.com/get-started)
- [DBeaver](https://dbeaver.io/download/) (o cualquier cliente de bases de datos compatible con JDBC)

---

## Configuración de la Base de Datos en Docker

Sigue estos pasos para configurar y ejecutar la base de datos en un contenedor de Docker:

### 1. Crear un Archivo docker-compose.yml

Crea un archivo llamado docker-compose.yml en la raíz de tu proyecto 

(Para mayor informacion de como crear este archivo consulte en internet)

# 2. Iniciar el Contenedor
Ejecuta el siguiente comando en la terminal para iniciar el contenedor:
docker-compose up -d

Esto descargará la imagen de PostgreSQL (o MySQL) y creará un contenedor con la base de datos.

# 3. Verificar que el Contenedor Esté en Ejecución

Para verificar que el contenedor esté en ejecución, usa:
docker ps

# Conexión desde DBeaver
Puedes conectarte a la base de datos en Docker desde DBeaver utilizando credenciales o una URL JDBC.

## Método 1: Conexión con Credenciales
Abre DBeaver.

Haz clic en "Nueva conexión" (el ícono de una base de datos con un signo más).

Selecciona el tipo de base de datos (PostgreSQL).

Completa los campos con la siguiente información:

Host: localhost

Puerto: 5432 (para PostgreSQL)

Base de datos: mydatabase

Usuario: myuser

Contraseña: mypassword

Haz clic en "Test Connection" para verificar la conexión.

Si la prueba es exitosa, haz clic en "Finish".

## Método 2: Conexión con URL JDBC
Abre DBeaver.

Haz clic en "Nueva conexión" (el ícono de una base de datos con un signo más).

Selecciona el tipo de base de datos (PostgreSQL).

En la pestaña "Principal", completa los siguientes campos:

URL:

Para PostgreSQL: jdbc:postgresql://localhost:5432/mydatabase


Usuario: myuser

Contraseña: mypassword

En la pestaña "SSL", configura lo siguiente:

Modo SSL: Selecciona "Disable" (a menos que estés utilizando SSL).

Haz clic en "Test Connection" para verificar la conexión.

Si la prueba es exitosa, haz clic en "Finish".

# Notas Adicionales
Persistencia de Datos: Los datos de la base de datos se almacenan en un volumen de Docker llamado db_data. Esto garantiza que los datos no se pierdan al reiniciar el contenedor.

Cambiar Credenciales: Si deseas cambiar el usuario, contraseña o nombre de la base de datos, modifica el archivo docker-compose.yml y reinicia el contenedor.

Detener el Contenedor: Para detener el contenedor, usa:
docker-compose down

Reiniciar el Contenedor: Para reiniciar el contenedor, usa:
docker-compose restart