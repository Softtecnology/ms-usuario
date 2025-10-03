-- -----------------------------------------------------
-- Tabla: usuarios
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS usuarios (
    usuario_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    tipo_documento VARCHAR(10) NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    rol VARCHAR(50) NOT NULL CHECK (rol IN ('SuperAdmin', 'Administrador', 'Propietario', 'Arrendatario', 'Guardia', 'Agente', 'Cliente')),
    activo BOOLEAN DEFAULT false,
    fecha_creacion TIMESTAMPTZ NOT NULL DEFAULT now(),
    ultimo_acceso TIMESTAMPTZ
);

-- Índices:
CREATE INDEX IF NOT EXISTS idx_usuarios_rol ON usuarios(rol);
CREATE INDEX IF NOT EXISTS idx_usuarios_activo ON usuarios(activo);


-- -----------------------------------------------------
-- Inserción de datos sintéticos
-- -----------------------------------------------------
-- NOTA: La contraseña para todos los usuarios es 'password123'.
-- El hash de abajo corresponde a esa contraseña, encriptada con BCrypt.
INSERT INTO usuarios (nombre, apellido, tipo_documento, numero_documento, email, password_hash, telefono, rol, activo) VALUES
('Ana', 'García', 'CC', '10000001', 'ana.garcia@example.com', '$2a$10$j8.a2u.mJ4L2l8.pE9q2a.u5b6c7d8e9f0g1h2i3j4k5', '3101234567', 'Administrador', true),
('Carlos', 'Rodriguez', 'CC', '10000002', 'carlos.rodriguez@example.com', '$2a$10$j8.a2u.mJ4L2l8.pE9q2a.u5b6c7d8e9f0g1h2i3j4k5', '3111234567', 'Propietario', true),
('Laura', 'Martinez', 'CE', '20000001', 'laura.martinez@example.com', '$2a$10$j8.a2u.mJ4L2l8.pE9q2a.u5b6c7d8e9f0g1h2i3j4k5', '3121234567', 'Arrendatario', true),
('Pedro', 'Sanchez', 'CC', '10000003', 'pedro.sanchez@example.com', '$2a$10$j8.a2u.mJ4L2l8.pE9q2a.u5b6c7d8e9f0g1h2i3j4k5', '3131234567', 'Cliente', false),
('Sofia', 'Lopez', 'CC', '10000004', 'sofia.lopez@example.com', '$2a$10$j8.a2u.mJ4L2l8.pE9q2a.u5b6c7d8e9f0g1h2i3j4k5', '3141234567', 'SuperAdmin', true);