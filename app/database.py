import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# Cargar las variables del archivo .env
load_dotenv()

# Obtener la URL de conexión
DATABASE_URL = os.getenv("DATABASE_URL")

# Validación de seguridad: Si no existe la variable, detenemos el programa
if not DATABASE_URL:
    raise ValueError("ERROR CRÍTICO: No se encontró la variable 'DATABASE_URL' en el archivo .env")

# Creación del motor de base de datos
engine = create_engine(DATABASE_URL)

# Creación de la sesión
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Base para los modelos
Base = declarative_base()