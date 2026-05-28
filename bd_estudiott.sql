CREATE DATABASE ESTUDIOTT;
GO
USE ESTUDIOTT;
GO

CREATE TABLE roles_empleados (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    nombre      NVARCHAR(100)    NOT NULL UNIQUE,
    descripcion NVARCHAR(100),
    permisos    NVARCHAR(100),
    created_at  DATETIME2
);

CREATE TABLE empleados (
    id            UNIQUEIDENTIFIER PRIMARY KEY,
    auth_user_id  UNIQUEIDENTIFIER NULL,
    rol_id        UNIQUEIDENTIFIER NULL,
    nombre        NVARCHAR(100)    NOT NULL,
    apellido      NVARCHAR(100)    NOT NULL,
    email         NVARCHAR(100)    NOT NULL UNIQUE,
    telefono      NVARCHAR(20),
    cargo         NVARCHAR(100),
    especialidad  NVARCHAR(100),
    fecha_ingreso DATE,
    activo        BIT,
    created_at    DATETIME2,
    updated_at    DATETIME2,
    FOREIGN KEY (rol_id) REFERENCES roles_empleados(id)
);

CREATE TABLE clientes (
    id                  UNIQUEIDENTIFIER PRIMARY KEY,
    nombre              NVARCHAR(150)    NOT NULL,
    tipo_cliente        NVARCHAR(50),
    documento_identidad NVARCHAR(50),
    condicion           NVARCHAR(50),
    categoria           NVARCHAR(100),
    email               NVARCHAR(100),
    telefono            NVARCHAR(20),
    direccion           NVARCHAR(100),
    activo              BIT,
    fecha_creacion      DATE,
    created_at          DATETIME2,
    updated_at          DATETIME2
);

CREATE TABLE contactos_clientes (
    id           UNIQUEIDENTIFIER PRIMARY KEY,
    cliente_id   UNIQUEIDENTIFIER NOT NULL,
    nombre       NVARCHAR(150)    NOT NULL,
    cargo        NVARCHAR(100),
    telefono     NVARCHAR(20),
    email        NVARCHAR(100),
    es_principal BIT,
    activo       BIT,
    created_at   DATETIME2,
    updated_at   DATETIME2,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

CREATE TABLE roles_cliente (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    nombre      NVARCHAR(100)    NOT NULL UNIQUE,
    descripcion NVARCHAR(100),
    color       NVARCHAR(50),
    created_at  DATETIME2
);

CREATE TABLE materias (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    nombre      NVARCHAR(100)    NOT NULL UNIQUE,
    descripcion NVARCHAR(100),
    color       NVARCHAR(50),
    activo      BIT,
    created_at  DATETIME2
);

CREATE TABLE tipos_proceso (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    nombre      NVARCHAR(100)    NOT NULL UNIQUE,
    descripcion NVARCHAR(100),
    color       NVARCHAR(50),
    activo      BIT,
    created_at  DATETIME2
);

CREATE TABLE estados_proceso (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    nombre      NVARCHAR(100)    NOT NULL UNIQUE,
    descripcion NVARCHAR(100),
    color       NVARCHAR(50),
    categoria   NVARCHAR(100),
    orden       INT,
    activo      BIT,
    created_at  DATETIME2
);

CREATE TABLE estados_tarea (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    nombre      NVARCHAR(100)    NOT NULL UNIQUE,
    descripcion NVARCHAR(100),
    color       NVARCHAR(50),
    categoria   NVARCHAR(100),
    orden       INT,
    activo      BIT,
    created_at  DATETIME2
);

CREATE TABLE lugar (
    id         UNIQUEIDENTIFIER PRIMARY KEY,
    nombre     NVARCHAR(255),
    created_at DATETIME2
);

CREATE TABLE procesos (
    id                      UNIQUEIDENTIFIER PRIMARY KEY,
    nombre                  NVARCHAR(255)    NOT NULL,
    cliente_id              UNIQUEIDENTIFIER NULL,
    rol_cliente_id          UNIQUEIDENTIFIER NULL,
    vs                      NVARCHAR(255),
    materia_id              UNIQUEIDENTIFIER NULL,
    pretensiones            NVARCHAR(255),
    dependencia             NVARCHAR(255),
    tipo_proceso_id         UNIQUEIDENTIFIER NULL,
    estado_id               UNIQUEIDENTIFIER NULL,
    estado_general          NVARCHAR(50),
    impulso                 BIT,
    ultima_actualizacion_id UNIQUEIDENTIFIER NULL,
    fecha_proximo_contacto  DATE,
    orden                   INT              NOT NULL,
    contraparte             NVARCHAR(255),
    lugar                   UNIQUEIDENTIFIER NULL,
    url_constancia_cierre   NVARCHAR(255),
    created_at              DATETIME2,
    updated_at              DATETIME2,
    FOREIGN KEY (cliente_id)      REFERENCES clientes(id),
    FOREIGN KEY (rol_cliente_id)  REFERENCES roles_cliente(id),
    FOREIGN KEY (materia_id)      REFERENCES materias(id),
    FOREIGN KEY (tipo_proceso_id) REFERENCES tipos_proceso(id),
    FOREIGN KEY (estado_id)       REFERENCES estados_proceso(id),
    FOREIGN KEY (lugar)           REFERENCES lugar(id)
);

CREATE TABLE actualizaciones_proceso (
    id                  UNIQUEIDENTIFIER PRIMARY KEY,
    proceso_id          UNIQUEIDENTIFIER NULL,
    empleado_id         UNIQUEIDENTIFIER NULL,
    descripcion         NVARCHAR(100)    NOT NULL,
    tipo                NVARCHAR(50),
    fecha_actualizacion DATETIME2,
    created_at          DATETIME2,
    FOREIGN KEY (proceso_id)  REFERENCES procesos(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

ALTER TABLE procesos
    ADD CONSTRAINT fk_ultima_actualizacion
    FOREIGN KEY (ultima_actualizacion_id) REFERENCES actualizaciones_proceso(id);

CREATE TABLE proceso_empleados (
    id               UNIQUEIDENTIFIER PRIMARY KEY,
    proceso_id       UNIQUEIDENTIFIER NULL,
    empleado_id      UNIQUEIDENTIFIER NULL,
    rol              NVARCHAR(100),
    fecha_asignacion DATETIME2,
    activo           BIT,
    created_at       DATETIME2,
    FOREIGN KEY (proceso_id)  REFERENCES procesos(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE tareas (
    id                  UNIQUEIDENTIFIER PRIMARY KEY,
    proceso_id          UNIQUEIDENTIFIER NULL,
    cliente_id          UNIQUEIDENTIFIER NULL,
    empleado_creador_id UNIQUEIDENTIFIER NULL,
    estado_id           UNIQUEIDENTIFIER NULL,
    nombre              NVARCHAR(255)    NOT NULL,
    descripcion         NVARCHAR(100),
    notas               NVARCHAR(100),
    importancia         NVARCHAR(50)     CHECK (importancia IN ('importante', 'no importante')),
    urgencia            NVARCHAR(50)     CHECK (urgencia IN ('urgente', 'no urgente')),
    fecha_limite        DATE,
    fecha_vencimiento   DATE,
    fecha_completada    DATETIME2,
    es_todo_el_dia      BIT              NOT NULL,
    hora_inicio         TIME,
    hora_fin            TIME,
    orden               INT,
    activo              BIT,
    created_at          DATETIME2,
    updated_at          DATETIME2,
    FOREIGN KEY (proceso_id)          REFERENCES procesos(id),
    FOREIGN KEY (cliente_id)          REFERENCES clientes(id),
    FOREIGN KEY (empleado_creador_id) REFERENCES empleados(id),
    FOREIGN KEY (estado_id)           REFERENCES estados_tarea(id)
);

CREATE TABLE tareas_empleados_responsables (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    tarea_id    UNIQUEIDENTIFIER NOT NULL,
    empleado_id UNIQUEIDENTIFIER NOT NULL,
    created_at  DATETIME2,
    FOREIGN KEY (tarea_id)    REFERENCES tareas(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE tareas_empleados_designados (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    tarea_id    UNIQUEIDENTIFIER NOT NULL,
    empleado_id UNIQUEIDENTIFIER NOT NULL,
    created_at  DATETIME2,
    FOREIGN KEY (tarea_id)    REFERENCES tareas(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE notas_tarea (
    id                     UNIQUEIDENTIFIER PRIMARY KEY,
    tarea_id               UNIQUEIDENTIFIER NOT NULL UNIQUE,
    contenido              NVARCHAR(100)    NOT NULL,
    empleado_modificado_id UNIQUEIDENTIFIER NULL,
    created_at             DATETIME2,
    updated_at             DATETIME2,
    FOREIGN KEY (tarea_id)               REFERENCES tareas(id),
    FOREIGN KEY (empleado_modificado_id) REFERENCES empleados(id)
);

CREATE TABLE notas_tarea_historial (
    id                 UNIQUEIDENTIFIER PRIMARY KEY,
    nota_id            UNIQUEIDENTIFIER NOT NULL,
    tarea_id           UNIQUEIDENTIFIER NOT NULL,
    empleado_id        UNIQUEIDENTIFIER NOT NULL,
    contenido_anterior NVARCHAR(100),
    contenido_nuevo    NVARCHAR(100),
    created_at         DATETIME2,
    FOREIGN KEY (nota_id)     REFERENCES notas_tarea(id),
    FOREIGN KEY (tarea_id)    REFERENCES tareas(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE subtareas (
    id                  UNIQUEIDENTIFIER PRIMARY KEY,
    tarea_id            UNIQUEIDENTIFIER NOT NULL,
    estado_id           UNIQUEIDENTIFIER NULL,
    empleado_creador_id UNIQUEIDENTIFIER NULL,
    nombre              NVARCHAR(255)    NOT NULL,
    descripcion         NVARCHAR(100),
    notas               NVARCHAR(100),
    observaciones       NVARCHAR(100),
    importancia         NVARCHAR(50)     CHECK (importancia IN ('importante', 'no importante')),
    urgencia            NVARCHAR(50)     CHECK (urgencia IN ('urgente', 'no urgente')),
    prioridad           NVARCHAR(50),
    tiempo_estimado     INT,
    tiempo_real         INT,
    fecha_limite        DATE,
    fecha_vencimiento   DATE,
    fecha_completada    DATETIME2,
    completada          BIT,
    orden               INT,
    activo              BIT,
    created_at          DATETIME2,
    updated_at          DATETIME2,
    FOREIGN KEY (tarea_id)            REFERENCES tareas(id),
    FOREIGN KEY (estado_id)           REFERENCES estados_tarea(id),
    FOREIGN KEY (empleado_creador_id) REFERENCES empleados(id)
);

CREATE TABLE subtareas_empleados_responsables (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    subtarea_id UNIQUEIDENTIFIER NOT NULL,
    empleado_id UNIQUEIDENTIFIER NOT NULL,
    created_at  DATETIME2,
    FOREIGN KEY (subtarea_id) REFERENCES subtareas(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE subtareas_empleados_designados (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    subtarea_id UNIQUEIDENTIFIER NOT NULL,
    empleado_id UNIQUEIDENTIFIER NOT NULL,
    created_at  DATETIME2,
    FOREIGN KEY (subtarea_id) REFERENCES subtareas(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE impulsos (
    id                 UNIQUEIDENTIFIER PRIMARY KEY,
    proceso_id         UNIQUEIDENTIFIER NULL,
    empleado_id        UNIQUEIDENTIFIER NULL,
    titulo             NVARCHAR(255)    NOT NULL,
    descripcion        NVARCHAR(100),
    tipo               NVARCHAR(50),
    estado             NVARCHAR(50),
    fecha_impulso      DATETIME2        NOT NULL,
    notificado         BIT,
    fecha_notificacion DATETIME2,
    created_at         DATETIME2,
    updated_at         DATETIME2,
    FOREIGN KEY (proceso_id)  REFERENCES procesos(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE comentarios (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    proceso_id  UNIQUEIDENTIFIER NULL,
    empleado_id UNIQUEIDENTIFIER NULL,
    contenido   NVARCHAR(100)    NOT NULL,
    tipo        NVARCHAR(50),
    created_at  DATETIME2,
    FOREIGN KEY (proceso_id)  REFERENCES procesos(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE documentos (
    id             UNIQUEIDENTIFIER PRIMARY KEY,
    proceso_id     UNIQUEIDENTIFIER NULL,
    empleado_id    UNIQUEIDENTIFIER NULL,
    nombre_archivo NVARCHAR(255)    NOT NULL,
    tipo_documento NVARCHAR(100),
    ruta_archivo   NVARCHAR(100)    NOT NULL,
    tamanio        BIGINT,
    mime_type      NVARCHAR(100),
    descripcion    NVARCHAR(100),
    created_at     DATETIME2,
    FOREIGN KEY (proceso_id)  REFERENCES procesos(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE historial_cambios (
    id               UNIQUEIDENTIFIER PRIMARY KEY,
    tabla            NVARCHAR(100)    NOT NULL,
    registro_id      UNIQUEIDENTIFIER NOT NULL,
    empleado_id      UNIQUEIDENTIFIER NULL,
    accion           NVARCHAR(50)     NOT NULL,
    datos_anteriores NVARCHAR(100),
    datos_nuevos     NVARCHAR(100),
    created_at       DATETIME2,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE chat_historial (
    id          UNIQUEIDENTIFIER PRIMARY KEY,
    empleado_id UNIQUEIDENTIFIER NULL,
    role        NVARCHAR(20)     CHECK (role IN ('user', 'assistant')),
    content     NVARCHAR(100)    NOT NULL,
    created_at  DATETIME2        NOT NULL,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE modificaciones (
    id                UNIQUEIDENTIFIER PRIMARY KEY,
    proceso_id        UNIQUEIDENTIFIER NULL,
    empleado_id       UNIQUEIDENTIFIER NULL,
    fechaModificacion DATETIME2        NOT NULL,
    descripcion       NVARCHAR(255)    NULL,
    tipo              NVARCHAR(50)     NULL,
    FOREIGN KEY (proceso_id)  REFERENCES procesos(id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE TABLE usuarios (
    id_usuario  INT              PRIMARY KEY IDENTITY,
    username    NVARCHAR(50)     NOT NULL UNIQUE,
    password    NVARCHAR(100)    NOT NULL,
    rol         NVARCHAR(50)     NOT NULL,
    empleado_id UNIQUEIDENTIFIER NULL,
    FOREIGN KEY (empleado_id) REFERENCES empleados(id)
);

CREATE NONCLUSTERED INDEX idx_empleados_rol     ON empleados(rol_id);
CREATE NONCLUSTERED INDEX idx_empleados_email   ON empleados(email);
CREATE NONCLUSTERED INDEX idx_empleados_nombre  ON empleados(nombre, apellido);
CREATE NONCLUSTERED INDEX idx_clientes_condicion ON clientes(condicion);
CREATE NONCLUSTERED INDEX idx_clientes_nombre    ON clientes(nombre);
CREATE NONCLUSTERED INDEX idx_contactos_cliente  ON contactos_clientes(cliente_id);
CREATE NONCLUSTERED INDEX idx_procesos_cliente   ON procesos(cliente_id);
CREATE NONCLUSTERED INDEX idx_procesos_estado    ON procesos(estado_id);
CREATE NONCLUSTERED INDEX idx_procesos_materia   ON procesos(materia_id);
CREATE NONCLUSTERED INDEX idx_procesos_tipo      ON procesos(tipo_proceso_id);
CREATE NONCLUSTERED INDEX idx_procesos_lugar     ON procesos(lugar);
CREATE NONCLUSTERED INDEX idx_actualizaciones_proceso  ON actualizaciones_proceso(proceso_id);
CREATE NONCLUSTERED INDEX idx_actualizaciones_empleado ON actualizaciones_proceso(empleado_id);
CREATE NONCLUSTERED INDEX idx_actualizaciones_fecha    ON actualizaciones_proceso(fecha_actualizacion);
CREATE NONCLUSTERED INDEX idx_proc_emp_proceso   ON proceso_empleados(proceso_id);
CREATE NONCLUSTERED INDEX idx_proc_emp_empleado  ON proceso_empleados(empleado_id);
CREATE NONCLUSTERED INDEX idx_tareas_proceso     ON tareas(proceso_id);
CREATE NONCLUSTERED INDEX idx_tareas_cliente     ON tareas(cliente_id);
CREATE NONCLUSTERED INDEX idx_tareas_estado      ON tareas(estado_id);
CREATE NONCLUSTERED INDEX idx_tareas_creador     ON tareas(empleado_creador_id);
CREATE NONCLUSTERED INDEX idx_tareas_fecha       ON tareas(fecha_limite);
CREATE NONCLUSTERED INDEX idx_tar_resp_tarea     ON tareas_empleados_responsables(tarea_id);
CREATE NONCLUSTERED INDEX idx_tar_resp_empleado  ON tareas_empleados_responsables(empleado_id);
CREATE NONCLUSTERED INDEX idx_tar_des_tarea      ON tareas_empleados_designados(tarea_id);
CREATE NONCLUSTERED INDEX idx_tar_des_empleado   ON tareas_empleados_designados(empleado_id);
CREATE NONCLUSTERED INDEX idx_notas_tarea        ON notas_tarea(tarea_id);
CREATE NONCLUSTERED INDEX idx_notas_hist_nota    ON notas_tarea_historial(nota_id);
CREATE NONCLUSTERED INDEX idx_notas_hist_tarea   ON notas_tarea_historial(tarea_id);
CREATE NONCLUSTERED INDEX idx_subtareas_tarea    ON subtareas(tarea_id);
CREATE NONCLUSTERED INDEX idx_subtareas_estado   ON subtareas(estado_id);
CREATE NONCLUSTERED INDEX idx_subtareas_creador  ON subtareas(empleado_creador_id);
CREATE NONCLUSTERED INDEX idx_sub_resp_subtarea  ON subtareas_empleados_responsables(subtarea_id);
CREATE NONCLUSTERED INDEX idx_sub_resp_empleado  ON subtareas_empleados_responsables(empleado_id);
CREATE NONCLUSTERED INDEX idx_sub_des_subtarea   ON subtareas_empleados_designados(subtarea_id);
CREATE NONCLUSTERED INDEX idx_sub_des_empleado   ON subtareas_empleados_designados(empleado_id);
CREATE NONCLUSTERED INDEX idx_impulsos_proceso   ON impulsos(proceso_id);
CREATE NONCLUSTERED INDEX idx_impulsos_empleado  ON impulsos(empleado_id);
CREATE NONCLUSTERED INDEX idx_impulsos_fecha     ON impulsos(fecha_impulso);
CREATE NONCLUSTERED INDEX idx_comentarios_proceso ON comentarios(proceso_id);
CREATE NONCLUSTERED INDEX idx_comentarios_emp     ON comentarios(empleado_id);
CREATE NONCLUSTERED INDEX idx_docs_proceso       ON documentos(proceso_id);
CREATE NONCLUSTERED INDEX idx_docs_empleado      ON documentos(empleado_id);
CREATE NONCLUSTERED INDEX idx_docs_tipo          ON documentos(tipo_documento);
CREATE NONCLUSTERED INDEX idx_historial_tabla    ON historial_cambios(tabla);
CREATE NONCLUSTERED INDEX idx_historial_empleado ON historial_cambios(empleado_id);
CREATE NONCLUSTERED INDEX idx_historial_fecha    ON historial_cambios(created_at);
CREATE NONCLUSTERED INDEX idx_chat_empleado      ON chat_historial(empleado_id);
CREATE NONCLUSTERED INDEX idx_chat_role          ON chat_historial(role);
CREATE NONCLUSTERED INDEX idx_usuarios_empleado  ON usuarios(empleado_id);