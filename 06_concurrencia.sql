
use test2;

CREATE USER 'usuario_sesion2'@'%' IDENTIFIED BY '1234'; -- Creo un usuario de prueba para simular dos sesiones distintas

SELECT user, host FROM mysql.user; -- Listar usuarios

GRANT ALL PRIVILEGES ON test2.* TO 'usuario_sesion2'@'%'; -- Asignar privilegios totales sobre la base de datos

FLUSH PRIVILEGES;

select * from empresa where id = 1;

START TRANSACTION;
UPDATE empresa SET cuit = 12345 where id = 1;

-- START TRANSACTION;
-- UPDATE empresa SET eliminado = 0 where id = 1;

SHOW PROCESSLIST;

-- ********************

SHOW TABLE STATUS LIKE 'empresa';

SELECT @@autocommit;

SET autocommit = 0;
START TRANSACTION;
UPDATE empresa SET eliminado = 1 WHERE id = 1;

