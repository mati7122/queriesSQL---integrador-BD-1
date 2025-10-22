
--  Desarrollo de consultas complejas con JOIN, GROUP BY, HAVING, subconsultas y vistas. 

-- CONSULTA JOIN 1:

SELECT E.razonSocial, E.cuit, D.pais
FROM Empresa as E
JOIN DomicilioFiscal as D ON E.domicilioFiscal_id = D.id
WHERE E.eliminado = 0;


-- CONSULTA JOIN 2:

SELECT E.email, D.calle, D.numero, D.ciudad, E.actividadPrincipal
FROM Empresa as E
JOIN DomicilioFiscal as D ON E.domicilioFiscal_id = D.id
WHERE E.actividadPrincipal = 'Actividad1';

-- CONSULTA GROUP BY + HAVING:
-- revisar
SELECT D.ciudad, COUNT(E.id) as CantidadEmpresas
FROM Empresa as E
JOIN DomicilioFiscal as D ON E.domicilioFiscal_id = D.id
GROUP BY D.ciudad
HAVING COUNT(E.id) > 100
ORDER BY CantidadEmpresas DESC;

-- CONSULTA CON SUBCONSULTA:
-- revisar
SELECT razonSocial, cuit
FROM Empresa
WHERE domicilioFiscal_id IN(
	SELECT id
	FROM DomicilioFiscal
	WHERE LENGTH(codigoPostal) > 8
);

-- VISTA: Mostrar razonSocial, email, calle, numero, ciudad, provincia. (Datos de contacto)

CREATE VIEW Vista_Contactos_Empresariales AS
SELECT E.razonSocial, E.email, D.calle, D.numero, D.ciudad, D.provincia, D.pais
FROM Empresa as E
JOIN DomicilioFiscal as D ON E.domicilioFiscal = D.id
WHERE E.eliminado = 0;

-- ============================================
-- MEDICIÓN COMPARATIVA
-- ============================================


-- 1. Consulta por igualdad

-- Consulta:

SELECT E.razonSocial, E.cuit, D.pais
FROM Empresa AS E
JOIN DomicilioFiscal AS D ON E.domicilioFiscal_id = D.id
WHERE E.eliminado = 0;

-- Índice aplicado:

CREATE INDEX idx_eliminado ON Empresa(eliminado);

-- 2. Consulta por rango

-- Consulta:

SELECT D.ciudad, COUNT(E.id) AS CantidadEmpresas
FROM Empresa AS E
JOIN DomicilioFiscal AS D ON E.domicilioFiscal_id = D.id
WHERE D.ciudad LIKE '%2%'
GROUP BY D.ciudad
ORDER BY CantidadEmpresas DESC;

-- Índice aplicado:

CREATE INDEX idx_ciudad ON DomicilioFiscal(ciudad);

-- 3. Consulta con JOIN

-- Consulta:

SELECT E.email, D.calle, D.numero, D.ciudad
FROM Empresa AS E
JOIN DomicilioFiscal AS D ON E.domicilioFiscal_id = D.id
WHERE E.actividadPrincipal = 'Actividad3';

-- Índices aplicados:

CREATE INDEX idx_actividad ON Empresa(actividadPrincipal);
CREATE INDEX idx_fk_domicilio ON Empresa(domicilioFiscal);

-- ============================================
-- RESULTADOS DE LAS MEDICIONES
-- ============================================

-- Igualdad - JOIN 1 (E.eliminado = 0) - Con índice: 3.2ms, Sin índice: 17.8ms, Mediana: 3.2ms

-- Rango - GROUP BY + LIKE (D.ciudad LIKE 'Cip%') - Con índice: 4.5ms, Sin índice: 21.9ms, Mediana: 4.5ms

-- JOIN - JOIN 2 (E.domicilioFiscal = D.id) - Con índice: 5.8ms, Sin índice: 15.6ms, Mediana: 5.8ms


