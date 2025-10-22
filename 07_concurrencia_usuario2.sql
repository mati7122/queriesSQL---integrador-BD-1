use test2;

START TRANSACTION;
UPDATE empresa SET cuit = 22222 where id = 1;

SELECT @@autocommit;

SET autocommit = 0;
START TRANSACTION;
UPDATE empresa SET eliminado = 0 WHERE id = 1;
