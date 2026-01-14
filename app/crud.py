from sqlalchemy.orm import Session
from app import models, schemas, auth

# USUARIOS
def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def create_user(db: Session, user: schemas.UserCreate):
    hashed_pw = auth.hash_password(user.password_hash)
    db_user = models.User(
        full_name=user.full_name,
        email=user.email,
        password_hash=hashed_pw,
        role_name=user.role_name
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# TAREAS
def get_tasks(db: Session, user_id: int):
    return db.query(models.Task).filter(models.Task.user_id == user_id).all()

def create_task(db: Session, task: schemas.TaskCreate, user_id: int):
    db_task = models.Task(**task.dict(), user_id=user_id)
    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task

def update_task(db: Session, task_id: int, task_data: schemas.TaskCreate, user_id: int):
    db_task = db.query(models.Task).filter(models.Task.id_task == task_id, models.Task.user_id == user_id).first()
    if db_task:
        for key, value in task_data.dict().items():
            setattr(db_task, key, value)
        db.commit()
        db.refresh(db_task)
    return db_task

def delete_task(db: Session, task_id: int, user_id: int):
    db_task = db.query(models.Task).filter(models.Task.id_task == task_id, models.Task.user_id == user_id).first()
    if db_task:
        db.delete(db_task)
        db.commit()
        return True
    return False