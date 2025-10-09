/*==============================================================*/
/* BORRADO DE LAS TABLAS                                        */
/*==============================================================*/
DROP TABLE IF EXISTS DETALLE_USUARIO;
DROP TABLE IF EXISTS ROL_PERMISO;
DROP TABLE IF EXISTS PERMISO;
DROP TABLE IF EXISTS USUARIO;
DROP TABLE IF EXISTS ROL;
DROP TABLE IF EXISTS TIPO_DOCUMENTO;


/*==============================================================*/
/* Table: TIPO_DOCUMENTO                                        */
/*==============================================================*/
CREATE TABLE TIPO_DOCUMENTO (
   TIPODOCUMENTO_ID     BIGSERIAL           NOT NULL,
   DESCRIPCION          VARCHAR(50)         NULL,
   ESTADO               BOOLEAN             NOT NULL DEFAULT TRUE,
   CONSTRAINT PK_TIPO_DOCUMENTO PRIMARY KEY (TIPODOCUMENTO_ID)
);

/*==============================================================*/
/* Table: ROL                                                   */
/*==============================================================*/
CREATE TABLE ROL (
   ROL_ID               BIGSERIAL           NOT NULL,
   NOMBRE_ROL           VARCHAR(50)         NOT NULL,
   DESCRIPCION          VARCHAR(255)        NULL,
   ESTADO               BOOLEAN             NOT NULL DEFAULT TRUE,
   CONSTRAINT PK_ROL PRIMARY KEY (ROL_ID)
);

/*==============================================================*/
/* Table: USUARIO                                               */
/*==============================================================*/
CREATE TABLE USUARIO (
   USUARIO_ID           BIGSERIAL           NOT NULL,
   ROL_ID               BIGINT              NOT NULL,
   EMAIL                VARCHAR(255)        NOT NULL UNIQUE,
   PASSWORD             VARCHAR(255)        NOT NULL,
   FECHA_CREACION       TIMESTAMP           NOT NULL DEFAULT NOW(),
   FECHA_ACTUALIZACION  TIMESTAMP           NULL,
   ESTADO               BOOLEAN             NOT NULL DEFAULT TRUE,
   CONSTRAINT PK_USUARIO PRIMARY KEY (USUARIO_ID)
);

/*==============================================================*/
/* Table: DETALLE_USUARIO                                       */
/*==============================================================*/
CREATE TABLE DETALLE_USUARIO (
   USUARIODETALLE_ID    BIGSERIAL           NOT NULL,
   USUARIO_ID           BIGINT              NOT NULL,
   TIPODOCUMENTO_ID     BIGINT              NOT NULL,
   NUMEROIDENTIFICACION VARCHAR(20)         NOT NULL,
   FECHANACIMIENTO      DATE                NOT NULL,
   PRIMERNOMBRE         VARCHAR(50)         NOT NULL,
   SEGUNDONOMBRE        VARCHAR(50)         NULL,
   PRIMERAPELLIDO       VARCHAR(50)         NOT NULL,
   SEGUNDOAPELLIDO      VARCHAR(50)         NULL,
   DIRECCION            VARCHAR(250)        NULL,
   CONSTRAINT PK_DETALLE_USUARIO PRIMARY KEY (USUARIODETALLE_ID)
);

/*==============================================================*/
/* Table: PERMISO                                               */
/*==============================================================*/
CREATE TABLE PERMISO (
   PERMISO_ID           BIGSERIAL           NOT NULL,
   -- RECOMENDACIÓN: Usar comillas dobles para palabras clave de SQL
   "READ"               BOOLEAN             NOT NULL,
   "WRITE"              BOOLEAN             NOT NULL,
   "UPDATE"             BOOLEAN             NOT NULL,
   "DELETE"             BOOLEAN             NOT NULL,
   ESTADO               BOOLEAN             NOT NULL DEFAULT TRUE,
   CONSTRAINT PK_PERMISO PRIMARY KEY (PERMISO_ID)
);

/*==============================================================*/
/* Table: ROL_PERMISO                                           */
/*==============================================================*/
CREATE TABLE ROL_PERMISO (
   -- RECOMENDACIÓN: Se elimina el ID autoincremental
   ROL_ID               BIGINT              NOT NULL,
   PERMISO_ID           BIGINT              NOT NULL,
   -- RECOMENDACIÓN: Se usa una llave primaria compuesta para garantizar unicidad
   CONSTRAINT PK_ROL_PERMISO PRIMARY KEY (ROL_ID, PERMISO_ID)
);

/*==============================================================*/
/* DEFINICIÓN DE CLAVES FORÁNEAS                                */
/*==============================================================*/

ALTER TABLE USUARIO
   ADD CONSTRAINT FK_USUARIO_ROL FOREIGN KEY (ROL_ID)
      REFERENCES ROL (ROL_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE DETALLE_USUARIO
   ADD CONSTRAINT FK_DETALLE_USUARIO FOREIGN KEY (USUARIO_ID)
      REFERENCES USUARIO (USUARIO_ID)
      ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DETALLE_USUARIO
   ADD CONSTRAINT FK_DETALLE_TIPO_DOC FOREIGN KEY (TIPODOCUMENTO_ID)
      REFERENCES TIPO_DOCUMENTO (TIPODOCUMENTO_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

-- CORRECCIÓN CRÍTICA: Se añaden las claves foráneas faltantes
ALTER TABLE ROL_PERMISO
   ADD CONSTRAINT FK_ROLPERMISO_ROL FOREIGN KEY (ROL_ID)
      REFERENCES ROL (ROL_ID)
      ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE ROL_PERMISO
   ADD CONSTRAINT FK_ROLPERMISO_PERMISO FOREIGN KEY (PERMISO_ID)
      REFERENCES PERMISO (PERMISO_ID)
      ON DELETE CASCADE ON UPDATE CASCADE;



/*==============================================================*/
/* SCRIPT DE DATOS SINTÉTICOS                                   */
/*==============================================================*/

-- 1. Poblando tablas maestras (sin dependencias)

INSERT INTO TIPO_DOCUMENTO (DESCRIPCION, ESTADO) VALUES
('Cédula de Ciudadanía', true),
('Cédula de Extranjería', true),
('Pasaporte', true),
('NIT', true);

INSERT INTO ROL (NOMBRE_ROL, DESCRIPCION, ESTADO) VALUES
('Administrador del Sistema', 'Acceso total a todas las funcionalidades del sistema.', true),
('Gestor Inmobiliario', 'Puede gestionar propiedades, contratos y clientes.', true),
('Cliente', 'Acceso limitado para ver propiedades y gestionar su información.', true);

INSERT INTO PERMISO ("READ", "WRITE", "UPDATE", "DELETE", ESTADO) VALUES
-- Permiso 1: Control Total (para Administradores)
(true, true, true, true, true),
-- Permiso 2: Gestión (para Gestores)
(true, true, true, false, true),
-- Permiso 3: Solo Lectura (para Clientes)
(true, false, false, false, true);


-- 2. Poblando tablas dependientes

-- NOTA: Se usa un hash BCrypt de ejemplo para la contraseña 'password123'.
-- En una aplicación real, este hash debe ser generado por el backend.
INSERT INTO USUARIO (ROL_ID, EMAIL, PASSWORD, ESTADO) VALUES
-- Usuario 1 (Admin), Rol ID = 1
(1, 'admin@inmobiliaria.com', '$2a$10$3zZ.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1', true),
-- Usuario 2 (Gestor), Rol ID = 2
(2, 'gestor@inmobiliaria.com', '$2a$10$3zZ.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1', true),
-- Usuario 3 (Cliente), Rol ID = 3
(3, 'cliente.ana@example.com', '$2a$10$3zZ.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1', true);


-- 3. Poblando tablas de unión y detalles

INSERT INTO ROL_PERMISO (ROL_ID, PERMISO_ID) VALUES
-- Admin (Rol 1) tiene Control Total (Permiso 1)
(1, 1),
-- Gestor (Rol 2) tiene permisos de Gestión (Permiso 2)
(2, 2),
-- Cliente (Rol 3) tiene permisos de Solo Lectura (Permiso 3)
(3, 3);

INSERT INTO DETALLE_USUARIO (USUARIO_ID, TIPODOCUMENTO_ID, NUMEROIDENTIFICACION, FECHANACIMIENTO, PRIMERNOMBRE, SEGUNDONOMBRE, PRIMERAPELLIDO, SEGUNDOAPELLIDO, DIRECCION) VALUES
-- Detalles para Admin (Usuario 1), Tipo Doc: Cédula de Ciudadanía (ID 1)
(1, 1, '1020304050', '1985-10-20', 'Carlos', 'Alberto', 'Ramírez', 'Gómez', 'Avenida Principal 123, Oficina 501'),
-- Detalles para Gestor (Usuario 2), Tipo Doc: Cédula de Extranjería (ID 2)
(2, 2, '987654-X', '1992-03-15', 'Sofia', NULL, 'Vargas', 'Mora', 'Calle 45 # 15-30, Bogotá'),
-- Detalles para Cliente (Usuario 3), Tipo Doc: Pasaporte (ID 3)
(3, 3, 'A0B1C2D3', '1998-07-01', 'Ana', 'Lucía', 'Martínez', 'López', 'Carrera 7 # 82-01, Apto 101');