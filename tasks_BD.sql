
-- 1. ESQUEMAS Y TABLAS (Los NOTICE son normales aquí)
CREATE SCHEMA IF NOT EXISTS user_schema;
CREATE SCHEMA IF NOT EXISTS task_schema;

CREATE TABLE IF NOT EXISTS user_schema.users(
    id_user       SERIAL PRIMARY KEY,
    full_name     VARCHAR (50) NOT NULL,
    email         VARCHAR (50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role_name     TEXT DEFAULT 'rol_user'
);

CREATE TABLE IF NOT EXISTS task_schema.tasks(
    id_task      SERIAL PRIMARY KEY,
    tasks_name    VARCHAR (25) NOT NULL,
    created       DATE DEFAULT CURRENT_DATE,
    status        TEXT CHECK (status IN ('pendiente', 'completada')),
    user_id       INTEGER NOT NULL,
    CONSTRAINT foreign_key_tasks_users
        FOREIGN KEY (user_id)
        REFERENCES user_schema.users (id_user)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- 2. CREACIÓN DE ROLES (Evitando errores si ya existen)
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'rol_manager') THEN
    CREATE ROLE rol_manager LOGIN PASSWORD 'manager';
  END IF;
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'rol_user') THEN
    CREATE ROLE rol_user;
  END IF;
END $$;

-- 3. PERMISOS
-- Nota: Asegúrate de que el nombre entre comillas sea exactamente el de tu BD
GRANT ALL PRIVILEGES ON DATABASE "tasks_BD" TO rol_manager;

GRANT ALL ON SCHEMA task_schema TO rol_manager;
GRANT ALL ON SCHEMA user_schema TO rol_manager;
GRANT ALL ON ALL TABLES IN SCHEMA user_schema TO rol_manager;
GRANT ALL ON ALL TABLES IN SCHEMA task_schema TO rol_manager;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA user_schema TO rol_manager;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA task_schema TO rol_manager;

GRANT CONNECT ON DATABASE "tasks_BD" TO rol_user;
GRANT USAGE ON SCHEMA task_schema TO rol_user;
GRANT SELECT, INSERT, UPDATE ON task_schema.tasks TO rol_user;
GRANT USAGE, SELECT ON SEQUENCE task_schema.tasks_id_tasks_seq TO rol_user;

-- 4. SEGURIDAD RLS
ALTER TABLE task_schema.tasks ENABLE ROW LEVEL SECURITY;

-- Borramos las políticas si ya existen para evitar errores al re-ejecutar
DROP POLICY IF EXISTS user_tasks_select_policy ON task_schema.tasks;
DROP POLICY IF EXISTS user_tasks_update_policy ON task_schema.tasks;
DROP POLICY IF EXISTS insert_tasks_policy ON task_schema.tasks;

CREATE POLICY user_tasks_select_policy ON task_schema.tasks
FOR SELECT USING (user_id = current_setting('app.current_user_id')::int);

CREATE POLICY user_tasks_update_policy ON task_schema.tasks
FOR UPDATE USING (user_id = current_setting('app.current_user_id')::int);

CREATE POLICY insert_tasks_policy ON task_schema.tasks
FOR INSERT WITH CHECK (user_id = current_setting('app.current_user_id')::int);
