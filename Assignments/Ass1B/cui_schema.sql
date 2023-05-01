set echo on
SPOOL custorders_schema_output.txt

-- Generated by Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   at:        2023-05-01 17:34:28 AEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



DROP TABLE local_authority CASCADE CONSTRAINTS;

DROP TABLE street CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE local_authority (
    authority_name          VARCHAR2(50) NOT NULL,
    authority_ceo_fname     VARCHAR2(50) NOT NULL,
    authority_ceo_lname     VARCHAR2(50) NOT NULL,
    authority_ceo_telephone VARCHAR2(50) NOT NULL,
    authority_total_area    NUMBER(8) NOT NULL,
    authority_type          VARCHAR2(50) NOT NULL
);

ALTER TABLE local_authority
    ADD CONSTRAINT chk_type CHECK ( authority_type IN ( 'B', 'C', 'D', 'S', 'T' ) );

COMMENT ON COLUMN local_authority.authority_name IS
    'The local authority''s name (which is unique)';

COMMENT ON COLUMN local_authority.authority_ceo_fname IS
    'CEO''s first name ';

COMMENT ON COLUMN local_authority.authority_ceo_lname IS
    'CEO''s last name ';

COMMENT ON COLUMN local_authority.authority_ceo_telephone IS
    'A contact phone number';

COMMENT ON COLUMN local_authority.authority_total_area IS
    'The authority total area. Assuming it is going to be quite high, have put precision of 8. No decimal places required for this value.'
    ;

COMMENT ON COLUMN local_authority.authority_type IS
    'The local authority type. This is classified into fixed types (constraints).';

ALTER TABLE local_authority ADD CONSTRAINT local_authority_pk PRIMARY KEY ( authority_name
);

CREATE TABLE street (
    street_id      NUMBER(7) NOT NULL,
    street_name    VARCHAR2(50) NOT NULL,
    street_length  NUMBER(5) NOT NULL,
    street_surface VARCHAR2(50) NOT NULL,
    street_lane    NUMBER(4) NOT NULL,
    authority_name VARCHAR2(50) NOT NULL
);

ALTER TABLE street
    ADD CONSTRAINT chk_surface CHECK ( street_surface IN ( 'A', 'C', 'U' ) );

COMMENT ON COLUMN street.street_id IS
    'This is the street/road id.';

COMMENT ON COLUMN street.street_name IS
    'The street/road name';

COMMENT ON COLUMN street.street_length IS
    'Street length in metres. Can be quite large given 1000m -> 1km.';

COMMENT ON COLUMN street.street_surface IS
    'Street/road surface type (this is a fixed type - add constraint).';

COMMENT ON COLUMN street.street_lane IS
    'The number of lanes on the street.';

COMMENT ON COLUMN street.authority_name IS
    'The local authority''s name (which is unique)';

ALTER TABLE street ADD CONSTRAINT street_pk PRIMARY KEY ( street_id );

ALTER TABLE street
    ADD CONSTRAINT authority_street FOREIGN KEY ( authority_name )
        REFERENCES local_authority ( authority_name );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             2
-- CREATE INDEX                             0
-- ALTER TABLE                              5
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0

SPOOL off
set echo off