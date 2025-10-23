
-- Etapa 5: Concurrencia y transacciones
use finalIntegradorDB;
-- TRANSACCIÓN 1: 

START TRANSACTION;

UPDATE empresa 
SET razonSocial = 'Empresa Modificada A'
WHERE id = 1;

-- Esperar para cruzar el bloqueo
SELECT SLEEP(1);

UPDATE domicilioFiscal
SET ciudad = 'Ciudad A Bloqueada'
WHERE id = 1;

COMMIT;

-- TRANSACCIÓN 2:

START TRANSACTION;

UPDATE domicilioFiscal
SET ciudad = 'Ciudad B Modificada'
WHERE id = 1;

-- Esperar para cruzar el bloqueo
SELECT SLEEP(1);

UPDATE empresa
SET razonSocial = 'Empresa Modificada B'
WHERE id = 1;

COMMIT;


-- (EJECUTAR AMBAS SIMULTÁNEAMENTE Y GUARDAR REGISTRO DEL ERROR, TIENE QUE DECIR ERROR 1213):

-- Procedimiento almacenado con retry

DELIMITER //

DROP PROCEDURE IF EXISTS sp_actualizar_empresa_retry //
CREATE PROCEDURE sp_actualizar_empresa_retry(IN p_id INT, IN p_valor TINYINT)
BEGIN
    DECLARE attempts INT DEFAULT 0;
    DECLARE max_attempts INT DEFAULT 3;
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE exit HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        -- no marcamos done aquí porque queremos reintentar
    END;

    REPEAT
        SET attempts = attempts + 1;

        START TRANSACTION;
        UPDATE empresa 
        SET eliminado = p_valor 
        WHERE id = p_id;

        COMMIT;
        SET done = TRUE;
        SELECT CONCAT('Transacción exitosa en intento #', attempts) AS resultado;

    UNTIL done OR attempts >= max_attempts END REPEAT;

    IF NOT done THEN
        SELECT 'Operación fallida tras múltiples intentos (deadlock persistente o error no recuperable).' AS resultado_final;
    ELSE
        SELECT 'Procedimiento finalizado correctamente.' AS resultado_final;
    END IF;
END //

DELIMITER ;

-- Comparación de dos niveles de aislamiento: READ COMMITTED y REPEATABLE READ.

-- READ COMMITED

-- En Sesión 1:

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT * FROM empresa WHERE id = 1;

-- (MySQL te devuelve la fila con Empresa A.)
-- Todavía no hacemos el commit, dejamos la transacción abierta.

--  En Sesión 2:
             
UPDATE empresa SET razonSocial = 'Empresa A - Actualizada' WHERE id = 1;
COMMIT;

-- Esta transacción ya se confirmó y cambió el valor.

--  Volvemos a la sesión 1(sigue en la misma transacción):

   SELECT * FROM empresa WHERE id = 1;

-- Resultado con READ COMMITED: vamos a ver el nuevo valor, porque este nivel si permite leer cambio confirmados por otras transacciones.

-- Hacemos lo mismo con REPEATABLE READ.

-- En sesion 1:

SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT * FROM empresa WHERE id = 1;

-- En sesion 2:

UPDATE empresa SET razonSocial = 'Empresa A - Segunda actualización' WHERE id = 1;
COMMIT;

-- En sesion 1:

SELECT * FROM empresa WHERE id = 1;

-- Seguiremos viendo el valor viejo porque MySQL mantiene la vista consistente hasta hacer el COMMIT, una vez hecho el COMMIT en la sesion 1 podremos ver el nuevo valor.


