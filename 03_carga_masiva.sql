
-- ============================================
-- SP Generar Domicilios
-- ============================================

DROP PROCEDURE IF EXISTS generarDomicilios;

DELIMITER $$

CREATE PROCEDURE generarDomicilios(IN cantidad INT)
BEGIN
    DECLARE contador INT DEFAULT 1;
    
    START TRANSACTION;
    
    WHILE contador <= cantidad DO
        INSERT INTO domicilioFiscal (
            eliminado,
            calle,
            numero,
            ciudad,
            provincia,
            codigoPostal,
            pais
        ) VALUES (
            FALSE,
            CONCAT('Calle ', contador),
            contador,
            CONCAT('Ciudad', contador),
            CONCAT('Provincia', contador),
            LPAD(contador, 4, '0'),
            'Argentina'
        );
        
        SET contador = contador + 1;
        
        -- Commit cada 10000 registros para evitar transacciones muy grandes
        IF contador % 10000 = 0 THEN
            COMMIT;
            START TRANSACTION;
        END IF;
    END WHILE;
    
    COMMIT;
    
END$$

DELIMITER ;


-- ============================================
-- SP Generar Empresas
-- ============================================

DROP PROCEDURE IF EXISTS generarEmpresas;

DELIMITER $$

CREATE PROCEDURE generarEmpresas(IN cantidad INT) 
BEGIN
    DECLARE contador INT DEFAULT 1;
    
    START TRANSACTION;
    
    WHILE contador <= cantidad DO
        INSERT INTO empresa (
            eliminado,
            razonSocial,
            cuit,
            actividadPrincipal,
            email,
            domicilioFiscal_id
        ) VALUES (
            FALSE,
            CONCAT('Empresa', contador),
            CONCAT('30', LPAD(contador, 8, '0'), (contador % 10)),
            CONCAT('Actividad', (contador % 100)),
            CONCAT('info@empresa', contador, '.com'),
            contador
        );
        
        SET contador = contador + 1;
        
        IF contador % 10000 = 0 THEN
            COMMIT;
            START TRANSACTION;
        END IF;
    END WHILE;
    
    COMMIT;
    
END$$

DELIMITER ;


-- ============================================
-- Primera carga desactivando indices
-- ============================================

-- CONFIGURACIÓN INICIAL
SET FOREIGN_KEY_CHECKS = 0;
SET autocommit = 0;
TRUNCATE TABLE empresa;
TRUNCATE TABLE domicilioFiscal;
ALTER TABLE empresa AUTO_INCREMENT = 1;
ALTER TABLE domicilioFiscal AUTO_INCREMENT = 1;

-- Desactivar índices
ALTER TABLE empresa DROP INDEX idx_empresa_razonSocial;
ALTER TABLE domicilioFiscal DROP INDEX idx_domicilio_ciudad;
ALTER TABLE domicilioFiscal DROP INDEX idx_domicilio_provincia;

-- EJECUTAR GENERACIÓN
-- Generar 100.000 domicilios
SET @inicio_carga_domicilios = NOW();
CALL generarDomicilios(100000);
SET @fin_carga_domicilios = NOW();
SET @tiempo_carga_domicilios = TIMESTAMPDIFF(SECOND, @inicio_carga_domicilios, @fin_carga_domicilios);

SELECT CONCAT(COUNT(*), ' domicilios generados en ', @tiempo_carga_domicilios, ' segundos') AS resultado
FROM domicilioFiscal; -- medicion de tiempo

select count(*) from domiciliofiscal;

-- Generar 100.000 empresas
SET @inicio_carga_empresas = NOW();
CALL generarEmpresas(100000);
SET @fin_carga_empresas = NOW();
SET @tiempo_carga_empresas = TIMESTAMPDIFF(SECOND, @inicio_carga_empresas, @fin_carga_empresas);

SELECT CONCAT(COUNT(*), ' empresas generadas en ',@tiempo_carga_empresas, ' segundos') AS resultado
FROM empresa;

-- Recrear índices
SET @inicio_crear_indices = NOW();
ALTER TABLE empresa ADD INDEX idx_empresa_razonSocial (razonSocial);
ALTER TABLE domicilioFiscal ADD INDEX idx_domicilio_ciudad (ciudad);
ALTER TABLE domicilioFiscal ADD INDEX idx_domicilio_provincia (provincia);
SET @fin_crear_indices = NOW();
SET @tiempo_crear_indices = TIMESTAMPDIFF(SECOND, @inicio_crear_indices, @fin_crear_indices);

SELECT CONCAT('Índices recreados en ', @tiempo_crear_indices, ' segundos') AS resultado;

-- ============================================
-- Segunda carga sin desactivar indices para analizar la diferencia de tiempo
-- ============================================
TRUNCATE TABLE empresa;
TRUNCATE TABLE domicilioFiscal;
ALTER TABLE empresa AUTO_INCREMENT = 1;
ALTER TABLE domicilioFiscal AUTO_INCREMENT = 1;

-- Generar 100.000 domicilios
SET @inicio_carga_domicilios_2 = NOW();
CALL generarDomicilios(100000);
SET @fin_carga_domicilios_2 = NOW();
SET @tiempo_carga_domicilios_2 = TIMESTAMPDIFF(SECOND, @inicio_carga_domicilios_2, @fin_carga_domicilios_2);

SELECT CONCAT(COUNT(*), 'domicilios generados en ', @tiempo_carga_domicilios_2, ' segundos Con Indice: ') AS resultado
FROM domicilioFiscal; -- medicion de tiempo

-- Generar 100.000 empresas
SET @inicio_carga_empresas_2 = NOW();
CALL generarEmpresas(100000);
SET @fin_carga_empresas_2 = NOW();
SET @tiempo_carga_empresas_2 = TIMESTAMPDIFF(SECOND, @inicio_carga_empresas_2, @fin_carga_empresas_2);

SELECT CONCAT(COUNT(*), 'empresas generadas en ',@tiempo_carga_empresas_2, ' segundos Con Indice: ') AS resultado
FROM empresa;

-- Reactivar configuraciones
SET FOREIGN_KEY_CHECKS = 1;
SET autocommit = 1;

-- Analizar tablas
ANALYZE TABLE domicilioFiscal;
ANALYZE TABLE empresa;

-- ============================================
-- RESUMEN Y MEDICION DE TIEMPOS
-- ============================================

SELECT 
    'domicilioFiscal' AS tabla,
    COUNT(*) AS registros,
    MIN(id) AS id_min,
    MAX(id) AS id_max
FROM domicilioFiscal
UNION ALL
SELECT 
    'empresa',
    COUNT(*),
    MIN(id),
    MAX(id)
FROM empresa;

SELECT 
    CONCAT(@tiempo_carga_domicilios, ' seg') AS tiempo_domicilios,
    CONCAT(@tiempo_carga_empresas, ' seg') AS tiempo_empresas,
    CONCAT(@tiempo_crear_indices, ' seg') AS tiempo_indices,
    CONCAT(@tiempo_carga_domicilios + @tiempo_carga_empresas + @tiempo_crear_indices, ' seg') AS tiempo_total_sin_indices,
    CONCAT(@tiempo_carga_domicilios_2, ' seg') AS tiempo_domicilios_2,
    CONCAT(@tiempo_carga_empresas_2, ' seg') AS tiempo_empresas_2,
    CONCAT(@tiempo_carga_domicilios + @tiempo_carga_empresas + @tiempo_crear_indices, ' seg') AS tiempo_total_con_indices;

-- Verificación (primeros y ultimos registros para comprobar numeros)
SELECT * FROM domicilioFiscal ORDER BY id LIMIT 5;
SELECT * FROM empresa ORDER BY id LIMIT 5;
SELECT * FROM domicilioFiscal ORDER BY id DESC LIMIT 5;
SELECT * FROM empresa ORDER BY id DESC LIMIT 5;

