# Configuración de la Base de Datos en Railway

Este directorio contiene los archivos necesarios para configurar y conectarse a una base de datos en la nube utilizando **Railway**.

## Requisitos

- Tener una cuenta en **Railway** (https://railway.app).
- Tener configurado un archivo `.env` con las credenciales de la base de datos de Railway.
- (Opcional) Usar un cliente de base de datos como **DBeaver** o **MySQL Workbench** para conectarse.

## Pasos para Crear y Configurar la Base de Datos en Railway

### 1. Crear la Base de Datos en Railway

1. Accede a tu cuenta de Railway: [https://railway.app](https://railway.app).
2. Crea un nuevo proyecto desde el panel de control.
3. Dentro de tu proyecto, agrega una nueva **base de datos**.
   - Selecciona el tipo de base de datos que deseas usar (por ejemplo, MySQL o PostgreSQL).
   - Railway generará una **URL de conexión** que contiene todas las credenciales necesarias.

### 2. Obtener la URL de Conexión

Después de crear la base de datos, Railway te proporcionará una URL de conexión similar a estas:

mysql://user:password@hostname:3306/dbname?sslmode=require

## Pasos para conectarse desde DBeaver


### 1. Conección a la base de datos


