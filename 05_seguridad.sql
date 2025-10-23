
-- Etapa 4: Seguridad e integridad

-- Creación de usuario con privilegios mínimos (sólo lectura)

CREATE USER 'usuario_vista'@'%' IDENTIFIED BY '1234';

-- Revocar cualquier otro permiso anterior por seguridad
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'usuario_vista'@'%';

-- vistas
-- vista realizada para ocultar información sensible

CREATE VIEW hide_sensitive_data AS 
SELECT
	e.razonSocial, 
    e.actividadPrincipal, 
    d.ciudad,
	d.provincia, 
    d.codigoPostal, 
    d.pais 
FROM domicilioFiscal d LEFT JOIN empresa e ON e.domicilioFiscal_id = d.id;

CREATE VIEW empresa_contacto_publico AS
SELECT 
    e.razonSocial,
    e.email,
    e.actividadPrincipal,
    d.ciudad,
    d.provincia,
    d.pais
FROM empresa e
LEFT JOIN domicilioFiscal d ON e.domicilioFiscal_id = d.id;

select * from hide_sensitive_data limit 10; -- mostramos la vista y limitamos los registros a 10

SHOW FULL TABLES WHERE Table_type = 'VIEW'; -- listar vistas

GRANT SELECT ON test2.hide_sensitive_data TO 'usuario_vista'@'%'; -- sólo le damos acceso al usuario a la vista hide_sensitive_data

FLUSH PRIVILEGES; -- aplicamos los cambios

SHOW GRANTS FOR 'usuario_vista'@'%'; -- mostrar privilegios del usuario creado

SELECT user, host FROM mysql.user; -- listar usuarios en la base de datos

-- PRUEBAS DE INTEGRIDAD

-- Inserción válida
INSERT INTO domicilioFiscal (id, calle, numero, ciudad, provincia, codigoPostal, pais)
VALUES (1, 'Calle Prueba', 100, 'CABA', 'Buenos Aires', '1000', 'Argentina');

-- Inserción inválida: mismo ID (violación de PK)
INSERT INTO domicilioFiscal (id, calle, numero, ciudad, provincia, codigoPostal, pais)
VALUES (1, 'Otra Calle', 200, 'Rosario', 'Santa Fe', '2000', 'Argentina');

-- Inserción inválida: domicilioFiscal_id no existente
INSERT INTO empresa (razonSocial, cuit, actividadPrincipal, email, domicilioFiscal_id)
VALUES ('Empresa Fantasma', '20345678901', 'Comercio', 'empresa@fantasma.com', 100000000000000000);

