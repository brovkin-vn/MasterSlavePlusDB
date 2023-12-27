spool stal.lst;
set define off;
set term on echo on;
set timing on;
set time on;



DROP USER stal CASCADE;


CREATE USER stal IDENTIFIED BY stal;

ALTER USER stal DEFAULT TABLESPACE users
              QUOTA UNLIMITED ON users;

ALTER USER stal TEMPORARY TABLESPACE temp;

GRANT create session
     , create table
     , create procedure 
     , create sequence
     , create trigger
     , create view
     , create synonym
     , alter session
TO stal;

CONNECT / AS SYSDBA;
GRANT execute ON sys.dbms_stats TO stal;


CONNECT stal/stal
ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;

SET FEEDBACK 1
SET NUMWIDTH 10
SET LINESIZE 80
SET TRIMSPOOL ON
SET TAB OFF
SET PAGESIZE 100



-- Create table
create table GAS_VALUES
(
  gas_val_id   NUMBER(10) not null,
  gas_val_date TIMESTAMP(6) not null,
  h2_val       NUMBER not null,
  o2_val       NUMBER not null
)
tablespace USERS
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate indexes 
create index GAS_VAL_DATE_PK on GAS_VALUES (GAS_VAL_DATE)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create unique index GAS_VAL_ID_IX on GAS_VALUES (GAS_VAL_ID)
  tablespace USERS
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );


COMMIT;

SET VERIFY OFF

set time off;
set timing off;
set term off echo off;
set define on;
spool off;
EXIT

