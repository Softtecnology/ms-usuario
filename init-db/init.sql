/*==============================================================*/
/* BORRADO DE LAS TABLAS                                        */
/*==============================================================*/
DROP TABLE IF EXISTS USER_DETAIL;
DROP TABLE IF EXISTS PERMISSION_ROLE;
DROP TABLE IF EXISTS PERMISSION;
DROP TABLE IF EXISTS USER_APP;
DROP TABLE IF EXISTS ROLE;
DROP TABLE IF EXISTS DOCUMENT_TYPE;


/*==============================================================*/
/* Table: DOCUMENT_TYPE                                        */
/*==============================================================*/
CREATE TABLE DOCUMENT_TYPE (
   DOCUMENT_TYPE_ID     BIGSERIAL           NOT NULL,
   DESCRIPTION          VARCHAR(50)         NULL,
   STATUS               BOOLEAN             NOT NULL DEFAULT TRUE,
   CONSTRAINT PK_DOCUMENT_TYPE PRIMARY KEY (DOCUMENT_TYPE_ID)
);

/*==============================================================*/
/* Table: ROLE                                                   */
/*==============================================================*/
CREATE TABLE ROLE (
   ROLE_ID               BIGSERIAL           NOT NULL,
   ROLE_NAME           VARCHAR(50)         NOT NULL,
   DESCRIPTION          VARCHAR(255)        NULL,
   STATUS               BOOLEAN             NOT NULL DEFAULT TRUE,
   CONSTRAINT PK_ROLE PRIMARY KEY (ROLE_ID)
);

/*==============================================================*/
/* Table: USER_APP                                               */
/*==============================================================*/
CREATE TABLE USER_APP (
   USER_APP_ID           BIGSERIAL           NOT NULL,
   ROLE_ID               BIGINT              NOT NULL,
   EMAIL                VARCHAR(255)        NOT NULL UNIQUE,
   PASSWORD             VARCHAR(255)        NOT NULL,
   CREATION_DATE       TIMESTAMP           NOT NULL DEFAULT NOW(),
   UPDATE_DATE  TIMESTAMP           NULL,
   STATUS              BOOLEAN             NOT NULL DEFAULT TRUE,
   CONSTRAINT PK_USER_APP PRIMARY KEY (USER_APP_ID)
);

/*==============================================================*/
/* Table: USER_DETAIL                                       */
/*==============================================================*/
CREATE TABLE USER_DETAIL (
   USER_DETAIL_ID    BIGSERIAL           NOT NULL,
   USER_ID           BIGINT              NOT NULL,
   DOCUMENTTYPE_ID     BIGINT              NOT NULL,
   IDENTIFICATIONNUMBER VARCHAR(20)         NOT NULL,
   DATEOFBIRTH      DATE                NOT NULL,
   FIRSTNAME         VARCHAR(50)         NOT NULL,
   MIDDLENAME        VARCHAR(50)         NULL,
   FIRSTLASTNAME       VARCHAR(50)         NOT NULL,
   SECONDLASTNAME      VARCHAR(50)         NULL,
   ADDRESS            VARCHAR(250)        NULL,
   CONSTRAINT PK_USER_DETAIL PRIMARY KEY (USER_DETAIL_ID)
);

/*==============================================================*/
/* Table: PERMISSION                                               */
/*==============================================================*/
CREATE TABLE PERMISSION (
   PERMISSION_ID           BIGSERIAL           NOT NULL,
   -- RECOMENDACIÓN: Usar comillas dobles para palabras clave de SQL
   "READ"               BOOLEAN             NOT NULL,
   "WRITE"              BOOLEAN             NOT NULL,
   "UPDATE"             BOOLEAN             NOT NULL,
   "DELETE"             BOOLEAN             NOT NULL,
   STATUS               BOOLEAN             NOT NULL DEFAULT TRUE,
   CONSTRAINT PK_PERMISSION PRIMARY KEY (PERMISSION_ID)
);

/*==============================================================*/
/* Table: PERMISSION_ROLE                                           */
/*==============================================================*/
CREATE TABLE PERMISSION_ROLE (
   -- RECOMENDACIÓN: Se elimina el ID autoincremental
   ROLE_ID               BIGINT              NOT NULL,
   PERMISSION_ID           BIGINT              NOT NULL,
   -- RECOMENDACIÓN: Se usa una llave primaria compuesta para garantizar unicidad
   CONSTRAINT PK_PERMISSION_ROLE PRIMARY KEY (ROLE_ID, PERMISSION_ID)
);

/*==============================================================*/
/* DEFINITION OF FOREIGN KEYS                                */
/*==============================================================*/

ALTER TABLE USER_APP
   ADD CONSTRAINT FK_USER_APP_ROLE FOREIGN KEY (ROLE_ID)
      REFERENCES ROLE (ROLE_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;

ALTER TABLE USER_DETAIL
   ADD CONSTRAINT FK_USER_DETAIL FOREIGN KEY (USER_ID)
      REFERENCES USER_APP (USER_APP_ID)
      ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE USER_DETAIL
   ADD CONSTRAINT FK_USER_DETAIL_DOC FOREIGN KEY (DOCUMENTTYPE_ID)
      REFERENCES DOCUMENT_TYPE (DOCUMENT_TYPE_ID)
      ON DELETE RESTRICT ON UPDATE RESTRICT;


ALTER TABLE PERMISSION_ROLE
   ADD CONSTRAINT FK_PERMISSION_ROLE_ROLE FOREIGN KEY (ROLE_ID)
      REFERENCES ROLE (ROLE_ID)
      ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE PERMISSION_ROLE
   ADD CONSTRAINT FK_PERMISSION_ROLE_PERMISSION FOREIGN KEY (PERMISSION_ID)
      REFERENCES PERMISSION (PERMISSION_ID)
      ON DELETE CASCADE ON UPDATE CASCADE;



/*==============================================================*/
/* SYNTHETIC DATA SCRIPT                                        */
/*==============================================================*/

-- 1. Poblando tablas maestras (sin dependencias)

-- Insertando los tipos de documento
INSERT INTO DOCUMENT_TYPE (DESCRIPTION, STATUS) VALUES
('Cédula de Ciudadanía', true),
('Cédula de Extranjería', true),
('Pasaporte', true),
('NIT', true),
('Permiso Especial de Permanencia', true);

-- Insertando los roles solicitados
INSERT INTO ROLE (ROLE_NAME, DESCRIPTION, STATUS) VALUES
('SuperAdmin', 'Control total del sistema y permisos máximos.', true),
('Administrador', 'Gestiona usuarios y configuraciones generales de la plataforma.', true),
('Propietario', 'Dueño de una o más propiedades en el sistema.', true),
('Arrendatario', 'Usuario que alquila una propiedad.', true),
('Guardia', 'Personal de seguridad con acceso a bitácoras y alertas.', true),
('Agente', 'Agente inmobiliario que gestiona propiedades y clientes.', true),
('Cliente', 'Usuario interesado en propiedades, con acceso de solo lectura.', true);

-- Insertando tipos de permisos
INSERT INTO PERMISSION ("READ", "WRITE", "UPDATE", "DELETE", STATUS) VALUES
-- Permiso 1: Control Total
(true, true, true, true, true),
-- Permiso 2: Gestión Completa (Sin Borrar)
(true, true, true, false, true),
-- Permiso 3: Solo Lectura
(true, false, false, false, true);


-- 2. Poblando la tabla de unión PERMISSION_ROLE

-- Asignando permisos a los roles
INSERT INTO PERMISSION_ROLE (ROLE_ID, PERMISSION_ID) VALUES
-- SuperAdmin (Rol 1) tiene Control Total (Permiso 1)
(1, 1),
-- Administrador (Rol 2) tiene Gestión Completa (Permiso 2)
(2, 2),
-- Propietario (Rol 3) tiene Gestión Completa (Permiso 2)
(3, 2),
-- Arrendatario (Rol 4) tiene Solo Lectura (Permiso 3)
(4, 3),
-- Guardia (Rol 5) tiene Solo Lectura (Permiso 3)
(5, 3),
-- Agente (Rol 6) tiene Gestión Completa (Permiso 2)
(6, 2),
-- Cliente (Rol 7) tiene Solo Lectura (Permiso 3)
(7, 3);


-- 3. Poblando la tabla USER_APP
-- NOTA: La contraseña es un hash BCrypt de ejemplo para 'password123'.
INSERT INTO USER_APP (ROLE_ID, EMAIL, PASSWORD, STATUS) VALUES
-- Usuario 1: SuperAdmin
(1, 'super.admin@inmobiliaria.com', '$2a$10$3zZ.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1', true),
-- Usuario 2: Administrador
(2, 'admin.principal@inmobiliaria.com', '$2a$10$3zZ.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1', true),
-- Usuario 3: Propietario
(3, 'juan.perez@email.com', '$2a$10$3zZ.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1', true),
-- Usuario 4: Arrendatario
(4, 'ana.gomez@email.com', '$2a$10$3zZ.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1', true),
-- Usuario 5: Agente
(6, 'carlos.rojas@inmobiliaria.com', '$2a$10$3zZ.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1Z.Y1', true);


-- 4. Poblando la tabla USER_DETAIL
INSERT INTO USER_DETAIL (USER_ID, DOCUMENTTYPE_ID, IDENTIFICATIONNUMBER, DATEOFBIRTH, FIRSTNAME, MIDDLENAME, FIRSTLASTNAME, SECONDLASTNAME, ADDRESS) VALUES
-- Detalles para SuperAdmin (User 1), Doc: Cédula de Ciudadanía (ID 1)
(1, 1, '1010101010', '1980-01-01', 'Admin', 'Root', 'System', 'Owner', 'Oficina Central, Calle 100 # 1-1'),
-- Detalles para Administrador (User 2), Doc: Cédula de Extranjería (ID 2)
(2, 2, 'CE-123456', '1988-05-12', 'Lucia', 'Isabel', 'Fernandez', 'Vega', 'Carrera 15 # 80-20'),
-- Detalles para Propietario (User 3), Doc: Cédula de Ciudadanía (ID 1)
(3, 1, '79888777', '1975-11-30', 'Juan', 'Carlos', 'Perez', 'Rodriguez', 'Calle Falsa 123, Apto 501'),
-- Detalles para Arrendatario (User 4), Doc: Pasaporte (ID 3)
(4, 3, 'A0B1C2D45', '1995-02-25', 'Ana', 'Maria', 'Gomez', 'Lopez', 'Avenida Siempre Viva 742'),
-- Detalles para Agente (User 5), Doc: Cédula de Ciudadanía (ID 1)
(5, 1, '1032456789', '1990-08-18', 'Carlos', 'Andres', 'Rojas', 'Mendoza', 'Transversal 5 # 45-90');