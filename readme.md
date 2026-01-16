# Task Manager API - Backend Robust con FastAPI

Este proyecto es una API REST profesional diseñada para la gestión de tareas, enfocada en la seguridad y la arquitectura limpia. Implementa autenticación robusta y una estructura de base de datos avanzada en PostgreSQL con soporte para múltiples esquemas.

## Características Principales

* **Autenticación JWT:** Sistema de Login seguro con tokens de acceso (JSON Web Tokens).
* **Seguridad de Contraseñas:** Hasheo mediante `bcrypt` para garantizar que las credenciales nunca se guarden en texto plano.
* **Arquitectura Limpia:** Separación estricta de responsabilidades en módulos (`models`, `schemas`, `crud`, `auth`).
* **PostgreSQL Avanzado:** Organización mediante **Schemas** independientes para usuarios y tareas.
* **Privacidad por Usuario:** Implementación de lógica donde cada usuario solo puede gestionar sus propias tareas.
* **Validación de Integridad:** Restricciones de base de datos (`CHECK constraints`) para estados de tareas como `pendiente` y `completada`.

## Stack Tecnológico

* **Lenguaje:** Python 3.9+
* **Framework:** FastAPI
* **ORM:** SQLAlchemy
* **Base de Datos:** PostgreSQL
* **Seguridad:** Jose-JWT, Passlib & Bcrypt

## Estructura del Proyecto

```text
├── main.py          # Entry point y definición de rutas (Endpoints)
├── auth.py          # Lógica de seguridad, hashing y generación de JWT
├── crud.py          # Operaciones Create, Read, Update, Delete
├── models.py        # Modelos de tablas de SQLAlchemy
├── schemas.py       # Modelos de validación de datos Pydantic
├── database.py      # Configuración y conexión a PostgreSQL
├── tasks_bd.sql     # Script SQL para la creación de la estructura de DB
└── requirements.txt # Lista de dependencias del proyecto

# Clonar el repositorio:

git clone https://github.com/LuisEnrique/task-manager-api.git
cd task-manager-api

https://github.com/LuisEnrique/task-manager-api.git