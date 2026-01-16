# Task Manager API - Robust Backend with FastAPI

This project is a professional REST API designed for task management, focusing on security and clean architecture. It implements robust authentication and an advanced database structure in PostgreSQL with support for multiple schemas.

## Key Features

* **JWT Authentication:** Secure login system using access tokens (JSON Web Tokens).
* **Password Security:** Hashing via `bcrypt` to ensure credentials are never stored in plain text.
* **Clean Architecture:** Strict separation of concerns into modules (`models`, `schemas`, `crud`, `auth`).
* **Advanced PostgreSQL:** Organized through independent **Schemas** for users and tasks.
* **User Privacy:** Logic implementation ensuring each user can only manage their own tasks.
* **Integrity Validation:** Database restrictions (`CHECK constraints`) for task statuses such as `pending` and `completed`.

## Tech Stack

* **Language:** Python 3.9+
* **Framework:** FastAPI
* **ORM:** SQLAlchemy
* **Database:** PostgreSQL
* **Security:** Jose-JWT, Passlib & Bcrypt

## Project Structure

```text
├── main.py          # Entry point and route definitions (Endpoints)
├── auth.py          # Security logic, hashing, and JWT generation
├── crud.py          # Create, Read, Update, Delete operations
├── models.py        # SQLAlchemy table models
├── schemas.py       # Pydantic data validation models
├── database.py      # PostgreSQL configuration and connection
├── tasks_bd.sql     # SQL script for DB structure creation
└── requirements.txt # Project dependencies list

git clone [https://github.com/Enrique1103/task-manager-api.git](https://github.com/Enrique1103/task-manager-api.git)
cd task-manager-api