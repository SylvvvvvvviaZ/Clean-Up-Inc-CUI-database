--student name: Shean De Fonseka & Xiaowen Zhou 
--Group: A09-Group142
set echo on
SPOOL cui_schema_output.txt

-- Generated by Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   at:        2023-05-03 14:09:14 AEST
--   site:      Oracle Database 11g
--   type:      Oracle Database 11g



DROP TABLE bin CASCADE CONSTRAINTS;

DROP TABLE bin_type CASCADE CONSTRAINTS;

DROP TABLE collection_cost CASCADE CONSTRAINTS;

DROP TABLE collector CASCADE CONSTRAINTS;

DROP TABLE contract CASCADE CONSTRAINTS;

DROP TABLE contract_driver CASCADE CONSTRAINTS;

DROP TABLE driver CASCADE CONSTRAINTS;

DROP TABLE "driver-truck" CASCADE CONSTRAINTS;

DROP TABLE information CASCADE CONSTRAINTS;

DROP TABLE local_authority CASCADE CONSTRAINTS;

DROP TABLE owner CASCADE CONSTRAINTS;

DROP TABLE property CASCADE CONSTRAINTS;

DROP TABLE "property-owner" CASCADE CONSTRAINTS;

DROP TABLE street CASCADE CONSTRAINTS;

DROP TABLE supply_cost CASCADE CONSTRAINTS;

DROP TABLE truck CASCADE CONSTRAINTS;

DROP TABLE waste_cost CASCADE CONSTRAINTS;

DROP TABLE waste_type CASCADE CONSTRAINTS;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE bin (
    bin_rfid_tag           VARCHAR2(16) NOT NULL,
    bin_supply_date        DATE NOT NULL,
    bin_replace_reason     VARCHAR2(50) NOT NULL,
    bin_type_id            NUMBER(4) NOT NULL,
    property_street_number NUMBER(3) NOT NULL,
    street_id              NUMBER(7) NOT NULL,
    authority_name         VARCHAR2(35) NOT NULL
);

ALTER TABLE bin
    ADD CONSTRAINT chk_reason CHECK ( bin_replace_reason IN ( 'B', 'D', 'DP', 'S' ) )
    ;

COMMENT ON COLUMN bin.bin_rfid_tag IS
    'bin rfid tag, which is unique';

COMMENT ON COLUMN bin.bin_supply_date IS
    'bin supply date';

COMMENT ON COLUMN bin.bin_replace_reason IS
    'about bin replace reason';

COMMENT ON COLUMN bin.bin_type_id IS
    'Bin Type Id (Surrogate PK)';

COMMENT ON COLUMN bin.property_street_number IS
    'property_street_number';

COMMENT ON COLUMN bin.street_id IS
    'This is the street/road id.';

COMMENT ON COLUMN bin.authority_name IS
    'The local authority''s name (which is unique)';

ALTER TABLE bin ADD CONSTRAINT bin_pk PRIMARY KEY ( bin_rfid_tag );

CREATE TABLE bin_type (
    bin_type_size                 NUMBER(7) NOT NULL,
    bin_type_standard_supply_cost NUMBER(7) NOT NULL,
    waste_type_id                 NUMBER(7) NOT NULL,
    bin_type_id                   NUMBER(4) NOT NULL
);

COMMENT ON COLUMN bin_type.bin_type_size IS
    'bin type size,which is ubique';

COMMENT ON COLUMN bin_type.bin_type_standard_supply_cost IS
    'bin_type_standard_supply_cost';

COMMENT ON COLUMN bin_type.waste_type_id IS
    'aste type id, which is unique';

COMMENT ON COLUMN bin_type.bin_type_id IS
    'Bin Type Id (Surrogate PK)';

ALTER TABLE bin_type ADD CONSTRAINT bin_type_pk PRIMARY KEY ( bin_type_id );

ALTER TABLE bin_type
    ADD CONSTRAINT bin_type_uk UNIQUE ( waste_type_id,
                                        bin_type_id,
                                        bin_type_size );

CREATE TABLE collection_cost (
    contract_collection_cost NUMBER(4),
    waste_type_id            NUMBER(7) NOT NULL,
    contract_number          NUMBER(7) NOT NULL
);

COMMENT ON COLUMN collection_cost.contract_collection_cost IS
    'The contract waste collection cost.';

COMMENT ON COLUMN collection_cost.waste_type_id IS
    'aste type id, which is unique';

COMMENT ON COLUMN collection_cost.contract_number IS
    'contract number, which is unique';

ALTER TABLE collection_cost ADD CONSTRAINT collection_cost_pk PRIMARY KEY ( waste_type_id
,
                                                                            contract_number
                                                                            );

CREATE TABLE collector (
    date_of_collection DATE NOT NULL,
    driver_number      NUMBER(7) NOT NULL
);

COMMENT ON COLUMN collector.date_of_collection IS
    'The date of collection for the bins.';

COMMENT ON COLUMN collector.driver_number IS
    'driver number,which is unique.';

ALTER TABLE collector ADD CONSTRAINT collector_pk PRIMARY KEY ( date_of_collection );

CREATE TABLE contract (
    contract_number      NUMBER(7) NOT NULL,
    contract_start_date  DATE NOT NULL,
    contract_end_date    DATE NOT NULL,
    authority_name       VARCHAR2(35) NOT NULL,
    collection_frequency VARCHAR2(50) NOT NULL
);

ALTER TABLE contract
    ADD CONSTRAINT chk_collections CHECK ( collection_frequency IN ( 'F', 'M', 'W' ) )
    ;

COMMENT ON COLUMN contract.contract_number IS
    'contract number, which is unique';

COMMENT ON COLUMN contract.contract_start_date IS
    'contract satrt date';

COMMENT ON COLUMN contract.contract_end_date IS
    'contract end date';

COMMENT ON COLUMN contract.authority_name IS
    'The local authority''s name (which is unique)';

COMMENT ON COLUMN contract.collection_frequency IS
    'Collection frequency of bins.';

ALTER TABLE contract ADD CONSTRAINT contract_pk PRIMARY KEY ( contract_number );

CREATE TABLE contract_driver (
    contract_number    NUMBER(7) NOT NULL,
    date_of_collection DATE NOT NULL
);

ALTER TABLE contract_driver ADD CONSTRAINT contract_driver_pk PRIMARY KEY ( contract_number
,
                                                                            date_of_collection
                                                                            );

CREATE TABLE driver (
    driver_number          NUMBER(7) NOT NULL,
    driver_contract_number NUMBER(7) NOT NULL,
    licence_number         NUMBER(9) NOT NULL
);

COMMENT ON COLUMN driver.driver_number IS
    'driver number,which is unique.';

COMMENT ON COLUMN driver.driver_contract_number IS
    'driver contract number';

COMMENT ON COLUMN driver.licence_number IS
    'licence number';

CREATE UNIQUE INDEX driver__idx ON
    driver (
        licence_number
    ASC );

ALTER TABLE driver ADD CONSTRAINT driver_pk PRIMARY KEY ( driver_number );

CREATE TABLE "driver-truck" (
    truck_vin     VARCHAR2(50) NOT NULL,
    driver_number NUMBER(7) NOT NULL
);

ALTER TABLE "driver-truck" ADD CONSTRAINT "driver-truck_PK" PRIMARY KEY ( truck_vin,
                                                                          driver_number
                                                                          );

CREATE TABLE information (
    licence_number      NUMBER(9) NOT NULL,
    licence_givname     VARCHAR2(35) NOT NULL,
    licence_famname     VARCHAR2(35) NOT NULL,
    licence_dateofbirth DATE NOT NULL,
    taxfile_number      NUMBER(9) NOT NULL
);

COMMENT ON COLUMN information.licence_number IS
    'licence number';

COMMENT ON COLUMN information.licence_givname IS
    'licence_givname';

COMMENT ON COLUMN information.licence_famname IS
    'licence famname';

COMMENT ON COLUMN information.licence_dateofbirth IS
    'licence date of birth';

COMMENT ON COLUMN information.taxfile_number IS
    'taxfile number';

ALTER TABLE information ADD CONSTRAINT information_pk PRIMARY KEY ( licence_number );

CREATE TABLE local_authority (
    authority_name          VARCHAR2(35) NOT NULL,
    authority_ceo_fname     VARCHAR2(25) NOT NULL,
    authority_ceo_lname     VARCHAR2(25) NOT NULL,
    authority_ceo_telephone VARCHAR2(15) NOT NULL,
    authority_total_area    NUMBER(8) NOT NULL,
    authority_type          VARCHAR2(15) NOT NULL
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

CREATE TABLE owner (
    owner_id            NUMBER(7) NOT NULL,
    owner_name          VARCHAR2(25) NOT NULL,
    owner_email_address VARCHAR2(30) NOT NULL,
    email_phone_number  VARCHAR2(15) NOT NULL
);

COMMENT ON COLUMN owner.owner_id IS
    'the owner id, which is unique.';

COMMENT ON COLUMN owner.owner_name IS
    'owner name';

COMMENT ON COLUMN owner.owner_email_address IS
    'owner email address';

COMMENT ON COLUMN owner.email_phone_number IS
    'email phone number';

ALTER TABLE owner ADD CONSTRAINT owner_pk PRIMARY KEY ( owner_id );

CREATE TABLE property (
    property_street_number NUMBER(3) NOT NULL,
    street_id              NUMBER(7) NOT NULL,
    authority_name         VARCHAR2(35) NOT NULL
);

COMMENT ON COLUMN property.property_street_number IS
    'property_street_number';

COMMENT ON COLUMN property.street_id IS
    'This is the street/road id.';

COMMENT ON COLUMN property.authority_name IS
    'The local authority''s name (which is unique)';

ALTER TABLE property
    ADD CONSTRAINT property_pk PRIMARY KEY ( property_street_number,
                                             street_id,
                                             authority_name );

CREATE TABLE "property-owner" (
    property_street_number NUMBER(3) NOT NULL,
    street_id              NUMBER(7) NOT NULL,
    authority_name         VARCHAR2(35) NOT NULL,
    owner_id               NUMBER(7) NOT NULL
);

ALTER TABLE "property-owner"
    ADD CONSTRAINT "property-owner_PK" PRIMARY KEY ( property_street_number,
                                                     street_id,
                                                     authority_name,
                                                     owner_id );

CREATE TABLE street (
    street_id      NUMBER(7) NOT NULL,
    street_name    VARCHAR2(50) NOT NULL,
    street_length  NUMBER(5) NOT NULL,
    street_surface VARCHAR2(50) NOT NULL,
    street_lane    NUMBER(4) NOT NULL,
    authority_name VARCHAR2(35) NOT NULL
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

ALTER TABLE street ADD CONSTRAINT street_pk PRIMARY KEY ( street_id,
                                                          authority_name );

CREATE TABLE supply_cost (
    contract_supply_cost NUMBER(5) NOT NULL,
    contract_number      NUMBER(7) NOT NULL,
    bin_type_id          NUMBER(4) NOT NULL
);

COMMENT ON COLUMN supply_cost.contract_supply_cost IS
    'contract supply coast';

COMMENT ON COLUMN supply_cost.contract_number IS
    'contract number, which is unique';

COMMENT ON COLUMN supply_cost.bin_type_id IS
    'Bin Type Id (Surrogate PK)';

ALTER TABLE supply_cost ADD CONSTRAINT supply_cost_pk PRIMARY KEY ( contract_number,
                                                                    bin_type_id );

CREATE TABLE truck (
    truck_vin        VARCHAR2(50) NOT NULL,
    driver_number    NUMBER(7) NOT NULL,
    truck_regonumber NUMBER(9) NOT NULL,
    truck_made       VARCHAR2(50) NOT NULL,
    truck_year       DATE NOT NULL
);

COMMENT ON COLUMN truck.truck_vin IS
    'truck vin, which is unique.';

COMMENT ON COLUMN truck.driver_number IS
    'driver number';

COMMENT ON COLUMN truck.truck_regonumber IS
    'truck regonumber';

COMMENT ON COLUMN truck.truck_made IS
    'truck made';

COMMENT ON COLUMN truck.truck_year IS
    'truck year';

ALTER TABLE truck ADD CONSTRAINT truck_pk PRIMARY KEY ( truck_vin );

CREATE TABLE waste_cost (
    collected_kg       NUMBER(4) NOT NULL,
    overweight         CHAR(1) NOT NULL,
    date_of_collection DATE NOT NULL,
    bin_rfid_tag       VARCHAR2(16) NOT NULL
);

COMMENT ON COLUMN waste_cost.collected_kg IS
    'The weight of the respective bin.';

COMMENT ON COLUMN waste_cost.overweight IS
    'Is the bin overweight or not.';

COMMENT ON COLUMN waste_cost.date_of_collection IS
    'The date of collection for the bins.';

COMMENT ON COLUMN waste_cost.bin_rfid_tag IS
    'bin rfid tag, which is unique';

ALTER TABLE waste_cost ADD CONSTRAINT waste_coast_pk PRIMARY KEY ( bin_rfid_tag,
                                                                   date_of_collection
                                                                   );

CREATE TABLE waste_type (
    waste_type_id          NUMBER(7) NOT NULL,
    waste_type_description VARCHAR2(50) NOT NULL
);

COMMENT ON COLUMN waste_type.waste_type_id IS
    'aste type id, which is unique';

COMMENT ON COLUMN waste_type.waste_type_description IS
    'waste type description';

ALTER TABLE waste_type ADD CONSTRAINT waste_type_pk PRIMARY KEY ( waste_type_id );

ALTER TABLE bin
    ADD CONSTRAINT "bin_type-bin" FOREIGN KEY ( bin_type_id )
        REFERENCES bin_type ( bin_type_id );

ALTER TABLE supply_cost
    ADD CONSTRAINT "bin_type-contract_supply_cost" FOREIGN KEY ( bin_type_id )
        REFERENCES bin_type ( bin_type_id );

ALTER TABLE waste_cost
    ADD CONSTRAINT "bin-contract_waste_cost" FOREIGN KEY ( bin_rfid_tag )
        REFERENCES bin ( bin_rfid_tag );

ALTER TABLE contract_driver
    ADD CONSTRAINT contract_driver_collector_fk FOREIGN KEY ( date_of_collection )
        REFERENCES collector ( date_of_collection );

ALTER TABLE contract_driver
    ADD CONSTRAINT contract_driver_contract_fk FOREIGN KEY ( contract_number )
        REFERENCES contract ( contract_number );

ALTER TABLE collection_cost
    ADD CONSTRAINT "contract-coll_cost" FOREIGN KEY ( contract_number )
        REFERENCES contract ( contract_number );

ALTER TABLE supply_cost
    ADD CONSTRAINT "contract-contract_supply_cost" FOREIGN KEY ( contract_number )
        REFERENCES contract ( contract_number );

ALTER TABLE waste_cost
    ADD CONSTRAINT dcollector_wastecost FOREIGN KEY ( date_of_collection )
        REFERENCES collector ( date_of_collection );

ALTER TABLE collector
    ADD CONSTRAINT "driver-driver_collector" FOREIGN KEY ( driver_number )
        REFERENCES driver ( driver_number );

ALTER TABLE "driver-truck"
    ADD CONSTRAINT "driver-truck_DRIVER_FK" FOREIGN KEY ( driver_number )
        REFERENCES driver ( driver_number );

ALTER TABLE "driver-truck"
    ADD CONSTRAINT "driver-truck_TRUCK_FK" FOREIGN KEY ( truck_vin )
        REFERENCES truck ( truck_vin );

ALTER TABLE driver
    ADD CONSTRAINT "information-driver" FOREIGN KEY ( licence_number )
        REFERENCES information ( licence_number );

ALTER TABLE contract
    ADD CONSTRAINT "local_auth-contract" FOREIGN KEY ( authority_name )
        REFERENCES local_authority ( authority_name );

ALTER TABLE street
    ADD CONSTRAINT "local_auth-street" FOREIGN KEY ( authority_name )
        REFERENCES local_authority ( authority_name );

ALTER TABLE bin
    ADD CONSTRAINT property_bin FOREIGN KEY ( property_street_number,
                                              street_id,
                                              authority_name )
        REFERENCES property ( property_street_number,
                              street_id,
                              authority_name );

ALTER TABLE "property-owner"
    ADD CONSTRAINT "property-owner_OWNER_FK" FOREIGN KEY ( owner_id )
        REFERENCES owner ( owner_id );

ALTER TABLE "property-owner"
    ADD CONSTRAINT "property-owner_PROPERTY_FK" FOREIGN KEY ( property_street_number,
                                                              street_id,
                                                              authority_name )
        REFERENCES property ( property_street_number,
                              street_id,
                              authority_name );

ALTER TABLE property
    ADD CONSTRAINT street_property FOREIGN KEY ( street_id,
                                                 authority_name )
        REFERENCES street ( street_id,
                            authority_name );

ALTER TABLE bin_type
    ADD CONSTRAINT "waste_type-bin_type" FOREIGN KEY ( waste_type_id )
        REFERENCES waste_type ( waste_type_id );

ALTER TABLE collection_cost
    ADD CONSTRAINT wastetype_collectioncost FOREIGN KEY ( waste_type_id )
        REFERENCES waste_type ( waste_type_id );



-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                            18
-- CREATE INDEX                             1
-- ALTER TABLE                             43
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