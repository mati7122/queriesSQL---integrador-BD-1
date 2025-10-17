-- validación del modelo

-- CASOS VÁLIDOS

-- Inserción correcta 1: Empresa completa con domicilio
INSERT INTO domicilioFiscal (calle, numero, ciudad, provincia, codigoPostal, pais)
VALUES ('Av. Corrientes', 1234, 'Buenos Aires', 'CABA', 'C1043', 'Argentina');

INSERT INTO empresa (razonSocial, cuit, actividadPrincipal, email, domicilioFiscal_id)
VALUES ('Tecnología Avanzada SA', '20123456789', 'Desarrollo de Software', 'contacto@tecavanzada.com.ar', 1);

-- Inserción correcta 2: Empresa sin domicilio asignado aún
INSERT INTO domicilioFiscal (calle, ciudad, provincia, pais)
VALUES ('San Martín', 'Rosario', 'Santa Fe', 'Argentina');

INSERT INTO empresa (razonSocial, cuit, actividadPrincipal, email)
VALUES ('Comercial del Litoral SRL', '30987654321', 'Comercio mayorista', 'info@comerciallitoral.com');

-- Inserción correcta 3: Domicilio con datos mínimos
INSERT INTO domicilioFiscal (calle, ciudad, provincia, pais)
VALUES ('Belgrano', 'Córdoba', 'Córdoba', 'Argentina');

INSERT INTO empresa (razonSocial, cuit, domicilioFiscal_id)
VALUES ('Inversiones del Centro SA', '27555666777', 3);

-- Verificación de datos insertados
SELECT e.id, e.razonSocial, e.cuit, e.email, 
       CONCAT(d.calle, ' ', IFNULL(d.numero, 's/n'), ', ', d.ciudad) AS domicilio
FROM empresa e
LEFT JOIN domicilioFiscal d ON e.domicilioFiscal_id = d.id 
WHERE e.eliminado = FALSE;

-- ========== CASOS INVÁLIDOS ==========

-- ERROR 1: Violación de UNIQUE (CUIT duplicado)
-- INSERT INTO empresa (razonSocial, cuit, domicilioFiscal_id)
-- VALUES ('Empresa Duplicada', '20123456789', 2);
-- Resultado esperado: ERROR 1062 (23000): Duplicate entry '20123456789' for key 'empresa.uk_empresa_cuit'

-- ERROR 2: Violación de CHECK (CUIT con longitud incorrecta)
-- INSERT INTO empresa (razonSocial, cuit)
-- VALUES ('Test Empresa', '201234567');
-- Resultado esperado: ERROR 3819 (HY000): Check constraint 'chk_emp_cuit_formato' is violated.

-- ERROR 3: Violación de CHECK (Email inválido - sin @)
-- INSERT INTO empresa (razonSocial, cuit, email)
-- VALUES ('Otra Empresa SRL', '23444555666', 'correo_sin_arroba.com');
-- Resultado esperado: ERROR 3819 (HY000): Check constraint 'chk_emp_email_formato' is violated.

-- ERROR 4: Violación de FOREIGN KEY (domicilio inexistente)
-- INSERT INTO empresa (razonSocial, cuit, domicilioFiscal_id)
-- VALUES ('Sin Domicilio SA', '24333444555', 999);
-- Resultado esperado: ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails

-- ERROR 5: Violación de NOT NULL (falta campo obligatorio)
-- INSERT INTO domicilioFiscal (calle, ciudad, provincia)
-- VALUES ('Mitre', 'Mendoza', 'Mendoza');
-- Resultado esperado: ERROR 1364 (HY000): Field 'pais' doesn't have a default value

-- ERROR 6: Violación de UNIQUE (dos empresas con el mismo domicilio)
-- Este es un caso especial de la relación 1→1
-- INSERT INTO empresa (razonSocial, cuit, domicilioFiscal_id)
-- VALUES ('Segunda Empresa Mismo Domicilio', '26111222333', 1);
-- Resultado esperado: ERROR 1062 (23000): Duplicate entry '1' for key 'empresa.uk_empresa_domicilio'

-- ============================================
-- CONSULTAS DE VERIFICACIÓN
-- ============================================

-- Ver estructura de las tablas
DESCRIBE domicilioFiscal;
DESCRIBE empresa;

-- Ver constraints definidos
SELECT 
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE,
    TABLE_NAME
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME IN ('empresa', 'domicilioFiscal')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;
