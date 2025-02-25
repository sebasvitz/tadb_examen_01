# Configuración de la Base de Datos en Railway

## Hecho por
**Sebastián Villa Vargas** - 000505962

## Tabla de Contenidos

- [Configuración de la Base de Datos en Railway](#configuración-de-la-base-de-datos-en-railway)
  - [Hecho por](#hecho-por)
  - [Tabla de Contenidos](#tabla-de-contenidos)
  - [Requisitos](#requisitos)
  - [Configuración en Railway](#configuración-en-railway)
    - [1. Crear la Base de Datos](#1-crear-la-base-de-datos)
    - [2. Obtener URL de Conexión](#2-obtener-url-de-conexión)
  - [Conexión desde DBeaver](#conexión-desde-dbeaver)
    - [Configuración Básica](#configuración-básica)
    - [Configuración SSL](#configuración-ssl)
  - [Notas Adicionales](#notas-adicionales)



---

## Requisitos
- Cuenta en [Railway](https://railway.app)
- Archivo `.env` configurado con credenciales de Railway
- Cliente de base de datos como [DBeaver](https://dbeaver.io/download/) (recomendado)

---

## Configuración en Railway

### 1. Crear la Base de Datos
1. Inicia sesión en [Railway](https://railway.app)
2. Crea un nuevo proyecto
3. Agrega un servicio de base de datos:
   - Selecciona MySQL/PostgreSQL
   - Railway generará automáticamente una **URL de conexión**

### 2. Obtener URL de Conexión
La URL tendrá este formato:

mysql://usuario:contraseña@host-railway:3306/nombre_db?sslmode=require

## Conexión desde DBeaver

### Configuración Básica
Abre DBeaver → Nueva conexión (icono de base de datos +)

Selecciona MySQL

Configura:
URL: jdbc:mysql://<host>:<port>/<database>
Usuario: <usuario>
Contraseña: <contraseña>

### Configuración SSL

Ve a la pestaña SSL

Configura:
Modo SSL: Require
Verify Server Certificate: false

Importante: Railway usa certificados SSL automáticos. No necesitas cargar archivos CA.

## Notas Adicionales

1 Formato JDBC:
Usa siempre este formato para MySQL:

jdbc:mysql://host:puerto/base_de_datos

2 Firewall:
Railway no requiere configuración de firewall. Si tienes errores de conexión:

Verifica la URL

Revisa las credenciales

Prueba desde otra red

Reinicio de servicio:
Si modificas el .env, reinicia DBeaver para aplicar cambios.

Backups automáticos:
Railway realiza backups diarios. No necesitas configuración adicional.