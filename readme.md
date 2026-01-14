# Task Manager API - Backend Robust con FastAPI

Este proyecto es una API REST profesional diseñada para la gestión de tareas, enfocada en la seguridad y la arquitectura limpia. Implementa autenticación robusta y una estructura de base de datos avanzada en PostgreSQL.

## Características Principales

* **Autenticación JWT:** Sistema de Login seguro con tokens de acceso (JSON Web Tokens).
* **Seguridad de Contraseñas:** Hasheo mediante `bcrypt` (nunca se guardan claves en texto plano).
* **Arquitectura Limpia:** Separación de responsabilidades en módulos (`models`, `schemas`, `crud`, `auth`).
* **PostgreSQL Avanzado:** Uso de **Schemas** independientes para usuarios y tareas.
* **Row Level Security (RLS):** Implementación de políticas de seguridad a nivel de base de datos para garantizar la privacidad de los datos por usuario.

## Stack Tecnológico

* **Lenguaje:** Python 3.9+
* **Framework:** FastAPI
* **ORM:** SQLAlchemy
* **Base de Datos:** PostgreSQL
* **Seguridad:** Jose-JWT & Passlib



## Estructura del Proyecto

```text
├── main.py          # Entry point y definición de Endpoints
├── auth.py          # Lógica de seguridad y JWT
├── crud.py          # Operaciones de base de datos
├── models.py        # Modelos de SQLAlchemy
├── schemas.py       # Esquemas de validación Pydantic
├── database.py      # Configuración de la conexión a DB
├── tasks_bd.sql     # Script de creación de base de datos
└── requirements.txt # Dependencias del proyecto

# Clonar el repositorio:

   git clone [https://github.com/tu-usuario/nombre-del-repo.git](https://github.com/tu-usuario/nombre-del-repo.git)
   cd nombre-del-repo

https://github.com/LuisEnrique/task-manager-api.git