-- Creacion de ESQUEMAS Y TABLAS
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



-- CREACIÓN DE ROLES (Evitando errores si ya existen)
DO $$ 
BEGIN
    -- 1. Creando el grupo de permisos si no existe
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'group_basic_operations') THEN
        CREATE ROLE group_basic_operations; 
        -- Aquí podrías añadir un aviso opcional:
        RAISE NOTICE 'Permission group "group_basic_operations" created.';
    END IF;

    -- Creando el USUARIO que se registrará (Con LOGIN)
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'rol_user') THEN
        CREATE ROLE rol_user LOGIN PASSWORD 'manager' INHERIT;
        RAISE NOTICE 'User "rol_user" created.';
    END IF;
END $$;



-- Vinculando al usuario con su grupo de permisos
GRANT group_basic_operations TO rol_user;



-- Permiso de conexion con la Base de Datos
GRANT CONNECT ON DATABASE "tasks_BD" TO group_basic_operations;

-- PERMISOS PARA EL GRUPO (La base de lo que hará cualquier usuario)
-- Acceso a los esquemas
GRANT USAGE ON SCHEMA task_schema TO rol_user;
GRANT USAGE ON SCHEMA user_schema TO rol_user;
-- Permisos de operación en las tablas para el grupo
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA task_schema TO rol_user;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA user_schema TO rol_user;
-- Permiso para secuencias (Indispensable para que funcionen los SERIAL / IDs)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA task_schema TO rol_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA user_schema TO rol_user;



-- Activar Row Level Security (RLS) en la tabla
ALTER TABLE task_schema.tasks ENABLE ROW LEVEL SECURITY;

-- Borrando las políticas previas para permitir la re-ejecución del script sin errores
DROP POLICY IF EXISTS politica_seleccionar_tareas ON task_schema.tasks;
DROP POLICY IF EXISTS politica_actualizar_tareas ON task_schema.tasks;
DROP POLICY IF EXISTS politica_insertar_tareas ON task_schema.tasks;

-- Política de LECTURA (SELECT)
-- El uso de ', true' hace que si la variable no existe, devuelva NULL en vez de ERROR.
CREATE POLICY politica_seleccionar_tareas ON task_schema.tasks
FOR SELECT 
USING (user_id = current_setting('app.current_user_id', true)::int);

-- 2. Política de ACTUALIZACIÓN (UPDATE)
-- Solo permite modificar filas que ya pertenecen al usuario.
CREATE POLICY politica_actualizar_tareas ON task_schema.tasks
FOR UPDATE 
USING (user_id = current_setting('app.current_user_id', true)::int);

-- 3. Política de INSERCIÓN (INSERT)
-- El WITH CHECK valida que el user_id de la nueva tarea coincida con el usuario de la sesión.
CREATE POLICY politica_insertar_tareas ON task_schema.tasks
FOR INSERT 
WITH CHECK (user_id = current_setting('app.current_user_id', true)::int);