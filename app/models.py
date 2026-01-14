from sqlalchemy import Column, Integer, String, Text, Date, ForeignKey
from sqlalchemy.orm import relationship
from app.database import Base 

class User(Base):
    __tablename__ = "users"
    __table_args__ = {"schema": "user_schema"}

    id_user = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(50), nullable=False)
    email = Column(String(50), unique=True, nullable=False, index=True)
    password_hash = Column(Text, nullable=False)
    role_name = Column(Text, default="rol_user")

    # Relación: un usuario tiene muchas tareas
    tasks = relationship("Task", back_populates="owner")


class Task(Base):
    __tablename__ = "tasks"
    __table_args__ = {"schema": "task_schema"}

    # OJO: En tu SQL pusiste 'id_tasks' (plural). 
    # Para que SQLAlchemy sea feliz, asegúrate que coincida:
    id_task = Column(Integer, primary_key=True, index=True) 
    tasks_name = Column(String(25), nullable=False)
    created = Column(Date)
    status = Column(Text, default="pendiente")
    
    # Referencia correcta al esquema y tabla de usuarios
    user_id = Column(Integer, ForeignKey("user_schema.users.id_user", ondelete="CASCADE", onupdate="CASCADE"))

    # Relación inversa
    owner = relationship("User", back_populates="tasks")
