
-- Etapa 4: Seguridad e integridad

-- Creación de usuario con privilegios mínimos (sólo lectura)

CREATE USER 'usuario_vista'@'%' IDENTIFIED BY '1234';

-- Revocar cualquier otro permiso anterior por seguridad
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'usuario_vista'@'%';

-- vistas
-- vista realizada para ocultar información sensible

CREATE VIEW hide_sensitive_data as select e.razonSocial, e.actividadPrincipal, d.ciudad,
d.provincia, d.codigoPostal, d.pais 
from domicilioFiscal d left join empresa e on e.domicilioFiscal_id = d.id;

select * from hide_sensitive_data limit 10; -- mostramos la vista y limitamos los registros a 10

SHOW FULL TABLES WHERE Table_type = 'VIEW'; -- listar vistas

GRANT SELECT ON test2.hide_sensitive_data TO 'usuario_vista'@'%'; -- sólo le damos acceso al usuario a la vista hide_sensitive_data

FLUSH PRIVILEGES; -- aplicamos los cambios

SHOW GRANTS FOR 'usuario_vista'@'%'; -- mostrar privilegios del usuario creado

SELECT user, host FROM mysql.user; -- listar usuarios en la base de datos