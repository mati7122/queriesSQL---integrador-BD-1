-- 

-- create database finalIntegradorBD;
-- use finalIntegradorBD;
use finalIntegradoDB;

drop table empresa, domicilioFiscal;

-- table domicilio fiscal
CREATE TABLE domicilioFiscal (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,     -- Identificador único
    eliminado BOOLEAN DEFAULT FALSE NOT NULL,  -- Control de baja lógica
    calle VARCHAR(100) NOT NULL, -- Datos de domicilio
    numero INT,
    ciudad VARCHAR(80) NOT NULL,
    provincia VARCHAR(80) NOT NULL,
    codigoPostal VARCHAR(10),
    pais VARCHAR(80) NOT NULL,
    -- CONSTRAINTS DE DOMINIO
    CONSTRAINT chk_df_calle_no_vacia 
        CHECK (CHAR_LENGTH(TRIM(calle)) > 0),
    CONSTRAINT chk_df_numero_positivo 
        CHECK (numero IS NULL OR numero > 0),
    CONSTRAINT chk_df_ciudad_no_vacia 
        CHECK (CHAR_LENGTH(TRIM(ciudad)) > 0),
    CONSTRAINT chk_df_provincia_no_vacia 
        CHECK (CHAR_LENGTH(TRIM(provincia)) > 0),
    CONSTRAINT chk_df_codigoPostal_formato 
        CHECK (codigoPostal IS NULL OR 
               (CHAR_LENGTH(codigoPostal) BETWEEN 4 AND 8)),
    CONSTRAINT chk_df_pais_no_vacio 
        CHECK (CHAR_LENGTH(TRIM(pais)) > 0)
);

CREATE TABLE empresa (
    
    id BIGINT PRIMARY KEY AUTO_INCREMENT, -- Identificador único
    eliminado BOOLEAN DEFAULT FALSE NOT NULL, -- Control de baja lógica
    razonSocial VARCHAR(120) NOT NULL, -- Datos de empresa
    cuit VARCHAR(13) NOT NULL,
    actividadPrincipal VARCHAR(80),
    email VARCHAR(120),
    domicilioFiscal_id BIGINT, -- Relación 1→1 con domicilioFiscal
    
    -- CONSTRAINT UNIQUE
    CONSTRAINT uk_empresa_cuit 
        UNIQUE (cuit),
    CONSTRAINT uk_empresa_domicilio 
        UNIQUE (domicilioFiscal_id),
    
    -- CONSTRAINTS CHECK
    CONSTRAINT chk_emp_razonSocial_no_vacia 
        CHECK (CHAR_LENGTH(TRIM(razonSocial)) > 2),
    CONSTRAINT chk_emp_cuit_formato 
        CHECK (CHAR_LENGTH(cuit) = 11 AND cuit REGEXP '^[0-9]{11}$'),
    CONSTRAINT chk_emp_email_formato 
        CHECK (email IS NULL OR 
               email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_emp_actividadPrincipal_longitud
        CHECK (actividadPrincipal IS NULL OR 
               CHAR_LENGTH(actividadPrincipal) >= 3),
    -- CONSTRAINT FOREIGN KEY
    CONSTRAINT fk_empresa_domicilioFiscal 
        FOREIGN KEY (domicilioFiscal_id) 
        REFERENCES domicilioFiscal(id)
        ON DELETE RESTRICT -- No permitir eliminar
        ON UPDATE CASCADE -- permitir modificar
);

-- INDEXES
CREATE INDEX idx_empresa_razonSocial ON empresa(razonSocial);
CREATE INDEX idx_domicilio_ciudad ON domicilioFiscal(ciudad);
CREATE INDEX idx_domicilio_provincia ON domicilioFiscal(provincia);